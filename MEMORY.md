# MEMORY.md — CLAUDIA

## EMPRESA
- Gabriel Certeiro Imóveis (CNPJ 46.779.145/0001-33) | Itajaí/SC
- Imóveis prontos alto padrão | Fazenda Park (R$2-2,5M) + Praia Brava (R$3M+)
- Meta 2026: R$100M VGV | Comissão 6% inegociável

## EQUIPE
- Gabriel Certeiro — dono, closer, estratégia
- Camilla — coordenação operacional, entrega de chaves
- Suelen — escrituras, pós-venda documental (~70% tarefas)
- Rafaela — pré-vendas, assistente operacional
- Gabriel (mkt) — marketing, IA, campanhas
- Felipe — videomaker
- Vitória — financeiro (BPO externo)
- Angélica Giotti — repaginação, construtora, esposa de Gabriel
- Robson Souza — corretor parceiro, tickets menores

## CONTATOS
- Ricardo Tokas | +55 47 99653-5223 | Itamirim, empresa próxima (2026-04-02)

## CANAIS DE COMUNICAÇÃO (REGRA DO GABRIEL)
- Camilla → grupo ADM e Pós Venda
- Suelen → grupo Dep. Jurídico
- Gabriel (mkt) → grupo Marketing
- Rafaela → grupo Rafaela conversas
- ❌ NUNCA falar no privado sem autorização de Gabriel

## AGENTES IA
- Claudion (estratégia), Cláudio Figueiredo (contratos), Claura (escrituras), Claudete (autorizações) → Claude.ai
- Claudemir (projetos), Claudia/eu (COO, operação) → OpenClaw

## SISTEMAS E CREDENCIAIS
- Trello: /data/.openclaw/credentials/trello.env (conta gabriel_certeiro) | Board Pós-Venda: 6994ca303742372379a01ff4 ✅
- Pipedrive: /data/.openclaw/credentials/pipedrive.env (Rafaela, suporte@gabrielcerteiro.com.br)
- n8n: /data/.openclaw/credentials/n8n.env (marketing@gabrielcerteiro.com.br)
- Supabase: /data/.openclaw/credentials/supabase.env
- ❌ NUNCA expor credentials em chat. ❌ NUNCA salvar keys aqui.

## TRELLO
- Boards: Pós-Vendas ✅ ATIVO | Marketing ❌ removido | Projetos ❌ removido | CLARA ❌ PROIBIDO
- Foco 100% Pós-Venda

## PROCESSO PÓS-VENDA
- Escritura: Contrato→Inventários→Due Diligence→Pagamentos→ITBI→Tabelionato→Registro→Entrega
- Financiamento: idem + Correspondente Bancário→Banco antes do ITBI

## REGRAS DE NEGÓCIO
- Exclusividade: 120d (pronto) / 180d (Repaginação) | Piso R$2M | Parceria 50/50
- Permuta aceita com liquidez + garantia | ~80-90% dos negócios têm permuta | Capacidade máx 8 exclusividades

## THRESHOLDS
- Trello sem movimento >2d → notificar | Pipedrive sem atividade >3d → notificar Gabriel
- Tarefa sem prazo → perguntar prazo | Vencida → cobrar | Bloqueio >48h → escalar Gabriel

## PIPEDRIVE
- 45 filtros (5 imóveis × 9): suncoast-1601, cezanne-1701, soho-1102, casa-ressacada, marechiaro-402 | IDs 7386–7430
- Pipeline "Funil de vendas (Reduzido)" = ID 19
- Field IDs: pipeline:12454 | stage_id:12456 | status:12457 | Source channel:12535 | channel_id:12536 | exclusividade_id:12561 | Imóvel:12543 | Campanha:12515
- n8n workflow Sync Pipedrive→Supabase: ID fv2Z36CMWDCnOTqS, roda 00:00 diário ✅
- Lições: origin/origin_id read-only | product_name read-only | filtros usam field_id numérico string

## LEADS ATIVOS
- Enzo: deal ID 53405, Casa Ressacada R$3,1M, visita seg 06/04 17h (activity 75903), confirmação 9h (75904)

## INFRAESTRUTURA
- OpenClaw 2026.4.1 | Bind 127.0.0.1:18789
- WhatsApp loop status 499: ocorre esporadicamente. Solução anterior: reset openclaw.json
- Grupos WhatsApp ativos: ADM/Pós-Venda, Jurídico, Marketing, Rafaela conversas

## AUTOMAÇÕES EM CONFIGURAÇÃO

**Webhook Pipedrive → WhatsApp (n8n)**
- Trigger: Deal move pra stage 118 (Visita Feita) ou 119 (Proposta Feita)
- Ação: Envia pergunta no WhatsApp "Qual imóvel foi visitado/recebeu proposta?"
- Input: Gabriel responde (pode ser múltiplos imóveis)
- Output: Aplica tags `EX | Visita | [Imóvel]` ou `EX | Proposta | [Imóvel]`
- Relatório: https://visitas.gabrielcerteiro.com.br/
- Status: Configurando em n8n (02/04)

## REGRAS CRÍTICAS (SOUL)
- NUNCA calcular datas de cabeça → usar session_status + calendário
- NUNCA matar processos com pkill/kill → usar `openclaw gateway restart`
- Áudio do Gabriel → reagir 🎤 antes de transcrever
- Custo: modelo Haiku por padrão, Sonnet só para tarefas complexas (/model sonnet)
