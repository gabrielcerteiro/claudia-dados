# REPOSITORY_SECURITY.md — Segurança do Repositório

## 🔐 STATUS: REPOSITÓRIO PROTEGIDO

---

## ✅ Configurações de Segurança (GitHub)

### 1. Visibilidade
- **Status:** PRIVATE ✅
- **Acesso:** Apenas você (gabrielmarketingdocerteiro)
- **Ação:** Já está privado

**Como verificar:**
- GitHub → Repositório → Settings → General → Visibility: Private

---

### 2. Branch Protection Rules
**Recomendado configurar em GitHub (Settings → Branches):**

```
Branch: main
Protections:
  ✅ Require pull request reviews before merging
  ✅ Require status checks to pass before merging
  ✅ Require branches to be up to date
  ✅ Include administrators
```

---

### 3. Credenciais (.gitignore)
- ✅ TRELLO_API_KEY — NÃO commit (variável de ambiente)
- ✅ TRELLO_TOKEN — NÃO commit (variável de ambiente)
- ✅ PIPEDRIVE_API_KEY — NÃO commit (variável de ambiente)
- ✅ SSH keys — NÃO commit (em ~/.ssh)
- ✅ Todas as credenciais em `.gitignore`

**Localização segura:**
```
/data/.openclaw/credentials/    (local, não versionado)
Variáveis de ambiente          (runtime, não versionado)
```

---

### 4. Acesso SSH (sem expor token)
- ✅ Chave SSH gerada: `~/.ssh/id_ed25519`
- ✅ Chave pública adicionada em GitHub
- ✅ Todos os pushes via SSH (seguro)
- ✅ Token NUNCA aparece em URLs ou commits

---

### 5. Auto-Sync Seguro
**Script `git-sync.sh`:**
- ✅ Executa a cada 15 minutos
- ✅ Usa SSH (chave privada protegida)
- ✅ Logs em `.git-sync.log` (local, não versionado)
- ✅ NÃO expõe credenciais

---

## 🚨 O que NÃO deve ir pro GitHub

| Item | Status | Localização Segura |
|------|--------|-------------------|
| API Keys | ❌ NUNCA | Variáveis de ambiente |
| Tokens | ❌ NUNCA | `/data/.openclaw/credentials/` |
| Senhas | ❌ NUNCA | Não armazene |
| CPFs/Dados Pessoais | ❌ NUNCA | Google Drive (privado) |
| Chaves SSH Privadas | ❌ NUNCA | `~/.ssh/` (local) |

---

## ✅ O que PODE ir pro GitHub

| Item | Status |
|------|--------|
| Documentação (.md) | ✅ Sim |
| Scripts (sem credenciais) | ✅ Sim |
| Configuração (operacao.md, agentes.md) | ✅ Sim |
| Skills | ✅ Sim |
| .gitignore | ✅ Sim |
| Histórico de commits | ✅ Sim |

---

## 🔑 Gerenciar Acesso

### Adicionar Colaborador (se necessário)
1. GitHub → Settings → Collaborators
2. Adicione: Claudemir, Claudion, etc
3. Defina permissão: Write (para editar), Read (apenas ler)

### Remover Colaborador
1. GitHub → Settings → Collaborators
2. Clique no X ao lado do nome

---

## 📊 Checklist de Segurança

- [x] Repositório é PRIVATE
- [x] Credenciais não estão commitadas
- [x] `.gitignore` protege dados sensíveis
- [x] SSH configurado (sem token em URL)
- [x] Auto-sync funciona (a cada 15 min)
- [x] Scripts sem expor secrets
- [x] Logs locais (não versionados)
- [ ] Branch protection rules (configurar no GitHub manualmente)
- [ ] Acesso restrito (apenas você por enquanto)

---

## 🔄 Fluxo de Segurança

```
Developer/Claudia trabalha localmente
  ↓
Edita arquivo (nunca credenciais)
  ↓
git add / git commit / git push (via SSH)
  ↓
Chave SSH privada valida a operação
  ↓
Arquivo chega ao GitHub PRIVATE
  ↓
Auto-sync sincroniza de volta ao servidor
  ↓
Claudia lê arquivo atualizado
  ↓
CICLO COMPLETO — Tudo seguro ✅
```

---

## 📞 Emergência: Credencial Comprometida

**Se uma credencial vazar:**

1. Regenere no serviço (GitHub, Trello, Pipedrive)
2. Atualize as variáveis de ambiente
3. Inicie novo token SSH se necessário
4. Nenhuma ação no Git necessária (credenciais não estão lá)

---

## 🎯 Próximas Melhorias (Futuro)

- [ ] Configurar 2FA no GitHub
- [ ] Adicionar secrets scanning (GitHub Advanced Security)
- [ ] Configurar branch protection rules
- [ ] Audit logs periodicamente
- [ ] Rotação de chaves SSH anual

---

## 📝 Referências

- GitHub Security: https://github.com/settings/security
- SSH Keys: `cat ~/.ssh/id_ed25519.pub`
- `.gitignore` master: https://github.com/github/gitignore

---

*REPOSITORY_SECURITY.md — Atualizado 26/03/2026*
*Status: SEGURANÇA ATIVADA ✅*
