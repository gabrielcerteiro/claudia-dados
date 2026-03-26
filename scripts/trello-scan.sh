#!/bin/bash

# trello-scan.sh — Scan automático do Trello Pós-Venda
# Executado via cron: 08:00 (diário)

set -e

WORKSPACE="/data/.openclaw/workspace"
LOG_FILE="$WORKSPACE/.trello-scan.log"
BOARD_ID="6994ca303742372379a01ff4"  # Contratos | Pós vendas

# Função de log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "========== TRELLO SCAN INICIADO =========="

# 1. Buscar todos os cards do board
log "Buscando cards do board Pós-Venda..."

CARDS=$(curl -s "https://api.trello.com/1/boards/$BOARD_ID/cards?key=$TRELLO_API_KEY&token=$TRELLO_TOKEN")

# 2. Contar cards por lista
PARA_FAZER=$(echo "$CARDS" | jq '[.[] | select(.idList=="6994cc60c983fefdc58bcdbf")] | length')
EM_ANDAMENTO=$(echo "$CARDS" | jq '[.[] | select(.idList=="6994ca4f80535e95990c72d7")] | length')
AGUARDANDO=$(echo "$CARDS" | jq '[.[] | select(.idList=="6994ca574a21d8c414dcbebd")] | length')
FEITO=$(echo "$CARDS" | jq '[.[] | select(.idList=="6994ca5c42ca7f5b17994a6a")] | length')

log "Cards por lista:"
log "  Para fazer: $PARA_FAZER"
log "  Em andamento: $EM_ANDAMENTO"
log "  Aguardando: $AGUARDANDO"
log "  Feito: $FEITO"

# 3. Buscar cards com vencimento
log "Verificando vencimentos..."

VENCIDOS=$(echo "$CARDS" | jq '[.[] | select(.due < now)] | length' 2>/dev/null || echo "0")
VENCENDO_HOJE=$(echo "$CARDS" | jq '[.[] | select(.due | . >= today and . < tomorrow)] | length' 2>/dev/null || echo "0")

log "  Vencidos: $VENCIDOS"
log "  Vencendo hoje: $VENCENDO_HOJE"

# 4. Buscar cards sem due date
SEM_DATA=$(echo "$CARDS" | jq '[.[] | select(.due == null)] | length')
log "  Sem prazo definido: $SEM_DATA"

# 5. Relatório resumido
log ""
log "📊 RESUMO:"
log "  Total cards: $(echo "$CARDS" | jq 'length')"
log "  ✅ Concluído: $FEITO"
log "  ⏳ Em progresso: $((PARA_FAZER + EM_ANDAMENTO + AGUARDANDO))"
log "  🚨 Bloqueios potenciais: $((VENCIDOS + SEM_DATA))"

log "✅ TRELLO SCAN FINALIZADO"
log ""
