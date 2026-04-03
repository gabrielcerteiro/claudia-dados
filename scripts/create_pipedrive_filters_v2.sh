#!/bin/bash
# Cria 45 filtros no Pipedrive — v2 com field_id numéricos
set -euo pipefail

export PIPEDRIVE_API_TOKEN=9fdbe8a6df3bd98c083298d7287aa1844c0ae14b
API="https://api.pipedrive.com/v1"

# Field IDs (numéricos como string)
FID_PIPELINE="12454"
FID_STAGE="12456"
FID_STATUS="12457"
FID_EXCL="12561"
FID_ORIGEM="12529"

# Values
PIPELINE_ID=19
STAGE_VISITA=118
STAGE_PROPOSTA=119
ORIGEM_META=596
ORIGEM_GOOGLE=597
ORIGEM_INDICACAO=603
ORIGEM_PARCERIA=678

SLUGS=("suncoast-1601" "cezanne-1701" "soho-1102" "casa-ressacada" "marechiaro-402")

CREATED=0
FAILED=0
RESULTS=""

create_filter() {
    local name="$1"
    local conditions="$2"
    
    local response=$(curl -s -X POST "$API/filters?api_token=$PIPEDRIVE_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d "{\"name\":\"$name\",\"type\":\"deals\",\"conditions\":$conditions}")
    
    local success=$(echo "$response" | jq -r '.success')
    local fid=$(echo "$response" | jq -r '.data.id // "null"')
    
    if [ "$success" = "true" ]; then
        echo "✅ $name (id: $fid)"
        RESULTS="$RESULTS\n$name|$fid"
        CREATED=$((CREATED + 1))
    else
        local error=$(echo "$response" | jq -r '.error // "unknown"')
        echo "❌ $name — $error"
        echo "   Response: $(echo "$response" | jq -c .)"
        FAILED=$((FAILED + 1))
    fi
    
    sleep 0.15
}

# Helper: build conditions JSON
# All filters share: exclusividade_id = SLUG AND pipeline = 19
# Additional conditions vary per filter type

for SLUG in "${SLUGS[@]}"; do
    echo ""
    echo "=== $SLUG ==="
    
    # Base conditions: exclusividade_id + pipeline
    BASE="[{\"object\":\"deal\",\"field_id\":\"$FID_EXCL\",\"operator\":\"=\",\"value\":\"$SLUG\",\"extra_value\":null},{\"object\":\"deal\",\"field_id\":\"$FID_PIPELINE\",\"operator\":\"=\",\"value\":\"$PIPELINE_ID\",\"extra_value\":null}"
    
    # 1. total_leads (no extra condition)
    CONDS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":${BASE}]},{\"glue\":\"or\",\"conditions\":[]}]}"
    create_filter "$SLUG | total_leads" "$CONDS"
    
    # 2. total_visitas (stage = Visita feita)
    CONDS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":${BASE},{\"object\":\"deal\",\"field_id\":\"$FID_STAGE\",\"operator\":\"=\",\"value\":\"$STAGE_VISITA\",\"extra_value\":null}]},{\"glue\":\"or\",\"conditions\":[]}]}"
    create_filter "$SLUG | total_visitas" "$CONDS"
    
    # 3. total_propostas (stage = Proposta feita)
    CONDS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":${BASE},{\"object\":\"deal\",\"field_id\":\"$FID_STAGE\",\"operator\":\"=\",\"value\":\"$STAGE_PROPOSTA\",\"extra_value\":null}]},{\"glue\":\"or\",\"conditions\":[]}]}"
    create_filter "$SLUG | total_propostas" "$CONDS"
    
    # 4. leads_abertos (status = open)
    CONDS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":${BASE},{\"object\":\"deal\",\"field_id\":\"$FID_STATUS\",\"operator\":\"=\",\"value\":\"open\",\"extra_value\":null}]},{\"glue\":\"or\",\"conditions\":[]}]}"
    create_filter "$SLUG | leads_abertos" "$CONDS"
    
    # 5. leads_perdidos (status = lost)
    CONDS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":${BASE},{\"object\":\"deal\",\"field_id\":\"$FID_STATUS\",\"operator\":\"=\",\"value\":\"lost\",\"extra_value\":null}]},{\"glue\":\"or\",\"conditions\":[]}]}"
    create_filter "$SLUG | leads_perdidos" "$CONDS"
    
    # 6. leads_meta_ads (Origem = Meta Ads)
    CONDS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":${BASE},{\"object\":\"deal\",\"field_id\":\"$FID_ORIGEM\",\"operator\":\"=\",\"value\":\"$ORIGEM_META\",\"extra_value\":null}]},{\"glue\":\"or\",\"conditions\":[]}]}"
    create_filter "$SLUG | leads_meta_ads" "$CONDS"
    
    # 7. leads_google_ads (Origem = Google Ads)
    CONDS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":${BASE},{\"object\":\"deal\",\"field_id\":\"$FID_ORIGEM\",\"operator\":\"=\",\"value\":\"$ORIGEM_GOOGLE\",\"extra_value\":null}]},{\"glue\":\"or\",\"conditions\":[]}]}"
    create_filter "$SLUG | leads_google_ads" "$CONDS"
    
    # 8. leads_indicacao (Origem = Indicação)
    CONDS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":${BASE},{\"object\":\"deal\",\"field_id\":\"$FID_ORIGEM\",\"operator\":\"=\",\"value\":\"$ORIGEM_INDICACAO\",\"extra_value\":null}]},{\"glue\":\"or\",\"conditions\":[]}]}"
    create_filter "$SLUG | leads_indicacao" "$CONDS"
    
    # 9. leads_corretor_parc (Origem = Parceria)
    CONDS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":${BASE},{\"object\":\"deal\",\"field_id\":\"$FID_ORIGEM\",\"operator\":\"=\",\"value\":\"$ORIGEM_PARCERIA\",\"extra_value\":null}]},{\"glue\":\"or\",\"conditions\":[]}]}"
    create_filter "$SLUG | leads_corretor_parc" "$CONDS"
done

echo ""
echo "=== RESULTADO ==="
echo "✅ Criados: $CREATED"
echo "❌ Falhas: $FAILED"
echo "Total: $((CREATED + FAILED))/45"
