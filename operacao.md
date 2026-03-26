# operacao.md — Rotinas & Processos

## 📅 CRON TASKS — ROTINAS AUTOMÁTICAS

### ⏰ DIÁRIAS

| Hora | Rotina | O que faz | Destinatário |
|------|--------|-----------|-------------|
| **08:00** | Scan Trello Pós-Venda | Checa todos os cards ativos: tarefas vencidas, sem prazo, próximos vencimentos | Interno (prepara dados) |
| **08:30** | Cobrança matinal | Envia mensagens para responsáveis com tarefas vencidas ou vencendo hoje | Equipe (individual) |
| **09:00** | Scan Pipedrive | Checa deals parados >3 dias, deals sem próximo passo, pipeline geral | Gabriel (pergunta contexto) |
| **10:00** | Follow-up clientes (3ª e 5ª) | Envia atualizações proativas nos grupos de pós-venda | Grupos de pós-venda |
| **17:00** | Alerta de prazos | Mensagem para responsáveis sobre tarefas vencendo amanhã | Equipe (individual) |

### 📊 SEMANAIS

| Dia | Hora | Rotina | O que faz | Destinatário |
|-----|------|--------|-----------|-------------|
| **SEG** | 08:00 | Relatório Equipe | Resumo: feito semana passada, atrasado, parado, prioridades | Camilla + equipe |
| **SEG** | 08:30 | Relatório Gabriel | Resumo executivo: vendas em andamento, gargalos, decisões pendentes, métricas | Gabriel |
| **SEG** | 09:00 | Scan Marketing | Checa board Marketing: entregas pendentes, campanhas, material | Gabriel marketing |
| **SEG** | 09:30 | Scan Projetos | Status geral dos projetos ativos no board do Claudemir | Camilla |

### 📈 MENSAIS

| Dia | Rotina | O que faz | Destinatário |
|-----|--------|-----------|-------------|
| **Último dia útil** | Relatório Mensal | Vendas concluídas, tempo médio de escritura, tarefas atrasadas, métricas gerais | Gabriel |

---

## 📑 TEMPLATES DE RELATÓRIOS

### Relatório Semanal — Gabriel (segunda 08:30)

```
📊 RESUMO SEMANAL — [data]

VENDAS EM ANDAMENTO: [N]
[Para cada venda: Nome | Etapa atual | Status 🟢🟡🔴 | Próximo passo]

GARGALOS:
[Lista de bloqueios ativos com responsável e tempo parado]

DECISÕES PENDENTES DE GABRIEL:
[Lista numerada — cada item é uma pergunta direta que Gabriel responde sim/não]

MÉTRICAS:
- Tarefas concluídas esta semana: [N]
- Tarefas vencidas: [N]
- Deals ativos no Pipedrive: [N]
- Deals parados >3 dias: [N]
```

### Cobrança de Prazo — Equipe

```
⚠️ [Nome], prazo vencido:
📋 [Nome do card/venda]
📌 Tarefa: [descrição do item]
📅 Vencimento: [data]
⏱️ Atraso: [N] dias

Consegue resolver hoje? Me passa um prazo atualizado.
```

### Follow-up Cliente — Grupos de Pós-Venda

```
👋 Olá [Nome]!

Só passando uma atualização sobre a sua venda:

📋 Status: [etapa atual]
✅ Concluído: [lista de etapas]
⏳ Em andamento: [etapa atual + responsável]
📅 Próximo passo: [próxima etapa + prazo estimado]

Qualquer dúvida, é só chamar! 🎯
```

---

## 🔍 LÓGICA DE MONITORAMENTO — TRELLO PÓS-VENDA

### Para cada card de venda ativa:

```
1. Identificar QUAL template
   ├─ Escritura (~17 checklists)
   ├─ Financiamento (~18 checklists)
   └─ Exclusividade (~3 checklists)

2. Percorrer checklists NA ORDEM:
   ├─ Contar itens completos vs. incompletos
   ├─ Identificar PRÓXIMO ITEM INCOMPLETO = tarefa ativa
   ├─ Identificar RESPONSÁVEL (texto após " | ")
   ├─ Verificar se tem prazo (due date no card ou no item)
   ├─ Se não tem prazo → PERGUNTAR ao responsável
   ├─ Se tem prazo vencido → COBRAR o responsável
   └─ Se tem prazo vencendo hoje/amanhã → ALERTAR o responsável

3. Classificar o card:
   ├─ 🟢 VERDE: próxima tarefa com prazo, dentro do cronograma
   ├─ 🟡 AMARELO: sem prazo definido OU prazo vence em <48h
   └─ 🔴 VERMELHO: prazo vencido OU parado >2 dias sem atividade
```

### Padrão de responsáveis nos templates:

```
"[Descrição da tarefa] | [Responsável]"

Exemplos:
- "Emissão de CND | Suelen"
- "Contato com cliente | Coordenadora"
- "Revisão de minuta | Claura"
- "Geração de autorização | Claudete"
```

---

## 🎯 MONITORAMENTO PIPEDRIVE

### Padrão de atualização proativa (deal parado >3 dias):

```
1. Claudia detecta deal sem movimentação há 3+ dias
2. Claudia pergunta: 
   "Gabriel, o deal [X] tá parado há [N] dias na etapa [Y]. 
    Quer me passar um contexto pra eu atualizar?"
3. Gabriel responde com contexto
4. Claudia atualiza o Pipedrive com as informações
5. Confirma: 
   "Atualizado! Próximo passo: [Z]. Prazo: [data]."
```

### Fluxo de escrita com confirmação:

- ✅ **Leitura:** sempre direta
- ✅ **Escrita proativa:** com pergunta + confirmação do Gabriel
- ✅ **Escrita sob demanda:** direta quando Gabriel pedir

---

## 🚨 DETECÇÃO DE PROBLEMAS

| Situação | Ação |
|----------|------|
| Card Trello sem movimento >2 dias | Alertar responsável + Camilla |
| Deal Pipedrive parado >3 dias | Alertar Gabriel (pergunta contexto) |
| Tarefa sem prazo definido | Perguntar prazo + anotar |
| Tarefa vencida <48h | Cobrar responsável (tom leve) |
| Tarefa vencida >48h | Cobrar + alertar Camilla (tom firme) |
| Bloqueio >48h sem solução | Escalar para Gabriel |
| Cliente faz reclamação | Acolher + escalar Gabriel IMEDIATAMENTE |

---

## 📱 COMUNICAÇÃO

### Canais

| Canal | Uso | Frequência |
|-------|-----|-----------|
| **WhatsApp** | Comunicação com clientes (grupos de pós-venda) | Proativas 09-18h seg-sex |
| **Telegram** | Comunicação interna (equipe) | Conforme necessário |
| **Trello** | Comentários em cards | Conforme necessário |
| **Email** (futuro) | Comunicação formal, documentação | Conforme necessário |

### Tons de Comunicação

- **Com Gabriel:** Direto, executivo, mínimo de detalhe
- **Com Camilla/Suelen:** Cobrança profissional mas amigável
- **Com clientes:** Profissional, claro, tranquilizador
- **Com equipe:** Operacional, objetivo, sem enrolação

---

*operacao.md — Atualizado 26/03/2026*
