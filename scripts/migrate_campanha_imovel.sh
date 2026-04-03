#!/bin/bash
# Migração: Campanha → origin_id (Source origin ID) e Imóvel → product_name (Product name)
export PIPEDRIVE_API_TOKEN=9fdbe8a6df3bd98c083298d7287aa1844c0ae14b

echo "=== MIGRAÇÃO 1: Campanha → Source origin ID ==="
echo "=== MIGRAÇÃO 2: Imóvel → Product name ==="

SUCCESS=0
FAILED=0
SKIPPED=0
COUNT=0
TOTAL=$(wc -l < /tmp/pd_camp_imovel.jsonl)

while IFS=$(printf '\t') read -r DEAL_ID CAMPANHA IMOVEL; do
  # Build update payload only for non-empty fields
  UPDATES=""
  
  if [ -n "$CAMPANHA" ]; then
    UPDATES="\"origin_id\":$(echo "$CAMPANHA" | jq -Rs .)"
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
