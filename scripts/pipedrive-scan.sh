#!/bin/bash

# pipedrive-scan.sh — Scan automático do Pipedrive
# Executado via cron: 09:00 (diário)

set -e

WORKSPACE="/data/.openclaw/workspace"
LOG_FILE="$WORKSPACE/.pipedrive-scan.log"
PIPEDRIVE_API_KEY="${PIPEDRIVE_API_KEY}"

# Função de log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "========== PIPEDRIVE SCAN INICIADO =========="

if [ -z "$PIPEDRIVE_API_KEY" ]; then
    log "❌ PIPEDRIVE_API_KEY não configurada"
    log "Pulando scan..."
    exit 0
fi

# 1. Buscar todos os deals
log "Buscando deals..."

DEALS=$(curl -s "https://api.pipedrive.com/v1/deals?api_token=$PIPEDRIVE_API_KEY&limit=500")

# 2. Contar deals por estágio
log "Analisando pipeline..."

TOTAL=$(echo "$DEALS" | jq '.data | length' 2>/dev/null || echo "0")
log "  Total de deals: $TOTAL"

# 3. Buscar deals sem atividade >3 dias (se possível)
log "Verificando deals parados..."

# Nota: Isso requer processamento mais complexo
# Por enquanto, apenas log o total
log "  ⚠️ Detalhes de deals requerem API detalhada"

log "✅ PIPEDRIVE SCAN FINALIZADO"
log ""
