#!/bin/bash
# Scan Trello Pós-Venda board - Lista completa com análise de prazos

set -e

API_KEY="496580f33c0affef2131ffabd91a4f67"
TOKEN="eb7a9e3e4a0b356956c9ddb2723a18a4e85aa67235e987a3adba6c837ce1a438"
BASE_URL="https://api.trello.com/1"

echo "=== SCAN TRELLO PÓS-VENDA ==="
echo "Data/Hora: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 1. Encontrar o board Pós-Venda
echo "[1/5] Buscando board Pós-Venda..."
BOARD_ID=$(curl -s "$BASE_URL/members/me/boards?key=$API_KEY&token=$TOKEN&fields=name,id" | \
  jq -r '.[] | select(.name == "Pós-Venda") | .id')

if [ -z "$BOARD_ID" ]; then
  echo "❌ Board 'Pós-Venda' não encontrado"
  exit 1
fi
echo "✓ Board ID: $BOARD_ID"
echo ""

# 2. Listar todas as listas do board
echo "[2/5] Mapeando listas do board..."
LISTS=$(curl -s "$BASE_URL/boards/$BOARD_ID/lists?key=$API_KEY&token=$TOKEN&fields=name,id")
echo "$LISTS" | jq -r '.[] | "\(.id)|\(.name)"' > /tmp/lists.txt
echo "✓ $(wc -l < /tmp/lists.txt) listas encontradas"
echo ""

# 3. Coletar todos os cards
echo "[3/5] Coletando cards de todas as listas..."
CARDS=$(curl -s "$BASE_URL/boards/$BOARD_ID/cards?key=$API_KEY&token=$TOKEN&fields=name,id,idList,due,dueComplete,labels,desc&limit=1000")
CARD_COUNT=$(echo "$CARDS" | jq 'length')
echo "✓ $CARD_COUNT cards no total"
echo ""

# 4. Processar e classificar cards
echo "[4/5] Analisando prazos..."
echo ""

TODAY=$(date '+%Y-%m-%d')
TOMORROW=$(date -d '+1 day' '+%Y-%m-%d' 2>/dev/null || date -v+1d '+%Y-%m-%d' 2>/dev/null)
NEXT_WEEK=$(date -d '+7 days' '+%Y-%m-%d' 2>/dev/null || date -v+7d '+%Y-%m-%d' 2>/dev/null)

echo "VENCIDOS (prazo < hoje):"
echo "$CARDS" | jq -r '.[] | select(.due != null) | select(.due < "'$TODAY'") | "\(.due) | \(.idList) | \(.name)"' | while read line; do
  DUE=$(echo "$line" | cut -d'|' -f1 | xargs)
  LIST=$(echo "$line" | cut -d'|' -f2 | xargs)
  NAME=$(echo "$line" | cut -d'|' -f3)
  LIST_NAME=$(grep "^$LIST|" /tmp/lists.txt | cut -d'|' -f2)
  echo "  • [$LIST_NAME] $NAME — VENCIDO em $DUE"
done

echo ""
echo "VENCENDO HOJE:"
echo "$CARDS" | jq -r '.[] | select(.due != null) | select(.due == "'$TODAY'") | "\(.idList) | \(.name)"' | while read line; do
  LIST=$(echo "$line" | cut -d'|' -f1 | xargs)
  NAME=$(echo "$line" | cut -d'|' -f2)
  LIST_NAME=$(grep "^$LIST|" /tmp/lists.txt | cut -d'|' -f2)
  echo "  • [$LIST_NAME] $NAME — HOJE"
done

echo ""
echo "PRÓXIMOS 7 DIAS:"
echo "$CARDS" | jq -r '.[] | select(.due != null) | select(.due > "'$TODAY'") | select(.due <= "'$NEXT_WEEK'") | "\(.due) | \(.idList) | \(.name)"' | sort | while read line; do
  DUE=$(echo "$line" | cut -d'|' -f1 | xargs)
  LIST=$(echo "$line" | cut -d'|' -f2 | xargs)
  NAME=$(echo "$line" | cut -d'|' -f3)
  LIST_NAME=$(grep "^$LIST|" /tmp/lists.txt | cut -d'|' -f2)
  echo "  • [$LIST_NAME] $NAME — $DUE"
done

echo ""
echo "SEM PRAZO DEFINIDO:"
echo "$CARDS" | jq -r '.[] | select(.due == null) | "\(.idList) | \(.name)"' | while read line; do
  LIST=$(echo "$line" | cut -d'|' -f1 | xargs)
  NAME=$(echo "$line" | cut -d'|' -f2)
  LIST_NAME=$(grep "^$LIST|" /tmp/lists.txt | cut -d'|' -f2)
  echo "  • [$LIST_NAME] $NAME"
done

echo ""
echo "[5/5] Gerando relatório final..."
echo ""
echo "=== RESUMO EXECUTIVO ==="

VENCIDOS=$(echo "$CARDS" | jq '[.[] | select(.due != null) | select(.due < "'$TODAY'")] | length')
HOJE=$(echo "$CARDS" | jq '[.[] | select(.due != null) | select(.due == "'$TODAY'")] | length')
SEMANA=$(echo "$CARDS" | jq '[.[] | select(.due != null) | select(.due > "'$TODAY'") | select(.due <= "'$NEXT_WEEK'")] | length')
SEM_PRAZO=$(echo "$CARDS" | jq '[.[] | select(.due == null)] | length')
COM_PRAZO=$(echo "$CARDS" | jq '[.[] | select(.due != null)] | length')

echo "Total de cards: $CARD_COUNT"
echo "Com prazo: $COM_PRAZO"
echo "  ├─ Vencidos: $VENCIDOS ⚠️"
echo "  ├─ Vencendo hoje: $HOJE 🔴"
echo "  ├─ Próximos 7 dias: $SEMANA 🟡"
echo "Sem prazo: $SEM_PRAZO ⚪"
echo ""
echo "✓ Scan completo"
