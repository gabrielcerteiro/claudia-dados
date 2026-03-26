# 🚀 SETUP: Conectar ao GitHub

## 1️⃣ Pré-requisitos

- ✅ Git já inicializado localmente
- ✅ Primeiro commit já feito
- ✅ GitHub account criado
- ✅ Token de acesso gerado

## 2️⃣ Gerar GitHub Personal Access Token

1. Acesse: https://github.com/settings/tokens
2. Clique: "Generate new token" → "Tokens (classic)"
3. Dê um nome: `claudia-openai-token`
4. Marque as permissões:
   - ✅ repo (acesso completo aos repos privados/públicos)
   - ✅ workflow (GitHub Actions — se usar depois)
5. Clique: "Generate token"
6. **COPIE o token** (você não verá novamente!)

## 3️⃣ Clonar o repositório OU criar um novo

### Opção A: Criar um novo repo no GitHub

1. Acesse: https://github.com/new
2. Nome: `claudia-openclaw` (sugestão)
3. Descrição: "Assistente executiva COO — Gabriel Certeiro Imóveis"
4. Tipo: **Private** (proteger dados da empresa)
5. NÃO inicialize com README (já temos um)
6. Clique: "Create repository"

### Opção B: Usar um repo existente

1. Vá para o repo no GitHub
2. Copie a URL HTTPS: `https://github.com/user/repo.git`

## 4️⃣ Conectar o repositório local ao GitHub

```bash
cd /data/.openclaw/workspace

# Adicionar remoto
git remote add origin https://github.com/SEU-USER/claudia-openclaw.git

# Renomear branch para 'main' (convenção moderna)
git branch -M main

# Fazer push do primeiro commit
git push -u origin main
# Será pedido: copie o TOKEN como senha
```

Pronto! 🎉 Seu repositório está sincronizado com GitHub.

## 5️⃣ Próximos passos

```bash
# Fazer mudanças
echo "alteração" > arquivo.md

# Staging
git add arquivo.md

# Commit
git commit -m "feat: descrição da mudança"

# Push para GitHub
git push
```

## 🔐 Proteção

Nunca faça commit de:
- ❌ API keys
- ❌ Senhas
- ❌ Tokens
- ❌ Credenciais

Use o `.gitignore` para ignorar esses arquivos automaticamente.

---

**Status:** Pronto para conectar. Aguardando URL do repo e token.
