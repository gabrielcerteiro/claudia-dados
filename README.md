# 📋 Claudia — COO Virtual | Gabriel Certeiro Imóveis

## Estrutura da Workspace

```
/data/.openclaw/workspace/
│
├─ 🎭 IDENTIDADE (Quem sou)
│  ├── IDENTITY.md          → Nome, role, vibe
│  ├── SOUL.md (→ 01_soul.md) → Valores e comportamento
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
├─ 🧠 MEMÓRIA (O que lembro)
│  ├── MEMORY.md            → Contexto vivo (atualizado, histórico de anotações)
│  └── memory/              → Histórico de sessões por data
│
├─ ⚙️ SISTEMA
│  ├── HEARTBEAT.md         → Tarefas periódicas
│  ├── TOOLS.md             → Notas locais (câmeras, SSH, etc)
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
- Leia: **IDENTITY.md** (nome, role, emoji)
- Leia: **01_soul.md** (valores, comportamento, princípios)

### 2️⃣ Quero entender a empresa?
- Leia: **empresa.md** (CNPJ, mercado, equipe, sistemas, regras de negócio)

### 3️⃣ Quero saber como Claudia deve agir?
- Leia: **agentes.md** (mapa da equipe, escalação, árvore de decisão)
- Leia: **regras.md** (políticas, limites, o que NUNCA fazer)

### 4️⃣ Quero entender as rotinas?
- Leia: **operacao.md** (cron tasks, templates, monitoramento)

### 5️⃣ Quero saber quais ferramentas Claudia usa?
- Leia: **02_skills.md** (Trello, Pipedrive, Google Drive, Brave Search, etc)

### 6️⃣ Quero consultar memória ou contexto histórico?
- Leia: **MEMORY.md** (contexto vivo + notas importantes)
- Consulte: **memory/** (histórico de sessões por data)

---

## 🎯 Responsabilidades da Claudia

| Função | Arquivo |
|--------|---------|
| Monitorar tarefas e prazos | operacao.md |
| Cobrar responsáveis | agentes.md |
| Organizar agenda do Gabriel | operacao.md |
| Consolidar informações | MEMORY.md |
| Alertar sobre riscos | regras.md, operacao.md |
| Gerenciar Trello | 02_skills.md |
| Gerenciar Pipedrive | 02_skills.md |
| Comunicar com clientes | agentes.md, operacao.md |
| Escalar problemas | agentes.md |

---

## 🔄 Fluxo de Decisão Rápido

```
1. Cliente pergunta algo?
   → agentes.md (Árvore de Escalação)

2. Equipe tem bloqueio?
   → agentes.md (Árvore de Escalação)

3. Claudia detecta problema?
   → operacao.md (Detecção de Problemas)

4. Não sabe o que fazer?
   → agentes.md (Quando Claudia não sabe o que fazer)

5. Precisa verificar segurança?
   → regras.md (Políticas & Limites)

6. Precisa fazer comunicação?
   → operacao.md (Templates de Relatórios)
```

---

## 🔐 Credenciais & Segurança

- ✅ Todas as API keys em: `/data/.openclaw/credentials/` (seguro)
- ❌ NUNCA exponha credentials em chat
- 🔒 Leia: **regras.md** (Segurança)

---

## 📅 Última Atualização

- **Data:** 26/03/2026
- **Versão:** 1.0 (Reorganização)
- **Status:** ✅ Estrutura limpa e consolidada

---

## 🚀 Próximas Etapas

- [ ] Inicializar Git e fazer primeiro commit
- [ ] Conectar ao GitHub
- [ ] Validar FASES de operação com Gabriel
- [ ] Começar FASE 1 (Observação)
- [ ] Setup de cron tasks
- [ ] Conectar Pipedrive (leitura/escrita)
- [ ] Conectar Trello (monitoramento)

---

*README.md — Estrutura de Claudia v1.0*
