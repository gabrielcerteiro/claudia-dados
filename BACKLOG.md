# BACKLOG — Demandas em Aberto
**Última atualização:** 11/04/2026 20:35

---

## 🔴 CRÍTICO (Bloqueado/Atrasado)

### 1. WhatsApp — Reset Aguardando Segunda
- **Status:** ⏳ Standby até seg 15/04
- **Problema:** Credenciais corrompidas (creds.json restaura de backup toda vez)
- **O que falta:** 
  - ✅ Gabriel vai ao escritório segunda (08:30)
  - Pega celular +554796418494
  - Escaneia novo QR code gerado
- **Proprietário:** Gabriel
- **Impacto:** Bot online mas sem receber/processar mensagens
- **Próximo:** Segunda 15/04 às 10h00 — Claudia cobra

### 2. Montpellier Residence | Paulo — Atrasado
- **Status:** ⚠️ 1 dia vencido (venceu 10/04)
- **Tarefa:** Financiamento
- **O que falta:** Cobrar Paulo (pode ser manual ou automático)
- **Proprietário:** Paulo / Claudia (operação)
- **Próximo:** Enviar mensagem hoje

---

## 🟡 DECISÃO PENDENTE (Esperando Gabriel)

### 3. 18 Deals Parados no Pipedrive
- **Status:** 🟡 R$39,1M em pipeline, sem movimento >8 dias
- **Breakdown:**
  - 8 em "Lead brifado" (R$18,9M) — faltam opções ou sem resposta?
  - 7 em "Opções enviadas" (R$12,7M) — novo contato, descartar ou reclassificar?
  - 1 visita feita (Keily Moser, R$3,2M) — próximo passo?
- **O que falta:** Decisão de estratégia (ativar/descartar)
- **Proprietário:** Gabriel
- **Ação recomendada:** Reunião rápida com Rafaela/Camilla

### 4. Certeiro One v1.2.2 — Em Validação
- **Status:** 🟡 Claude Code fez alterações, falta testar
- **Mudanças feitas:**
  - Delete 4 propriedades órfãs
  - Update registro.html (fetch only active exclusividades)
  - Edge Function para user creation seguro
  - Role-based access control
  - Remove credenciais expostas
- **O que falta:** Validar em staging, fazer PR pro main
- **Proprietário:** Gabriel (validação) / Claudia (deploy)

### 5. Google Drive SA — Chave inválida
- **Status:** 🟡 Service Account criada, private key não funciona
- **O que falta:** Regenerar SA no Google Cloud Console
- **Proprietário:** Gabriel (Google Cloud)
- **Impacto:** Automações de Google Drive não funcionam

### 6. Trello — Credenciais Atualizadas ✅
- **Status:** 🟢 RESOLVIDO
- **Detalhes:** Token correto agora, scan funcionando
- **Cards vencidos:** 1 (Montpellier — já listado acima)
- **Cards sem prazo:** 58 (precisam de revisão)

---

## 🟢 EM OPERAÇÃO (Claudia cuida)

### 7. Cobrança Matinal Automática
- **Status:** ✅ Funcionando
- **Horário:** 08:30 (cron ativo)
- **O que faz:** Scan Trello → cards vencidos → aviso pra responsáveis
- **Próximo:** Cobrar Paulo sobre Montpellier hoje

### 8. Scan Pipedrive Semanal
- **Status:** ✅ Funcionando
- **Frequência:** Sexta-feira 09h
- **Últimas descobertas:** 18 deals parados, R$39,1M em risco
- **Ação:** Relatório + pergunta pro Gabriel

### 9. Monitor de Visitas/Propostas
- **Status:** ⏳ Pronto (scripts criados)
- **O que falta:** Ativar cron (precisa aprovação)
- **Automação:** Detecta move pra stage 118 (Visita) / 119 (Proposta) → aplica tags + aviso

### 10. Trello Scan — Pós-Venda
- **Status:** ✅ Funcionando
- **O que faz:** Identifica cards vencidos, vencendo hoje, próximos 7d
- **Frequência:** Diário 08:30
- **Último resultado:** 1 vencido, 58 sem prazo

---

## 🟡 PENDÊNCIAS — GOOGLE WORKSPACE / HOSPEDAGEM

### 5. Google Workspace — Hospedagem e E-mail
- **Status:** 🟡 Pendente investigação
- **Tarefas:**
  - [ ] Entender como acessar a hospedagem do site
  - [ ] Verificar acesso ao Google Workspace
  - [ ] Verificar se contato@gabrielcerteiro.com.br está ativo (e se está sendo pago desnecessariamente)
  - [ ] Avaliar deletar e-mail `contato@` se não tiver uso
- **Próximo:** Gabriel confirmar quando quiser revisar isso

---

## 📋 RESUMO OPERACIONAL

| Item | Status | Quem | Próximo Passo |
|------|--------|------|---------------|
| WhatsApp | 🔴 Parado | Gabriel | Reset SSH |
| Montpellier | ⚠️ 1d atrasado | Paulo/Claudia | Cobrar hoje |
| Deals parados | 🟡 R$39M | Gabriel | Decisão strategy |
| Certeiro One | 🟡 Validação | Gabriel | Validar + PR |
| Google Drive SA | 🟡 Chave inválida | Gabriel | Regenerar |
| Trello scan | ✅ OK | Claudia | Operando |
| Pipedrive scan | ✅ OK | Claudia | Operando |
| Visitas/Propostas | ⏳ Pronto | Claudia | Ativar cron |

---

## 🎯 PRÓXIMA SEXTA (16/04) — CHECK-IN

- [ ] WhatsApp — Reset completo e testado
- [ ] Montpellier — Resolvido ou escalado
- [ ] Deals parados — Estratégia definida
- [ ] Certeiro One — v1.2.2 em produção
- [ ] Google Drive — SA regenerada
