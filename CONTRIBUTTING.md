# 🤝 Guia de Contribuição - ZapDesk

Obrigado por seu interesse em contribuir com o ZapDesk! 🎉

## 📋 Índice

- [Código de Conduta](#-código-de-conduta)
- [Como Posso Contribuir?](#-como-posso-contribuir)
- [Configuração do Ambiente](#️-configuração-do-ambiente)
- [Processo de Desenvolvimento](#-processo-de-desenvolvimento)
- [Padrões de Código](#-padrões-de-código)
- [Commit e Pull Requests](#-commit-e-pull-requests)
- [Recursos Úteis](#-recursos-úteis)

## 📜 Código de Conduta

Este projeto adere ao [Código de Conduta](CODE_OF_CONDUCT.md). Ao participar, você concorda em manter um ambiente respeitoso para todos.

## 🚀 Como Posso Contribuir?

### 🐛 Reportando Bugs

1. **Verifique** se o bug já foi reportado nas [Issues](https://github.com/felipemacedo1/zapdesk/issues)
2. **Use** o template de [Bug Report](.github/ISSUE_TEMPLATE/bug_report.md)
3. **Inclua** informações detalhadas sobre seu sistema
4. **Adicione** logs de erro se disponíveis

### 💡 Sugerindo Funcionalidades

1. **Verifique** se a funcionalidade já foi sugerida
2. **Use** o template de [Feature Request](.github/ISSUE_TEMPLATE/feature_request.md)
3. **Explique** o problema que a funcionalidade resolve
4. **Descreva** a solução proposta detalhadamente

### 🔧 Contribuindo com Código

1. **Fork** o repositório
2. **Crie** uma branch para sua funcionalidade: `git checkout -b feature/nome-da-funcionalidade`
3. **Faça** suas alterações seguindo os padrões
4. **Teste** suas alterações localmente
5. **Abra** um Pull Request

### 📝 Melhorando Documentação

- Corrija erros de ortografia/gramática
- Adicione exemplos práticos
- Melhore explicações existentes
- Traduza para outros idiomas

## 🛠️ Configuração do Ambiente

### Pré-requisitos

- **Node.js** 16+ ([Download](https://nodejs.org/))
- **Git** ([Download](https://git-scm.com/))
- **npm** (vem com Node.js)

### Setup Local

```bash
# 1. Fork e clone o repositório
git clone https://github.com/felipemacedo1/zapdesk.git
cd zapdesk

# 2. Instale dependências
npm install

# 3. Execute em modo desenvolvimento
npm run dev

# 4. Execute testes (quando disponíveis)
npm test

# 5. Teste o build
npm run build:linux
```

### Estrutura do Projeto

```
zapdesk/
├── main.js              # Processo principal
├── preload.js           # Script de preload
├── build/               # Recursos (ícones, etc.)
├── screenshots/         # Imagens da documentação
├── docs/               # Documentação adicional
├── .github/            # Templates e workflows
└── dist/               # Builds (ignorado)
```

## 🔄 Processo de Desenvolvimento

### 1. **Escolha uma Issue**

- Procure issues com labels: `good first issue`, `help wanted`
- Comente na issue indicando interesse
- Aguarde confirmação antes de começar

### 2. **Desenvolvimento**

```bash
# Crie uma branch específica
git checkout -b feature/sua-funcionalidade
# ou
git checkout -b fix/problema-especifico

# Faça suas alterações
# Teste localmente
npm start

# Commit frequentemente
git add .
git commit -m "feat: adiciona nova funcionalidade"
```

### 3. **Antes de Enviar PR**

- [ ] Código está funcionando
- [ ] Não quebra funcionalidades existentes
- [ ] Documentação foi atualizada (se necessário)
- [ ] Commit messages seguem padrão
- [ ] Branch está atualizada com main

## 📏 Padrões de Código

### JavaScript/Node.js

- **Indentação**: 2 espaços
- **Aspas**: Simples (`'`) para strings
- **Ponto e vírgula**: Sempre usar
- **Nomenclatura**: camelCase para variáveis e funções

```javascript
// ✅ Bom
const userName = 'Felipe';
function createWindow() {
  // código aqui
}

// ❌ Evitar
const user_name = "Felipe"
function CreateWindow() {
  // código aqui
}
```

### Estrutura de Arquivos

- **Nomes**: kebab-case para arquivos
- **Organização**: Funcionalidades relacionadas juntas
- **Comentários**: Explicar o "porquê", não o "como"

## 📝 Commit e Pull Requests

### Padrão de Commits

Use [Conventional Commits](https://conventionalcommits.org/):

```bash
# Tipos válidos:
feat: nova funcionalidade
fix: correção de bug
docs: documentação
style: formatação
refactor: refatoração
test: testes
chore: tarefas de manutenção

# Exemplos:
git commit -m "feat: adiciona suporte à bandeja do sistema"
git commit -m "fix: corrige crash ao minimizar janela"
git commit -m "docs: atualiza README com instruções de instalação"
```

### Pull Request

**Título**: Seja descritivo e claro

```
✅ feat: adiciona tema claro como opção
❌ Update main.js
```

**Descrição**: Use o template

- Explique **o que** foi alterado
- Explique **por que** foi alterado
- Mencione issues relacionadas: `Closes #123`
- Adicione screenshots se for mudança visual

### Review Process

1. **Automated checks** devem passar
2. **Code review** por maintainer
3. **Discussão** se necessário
4. **Merge** após aprovação

## 🎯 Áreas que Precisam de Ajuda

### 🚨 Alta Prioridade
- [ ] Testes automatizados
- [ ] Suporte ao Windows/macOS
- [ ] Otimizações de performance
- [ ] Correções de bugs críticos

### 🟡 Média Prioridade
- [ ] Novas funcionalidades
- [ ] Melhorias de UI/UX
- [ ] Internacionalização (i18n)
- [ ] Documentação

### 🟢 Baixa Prioridade
- [ ] Refatorações
- [ ] Otimizações menores
- [ ] Recursos experimentais

## 🔗 Recursos Úteis

### Documentação Técnica
- [Electron Docs](https://www.electronjs.org/docs)
- [Node.js API](https://nodejs.org/api/)
- [Electron Builder](https://www.electron.build/)

### Ferramentas
- [VS Code](https://code.visualstudio.com/) com extensões JavaScript
- [GitHub Desktop](https://desktop.github.com/) para Git visual
- [Postman](https://www.postman.com/) para testar APIs

### Comunidade
- [GitHub Discussions](https://github.com/felipemacedo1/zapdesk/discussions)
- [Issues](https://github.com/felipemacedo1/zapdesk/issues)

## ❓ Dúvidas?

- 💬 **Discussions**: Para perguntas gerais
- 🐛 **Issues**: Para bugs específicos
- 📧 **Email**: felipe@felipemacedo.dev

## 🙏 Reconhecimento

Todos os contribuidores são listados em nosso [README](README.md#-contribuidores) e recebem crédito pelo trabalho.

---

**Obrigado por contribuir com o ZapDesk! 🚀**