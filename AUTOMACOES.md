# AUTOMAÇÕES — Claudia
## Atualizado: 02/04/2026

---

## STATUS GERAL
- Script monitor-visitas.sh: ✅ criado, testado
- Cron monitor-visitas: ❌ pendente
- Monitor propostas: ❌ pendente
- Tags no Pipedrive: ✅ criadas manualmente

---

## AUTOMAÇÃO 1: VISITA FEITA

**Trigger:** Visita cadastrada em https://visitas.gabrielcerteiro.com.br/
**Banco:** Supabase vtykzralkxlbqqkleofl.supabase.co — tabela `visitas`
**Script:** /data/.openclaw/workspace/scripts/monitor-visitas.sh
**Estado:** /tmp/visitas_last_id.txt

**Lógica:**
1. Busca visitas novas (mais recentes que último ID)
2. Verifica se é exclusividade (Casa Ressacada, Suncoast 1601, Cezanne 1701, Soho 1102, Marechiaro 402)
3. Acha deal no Pipedrive pelo nome → notifica Gabriel pra confirmar tag
4. Não acha → pede Gabriel identificar o deal

**Cron:** a cada 15 min via cron tool (pendente)

---

## AUTOMAÇÃO 2: PROPOSTA FEITA

**Trigger:** Deal entra no stage 119 (Proposta Feita) — Pipeline 19
**Lógica:**
1. Detectar deal no stage 119
2. Perguntar Gabriel se proposta foi em exclusividade
3. Aplicar tag EX | Proposta | [Imóvel]
4. Se >3 dias no stage → perguntar de novo

**Status:** pendente — criar script + cron

---

## TAGS PIPEDRIVE (criadas manualmente)
- EX | Proposta | Casa Ressacada / Suncoast 1601 / Cezanne 1701 / Soho 1102 / Marechiaro 402
- EX | Visita | Casa Ressacada / Suncoast 1601 / Cezanne 1701 / Soho 1102 / Marechiaro 402
⚠️ API de tags não funciona nessa conta — só manual

---

## DADOS TÉCNICOS
- Pipeline Funil de Vendas: ID 19
- Stage Visita Feita: 118 | Proposta Feita: 119
- Pipedrive token: /data/.openclaw/credentials/pipedrive.env
- Supabase URL: https://vtykzralkxlbqqkleofl.supabase.co
- Relatório visitas: https://visitas.gabrielcerteiro.com.br/

---

## CREDENCIAIS PENDENTES (salvar no cofre manualmente)
1. GitHub: /data/.openclaw/credentials/github.env → GITHUB_TOKEN=xxx
2. Supabase service role: adicionar em supabase.env → SUPABASE_SERVICE_ROLE_KEY=xxx
   (https://supabase.com/dashboard/project/vtykzralkxlbqqkleofl/settings/api)

---

## PRÓXIMOS PASSOS
1. Gabriel salva Supabase service role key no cofre
2. Criar cron monitor-visitas (15min)
3. Criar script + cron monitor-propostas
4. Testar fluxo completo
