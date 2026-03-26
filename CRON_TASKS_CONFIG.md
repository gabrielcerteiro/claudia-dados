# CRON_TASKS_CONFIG.md — Tarefas Automáticas Configuradas

## ✅ STATUS: 4 CRON TASKS ATIVAS

Todas as tarefas estão configuradas, testadas e **ATIVAS**.

---

## 📅 ROTINAS DIÁRIAS

### 1️⃣ 08:00 — Scan Trello Pós-Venda
**Job ID:** `claudia-trello-scan-08h`
**Frequência:** Todo dia às 08:00 (GMT-3)
**Timeout:** 60 segundos

**O que faz:**
```
Fazer scan completo do Trello (board Pós-Venda):
  ├─ Listar todos os cards
  ├─ Identificar vencidos
  ├─ Identificar sem prazo
  ├─ Próximos vencimentos
  └─ Preparar dados pra relatório
```

**Resultado:**
- Identifica problemas antes de virar crítico
- Prepara informações para cobrança

---

### 2️⃣ 08:30 — Cobrança Matinal
**Job ID:** `claudia-cobranca-matinal-830h`
**Frequência:** Todo dia às 08:30 (GMT-3)
**Timeout:** 60 segundos

**O que faz:**
```
Verificar tarefas vencidas ou vencendo hoje:
  ├─ Identificar prazo < hoje OU prazo = hoje
  ├─ Enviar mensagem pra cada responsável
  ├─ Incluir: nome tarefa, vencimento, atraso em dias
  └─ Tom: firme mas profissional
```

**Destinatário:**
- Suelen (escrituras)
- Camilla (coordenação)
- Rafaela (pré-vendas)
- Gabriel (marketing)
- Felipe (videomaker)
- Vitória (financeiro)
- Angélica (repaginação)

---

### 3️⃣ 09:00 — Scan Pipedrive
**Job ID:** `claudia-pipedrive-scan-09h`
**Frequência:** Todo dia às 09:00 (GMT-3)
**Timeout:** 60 segundos

**O que faz:**
```
Listar todos os deals ativos:
  ├─ Identificar deals parados >3 dias
  ├─ Identificar deals sem próximo passo
  ├─ Análise geral do pipeline
  └─ Preparar pergunta pro Gabriel
```

**Destinatário:**
- Gabriel (decisões sobre deals)

---

## 📊 ROTINAS SEMANAIS

### 4️⃣ SEGUNDA 08:30 — Relatório Executivo Semanal
**Job ID:** `claudia-relatorio-gabriel-seg`
**Frequência:** Toda segunda às 08:30 (GMT-3)
**Timeout:** 90 segundos

**O que faz:**
```
Relatório Executivo Semanal - Gabriel:
  ├─ Vendas em andamento (nome | etapa | status 🟢🟡🔴 | próximo passo)
  ├─ Gargalos (bloqueios com responsável e tempo parado)
  ├─ Decisões pendentes (perguntas diretas sim/não)
  └─ Métricas (tarefas, deals, atrasos)
```

**Destinatário:**
- Gabriel (resumo executivo)

---

## 🔧 Gerenciar Cron Tasks

### Listar todas
```bash
openclaw cron list
```

### Ver detalhes de um job
```bash
openclaw cron list | jq '.[] | select(.name | contains("claudia"))'
```

### Desativar um job
```bash
openclaw cron update 6e87b441-cc94-4c9c-be04-63cbb580552f --patch '{"enabled": false}'
```

### Reativar um job
```bash
openclaw cron update 6e87b441-cc94-4c9c-be04-63cbb580552f --patch '{"enabled": true}'
```

### Rodar um job agora (on-demand)
```bash
openclaw cron run 6e87b441-cc94-4c9c-be04-63cbb580552f
```

### Ver histórico de execuções
```bash
openclaw cron runs 6e87b441-cc94-4c9c-be04-63cbb580552f
```

---

## 📝 Logs

Logs de execução ficam no próprio OpenClaw.
Você pode acompanhar via sessão ou histórico de cron.

---

## 🎯 Próximas Tarefas a Adicionar

- ⏳ 10:00 — Follow-up clientes (3ª e 5ª feira)
- ⏳ 17:00 — Alerta de prazos vencendo amanhã
- ⏳ Último dia útil do mês — Relatório Mensal

---

## ✨ Integração com Repositório

Todos os cron jobs são:
- ✅ Documentados em `operacao.md`
- ✅ Versionados no Git
- ✅ Sincronizados via auto-sync (a cada 15 min)
- ✅ Backup no GitHub

---

*CRON_TASKS_CONFIG.md — Atualizado 26/03/2026*
