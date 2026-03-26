# GIT_SYNC_CONFIG.md — Auto-Sincronização

## 🔄 Como Funciona

A workspace está configurada pra **sincronizar automaticamente com GitHub a cada 15 minutos**.

### Fluxo:

```
A cada 15 minutos:
  1. git pull origin main  (traz mudanças do GitHub)
  2. Detecta mudanças locais
  3. git add -A
  4. git commit -m "chore: auto-sync - [timestamp]"
  5. git push origin main
```

---

## 📋 Componentes

### 1. Script de Sincronização
**Arquivo:** `git-sync.sh`
**Localização:** `/data/.openclaw/workspace/git-sync.sh`
**Função:** Executa pull + commit + push

```bash
# Rodar manualmente:
cd /data/.openclaw/workspace
./git-sync.sh
```

### 2. Cron Job
**Nome:** `claudia-git-sync`
**Frequência:** A cada 15 minutos (900000ms)
**Tipo:** Sistema automático
**Status:** ✅ Ativo

---

## 📊 O que é Sincronizado

**Vem do GitHub (git pull):**
- Qualquer mudança que você fizer via web
- Commits de outras máquinas/pessoas

**Vai pro GitHub (git push):**
- Mudanças locais em arquivos
- Novos arquivos criados
- Deletions

**Ignorado (protegido por .gitignore):**
- Credenciais em `/data/.openclaw/credentials/`
- Arquivos `.env`, `*.key`, `*.pem`
- `node_modules/`, logs

---

## 📝 Logs

**Arquivo de log:** `.git-sync.log`

Ver os últimos syncs:
```bash
cd /data/.openclaw/workspace
tail -100 .git-sync.log
```

Exemplo de log:
```
[2026-03-26 10:15:00] ========== GIT SYNC INICIADO ==========
[2026-03-26 10:15:00] Executando: git pull
[2026-03-26 10:15:02] ✅ Git pull concluído
[2026-03-26 10:15:02] Status local:
[2026-03-26 10:15:02]  M empresa.md
[2026-03-26 10:15:02] Mudanças detectadas. Fazendo commit...
[2026-03-26 10:15:03] ✅ Git push concluído
```

---

## ⚙️ Configuração Manual

### Mudar Frequência

**Default:** 15 minutos (900000ms)

Para mudar, edite o cron job:
```bash
openclaw cron list  # Ver jobs
openclaw cron update [job-id] --patch '{"schedule": {"everyMs": 300000}}'
# 300000ms = 5 minutos
```

### Desativar Auto-Sync

```bash
openclaw cron update claudia-git-sync --patch '{"enabled": false}'
```

### Reativar

```bash
openclaw cron update claudia-git-sync --patch '{"enabled": true}'
```

---

## 🚨 Possíveis Cenários

### Cenário 1: Conflito de Merge
Se você editar o mesmo arquivo em dois lugares (GitHub web + local):
- ✅ Git pull vai falhar (detecta conflito)
- 🔧 **Manual:** Resolve o conflito e faz `git add` + `git commit`
- ⏳ Próximo sync vai funcionar

### Cenário 2: Erro de Push
Se o push falhar (ex: permissão):
- ✅ Log vai registrar o erro
- 🔧 **Você:** Checa `.git-sync.log` e resolve manualmente

### Cenário 3: Muitas Mudanças
Se tiver 100+ mudanças de uma vez:
- ✅ Tudo é commitado junto
- ✅ Push é feito em um commit só
- 📊 Log mostra tudo

---

## 📱 Sincronizar Manualmente (On-Demand)

Se quiser sincronizar **agora** (sem esperar 15 minutos):

```bash
cd /data/.openclaw/workspace
./git-sync.sh
```

Ou peça pra Claudia:
> "Sincroniza o repositório com GitHub agora"

---

## ✅ Status Atual

- ✅ Script: `git-sync.sh` criado
- ✅ Cron job: `claudia-git-sync` ativo
- ✅ Frequência: 15 minutos
- ✅ Logs: `.git-sync.log` disponível
- ✅ Pronto pra usar

---

## 🔐 Segurança

- ✅ Credenciais protegidas por `.gitignore`
- ✅ Chave SSH configurada (não expõe token)
- ✅ Logs registram todas as ações
- ✅ Commits automáticos com timestamp

---

*GIT_SYNC_CONFIG.md — Atualizado 26/03/2026*
