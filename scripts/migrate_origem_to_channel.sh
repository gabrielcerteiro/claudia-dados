#!/bin/bash
# Migra campo Origem → Source channel no Pipedrive
# Mapeamento:
#   596 (Meta Ads)        → 728 (Meta Ads)
#   597 (Google Ads)      → 729 (Google Ads)
#   598 (FB/IG Orgânico)  → 731 (Instagram Orgânico)
#   600 (Mídia Offline)   → 737 (Outdoor / Mídia offline)
#   602 (Site)            → 730 (Site / Orgânico) — EXCETO 31 aleatórios → 729 (Google Ads)
#   603 (Indicação)       → 734 (Indicação de cliente)
#   604 (Relacionamento)  → 736 (Relacionamento)
#   605 (Desconhecido)    → 745 (Desconhecido/Outros)
#   678 (Parceria)        → 735 (Corretor parceiro)

export PIPEDRIVE_API_TOKEN=9fdbe8a6df3bd98c083298d7287aa1844c0ae14b
ORIGEM_KEY="07f27e23b9179cf8ae862b8259eecc2fc410b6cd"
CHANNEL_KEY="channel"

# Step 1: Collect all deal IDs with their Origem value
echo "=== Coletando deals ==="
> /tmp/pd_all_deals.jsonl

START=0
while true; do
  curl -s "https://api.pipedrive.com/v1/deals?status=all_not_deleted&start=$START&limit=500&api_token=$PIPEDRIVE_API_TOKEN" > /tmp/pd_batch.json
  
  jq -r --arg key "$ORIGEM_KEY" '.data[]? | select(.[$key] != null and .[$key] != "") | "\(.id)\t\(.[$key])"' /tmp/pd_batch.json >> /tmp/pd_all_deals.jsonl
  
  MORE=$(jq -r '.additional_data.pagination.more_items_in_collection' /tmp/pd_batch.json)
  if [ "$MORE" != "true" ]; then break; fi
  START=$(jq -r '.additional_data.pagination.next_start' /tmp/pd_batch.json)
  echo "  Coletados até start=$START..."
done

TOTAL=$(wc -l < /tmp/pd_all_deals.jsonl)
echo "Total deals com Origem: $TOTAL"

# Step 2: Separate Site deals and pick 31 random for Google Ads
echo ""
echo "=== Separando deals do Site (602) ==="
grep "602$" /tmp/pd_all_deals.jsonl | awk '{print $1}' > /tmp/pd_site_deals.txt
SITE_COUNT=$(wc -l < /tmp/pd_site_deals.txt)
echo "Deals do Site: $SITE_COUNT"

# Shuffle and pick 31 for Google Ads
shuf /tmp/pd_site_deals.txt | head -31 > /tmp/pd_site_to_google.txt
# The rest stay as Site
comm -23 <(sort /tmp/pd_site_deals.txt) <(sort /tmp/pd_site_to_google.txt) > /tmp/pd_site_stay.txt

echo "Site → Google Ads: $(wc -l < /tmp/pd_site_to_google.txt)"
echo "Site → Site/Orgânico: $(wc -l < /tmp/pd_site_stay.txt)"

# Step 3: Build mapping file (deal_id → channel_value)
echo ""
echo "=== Construindo mapeamento ==="
> /tmp/pd_migration.tsv

# Regular mappings (excluding 602 which is special)
while IFS=$'\t' read -r DEAL_ID ORIGEM; do
  case "$ORIGEM" in
    596) CHANNEL=728 ;;
    597) CHANNEL=729 ;;
    598) CHANNEL=731 ;;
    600) CHANNEL=737 ;;
    603) CHANNEL=734 ;;
    604) CHANNEL=736 ;;
    605) CHANNEL=745 ;;
    678) CHANNEL=735 ;;
    602) continue ;; # handled separately
    *) continue ;;
  esac
  echo -e "$DEAL_ID\t$CHANNEL" >> /tmp/pd_migration.tsv
done < /tmp/pd_all_deals.jsonl

# Site → Google Ads (31 random)
while read -r DEAL_ID; do
  echo -e "$DEAL_ID\t729" >> /tmp/pd_migration.tsv
done < /tmp/pd_site_to_google.txt

# Site → Site/Orgânico (rest)
while read -r DEAL_ID; do
  echo -e "$DEAL_ID\t730" >> /tmp/pd_migration.tsv
done < /tmp/pd_site_stay.txt

MIGRATE_COUNT=$(wc -l < /tmp/pd_migration.tsv)
echo "Total a migrar: $MIGRATE_COUNT"

# Step 4: Execute updates
echo ""
echo "=== Executando migração ==="
SUCCESS=0
FAILED=0
COUNT=0

while IFS=$'\t' read -r DEAL_ID CHANNEL_VAL; do
  RESPONSE=$(curl -s -X PUT "https://api.pipedrive.com/v1/deals/$DEAL_ID?api_token=$PIPEDRIVE_API_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"$CHANNEL_KEY\":\"$CHANNEL_VAL\"}")
  
  OK=$(echo "$RESPONSE" | jq -r '.success')
  if [ "$OK" = "true" ]; then
    SUCCESS=$((SUCCESS + 1))
  else
    echo "❌ Deal $DEAL_ID → channel $CHANNEL_VAL: $(echo $RESPONSE | jq -r '.error // "unknown"')"
    FAILED=$((FAILED + 1))
  fi
  
  COUNT=$((COUNT + 1))
  if [ $((COUNT % 100)) -eq 0 ]; then
    echo "  Progresso: $COUNT / $MIGRATE_COUNT (✅ $SUCCESS ❌ $FAILED)"
    sleep 0.5
  fi
  
  # Rate limit
  sleep 0.05
done < /tmp/pd_migration.tsv

echo ""
echo "=== RESULTADO ==="
echo "✅ Sucesso: $SUCCESS"
echo "❌ Falhas: $FAILED"
echo "Total: $((SUCCESS + FAILED)) / $MIGRATE_COUNT"
