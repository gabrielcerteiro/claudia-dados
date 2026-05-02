# SKILL_DRIVE_ARQUIVAR_DOC.md — Arquivamento de Documentos no Drive via WhatsApp
**Última atualização:** 02/05/2026
**Branch:** `claude/check-document-payload-LQ9b2`
**Status:** Etapa 1 em construção — bloqueado aguardando payload real de doc do stevo.chat

---

## Contexto

Gabriel envia documentos pro WhatsApp da Claudia. Hoje (sem essa skill) ele precisa salvar manualmente no Drive certo. Esta skill automatiza:

1. Doc chega via WhatsApp → Claudia pergunta: tipo (compra/exclusividade) + cliente + imóvel
2. Cria pasta na staging correta com nome `Imóvel | Cliente`
3. Sobe o arquivo
4. Quando o negócio fechar (Etapa 2, futura): move pra pasta de fechados + renomeia com prefixo `V[NNNN]` ou `E[NNNN]`

---

## Arquitetura mental

```
WhatsApp recebe doc → Claudia pergunta tipo + cliente + imóvel
                           ↓
                  [Compra] ou [Exclusividade]
                           ↓
              Cria/encontra pasta "Imóvel | Cliente"
                           ↓
                       Sobe arquivo
                           ↓
                Aguarda evento "negócio fechado"  ← Etapa 2
                           ↓
        Move para [Vendas] ou [Exclusividades fechadas] + renomeia
```

---

## Decisões já tomadas (não rediscutir)

### 1. Pastas do Drive (4 IDs confirmados)

| Pasta | ID | Uso |
|---|---|---|
| Compra (ativos) | `1YLGn5d_45wAEw5I-QE1LBPX10oxgSH8_` | Staging compras |
| Exclusividade (ativos) | `1mNrFk3nleej4Hu6UamLXbjZ-ED70-1Pj` | Staging exclusividades |
| Vendas (fechados) | `1DdC9nTy2LomyOOaSVlsQLKcqY9d9jkb0` | Compras concluídas |
| Exclusividades (fechadas) | `17mFrwbk7jvXcb3N4AeayPyJCkEbkkacj` | Exclusividades concluídas |

### 2. Padrão de nome

- **Staging (sem código):** `Sun Coast 1601 | João` — formato `Imóvel | Cliente`
- **Ao fechar (com código sequencial):**
  - Vendas: `V0350 - Sun Coast 1601 | João`
  - Exclusividades: `E[NNNN] - Imóvel | Cliente` (contador próprio E, não V)
  - Exclusividades já seguem esse padrão hoje: `E47 | Sun Coast 1601`, `E48 | Cezanne 1701`, ..., `E57 | Duetto 1803 B`

### 3. Geração do próximo código (Etapa 2)

- Lista a pasta de fechados (Vendas ou Exclusividades) → pega maior `V[NNNN]`/`E[NNNN]` → +1
- Exclusividade usa contador `E` próprio, não `V`

### 4. UX: multi-turn (não legenda)

- Gabriel manda doc → Claudia pergunta no WhatsApp → Gabriel responde → Claudia salva
- Não vamos parsear legenda do doc nesta versão

### 5. Gatilho do fechamento (Etapa 2)

- Pendente decidir: Gabriel fala no WhatsApp ("fechei o negócio do João") OU vem automático do ZapSign quando contrato é assinado
- **Não bloqueia Etapa 1**

### 6. Pasta `_inbox` temporária

- Criar `_inbox-claudia` programaticamente dentro de **Compra (ativos)** quando primeira execução
- Função: segurar o arquivo entre "doc chegou" e "Gabriel respondeu tipo+cliente+imóvel"
- Move pra pasta final quando agente recebe contexto completo

---

## Implementação faseada

### ✅ Etapa 1 (em construção agora)
- Receber doc via WhatsApp
- Claudia perguntar tipo + cliente + imóvel
- Criar pasta na staging
- Subir arquivo

### 🔲 Etapa 2 (depois)
- Comando de fechamento (gatilho a definir)
- Lista pasta de fechados → próximo código
- Renomeia pasta com `V[NNNN]` ou `E[NNNN]`
- Move pra pasta de fechados

---

## Bloqueador atual (único)

### Payload de documento do stevo.chat

O webhook do orquestrador (`aEx98En6H0rHvgCa`) hoje só parseia mensagens de texto (`Message.conversation`). Não sabemos o formato exato quando chega:
- PDF/imagem como base64 inline?
- URL temporária + chamada `/get/media`?
- Estrutura Baileys padrão (`Message.documentMessage` com `url`, `mediaKey`)?

**Como destravar:** Gabriel manda 1 PDF de teste pro WhatsApp da Claudia → Claude Code pega o payload via `get_execution` no n8n → constrói com o formato real.

---

## Componentes a criar no n8n

### Sub-workflow: `skill_drive_arquivar_doc`
- **Tipo:** tool reutilizável (chamada pelo orquestrador)
- **Input:** `{ tipo, cliente, imovel, drive_file_id }`
- **Lógica:**
  1. Procura pasta `Imóvel | Cliente` na staging do tipo correto
  2. Se não existe, cria
  3. Move o arquivo do `_inbox-claudia` pra essa pasta
  4. Retorna URL da pasta

### Update no orquestrador `aEx98En6H0rHvgCa`
- Filtro aceita `documentMessage`/`imageMessage` além de `conversation`
- Quando chega doc:
  - Baixa do stevo.chat
  - Sobe no `_inbox-claudia` no Drive
  - Manda contexto pro agente: "Recebi `arquivo.pdf` (file_id X). Pergunte tipo/cliente/imóvel."
- Agente recebe a tool `arquivar_doc_pendente`
- Quando Gabriel responde, agente chama tool → tool faz o move

---

## Como retomar em outra sessão

> *"Leia `SKILL_DRIVE_ARQUIVAR_DOC.md` e `N8N_AUTOMACOES.md` no repo `gabrielcerteiro/claudia-dados`. Estou na branch `claude/check-document-payload-LQ9b2` continuando a Etapa 1 da skill de arquivamento de documentos."*

Se já tiver o payload do stevo capturado, mencionar:
> *"Payload de doc do stevo já capturei na execução [ID] do workflow `aEx98En6H0rHvgCa`."*
