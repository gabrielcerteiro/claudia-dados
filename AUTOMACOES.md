# AUTOMAÇÕES — Claudia

## Status: EM DESENVOLVIMENTO

---

## AUTOMAÇÃO 1: VISITA FEITA

**Trigger:** Visita cadastrada em https://visitas.gabrielcerteiro.com.br/

**Ação:**
1. Monitoro a landing page periodicamente (cron 5/5 min)
2. Detecta visita nova
3. Procura o deal do cliente no Pipedrive
4. Se achar → aplica tag `EX | Visita | [Imóvel]`
5. Se não tiver certeza qual cliente → pergunta no WhatsApp

**Status:** Pendente - preciso saber como acessar os dados da landing page (API? Banco de dados? Browser scraping?)

---

## AUTOMAÇÃO 2: PROPOSTA FEITA

**Trigger:** Deal move pra stage 119 (Proposta Feita) no Pipedrive

**Ação Inicial:**
1. Detecto o movimento
2. Pergunto no WhatsApp: "Proposta do [cliente] foi em qual exclusividade?"
3. Você responde
4. Aplico tag `EX | Proposta | [Imóvel]`

**Ação Follow-up (>3 dias):**
1. Se deal ficar >3 dias no stage 119 sem mover
2. Pergunto de novo: "Ouve proposta em outro imóvel?"
3. Se sim → aplico tag adicional `EX | Proposta | [Imóvel 2]`

**Stages do Funil:**
- 116 = Novo lead
- 117 = Atendimento iniciado
- 130 = Lead brifado
- 129 = Opções enviadas
- 124 = Visita agendada
- 118 = Visita feita ← futura automação 1
- 123 = Imóvel qualificado
- 119 = Proposta feita ← automação 2
- 122 = Fechamento

**Pipeline ID:** 19 (Funil de vendas Reduzido)

**Status:** Implementável agora

---

## TAGS CRIADAS NO PIPEDRIVE

Amarelo (Proposta):
- EX | Proposta | Casa Ressacada
- EX | Proposta | Suncoast 1601
- EX | Proposta | Cezanne 1701
- EX | Proposta | Soho 1102
- EX | Proposta | Marechiaro 402

Verde (Visita):
- EX | Visita | Casa Ressacada
- EX | Visita | Suncoast 1601
- EX | Visita | Cezanne 1701
- EX | Visita | Soho 1102
- EX | Visita | Marechiaro 402

**API de Tags:** Não funciona nesta conta (endpoint retorna 404)

---

## CREDENCIAIS

- Pipedrive: /data/.openclaw/credentials/pipedrive.env ✅
- n8n: /data/.openclaw/credentials/n8n.env ✅
- Landing page: API/acesso pendente

---

## PRÓXIMOS PASSOS

1. Gabriel informar como acessar dados da landing page
2. Implementar cron pra visitas
3. Implementar cron pra propostas + follow-up
4. Testar tudo
