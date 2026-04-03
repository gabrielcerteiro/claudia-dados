#!/bin/bash
# Monitor de Visitas — Claudia
# Roda a cada 15min via cron

ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0eWt6cmFsa3hsYnFxa2xlb2ZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzNjMyNjAsImV4cCI6MjA4OTkzOTI2MH0.rYBifw2NXqVDGrKbDWKJgrFAIdoruxxsIPc9RXibgy0"
PIPEDRIVE_TOKEN="143546034679150ee9c1716e1a1fb91b71377610"
SUPABASE_URL="https://vtykzralkxlbqqkleofl.supabase.co"
STATE_FILE="/tmp/visitas_last_id.txt"
HOOK_URL="http://127.0.0.1:18789/api/send"
HOOK_TOKEN="ufSFd9QcyuykbrcAYQaGF6JXZGREHRrq"
GABRIEL="+5549991990088"

EXCLUSIVIDADES=("Casa Ressacada" "Suncoast 1601" "Cezanne 1701" "Soho 1102" "Marechiaro 402")

# Busca todas as visitas recentes (últimas 20)
VISITAS=$(curl -s "$SUPABASE_URL/rest/v1/visitas?select=id,nome_interessado,imovel_nome,data_visita,created_at&order=created_at.desc&limit=20" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $ANON_KEY")

COUNT=$(echo "$VISITAS" | jq 'length')

if [ "$COUNT" -eq 0 ]; then
  echo "Nenhuma visita encontrada"
  exit 0
fi

# Pega ID da última visita processada
LAST_ID=""
if [ -f "$STATE_FILE" ]; then
  LAST_ID=$(cat "$STATE_FILE")
fi

# Salva ID mais recente
NEWEST_ID=$(echo "$VISITAS" | jq -r '.[0].id')
echo "$NEWEST_ID" > "$STATE_FILE"

# Se não tem last ID, inicializa e sai (primeira execução)
if [ -z "$LAST_ID" ]; then
  echo "Primeira execução. Marcando ponto de partida: $NEWEST_ID"
  exit 0
fi

# Processa apenas visitas mais novas que o último ID processado
echo "Verificando visitas novas desde $LAST_ID..."

NOVAS=0
for i in $(seq 0 $((COUNT-1))); do
  ID=$(echo "$VISITAS" | jq -r ".[$i].id")
  
  # Para quando chegar no último ID processado
  if [ "$ID" = "$LAST_ID" ]; then
    break
  fi
  
  NOVAS=$((NOVAS+1))
  NOME=$(echo "$VISITAS" | jq -r ".[$i].nome_interessado")
  IMOVEL=$(echo "$VISITAS" | jq -r ".[$i].imovel_nome")
  DATA=$(echo "$VISITAS" | jq -r ".[$i].data_visita")
  
  echo "Nova visita: $NOME | $IMOVEL | $DATA"
  
  # Verifica se é exclusividade
  IS_EX=false
  TAG_IMOVEL=""
  for EX in "${EXCLUSIVIDADES[@]}"; do
    if echo "$IMOVEL" | grep -qi "$EX"; then
      IS_EX=true
      TAG_IMOVEL="$EX"
      break
    fi
  done
  
  if [ "$IS_EX" = true ]; then
    # Busca deal no Pipedrive pelo nome
    NOME_ENC=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$NOME'))" 2>/dev/null || echo "$NOME")
    DEALS=$(curl -s "https://api.pipedrive.com/v1/deals?term=$NOME_ENC&api_token=$PIPEDRIVE_TOKEN" | jq '.data')
    DEAL_COUNT=$(echo "$DEALS" | jq 'if . == null then 0 else length end')
    
    if [ "$DEAL_COUNT" -eq 0 ]; then
      MSG="⚠️ *Visita em exclusividade - deal não encontrado*\n\n*Cliente:* $NOME\n*Imóvel:* $IMOVEL\n*Data:* $DATA\n\nNão encontrei o deal no Pipedrive. Qual é?"
    else
      DEAL_ID=$(echo "$DEALS" | jq -r '.[0].id')
      DEAL_TITLE=$(echo "$DEALS" | jq -r '.[0].title')
      MSG="🏠 *Visita em exclusividade registrada!*\n\n*Cliente:* $NOME\n*Imóvel:* $IMOVEL\n*Data:* $DATA\n*Deal:* $DEAL_TITLE (ID $DEAL_ID)\n\nConfirma que aplico a tag *EX | Visita | $TAG_IMOVEL*? (responda 'sim' ou 'não')"
    fi
    
    curl -s -X POST "$HOOK_URL" \
      -H "Authorization: Bearer $HOOK_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"channel\":\"whatsapp\",\"to\":\"$GABRIEL\",\"message\":\"$MSG\"}" > /dev/null
    echo "→ Notificação enviada para Gabriel"
  fi
done

echo "Total de visitas novas processadas: $NOVAS"
