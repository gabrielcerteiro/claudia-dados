#!/bin/bash
# Cria 45 filtros no Pipedrive para dashboard de exclusividades
# Pipeline: Funil de vendas (Reduzido) = 19
# Stages: Visita feita = 118, Proposta feita = 119
# Fields: exclusividade_id = ebbb402000d40a48666061852fd7cb52d83b29f4
#         Origem = 07f27e23b9179cf8ae862b8259eecc2fc410b6cd
# Origem IDs: Meta Ads=596, Google Ads=597, Indicação=603, Parceria=678

export PIPEDRIVE_API_TOKEN=9fdbe8a6df3bd98c083298d7287aa1844c0ae14b

API="https://api.pipedrive.com/v1"
EXCL_KEY="ebbb402000d40a48666061852fd7cb52d83b29f4"
ORIGEM_KEY="07f27e23b9179cf8ae862b8259eecc2fc410b6cd"
PIPELINE=19
STAGE_VISITA=118
STAGE_PROPOSTA=119

SLUGS=("suncoast-1601" "cezanne-1701" "soho-1102" "casa-ressacada" "marechiaro-402")

CREATED=0
FAILED=0

create_filter() {
    local name="$1"
    local conditions="$2"
    
    local payload=$(jq -n \
        --arg name "$name" \
        --arg type "deals" \
        --argjson conditions "$conditions" \
        '{name: $name, type: $type, conditions: $conditions}')
    
    local response=$(curl -s -X POST "$API/filters?api_token=$PIPEDRIVE_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$payload")
    
    local success=$(echo "$response" | jq -r '.success')
    local fid=$(echo "$response" | jq -r '.data.id // "null"')
    
    if [ "$success" = "true" ]; then
        echo "✅ $name (id: $fid)"
        CREATED=$((CREATED + 1))
    else
        local error=$(echo "$response" | jq -r '.error // "unknown"')
        echo "❌ $name — $error"
        FAILED=$((FAILED + 1))
    fi
    
    # Rate limit: ~100ms between calls
    sleep 0.15
}

for SLUG in "${SLUGS[@]}"; do
    echo ""
    echo "=== $SLUG ==="
    
    # Base condition: exclusividade_id = SLUG + pipeline
    BASE_COND="{\"object\":\"deal\",\"field_id\":\"$EXCL_KEY\",\"operator\":\"=\",\"value\":\"$SLUG\"}"
    PIPELINE_COND="{\"object\":\"deal\",\"field_id\":\"pipeline_id\",\"operator\":\"=\",\"value\":$PIPELINE}"
    
    # 1. total_leads — any status in pipeline
    CONDITIONS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":[$BASE_COND,$PIPELINE_COND]}]}"
    create_filter "$SLUG | total_leads" "$CONDITIONS"
    
    # 2. total_visitas — stage = Visita feita
    STAGE_COND="{\"object\":\"deal\",\"field_id\":\"stage_id\",\"operator\":\"=\",\"value\":$STAGE_VISITA}"
    CONDITIONS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":[$BASE_COND,$PIPELINE_COND,$STAGE_COND]}]}"
    create_filter "$SLUG | total_visitas" "$CONDITIONS"
    
    # 3. total_propostas — stage = Proposta feita
    STAGE_COND="{\"object\":\"deal\",\"field_id\":\"stage_id\",\"operator\":\"=\",\"value\":$STAGE_PROPOSTA}"
    CONDITIONS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":[$BASE_COND,$PIPELINE_COND,$STAGE_COND]}]}"
    create_filter "$SLUG | total_propostas" "$CONDITIONS"
    
    # 4. leads_abertos — status = open
    STATUS_COND="{\"object\":\"deal\",\"field_id\":\"status\",\"operator\":\"=\",\"value\":\"open\"}"
    CONDITIONS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":[$BASE_COND,$PIPELINE_COND,$STATUS_COND]}]}"
    create_filter "$SLUG | leads_abertos" "$CONDITIONS"
    
    # 5. leads_perdidos — status = lost
    STATUS_COND="{\"object\":\"deal\",\"field_id\":\"status\",\"operator\":\"=\",\"value\":\"lost\"}"
    CONDITIONS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":[$BASE_COND,$PIPELINE_COND,$STATUS_COND]}]}"
    create_filter "$SLUG | leads_perdidos" "$CONDITIONS"
    
    # 6. leads_meta_ads — Origem = Meta Ads (596)
    ORIGEM_COND="{\"object\":\"deal\",\"field_id\":\"$ORIGEM_KEY\",\"operator\":\"=\",\"value\":596}"
    CONDITIONS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":[$BASE_COND,$PIPELINE_COND,$ORIGEM_COND]}]}"
    create_filter "$SLUG | leads_meta_ads" "$CONDITIONS"
    
    # 7. leads_google_ads — Origem = Google Ads (597)
    ORIGEM_COND="{\"object\":\"deal\",\"field_id\":\"$ORIGEM_KEY\",\"operator\":\"=\",\"value\":597}"
    CONDITIONS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":[$BASE_COND,$PIPELINE_COND,$ORIGEM_COND]}]}"
    create_filter "$SLUG | leads_google_ads" "$CONDITIONS"
    
    # 8. leads_indicacao — Origem = Indicação (603)
    ORIGEM_COND="{\"object\":\"deal\",\"field_id\":\"$ORIGEM_KEY\",\"operator\":\"=\",\"value\":603}"
    CONDITIONS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":[$BASE_COND,$PIPELINE_COND,$ORIGEM_COND]}]}"
    create_filter "$SLUG | leads_indicacao" "$CONDITIONS"
    
    # 9. leads_corretor_parc — Origem = Parceria (678)
    ORIGEM_COND="{\"object\":\"deal\",\"field_id\":\"$ORIGEM_KEY\",\"operator\":\"=\",\"value\":678}"
    CONDITIONS="{\"glue\":\"and\",\"conditions\":[{\"glue\":\"and\",\"conditions\":[$BASE_COND,$PIPELINE_COND,$ORIGEM_COND]}]}"
    create_filter "$SLUG | leads_corretor_parc" "$CONDITIONS"
done

echo ""
echo "=== RESULTADO ==="
echo "✅ Criados: $CREATED"
echo "❌ Falhas: $FAILED"
echo "Total: $((CREATED + FAILED))/45"
