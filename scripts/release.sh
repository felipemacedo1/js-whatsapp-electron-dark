#!/bin/bash
# Script para criar release do ZapDesk

set -e  # Sai se algum comando falhar

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log colorido
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

# Verificar se está na branch main
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    error "Você deve estar na branch main para fazer release"
fi

# Verificar se o working directory está limpo
if [ -n "$(git status --porcelain)" ]; then
    error "Working directory não está limpo. Commit ou stash suas alterações."
fi

# Obter versão atual
current_version=$(node -p "require('./package.json').version")
log "Versão atual: $current_version"

# Perguntar nova versão
echo -e "${BLUE}Escolha o tipo de release:${NC}"
echo "1) patch (1.0.0 -> 1.0.1) - Bug fixes"
echo "2) minor (1.0.0 -> 1.1.0) - Novas funcionalidades"
echo "3) major (1.0.0 -> 2.0.0) - Breaking changes"
echo "4) Versão personalizada"

read -p "Opção (1-4): " release_type

case $release_type in
    1)
        new_version=$(npm version patch --no-git-tag-version)
        ;;
    2)
        new_version=$(npm version minor --no-git-tag-version)
        ;;
    3)
        new_version=$(npm version major --no-git-tag-version)
        ;;
    4)
        read -p "Digite a nova versão (ex: 1.2.3): " custom_version
        if [[ ! $custom_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            error "Formato de versão inválido. Use: x.y.z"
        fi
        new_version="v$custom_version"
        npm version $custom_version --no-git-tag-version
        ;;
    *)
        error "Opção inválida"
        ;;
esac

log "Nova versão: $new_version"

# Atualizar CHANGELOG.md
log "Atualizando CHANGELOG.md..."
current_date=$(date +"%Y-%m-%d")
sed -i "s/## \[Não lançado\]/## [Não lançado]\n\n## [$new_version] - $current_date/" CHANGELOG.md

# Fazer build para verificar se está tudo funcionando
log "Testando build..."
npm run build:linux

if [ $? -ne 0 ]; then
    error "Build falhou. Corrija os erros antes de continuar."
fi

# Commit das alterações
log "Fazendo commit das alterações..."
git add package.json CHANGELOG.md
git commit -m "chore: release $new_version"

# Criar tag
log "Criando tag $new_version..."
git tag -a "$new_version" -m "Release $new_version

## Principais alterações:
- $(git log --oneline --since='1 month ago' --pretty=format:'%s' | head -5 | sed 's/^/- /')

Veja CHANGELOG.md para detalhes completos."

# Push para origin
log "Fazendo push para origin..."
git push origin main
git push origin "$new_version"

# Mostrar próximos passos
echo ""
echo -e "${GREEN}✅ Release $new_version criado com sucesso!${NC}"
echo ""
echo -e "${BLUE}Próximos passos:${NC}"
echo "1. 🔍 Verifique o GitHub Actions: https://github.com/$(git config remote.origin.url | sed 's/.*github.com[\/:]\([^\/]*\/[^\/]*\).*/\1/' | sed 's/.git$//')/actions"
echo "2. 📦 Os builds serão criados automaticamente"
echo "3. 📄 O release será publicado em: https://github.com/$(git config remote.origin.url | sed 's/.*github.com[\/:]\([^\/]*\/[^\/]*\).*/\1/' | sed 's/.git$//')/releases"
echo "4. 📢 Considere anunciar o release nas redes sociais"
echo ""
echo -e "${YELLOW}Arquivos que serão disponibilizados:${NC}"
echo "- zapdesk_${new_version#v}_amd64.deb (Ubuntu/Debian)"
echo "- ZapDesk-${new_version#v}.AppImage (Linux Universal)"
echo "- zapdesk-${new_version#v}-linux-x64.tar.gz (Portátil)"
echo ""

# Opcional: Abrir página de releases no navegador
read -p "Abrir página de releases no navegador? (y/N): " open_browser
if [[ $open_browser =~ ^[Yy]$ ]]; then
    repo_url=$(git config remote.origin.url | sed 's/git@github.com:/https:\/\/github.com\//' | sed 's/.git$//')
    xdg-open "$repo_url/releases" 2>/dev/null || open "$repo_url/releases" 2>/dev/null || true
fi

log "Release process completo! 🎉"