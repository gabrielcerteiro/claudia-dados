#!/bin/bash
# API Queries Script — Centraliza todas as chamadas pra Pipedrive, Supabase, n8n, Trello
# Uso: ./api-queries.sh <comando> [args]
# Exemplo: ./api-queries.sh pipedrive-deals | ./api-queries.sh supabase-insert funil_snapshot

set -e

# Load credenciais
CREDS_DIR="/data/.openclaw/credentials"
load_cred() {
  grep "^$1=" "$CREDS_DIR/$2.env" 2>/dev/null | cut -d= -f2 || echo ""
}

# ===== PIPEDRIVE =====
pipedrive_deals() {
  local TOKEN=$(load_cred PIPEDRIVE_API_TOKEN pipedrive)
  local FILTER_ID=${1:-}
  
  if [ -z "$FILTER_ID" ]; then
    # Todos os deals
    curl -s "https://api.pipedrive.com/v1/deals?limit=500&api_token=$TOKEN" | jq '.data'
  else
    # Deals com filtro
    curl -s "https://api.pipedrive.com/v1/deals?filter_id=$FILTER_ID&limit=500&api_token=$TOKEN" | jq '.data'
  fi
}

pipedrive_activities() {
  local TOKEN=$(load_cred PIPEDRIVE_API_TOKEN pipedrive)
  curl -s "https://api.pipedrive.com/v1/activities?limit=500&api_token=$TOKEN" | jq '.data'
}

# ===== SUPABASE =====
supabase_query() {
  local TABLE=$1
  local QUERY=${2:-}
  local URL=$(load_cred SUPABASE_URL supabase)
  local KEY=$(load_cred SUPABASE_SERVICE_ROLE_KEY supabase)
  
  if [ -z "$QUERY" ]; then
    # GET todas as linhas
    curl -s "$URL/rest/v1/$TABLE?apikey=$KEY" \
      -H "Accept: application/json" | jq '.'
  else
    # Query customizada (filtros, etc)
    curl -s "$URL/rest/v1/$TABLE?$QUERY&apikey=$KEY" \
      -H "Accept: application/json" | jq '.'
  fi
}

supabase_insert() {
  local TABLE=$1
  local DATA=$2  # JSON stdin ou argumento
  local URL=$(load_cred SUPABASE_URL supabase)
  local KEY=$(load_cred SUPABASE_SERVICE_ROLE_KEY supabase)
  
  if [ -z "$DATA" ]; then
    DATA=$(cat)  # Lê do stdin
  fi
  
  curl -s -X POST "$URL/rest/v1/$TABLE?apikey=$KEY" \
    -H "Content-Type: application/json" \
    -H "Prefer: return=representation" \
    -d "$DATA" | jq '.'
}

supabase_update() {
  local TABLE=$1
  local ID=$2
  local DATA=$3
  local URL=$(load_cred SUPABASE_URL supabase)
  local KEY=$(load_cred SUPABASE_SERVICE_ROLE_KEY supabase)
  
  if [ -z "$DATA" ]; then
    DATA=$(cat)
  fi
  
  curl -s -X PATCH "$URL/rest/v1/$TABLE?id=eq.$ID&apikey=$KEY" \
    -H "Content-Type: application/json" \
    -H "Prefer: return=representation" \
    -d "$DATA" | jq '.'
}

# ===== TRELLO =====
trello_cards() {
  local BOARD_ID=$1
  local KEY=$(load_cred TRELLO_API_KEY trello)
  local TOKEN=$(load_cred TRELLO_TOKEN trello)
  
  curl -s "https://api.trello.com/1/boards/$BOARD_ID/cards?key=$KEY&token=$TOKEN" | jq '.'
}

trello_lists() {
  local BOARD_ID=$1
  local KEY=$(load_cred TRELLO_API_KEY trello)
  local TOKEN=$(load_cred TRELLO_TOKEN trello)
  
  curl -s "https://api.trello.com/1/boards/$BOARD_ID/lists?key=$KEY&token=$TOKEN" | jq '.'
}

# ===== N8N =====
n8n_workflows() {
  local N8N_URL=$(load_cred N8N_URL n8n)
  local N8N_KEY=$(load_cred N8N_API_KEY n8n)
  
  curl -s -H "X-N8N-API-KEY: $N8N_KEY" "$N8N_URL/api/v1/workflows" | jq '.data'
}

n8n_execute() {
  local WORKFLOW_ID=$1
  local N8N_URL=$(load_cred N8N_URL n8n)
  local N8N_KEY=$(load_cred N8N_API_KEY n8n)
  
  curl -s -X POST -H "X-N8N-API-KEY: $N8N_KEY" "$N8N_URL/api/v1/workflows/$WORKFLOW_ID/execute" | jq '.'
}

# ===== MAIN =====
COMMAND=$1
shift || true

case "$COMMAND" in
  pipedrive-deals)
    pipedrive_deals "$@"
    ;;
  pipedrive-activities)
    pipedrive_activities
    ;;
  supabase-query)
    supabase_query "$@"
    ;;
  supabase-insert)
    supabase_insert "$@"
    ;;
  supabase-update)
    supabase_update "$@"
    ;;
  trello-cards)
    trello_cards "$@"
    ;;
  trello-lists)
    trello_lists "$@"
    ;;
  n8n-workflows)
    n8n_workflows
    ;;
  n8n-execute)
    n8n_execute "$@"
    ;;
  *)
    echo "Uso: $0 <comando> [args]"
    echo ""
    echo "Comandos:"
    echo "  pipedrive-deals [filter_id]     — Todos os deals ou com filtro"
    echo "  pipedrive-activities            — Todas as atividades"
    echo "  supabase-query <table> [query]  — SELECT * FROM table"
    echo "  supabase-insert <table> <json>  — INSERT data"
    echo "  supabase-update <table> <id> <json> — UPDATE"
    echo "  trello-cards <board_id>         — Cards de um board"
    echo "  trello-lists <board_id>         — Listas de um board"
    echo "  n8n-workflows                   — Lista workflows"
    echo "  n8n-execute <workflow_id>       — Executa workflow"
    exit 1
    ;;
esac
