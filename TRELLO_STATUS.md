# TRELLO_STATUS.md — Status de Integração

## ✅ STATUS: CONECTADO E FUNCIONAL

### Credenciais
- ✅ **API Key:** Configurada
- ✅ **Token:** Configurado
- ✅ **Variáveis de ambiente:** TRELLO_API_KEY, TRELLO_TOKEN
- 🔐 Credenciais armazenadas seguramente

### Boards Detectados

| Board | ID | Status |
|-------|-----|--------|
| **Contratos \| Pós vendas** | `6994ca303742372379a01ff4` | ✅ Principal |
| **Marketing \| Social Mídia** | `66a29f9301e035cec17285b3` | ✅ Ativo |
| **Pós Vendas Gabriel Certeiro** | `67ec580a6a9fd9408f018dd2` | ℹ️ Secundário |
| Informações | `679d0817cd05aa558fd04f66` | ℹ️ Info |
| Projeto Pessoal | `699ca5535e14bce16d2e52b0` | ℹ️ Personal |

### Board Principal: Contratos | Pós vendas

**Listas:**
- Para fazer
- Em andamento
- Aguardando
- Feito
- Template
- Finalizar algum dia

**Cards Ativos:** 6+ cards em monitoramento

---

## 🔧 Próximos Passos

### 1. Configurar Cron Tasks de Monitoramento

**08:00 - Scan Diário Trello:**
```
Verifica: Contratos | Pós vendas
  ├─ Cards em "Para fazer"
  ├─ Cards em "Em andamento"
  ├─ Cards em "Aguardando"
  └─ Identifica: vencidos, sem prazo, próximos vencimentos
```

**08:30 - Cobrança de Responsáveis:**
```
Se card tiver:
  ├─ Prazo vencido >48h → Cobrar responsável (firme)
  ├─ Prazo vencido <48h → Alertar (leve)
  └─ Sem prazo → Perguntar
```

**17:00 - Alerta de Prazos:**
```
Cards vencendo amanhã → Notificar responsáveis
```

### 2. Criar Skill de Monitoramento

Arquivo: `skills/trello-monitor/SKILL.md`

Funcionalidade:
- Ler cards diariamente
- Extrair checklists
- Identificar próximo item incompleto
- Verificar responsáveis e prazos
- Classificar: 🟢 🟡 🔴

### 3. Integrar com operacao.md

Adicionar à rotina de cron tasks:
- Horários específicos
- Responsáveis por notificação
- Templates de mensagens

---

## 📋 API Endpoints Disponíveis

```bash
# Listar boards
GET /1/members/me/boards

# Listar listas em um board
GET /1/boards/{boardId}/lists

# Listar cards
GET /1/boards/{boardId}/cards
GET /1/lists/{listId}/cards

# Ler card específico
GET /1/cards/{cardId}

# Lê checklists de um card
GET /1/cards/{cardId}/checklists

# Criar card
POST /1/cards

# Comentar em card
POST /1/cards/{cardId}/actions/comments

# Mover card
PUT /1/cards/{cardId}
```

---

## 🧪 Teste Executado

✅ Conexão estabelecida
✅ Boards listados
✅ Cards lidos
✅ Listas identificadas

**Próximo:** Configurar automação de monitoramento

---

## 📝 Notas

- Skill Trello já existe em: `/data/.openclaw/workspace/skills/trello/SKILL.md`
- Rate limits: 300 req/10s (API key), 100 req/10s (token)
- Credenciais em variáveis de ambiente (seguro)
- Pronto para cron tasks

---

*TRELLO_STATUS.md — Atualizado 26/03/2026*
