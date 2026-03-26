#!/bin/bash

# git-sync.sh — Auto-sincronização com GitHub
# Executa: git pull + git push a cada intervalo

set -e

REPO_DIR="/data/.openclaw/workspace"
LOG_FILE="/data/.openclaw/workspace/.git-sync.log"

# Função de log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Ir pro diretório
cd "$REPO_DIR"

log "========== GIT SYNC INICIADO =========="

# 1. Git pull (trazer mudanças do GitHub)
log "Executando: git pull"
if git pull origin main 2>&1 | tee -a "$LOG_FILE"; then
    log "✅ Git pull concluído"
else
    log "❌ Git pull falhou"
fi

# 2. Git status
log "Status local:"
git status --short >> "$LOG_FILE" 2>&1 || true

# 3. Se tiver mudanças, fazer commit e push
if [ -n "$(git status --porcelain)" ]; then
    log "Mudanças detectadas. Fazendo commit..."
    
    git add -A
    
    # Commit com timestamp
    COMMIT_MSG="chore: auto-sync - $(date '+%d/%m/%Y %H:%M:%S')"
    git commit -m "$COMMIT_MSG" 2>&1 | tee -a "$LOG_FILE"
    
    log "Executando: git push"
    if git push origin main 2>&1 | tee -a "$LOG_FILE"; then
        log "✅ Git push concluído"
    else
        log "❌ Git push falhou"
    fi
else
    log "Nenhuma mudança detectada"
fi

log "✅ GIT SYNC FINALIZADO"
log ""
