# CONTEXTO DE ALTERAÇÕES — CERTEIRO ONE v1.2.2

**Data:** 07/04/2026  
**Versão:** v1.2.2-fix/cleanup  
**Executar em:** Claude Code  
**Repositório:** github.com/gabrielcerteiro/dashboard-certeiro  

---

## RESUMO DAS ALTERAÇÕES

Consolidação de lista de imóveis: remover órfãos (sem exclusividade) e centralizar toda a operação na lista oficial de exclusividades.

---

## 1. LIMPEZA DO BANCO DE DADOS

### 1.1 Deletar imóveis órfãos e seus registros

**Imóveis a deletar (SEM exclusividade):**
- Laguna 1202
- Smart São João 506
- Lago di Garda 1301
- Reserva Perequê 2101

**Procedimento:**
1. Deletar todas as `visitas` onde `imovel_nome` = um desses 4
2. Deletar todas as `propostas` onde `imovel_id` aponta pra esses 4
3. Deletar os `imoveis` com esses nomes

**SQL (executar no Supabase SQL Editor):**
```sql
-- Deletar visitas dos órfãos
DELETE FROM visitas WHERE imovel_nome IN ('Laguna 1202', 'Smart São João 506', 'Lago di Garda 1301', 'Reserva Perequê 2101');

-- Deletar propostas dos órfãos (via imovel_id)
DELETE FROM propostas 
WHERE imovel_id IN (
  SELECT id FROM imoveis WHERE nome IN ('Laguna 1202', 'Smart São João 506', 'Lago di Garda 1301', 'Reserva Perequê 2101')
);

-- Deletar os imóveis órfãos
DELETE FROM imoveis WHERE nome IN ('Laguna 1202', 'Smart São João 506', 'Lago di Garda 1301', 'Reserva Perequê 2101');
```

### 1.2 Validar lista oficial

**Imóveis que devem permanecer (com exclusividade ativa):**
- Casa Ressacada
- Cezanne
- Soho 1102
- Marechiaro 402
- Felicita 802
- Felicita 505

**Verificar no Supabase:**
```sql
SELECT i.id, i.nome, e.status, e.data_inicio
FROM imoveis i
INNER JOIN exclusividades e ON i.id = e.imovel_id
ORDER BY i.nome;
```

**Resultado esperado:** 6 imóveis com status = 'ativa'

---

## 2. ALTERAÇÕES NO FRONTEND

### 2.1 Atualizar `registro.html`

**Problema:** Dropdown de visitas/propostas traz lista de TODOS os imóveis (incluindo órfãos).

**Solução:** Alterar query pra buscar APENAS imóveis com exclusividade ativa.

**Locais a atualizar em `registro.html`:**

1. **Função que carrega dropdown de imóveis:**
   ```javascript
   // ANTES: SELECT all from imoveis
   // DEPOIS: SELECT imoveis com JOIN em exclusividades onde status = 'ativa'
   
   const { data: imoveis } = await supabase
     .from('imoveis')
     .select(`
       id, 
       nome,
       preco,
       proprietario,
       exclusividades!inner(id, status, data_inicio)
     `)
     .eq('exclusividades.status', 'ativa')
     .order('nome');
   ```

2. **Atualizar label/dados exibidos:**
   - Mostrar além do nome: `proprietario`, `preco`
   - Facilitar identificação do imóvel correto

### 2.2 Adicionar validação de roles (controle de acesso)

**Problema:** Sem controle de roles no frontend — qualquer usuário que saiba um ID acessa os dados.

**Solução:** Adicionar função que valida role ANTES de renderizar dados sensíveis.

```javascript
// Função de verificação
async function getUserRole() {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return null;
  
  // Buscar role do usuário (adicionar campo `role` na tabela auth.users ou criar tabela user_roles)
  const { data: profile } = await supabase
    .from('user_profiles') // criar essa tabela se não existir
    .select('role')
    .eq('user_id', user.id)
    .single();
  
  return profile?.role || null;
}

// Usar em componentes sensíveis
const role = await getUserRole();
if (role !== 'admin' && role !== 'operacional') {
  // esconder/bloquear ação
}
```

---

## 3. CRIAR EDGE FUNCTION DE CADASTRO DE USUÁRIOS

**Problema:** `sb.auth.signUp()` no frontend derruba sessão do admin e não salva usuários.

**Solução:** Edge Function server-side com `service_role`.

**Arquivo a criar:** `supabase/functions/create-user/index.ts`

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const supabaseUrl = Deno.env.get("SUPABASE_URL")
const supabaseServiceRole = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")

const supabase = createClient(supabaseUrl, supabaseServiceRole)

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 })
  }

  try {
    const { email, password, role } = await req.json()

    if (!email || !password || !role) {
      return new Response(
        JSON.stringify({ error: "email, password, role required" }),
        { status: 400 }
      )
    }

    // Criar usuário no Auth
    const { data: authData, error: authError } = await supabase.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
    })

    if (authError) {
      return new Response(JSON.stringify({ error: authError.message }), { status: 400 })
    }

    // Criar perfil com role
    const { error: profileError } = await supabase
      .from("user_profiles")
      .insert([
        {
          user_id: authData.user.id,
          email,
          role,
        },
      ])

    if (profileError) {
      return new Response(JSON.stringify({ error: profileError.message }), { status: 400 })
    }

    return new Response(
      JSON.stringify({
        success: true,
        user_id: authData.user.id,
        email,
        role,
      }),
      { status: 201 }
    )
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 })
  }
})
```

**Como usar no frontend:**
```javascript
async function createNewUser(email, password, role) {
  const response = await fetch(
    'https://vtykzralkxlbqqkleofl.functions.supabase.co/create-user',
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password, role })
    }
  )
  return response.json()
}
```

---

## 4. REMOVER CHAVE SUPABASE EXPOSTA

**Problema:** Anon Key commitada em texto puro em `CONTEXTO_CLAUDE_CODE.md` em repo público.

**Solução:** Remover do arquivo e usar variáveis de ambiente.

**Ações:**
1. Remover Anon Key do `CONTEXTO_CLAUDE_CODE.md`
2. Adicionar `.env.local.example` com placeholder
3. Documentar que chaves devem vir de variáveis de ambiente, não do código

---

## 5. VERSIONAMENTO E COMMIT

**Branch:** `v1.2.2-fix/cleanup`

**Commits (na ordem):**
1. `[v1.2.2] feat: remove orphan properties and consolidate data`
2. `[v1.2.2] fix: update registro.html to fetch only active exclusivities`
3. `[v1.2.2] feat: add role-based access control to frontend`
4. `[v1.2.2] feat: create Edge Function for secure user creation`
5. `[v1.2.2] security: remove exposed Supabase keys from documentation`

**Após commits:**
1. Fazer push do branch
2. Você valida em staging
3. Você cria PR pra `main` e faz merge

---

## 6. CHECKLIST FINAL

- [ ] Deletar órfãos do Supabase (SQL executado)
- [ ] Validar que 6 imóveis com exclusividade permanecem
- [ ] Atualizar `registro.html` — dropdown busca só imóveis com exclusividade
- [ ] Criar Edge Function de cadastro de usuários
- [ ] Adicionar validação de roles no frontend
- [ ] Remover chaves expostas da documentação
- [ ] Fazer commits com versionamento `[v1.2.2]`
- [ ] Fazer push do branch `v1.2.2-fix/cleanup`
- [ ] Testar em staging
- [ ] Fazer PR e merge pra `main`

---

**Próximas versões:**
- **v1.2.3:** Alertas de usuário + email notifications
- **v1.3.0:** Dashboard de disparos para Rafaela + Overview por status
