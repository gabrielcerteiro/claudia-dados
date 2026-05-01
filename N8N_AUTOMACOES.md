# N8N_AUTOMACOES.md — Claudia no n8n
**Última atualização:** 01/05/2026
**Status geral:** Fase 1 concluída — infraestrutura pronta, aguardando credenciais

---

## Visão Geral

A Claudia opera em duas camadas no n8n:

1. **Orquestrador** — recebe tarefas via claude.ai/desktop ou webhooks, decide e delega
2. **Skills** — workflows pequenos com responsabilidade única, chamados pelo orquestrador

```
claude.ai / Claude Desktop
         ↓ MCP
    CLAUDIA (orquestrador)
         ↓ chama skills
  ZapSign | Drive | WhatsApp | CRM | ...
         ↑ gatilhos automáticos
    Schedule | Webhooks
```

---

## Instância n8n

- **URL:** `https://n8n-erpn.srv795811.hstgr.cloud`
- **Tipo:** Self-hosted (Hostinger)
- **MCP configurado em:** `~/.claude/claude_desktop_config.json` ✅

---

## Workflows Ativos

| ID | Nome | Status | Função |
|---|---|---|---|
| `BnXulok0VMQNzqSX` | ZapSign MCP Server (Produção) | ✅ Ativo | MCP legado ZapSign — manter até Fase 2 |

---

## Workflows Criados — Aguardando Credenciais

### 1. Claudia — Orquestrador Principal
- **ID:** `aEx98En6H0rHvgCa`
- **Gatilhos:** MCP (claude.ai/desktop) + Webhook POST
- **Modelo:** Claude Sonnet 4.5
- **Tools base:** `registrar_execucao`, `consultar_contexto`, `listar_skills_disponiveis`
- **Memória:** Supabase `agent_execution_log` + `agent_context`
- **Pendente:** 4 credenciais (ver seção abaixo)

### 2. ZapSign MCP Server v2
- **ID:** `eNR0oygLCZVpD9He`
- **Tools expostas:**
  - `listar_documentos` — busca com filtros (status, pasta, data)
  - `detalhar_documento` — atributos completos + URL do PDF
  - `baixar_documento` — download do PDF assinado (URL S3 expira em 60min)
  - `reenviar_link_assinatura` — reenvia por email ou WhatsApp
- **Pendente:** credenciais ZapSign + MCP Bearer

### 3. ZapSign → Drive + WhatsApp (Rotina Horária)
- **ID:** `dsjjoClSIFJJ8KWx`
- **Frequência:** a cada 1 hora
- **Fluxo:**
  1. Lista docs `status=signed` na ZapSign
  2. Cruza com `zapsign_processed` no Supabase (evita duplicata)
  3. Para cada novo: detalha → baixa PDF → sobe no Drive → notifica WhatsApp
- **Drive destino:** pasta `1v6ag59weRd8MblIAV9C7VicOgJv10gpJ`
- **WhatsApp destino:** `+5547996505050` (Gabriel) via Stevo.chat
- **Pendente:** credenciais ZapSign + Google Drive + Stevo + popular `zapsign_processed` com tokens históricos

---

## Credenciais Pendentes no n8n

> Criar em: n8n → Credentials → New

| Nome da Credencial | Tipo | Dados |
|---|---|---|
| `Anthropic API` | Anthropic | API key |
| `Supabase Service Key` | HTTP Header Auth | Name: `apikey` / Value: service_role key do projeto `vtykzralkxlbqqkleofl` |
| `MCP Bearer (Claudia)` | HTTP Bearer Auth | Token forte (qualquer string longa) |
| `Webhook Auth (Claudia)` | HTTP Header Auth | Token forte para autenticar rotinas |
| `ZapSign API Token` | HTTP Header Auth | Name: `Authorization` / Value: `Bearer TOKEN_ZAPSIGN` |
| `Google Drive Empresa` | OAuth2 | Conta Google da empresa |
| `Stevo API Key` | HTTP Header Auth | Confirmar formato no painel Stevo |
| `MCP Bearer (ZapSign)` | HTTP Bearer Auth | Token para expor ZapSign ao claude.ai |

> **Atalho:** usar o Claude Cowork para preencher os formulários no painel do n8n automaticamente, passando os tokens um a um.

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
- [x] Orquestrador criado no n8n (2 gatilhos: MCP + Webhook)
- [x] ZapSign MCP Server v2 (4 tools)
- [x] Rotina horária ZapSign → Drive + WhatsApp
- [x] MCP do n8n configurado no Claude Desktop
- [x] Duplicatas arquivadas

**Pendente para ativar:**
- [ ] Criar as 8 credenciais no n8n (usar Cowork)
- [ ] Ativar os 3 workflows
- [ ] Adicionar MCP da Claudia no claude.ai
- [ ] Popular `zapsign_processed` com docs históricos antes de ativar rotina

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

### 🔲 Fase 5 — Relatórios e Inteligência
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

---

## Como Reativar o Contexto em Nova Sessão

Em qualquer ambiente (claude.ai, Claude Desktop, Claude Code):

> *"Leia o arquivo `N8N_AUTOMACOES.md` no repositório `gabrielcerteiro/claudia-dados` e me diz o status atual das automações da Claudia."*

Para contexto completo da Claudia:

> *"Leia `README.md`, `IDENTITY.md`, `empresa.md` e `N8N_AUTOMACOES.md` no repositório `gabrielcerteiro/claudia-dados`."*
