# Análise do Plano de Contas — Controle

**Data da Análise:** 12 de abril de 2026  
**Empresa:** Gabriel Certeiro LTDA  
**Usuário:** gabriel@gabrielcerteiro.com.br

---

## PLANO DE CONTAS ATUAL

### SAÍDAS (Despesas)

1. **1.03.01 — Aporte de Capital**
   - Tipo: Aporte / Devolução de capital
   - DRE: Sim

2. **2.01 — Impostos sobre Faturamento**
   - Tipo: Imposto direto sobre vendas
   
   - **2.01.01 — IRPJ E CSLL**
     - Descrição: "Impostos sobre vendas e serviços"
     - DRE: Sim

---

### ENTRADAS (Receitas)

1. **1.01 — Receitas de Vendas e Serviços**
   - Tipo: Receita operacional principal
   
   - **1.01.01 — Comissão de Intermediação**
     - Descrição: "Prestação de serviços"
     - DRE: Sim

2. **1.02 — Receitas Financeiras**
   - Tipo: Receita de investimentos/juros

---

### OUTROS

1. **Aplicação CDB**
   - Descrição: Investimento em CDB
   - DRE: Sim

2. **Outros**
   - Tipo: Categorização genérica

3. **Pagamento de Fatura**
   - Tipo: Operação de pagamento

---

## ANÁLISE CRÍTICA

### ✅ O que está BEM configurado:

1. **Receita principal — Comissão de Intermediação**
   - Corretamente mapeada em "1.01.01"
   - Vinculada ao DRE
   - Descrição clara: "Prestação de serviços"

2. **Imposto sobre faturamento**
   - IRPJ e CSLL separados
   - Vinculados ao DRE
   - Categoria correta para lucro real

### ⚠️ PROBLEMAS IDENTIFICADOS:

1. **"1.03.01 — Aporte de Capital" em SAÍDAS (errado!)**
   - Aporte de capital NÃO é despesa
   - Deveria estar em conta de patrimônio (classe 8 ou 9 no plano contábil)
   - **Risco:** Distorce o resultado no DRE

2. **Estrutura incompleta para operações imobiliárias:**
   - ❌ Sem categoria específica para "Comissão de Vendas Recebida"
   - ❌ Sem separação: comissão própria vs. comissão de terceiros (corretores)
   - ❌ Sem categoria para "Lucro / Prejuízo em Permutas"
   - ❌ Sem categoria para "Despesas com Repaginação" (está sendo paga? qual categoria?)
   - ❌ Sem categoria para "Mídia Paga" (publicidade/marketing)

3. **Categorias genéricas demais:**
   - "Outros" é vago — não permite análise
   - "Pagamento de Fatura" parece ser operacional, não deveria estar em "Categorias"

4. **Investimentos (CDB) em "OUTROS"**
   - Deveria estar em classe específica (Receitas Financeiras ou Investimentos)
   - CDB é investimento, não é operacional

---

## RECOMENDAÇÕES

### 1. CORRIGIR ESTRUTURA IMEDIATAMENTE:

**Saídas (Despesas):**
```
2.01 — Impostos sobre Faturamento [MANTÉM]
  2.01.01 — IRPJ e CSLL [MANTÉM]
  2.01.02 — ICMS (se aplicável)
  2.01.03 — ISS (se aplicável)

2.02 — Despesas Operacionais (NOVO)
  2.02.01 — Mídia Paga (Meta Ads, Google Ads, etc)
  2.02.02 — Honorários / Brokerage (pagamento a corretores)
  2.02.03 — Repaginação (Angélica Giotti - reformas)

2.03 — Despesas Gerais
  2.03.01 — Pessoal (folha)
  2.03.02 — Aluguel / Espaço
  2.03.03 — Serviços (contábil, jurídico, etc)
```

**Entradas (Receitas):**
```
1.01 — Receitas de Vendas e Serviços [MANTÉM]
  1.01.01 — Comissão de Intermediação [MANTÉM]
  1.01.02 — Comissão de Terceiros (corretores parceiros) (NOVO)
  1.01.03 — Lucro em Operações de Permuta (NOVO)

1.02 — Receitas Financeiras [MANTÉM]
  1.02.01 — Juros / CDB
  1.02.02 — Outras Receitas Financeiras
```

**Patrimônio / Não-Operacional (NOVO):**
```
8.01 — Aportes de Capital (aporte do sócio)
8.02 — Lucros Retidos
```

### 2. AÇÕES IMEDIATAS:

- [ ] **Mover "Aporte de Capital"** de Saídas → Classe 8 (Patrimônio)
- [ ] **Criar categorias específicas** para operações de venda (própria vs. terceiro)
- [ ] **Mapear todas as despesas de Repaginação** — criar categoria específica
- [ ] **Separar CDB** — colocar em Receitas Financeiras
- [ ] **Remover "Outros" genérico** — ser específico em cada categoria

### 3. INTEGRAÇÃO COM PIPEDRIVE

Quando um deal é ganho:
- Comissão própria → 1.01.01
- Comissão a terceiro (corretor) → 2.02.02
- Permuta → 1.01.03
- Repaginação gasta → 2.02.03

---

## QUESTÕES PARA VICTÓRIA / GABRIEL

1. **Permuta é recebida em que conta?** Deveria ser em categoria de entrada (não reduz comissão?)
2. **Repaginação (Angélica)** — está sendo paga de que forma? Fatura? Retirada?
3. **Corretores parceiros** — recebem antes ou depois do fechamento?
4. **Meta Ads / Google Ads** — está sendo pago? De qual conta?
5. **Salários da equipe** — como está sendo registrado? (Pessoal vs. Autônomo)

---

## CONCLUSÃO

**Status:** ⚠️ **PLANO INCOMPLETO E COM ERRO**

O plano serve para o básico (receita + imposto), mas **não captura a realidade operacional** de uma imobiliária. 

**Recomendação:** Refazer com Victória antes de integrar com Pipedrive automaticamente. Um lançamento errado se multiplica quando automatizado.

---

**Próximo passo:** Esperar confirmação de Gabriel e Victória sobre as questões acima para ajustar.
