# SKILL.md — Monitoramento de Mercado e Concorrentes
## Claudia · Gabriel Certeiro Imóveis

---
name: market-monitoring
description: Monitoramento semanal do mercado imobiliário de alto padrão em Itajaí/SC. Usar quando precisar pesquisar imóveis de concorrentes nos bairros Fazenda e Praia Brava, comparar com a pauta da Gabriel Certeiro, e gerar relatório para Gabriel. Também usar quando Gabriel pedir informações sobre concorrentes, imóveis no mercado, ou oportunidades de captação.
---

## OBJETIVO

Pesquisar semanalmente todos os imóveis de 3 e 4 suítes, prontos, nos bairros Fazenda e Praia Brava (Itajaí/SC), anunciados por concorrentes. Comparar com a pauta da Gabriel Certeiro (Google Sheets) e gerar relatório com oportunidades.

---

## FILTROS DE BUSCA

### Critérios obrigatórios:
- **Tipologia:** 3 suítes OU 4 suítes
- **Status:** Prontos (não lançamentos, não planta)
- **Bairro:** Fazenda OU Praia Brava
- **Cidade:** Itajaí/SC
- **Faixa de preço:** Acima de R$ 1.500.000

### Prédios monitorados — BAIRRO FAZENDA (~50 prédios):

Cezanne, Exclusive, Marechiaro, Marine Vision, Valência, Serenety, Classic, Lcqua, Soho, Volpi, Maison Royalle, Portal do Sol, Gran Soleil, Camboriú Tower, Porto Atlântico, November, Van Gogh, Al Mare, Marettimo, Brisa do Mar, Gran Marine, Sun Coast, Nobhill, Lotisa Home Club, Tarsila do Amaral, Maison D'Lurdes, Chateau Versailles, Ópera, Tivolli, Sant Moritz, Infinita, Velasquez, Skyline, Frontmare, Vivacitá, Vistamare, Starclass, Monte Viso, Laguna, Motirá, Chelsea

### Prédios monitorados — PRAIA BRAVA (~80+ prédios):

**Frente Mar:**
Bravissima, Brava Beach Aroeira, Mirage, Quintas do Arpoador, Brava Villi, Tirreno, Sunrise, Bay House, Prédio de Brusque, Prédio da CEG, Brava Beach Corais, Brava Prime

**Quadra Mar:**
Brava Home, Le Blanc, Amores da Brava, Surfer Paradise, Solares da Brava, Privillge, Square Hobus, Sunset Brava, Brava Beach Aroeira, Brava Beach Figueira, Brava Garden, Cala d'Our, Ocean Wind, Brava Palace, Brava Village, Porto Madeiro, Tamisa, Saint Antonie, Brava Premium, Riva, Brava Arts, Brava 22

**Segunda Quadra:**
Helicônia, Colina da Brava, Emerald Residence, JK399, Brava Unique, Aloha, Bora Bora

**Osvaldo Reis:**
Riviera Concept, Torres da Brava, Duo CK, Brava View, Privillege Fans, Costa Rica, Brava Garden, Brava Hill, North Brava, Perola, Max Haus

**Outros Brava:**
Bravo, Brava Beach Recife, Zaya, Brava Splendore, Jardins da Brava, Brava Lux, Dusseldorf, Brava Vel, Sun Seeker, Brava Select, Brava Sexteen, Artefacto, Habitat, Pantai Brava, Brava Ocean, Brava Green, Positano, Salt, Soul Brava, Manu Bay, Sky Brava, Brava Breeze, Brava Valley, Adoratta

---

## ESTRATÉGIA DE BUSCA

### Fontes de busca (via web_search Brave):

**PRIORIDADE: Sites de imobiliárias concorrentes.** Portais genéricos (ZAP, Viva Real, OLX) têm muito anúncio desatualizado. Preferir sempre os sites das imobiliárias locais.

```
Rodada 1 — Sites de concorrentes (PRIORIDADE MÁXIMA):
"site:imobille.com.br apartamento Fazenda Itajaí"
"site:imobille.com.br apartamento Praia Brava"
"site:maximoveis.com.br apartamento Fazenda 3 suítes"
"site:maximoveis.com.br apartamento Praia Brava"
"site:tabimoveis.com.br apartamento Fazenda"
"site:tabimoveis.com.br apartamento Praia Brava"
"site:i3imobiliaria.com.br apartamento Fazenda 3 suítes"
"site:leorostro.com.br apartamento Fazenda Itajaí"
"site:leorostro.com.br apartamento Praia Brava"
"site:bravaimoveis.com.br apartamento Praia Brava 3 suítes"
(Repetir para cada concorrente da lista abaixo)

Rodada 2 — Por prédio premium (complementar):
"[nome do prédio] Itajaí venda apartamento"
(Focar nos prédios de maior valor: Cezanne, Exclusive, Velasquez, Bravissima, Mirage, etc.)

Rodada 3 — Busca geral (backup, só se Rodadas 1 e 2 não gerarem resultados suficientes):
"apartamento 3 suítes Fazenda Itajaí venda"
"apartamento 4 suítes Praia Brava Itajaí venda"
```

### Fontes PRIORITÁRIAS (sites de imobiliárias):
- Imobille (imobille.com.br)
- Felicita (verificar URL)
- Leo Rostro (leorostro.com.br)
- Max Imóveis (maximoveis.com.br)
- Nacita (verificar URL)
- TAB Imóveis (tabimoveis.com.br)
- I3 Imóveis (i3imobiliaria.com.br)
- Brava Imóveis (bravaimoveis.com.br)
- Brava Norte Imóveis (bravanorteimoveis.com.br)
- Imóveis na Brava (imoveisnabrava.com)
- LA Franzoi (lafranzoi.com.br)
- Ana Sorato Imóveis (anasoratoimoveis.com.br)

### Fontes SECUNDÁRIAS (portais — usar como backup):
- ZAP Imóveis (zapimoveis.com.br)
- Viva Real (vivareal.com.br)
- Imovelweb (imovelweb.com.br)
- MySide (myside.com.br)
- Meu Lar SC (meularsc.com.br)

### Fontes IGNORAR (muita coisa desatualizada):
- OLX — excesso de anúncios fantasma
- Chaves na Mão — pouca relevância no alto padrão

---

## COMPARAÇÃO COM PAUTA GABRIEL CERTEIRO

### Lógica de comparação:

```
Para cada imóvel encontrado na busca:

1. Identificar o NOME DO PRÉDIO
2. Consultar a planilha de monitoramento no Google Sheets
3. Comparar:

   PRÉDIO está na planilha E tem unidades ativas?
     → Status: ✅ JÁ TEMOS NA PAUTA
     → Se preço muito diferente (>20% discrepância): ❓ VALIDAR PREÇO

   PRÉDIO está na planilha MAS sem unidades ativas?
     → Status: ❓ PRÉDIO CONHECIDO — UNIDADE NOVA?
     → Pode ser unidade que não captamos

   PRÉDIO NÃO está na planilha?
     → Status: ❌ NÃO TEMOS
     → Oportunidade potencial de captação

   DÚVIDA sobre qualquer item?
     → Status: ❓ VALIDAR COM GABRIEL
```

---

## FORMATO DO RELATÓRIO SEMANAL

### Assunto: 📊 Relatório de Mercado — Semana [data]

```
📊 RELATÓRIO DE MERCADO — Semana de [data]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📈 RESUMO:
- Total de imóveis encontrados: [N]
- Já temos na pauta: [N]
- Não temos (oportunidade): [N]
- Para validar: [N]
- Concorrentes mais ativos: [nomes das top 3 imobiliárias]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ IMÓVEIS QUE NÃO TEMOS (oportunidades):

🏢 [Nome do Prédio] — [Bairro]
📐 [Tipologia: 3 ou 4 suítes] | [Metragem se disponível]
💰 R$ [valor]
🏪 Anunciado por: [Imobiliária/Corretor]
🔗 [Link do anúncio]
📋 Observação: [tempo no mercado se identificável, posição, andar]

🏢 [Próximo imóvel...]
...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❓ PARA VALIDAR COM GABRIEL:

🏢 [Nome do Prédio] — [Bairro]
📐 [Tipologia]
💰 R$ [valor]
🏪 [Imobiliária]
🔗 [Link]
📋 Motivo da dúvida: [ex: "prédio na pauta mas preço 25% abaixo do nosso"]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ JÁ TEMOS NA PAUTA (resumo):
[Lista simples: Prédio — Valor anunciado — Imobiliária]
(Só pra Gabriel ter visibilidade de quem mais está anunciando os mesmos imóveis)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🏪 CONCORRENTES MAIS ATIVOS ESTA SEMANA:

| Imobiliária | Qtd Anúncios | Bairros | Faixa de Preço |
|-------------|-------------|---------|----------------|
| [Nome] | [N] | [Fazenda/Brava] | R$ X — R$ Y |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 OBSERVAÇÕES DA CLAUDIA:
[Insights que Claudia identificou: tendências de preço, concorrente novo, prédio com muita oferta, oportunidade clara de captação]
```

---

## LISTA DE CONCORRENTES

### Concorrentes confirmados (monitorar semanalmente):

| Imobiliária | Site | Foco | Prédios onde atua |
|-------------|------|------|-------------------|
| **Imobille** | imobille.com.br | Fazenda + Brava, alto padrão | Cezanne, Exclusive, diversos |
| **Felicita** | (verificar URL) | Fazenda + Brava | A confirmar |
| **Leo Rostro** | leorostro.com.br | Fazenda + Brava, lançamentos e prontos | Amplo portfólio na região |
| **Max Imóveis** | maximoveis.com.br | Fazenda + Brava, alto padrão | Altimare, Brava Beach, diversos |
| **Nacita** | (verificar URL) | Fazenda + Brava | A confirmar |
| **TAB Imóveis** | tabimoveis.com.br | Praia Brava + Fazenda, alto padrão | Exclusive, Tirreno, Brava Home, Brava Breeze |
| **I3 Imóveis** | i3imobiliaria.com.br | Fazenda + Brava, sede na 7 de Setembro | Marechiaro, Marine Vision, Lotisa Classic, Exclusive, Pontal da Barra |
| **Brava Imóveis** | bravaimoveis.com.br | Praia Brava + Fazenda | Prontos e lançamentos |
| **Brava Norte Imóveis** | bravanorteimoveis.com.br | Praia Brava | Foco em investimento |
| **Imóveis na Brava** | imoveisnabrava.com | Praia Brava | Brava Beach, North Brava |
| **LA Franzoi** | lafranzoi.com.br | Fazenda + Itajaí geral | Imobiliária tradicional |
| **Ana Sorato Imóveis** | anasoratoimoveis.com.br | Fazenda + Brava | Marine Vision, Frontemare |

### Como identificar novos concorrentes:
- Toda imobiliária que aparecer anunciando 3+ imóveis nos bairros-alvo é concorrente relevante
- Registrar: nome + site + prédios onde atua
- Reportar novos concorrentes no relatório semanal
- Gabriel valida se adiciona à lista de monitoramento permanente

---

## CRON TASK

```json
{
  "name": "relatorio-mercado-semanal",
  "schedule": "0 7 * * 3",
  "prompt": "Execute a skill market-monitoring. Pesquise via web_search todos os imóveis de 3 e 4 suítes prontos nos bairros Fazenda e Praia Brava em Itajaí/SC. Compare com a planilha de monitoramento no Google Sheets. Gere o relatório semanal de mercado para Gabriel no formato definido na skill. Priorize a seção de imóveis que NÃO temos na pauta."
}
```

Frequência: **Toda quarta-feira às 07:00** (meio da semana — Gabriel recebe o relatório de mercado separado do relatório operacional de segunda).

---

## REGRAS

1. **NUNCA inventar dados.** Se não encontrou informação, não preenche. Marca como "não disponível".
2. **Links devem ser reais.** Só incluir links que apareceram nos resultados do web_search.
3. **Preços podem variar.** Portais às vezes mostram preços desatualizados. Sempre anotar a fonte.
4. **Não acessar páginas (web_fetch desabilitado).** Usar apenas títulos, snippets e URLs do web_search.
5. **Manter a lista de concorrentes atualizada.** Cada semana, se aparecer imobiliária nova nos resultados, adicionar à lista.
6. **Se a planilha do Google Sheets estiver inacessível**, gerar o relatório mesmo assim — apenas sem a coluna de comparação. Avisar Gabriel.
7. **Limite de buscas:** Máximo ~30 queries por relatório (pra caber no tier gratuito do Brave: ~1.000/mês).
