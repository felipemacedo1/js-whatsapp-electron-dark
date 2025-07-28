#!/bin/bash
# Script para configurar o repositório ZapDesk no GitHub

echo "🚀 Configurando ZapDesk para distribuição pública..."

# 1. Inicializar git se necessário
if [ ! -d ".git" ]; then
    echo "📁 Inicializando repositório Git..."
    git init
    git branch -M main
fi

# 2. Criar estrutura de pastas
echo "📁 Criando estrutura de pastas..."
mkdir -p build screenshots docs .github/{workflows,ISSUE_TEMPLATE}

# 3. Verificar se existe ícone
if [ ! -f "build/icon.png" ]; then
    echo "⚠️  ATENÇÃO: Crie o arquivo build/icon.png (512x512 ou 1024x1024)"
    echo "   Você pode usar este gerador: https://favicon.io/favicon-generator/"
fi

# 4. Criar arquivo de versão
echo "1.0.0" > VERSION

# 5. Configurar Git (se necessário)
echo "👤 Configurando Git..."
git config user.name "Felipe Macedo" 2>/dev/null || true
git config user.email "felipe@felipemacedo.dev" 2>/dev/null || true

# 6. Adicionar arquivos
echo "📦 Adicionando arquivos..."
git add .
git status

echo ""
echo "✅ Setup concluído! Próximos passos:"
echo ""
echo "1. 🎨 Adicione um ícone em build/icon.png"
echo "2. 📸 Adicione screenshots em screenshots/"
echo "3. 🔧 Teste o build: npm run build:linux"
echo "4. 📤 Faça o primeiro commit:"
echo "   git commit -m 'feat: initial ZapDesk release v1.0.0'"
echo ""
echo "5. 🌐 Crie o repositório no GitHub:"
echo "   https://github.com/new"
echo ""
echo "6. 🔗 Conecte com o repositório remoto:"
echo "   git remote add origin https://github.com/SEU_USUARIO/zapdesk.git"
echo "   git push -u origin main"
echo ""