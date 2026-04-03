#!/bin/bash
# Migração: Campanha → channel_id (Source channel ID) e Imóvel → product_name (Product name)
export PIPEDRIVE_API_TOKEN=9fdbe8a6df3bd98c083298d7287aa1844c0ae14b
CAMPANHA_KEY="ddd851a1bd147d41c448c8358c16a49d66ba5702"
IMOVEL_KEY="3e0a04f3b16e50b6843a0ce7ae1e76204c630ba3"

SUCCESS=0
FAILED=0
SKIPPED=0
COUNT=0
TOTAL=$(wc -l < /tmp/pd_camp_imovel.jsonl)

echo "=== Migrando Campanha → channel_id + Imóvel → product_name ==="
echo "Total deals: $TOTAL"

while IFS=$(printf '\t') read -r DEAL_ID CAMPANHA IMOVEL; do
  UPDATES=""
  
  if [ -n "$CAMPANHA" ]; then
    UPDATES="\"channel_id\":$(echo "$CAMPANHA" | jq -Rs .)"
  fi
  
  if [ -n "$IMOVEL" ]; then
    [ -n "$UPDATES" ] && UPDATES="$UPDATES,"
    UPDATES="${UPDATES}\"product_name\":$(echo "$IMOVEL" | jq -Rs .)"
  fi
  
  if [ -z "$UPDATES" ]; then
    SKIPPED=$((SKIPPED + 1))
    COUNT=$((COUNT + 1))
    continue
  fi
  
  RESPONSE=$(curl -s -X PUT "https://api.pipedrive.com/v1/deals/$DEAL_ID?api_token=$PIPEDRIVE_API_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{$UPDATES}")
  
  OK=$(echo "$RESPONSE" | jq -r '.success')
  if [ "$OK" = "true" ]; then
    SUCCESS=$((SUCCESS + 1))
  else
    echo "❌ Deal $DEAL_ID: $(echo $RESPONSE | jq -r '.error')"
    FAILED=$((FAILED + 1))
  fi
  
  COUNT=$((COUNT + 1))
  if [ $((COUNT % 200)) -eq 0 ]; then
    echo "  Progresso: $COUNT / $TOTAL (✅ $SUCCESS ⏭ $SKIPPED ❌ $FAILED)"
  fi
  sleep 0.05
done < /tmp/pd_camp_imovel.jsonl

echo ""
echo "=== RESULTADO ==="
echo "✅ Atualizados: $SUCCESS"
echo "⏭ Sem dados: $SKIPPED"
echo "❌ Falhas: $FAILED"
echo "Total: $COUNT / $TOTAL"
