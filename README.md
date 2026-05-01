# 📋 Claudia — COO Virtual | Gabriel Certeiro Imóveis

## Estrutura da Workspace

```
/claudia-dados/
│
├─ 🎭 IDENTIDADE (Quem sou)
│  ├── IDENTITY.md          → Nome, role, vibe
│  ├── SOUL.md              → Valores e comportamento
│  └── USER.md              → Quem é meu usuário (Gabriel)
│
├─ 📚 OPERACIONAL (Como funciono)
│  ├── 01_soul.md           → Princípios e comportamento
│  ├── 02_skills.md         → Ferramentas e integrações disponíveis
│  ├── empresa.md           → Contexto da empresa (CNPJ, equipe, sistemas, regras de negócio)
│  ├── agentes.md           → Mapa da equipe & escalação (quem faz o quê)
│  ├── operacao.md          → Rotinas, cron tasks, templates de comunicação
│  └── regras.md            → Políticas, limites, faseamento
│
├─ ⚙️ AUTOMAÇÕES n8n (Claudia como agente autônomo)
│  ├── N8N_AUTOMACOES.md   → Workflows, skills, fases, credenciais pendentes ← NOVO
│  └── AUTOMACOES.md       → Automações legado (visitas, propostas, Pipedrive)
│
├─ 🧠 MEMÓRIA (O que lembro)
│  ├── MEMORY.md            → Contexto vivo (atualizado, histórico de anotações)
│  └── memory/              → Histórico de sessões por data
│
├─ 📋 GESTÃO
│  ├── BACKLOG.md           → Demandas abertas e status operacional
│  ├── AUDITORIA.md         → Registro de auditorias
│  └── TRELLO_STATUS.md     → Status do board Trello
│
├─ ⚙️ SISTEMA
│  ├── HEARTBEAT.md         → Tarefas periódicas
│  ├── TOOLS.md             → Notas locais (câmeras, SSH, etc)
│  ├── CRON_TASKS_CONFIG.md → Configuração de crons
│  └── README.md            → Este arquivo
│
└─ 📁 skills/               → Skills customizadas
   ├── trello/              → Gerenciar boards Trello
   ├── pipedrive/           → Gerenciar CRM
   ├── message-templates/   → Templates de mensagens
   └── market-monitoring/   → Monitoramento de mercado
```

---

## 📖 Como Usar Esta Workspace

### 1️⃣ Quero entender quem é Claudia?
→ **IDENTITY.md** + **01_soul.md**

### 2️⃣ Quero entender a empresa?
→ **empresa.md**

### 3️⃣ Quero saber como Claudia deve agir?
→ **agentes.md** + **regras.md**

### 4️⃣ Quero entender as rotinas operacionais?
→ **operacao.md**

### 5️⃣ Quero saber quais ferramentas Claudia usa?
→ **02_skills.md**

### 6️⃣ Quero ver o que está pendente / status operacional?
→ **BACKLOG.md**

### 7️⃣ Quero entender as automações no n8n (Claudia autônoma)?
→ **N8N_AUTOMACOES.md**

### 8️⃣ Quero consultar memória ou contexto histórico?
→ **MEMORY.md** + pasta **memory/**

---

## 🎯 Responsabilidades da Claudia

| Função | Arquivo |
|--------|---------|
| Monitorar tarefas e prazos | operacao.md, BACKLOG.md |
| Cobrar responsáveis | agentes.md |
| Organizar agenda do Gabriel | operacao.md |
| Consolidar informações | MEMORY.md |
| Alertar sobre riscos | regras.md, operacao.md |
| Gerenciar Trello | 02_skills.md |
| Gerenciar Pipedrive | 02_skills.md |
| Comunicar com clientes | agentes.md, operacao.md |
| Escalar problemas | agentes.md |
| Processar docs ZapSign → Drive | N8N_AUTOMACOES.md |
| Notificar Gabriel no WhatsApp | N8N_AUTOMACOES.md |

---

## 🤖 Como Reativar o Contexto em Nova Sessão

**Contexto mínimo (operação do dia a dia):**
> *"Leia `README.md`, `IDENTITY.md` e `BACKLOG.md` no repositório `gabrielcerteiro/claudia-dados`."*

**Contexto completo (incluindo automações n8n):**
> *"Leia `README.md`, `IDENTITY.md`, `empresa.md` e `N8N_AUTOMACOES.md` no repositório `gabrielcerteiro/claudia-dados`."*

**Para retomar desenvolvimento de automações:**
> *"Leia `N8N_AUTOMACOES.md` no repositório `gabrielcerteiro/claudia-dados` e me diz o status atual e o que falta fazer."*

---

## 🔐 Credenciais & Segurança

- ✅ API keys sensíveis: `/data/.openclaw/credentials/`
- ❌ NUNCA exponha credentials em chat
- 🔒 Leia: **regras.md** (Segurança)
- ⚠️ Credenciais n8n pendentes: ver **N8N_AUTOMACOES.md**

---

## 📅 Última Atualização

- **Data:** 01/05/2026
- **Versão:** 1.1
- **Mudanças:** Adicionado `N8N_AUTOMACOES.md` com arquitetura da Claudia no n8n (orquestrador + skills ZapSign + rotina Drive/WhatsApp)
- **Status:** Fase 1 infraestrutura concluída — aguardando credenciais para ativar

---

*README.md — Estrutura de Claudia v1.1*
