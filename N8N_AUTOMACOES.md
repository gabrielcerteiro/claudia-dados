# N8N_AUTOMACOES.md — Claudia no n8n
**Última atualização:** 01/05/2026
**Status geral:** Fase 1 concluída — credenciais criadas, orquestrador WhatsApp em construção

---

## Visão Geral

A Claudia opera em duas camadas no n8n:

1. **Orquestrador** — recebe tarefas via WhatsApp (stevo.chat), claude.ai/desktop ou webhooks, decide e delega
2. **Skills** — workflows pequenos com responsabilidade única, chamados pelo orquestrador

```
WhatsApp (stevo.chat)
         ↓ webhook
    CLAUDIA (orquestrador)
         ↓ AI Agent (Claude Sonnet)
  ZapSign | Drive | ContaAzul | CRM | ...
         ↑ gatilhos automáticos
    Schedule | Webhooks
         ↓ (futuro)
    Chatwoot (monitoramento de conversas)
```

---

## Instância n8n

- **URL:** `https://n8n-erpn.srv795811.hstgr.cloud`
- **Projeto:** `VjiToCFFl4SigUVT`
- **Tipo:** Self-hosted (Hostinger)
- **MCP configurado em:** `~/.claude/claude_desktop_config.json` ✅

---

## Workflows Ativos

| ID | Nome | Status | Função |
|---|---|---|---|
| `BnXulok0VMQNzqSX` | ZapSign MCP Server (Produção) | ✅ Ativo | MCP legado ZapSign — manter até Fase 2 |

---

## Workflows Criados — Aguardando Ativação

### 1. Claudia — Orquestrador Principal
- **ID:** `aEx98En6H0rHvgCa`
- **Gatilhos:** MCP (claude.ai/desktop) + Webhook POST + WhatsApp (stevo.chat)
- **Modelo:** Claude Sonnet 4.5
- **Tools base:** `registrar_execucao`, `consultar_contexto`, `listar_skills_disponiveis`
- **Memória:** Window Buffer por número de telefone (multi-usuário desde o início)
- **Futuro:** Supabase `agent_execution_log` + `agent_context`
- **Próximo passo:** Construir via Claude Code (continuar de onde o Cowork parou)

### 2. ZapSign MCP Server v2
- **ID:** `eNR0oygLCZVpD9He`
- **Tools expostas:**
  - `listar_documentos` — busca com filtros (status, pasta, data)
  - `detalhar_documento` — atributos completos + URL do PDF
  - `baixar_documento` — download do PDF assinado (URL S3 expira em 60min)
  - `reenviar_link_assinatura` — reenvia por email ou WhatsApp
- **Pendente:** ativar workflow

### 3. ZapSign → Drive + WhatsApp (Rotina Horária)
- **ID:** `dsjjoClSIFJJ8KWx`
- **Frequência:** a cada 1 hora
- **Fluxo:**
  1. Lista docs `status=signed` na ZapSign
  2. Cruza com `zapsign_processed` no Supabase (evita duplicata)
  3. Para cada novo: detalha → baixa PDF → sobe no Drive → notifica WhatsApp
- **Drive destino:** pasta `1v6ag59weRd8MblIAV9C7VicOgJv10gpJ`
- **WhatsApp destino:** `+5547996505050` (Gabriel) via Stevo.chat
- **Pendente:** popular `zapsign_processed` com tokens históricos + ativar

---

## Credenciais no n8n

> **Status em 01/05/2026** — todas criadas no painel do n8n

| Nome da Credencial | Tipo | Status |
|---|---|---|
| `Anthropic API` | Anthropic | ⏳ Pendente criar |
| `Supabase Service Key` | HTTP Header Auth | ⏳ Pendente criar |
| `MCP Bearer (Claudia)` | HTTP Bearer Auth | ✅ Criada |
| `Webhook Auth (Claudia)` | HTTP Header Auth | ✅ Criada |
| `ZapSign API Token` | HTTP Header Auth | ✅ Criada (via Stevo workflow) |
| `Google Drive Empresa` | Google Drive OAuth2 | ✅ Criada e conectada |
| `Stevo API Key` | HTTP Header Auth | ✅ Criada |
| `MCP Bearer (ZapSign)` | HTTP Bearer Auth | ✅ Criada |
| `Conta Azul` | OAuth2 API | ✅ Criada e conectada (Account connected) |

---

## Integração ContaAzul Pro — Configurada em 01/05/2026

### Dados da conexão OAuth2
- **App:** "Claudia n8n Automacao" (produção)
- **Portal:** `developers-portal.contaazul.com`
- **client_id:** `2laildfenhndb82dqphupd6cqo`
- **Authorization URL:** `https://auth.contaazul.com/oauth2/authorize`
- **Access Token URL:** `https://auth.contaazul.com/oauth2/token`
- **Redirect URL:** `https://n8n-erpn.srv795811.hstgr.cloud/rest/oauth2-credential/callback`
- **Plataforma:** ContaAzul Pro (`pro.contaazul.com`) — usa AWS Cognito, **não** `api.contaazul.com`
- **MFA:** TOTP ativo na conta (necessário no primeiro connect e reconect)

> ⚠️ **Atenção:** Os endpoints legados `api.contaazul.com/auth/*` são para o ContaAzul antigo. O ContaAzul Pro usa exclusivamente `auth.contaazul.com/oauth2/*`.

### Skills planejadas (ContaAzul)
| Skill | Descrição |
|---|---|
| `contaazul_listar_lancamentos` | Lista lançamentos financeiros com filtros |
| `contaazul_dar_baixa` | Marca pagamento/recebimento como liquidado |
| `contaazul_criar_lancamento` | Cria novo lançamento financeiro |
| `contaazul_consultar_extrato` | Consulta extrato de conta/período |

---

## WhatsApp (stevo.chat) — Plano Orquestrador

### Canal principal de entrada
- **Serviço:** stevo.chat (instável → migrar para API oficial se necessário)
- **Credencial n8n:** `Stevo API Key` ✅
- **Webhook:** n8n recebe eventos `messages.upsert` do stevo.chat
- **Filtro:** apenas mensagens de entrada (`fromMe: false`), ignorar status/notificações

### Arquitetura do fluxo
```
stevo.chat webhook POST
        ↓
extrai: número, nome, texto da mensagem
        ↓
Window Buffer Memory (chave = número de telefone)
        ↓
Claude AI Agent (Sonnet)
   ↓ tools (cada uma chama um workflow n8n)
ContaAzul | ZapSign | Drive | Pipedrive | ...
        ↓
HTTP POST → stevo.chat API → resposta no WhatsApp
```

### Usuários previstos
- **Fase inicial:** Gabriel apenas (+5547996505050)
- **Fase 2:** equipe (Camilla, Rafaela, Suelen)
- **Fase 3:** clientes (acesso limitado/filtrado)

### Chatwoot (monitoramento)
- **Status:** não instalado — instalar após orquestrador funcional
- **Função:** dashboard de todas as conversas da Claudia em tempo real
- **Instalação prevista:** Docker self-hosted (mesmo servidor n8n)

---

## Supabase — Tabelas do Agente

> Projeto: `vtykzralkxlbqqkleofl` — criadas em 01/05/2026

| Tabela | Função |
|---|---|
| `agent_execution_log` | Histórico completo de execuções da Claudia |
| `agent_context` | Cérebro persistente: empresa, equipe, configurações |
| `agent_task_queue` | Fila de tarefas com prioridade e retry |
| `agent_skill_registry` | Catálogo de skills — alimenta o system prompt |
| `zapsign_processed` | Controle de docs ZapSign já processados |

### Skills registradas em `agent_skill_registry`

| Skill | Workflow |
|---|---|
| `zapsign_listar_documentos` | `eNR0oygLCZVpD9He` |
| `zapsign_detalhar_documento` | `eNR0oygLCZVpD9He` |
| `zapsign_baixar_documento` | `eNR0oygLCZVpD9He` |
| `zapsign_reenviar_link` | `eNR0oygLCZVpD9He` |
| `rotina_zapsign_drive_whatsapp` | `dsjjoClSIFJJ8KWx` |

---

## Fases de Desenvolvimento

### ✅ Fase 1 — Fundação (01/05/2026)
- [x] Tabelas de memória no Supabase
- [x] Orquestrador criado no n8n (esqueleto: MCP + Webhook triggers)
- [x] ZapSign MCP Server v2 (4 tools)
- [x] Rotina horária ZapSign → Drive + WhatsApp
- [x] MCP do n8n configurado no Claude Desktop
- [x] Duplicatas arquivadas
- [x] Credenciais criadas: MCP Bearer, Webhook Auth, Stevo, Google Drive, ZapSign, Conta Azul
- [x] ContaAzul Pro OAuth2 conectado e autenticado (Account connected ✅)

**Ainda pendente para ativar workflows:**
- [ ] Criar credenciais: Anthropic API, Supabase Service Key
- [ ] Popular `zapsign_processed` com docs históricos antes de ativar rotina horária

---

### 🔧 Fase 1.5 — Orquestrador WhatsApp (em construção — Claude Code)
> Continuar pelo Claude Code: ler este arquivo + `IDENTITY.md` + `empresa.md` para contexto completo.

- [ ] Construir workflow completo do orquestrador (`aEx98En6H0rHvgCa`)
  - [ ] Webhook trigger para stevo.chat (`messages.upsert`)
  - [ ] Filtro de mensagens (apenas entrada, não sistema)
  - [ ] Window Buffer Memory por número de telefone
  - [ ] AI Agent (Claude Sonnet) com system prompt da Claudia
  - [ ] Tool: `contaazul_*` (4 skills financeiras)
  - [ ] Tool: `zapsign_*` (chamar workflow `eNR0oygLCZVpD9He`)
  - [ ] Resposta via stevo.chat API
- [ ] Testar com Gabriel (+5547996505050)
- [ ] Instalar Chatwoot (Docker) para monitoramento

---

### 🔲 Fase 2 — Integração ZapSign + Drive + WhatsApp
- [ ] Testar ciclo completo: doc assinado → Drive → WhatsApp
- [ ] Conectar ZapSign MCP como tool da Claudia
- [ ] Atualizar `agent_skill_registry` com webhook_urls reais

---

### 🔲 Fase 3 — CRM (Pipedrive)
- [ ] Skill: `crm_buscar_lead`
- [ ] Skill: `crm_atualizar_status`
- [ ] Integrar com scripts Pipedrive já existentes em `scripts/`

---

### 🔲 Fase 4 — Contratos ZapSign
- [ ] Skill: `contrato_criar_zapsign` (a partir de template)
- [ ] Skill: `contrato_buscar_por_cliente`

---

### 🔲 Fase 5 — Financeiro ContaAzul
- [ ] Skill: `contaazul_dar_baixa` (marcar pagamento como liquidado)
- [ ] Skill: `contaazul_consultar_extrato`
- [ ] Skill: `contaazul_criar_lancamento`

---

### 🔲 Fase 6 — Relatórios e Inteligência
- [ ] Relatório diário matinal (resumo + agenda)
- [ ] Alerta de follow-up (leads parados)
- [ ] Relatório semanal de docs assinados
- [ ] Dashboard na Plataforma Certeiro

---

## Convenções de Desenvolvimento

| Tipo | Padrão | Exemplo |
|---|---|---|
| Workflow skill | `skill_[categoria]_[acao]` | `skill_zapsign_listar` |
| Workflow rotina | `rotina_[frequencia]_[descricao]` | `rotina_horaria_zapsign` |
| Workflow agente | `agente_[nome]` | `agente_claudia` |
| Credencial n8n | `[Serviço] [Tipo]` | `ZapSign API Token` |
| Tabela agente | `agent_[nome]` | `agent_execution_log` |
| Tabela processo | `[processo]_[entidade]` | `zapsign_processed` |

### Regras técnicas
1. Sempre `validate_workflow` antes de `create_workflow_from_code`
2. Nunca hardcodar tokens — sempre `newCredential('Nome')`
3. Toda execução gera entrada em `agent_execution_log`
4. Toda nova skill é registrada em `agent_skill_registry`
5. GitHub: sempre buscar SHA antes de atualizar arquivo existente
6. ContaAzul Pro: usar endpoints `auth.contaazul.com/oauth2/*` — nunca `api.contaazul.com/auth/*`

---

## Como Reativar o Contexto em Nova Sessão

Em qualquer ambiente (claude.ai, Claude Desktop, Claude Code):

> *"Leia o arquivo `N8N_AUTOMACOES.md` no repositório `gabrielcerteiro/claudia-dados` e me diz o status atual das automações da Claudia."*

Para contexto completo da Claudia:

> *"Leia `README.md`, `IDENTITY.md`, `empresa.md` e `N8N_AUTOMACOES.md` no repositório `gabrielcerteiro/claudia-dados`."*

Para continuar o orquestrador pelo Claude Code:

> *"Leia `N8N_AUTOMACOES.md`, `IDENTITY.md` e `empresa.md` no repositório `gabrielcerteiro/claudia-dados`. Preciso continuar construindo o orquestrador WhatsApp da Claudia no n8n (projeto VjiToCFFl4SigUVT em n8n-erpn.srv795811.hstgr.cloud). O workflow esqueleto existe com ID `aEx98En6H0rHvgCa`. Credenciais Stevo e Conta Azul já configuradas. Próximo passo: Fase 1.5 do N8N_AUTOMACOES.md."*
