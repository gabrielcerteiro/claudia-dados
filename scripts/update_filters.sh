#!/bin/bash
export PIPEDRIVE_API_TOKEN=9fdbe8a6df3bd98c083298d7287aa1844c0ae14b

# 20 filtros de origem: 4 por imóvel × 5 imóveis
FILTER_IDS="7391 7392 7393 7394 7400 7401 7402 7403 7409 7410 7411 7412 7418 7419 7420 7421 7427 7428 7429 7430"

SUCCESS=0
FAILED=0

for FID in $FILTER_IDS; do
  FILTER=$(curl -s "https://api.pipedrive.com/v1/filters/$FID?api_token=$PIPEDRIVE_API_TOKEN")
  NAME=$(echo "$FILTER" | jq -r '.data.name')
  
  NEW_CONDITIONS=$(echo "$FILTER" | jq '.data.conditions | 
    .conditions[0].conditions = [.conditions[0].conditions[] | 
      if .field_id == "12529" then 
        .field_id = "12535" | 
        if .value == "596" then .value = "728"
        elif .value == "597" then .value = "729"
        elif .value == "603" then .value = "734"
        elif .value == "678" then .value = "735"
        else . end
      else . end
    ]')
  
  PAYLOAD=$(jq -n --arg name "$NAME" --argjson conditions "$NEW_CONDITIONS" '{name: $name, conditions: $conditions}')
  
  RESPONSE=$(curl -s -X PUT "https://api.pipedrive.com/v1/filters/$FID?api_token=$PIPEDRIVE_API_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD")
  
  OK=$(echo "$RESPONSE" | jq -r '.success')
  if [ "$OK" = "true" ]; then
    echo "✅ $FID — $NAME"
    SUCCESS=$((SUCCESS + 1))
  else
    echo "❌ $FID — $NAME: $(echo $RESPONSE | jq -r '.error')"
    FAILED=$((FAILED + 1))
  fi
  sleep 0.15
done

echo ""
echo "=== RESULTADO ==="
echo "✅ Atualizados: $SUCCESS / 20"
echo "❌ Falhas: $FAILED"
