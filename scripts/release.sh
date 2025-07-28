#!/bin/bash
# Script para criar release do ZapDesk

set -e  # Sai se algum comando falhar

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Função para log colorido
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Banner
echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════╗"
echo "║           ZapDesk Release Script         ║"
echo "║        Automatização de Releases         ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

# Verificações preliminares
pre_flight_checks() {
    log "Executando verificações preliminares..."
    
    # Verificar se está na branch main
    current_branch=$(git branch --show-current 2>/dev/null || git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    if [ "$current_branch" != "main" ] && [ "$current_branch" != "master" ]; then
        error "Você deve estar na branch main/master para fazer release (branch atual: $current_branch)"
    fi
    
    # Verificar se o working directory está limpo
    if [ -n "$(git status --porcelain)" ]; then
        error "Working directory não está limpo. Commit ou stash suas alterações."
    fi
    
    # Verificar se existe package.json
    if [ ! -f "package.json" ]; then
        error "package.json não encontrado. Execute este script na raiz do projeto."
    fi
    
    # Verificar se npm está instalado
    command -v npm >/dev/null 2>&1 || error "NPM não está instalado"
    
    # Verificar se há commits para release
    if [ -z "$(git log --oneline -n1 2>/dev/null)" ]; then
        error "Nenhum commit encontrado. Faça pelo menos um commit antes do release."
    fi
    
    success "Todas as verificações preliminares passaram"
}

# Obter versão atual
get_current_version() {
    if command -v node >/dev/null 2>&1 && [ -f "package.json" ]; then
        current_version=$(node -p "require('./package.json').version" 2>/dev/null || echo "")
    fi
    
    if [ -z "$current_version" ] && [ -f "VERSION" ]; then
        current_version=$(cat VERSION 2>/dev/null || echo "")
    fi
    
    if [ -z "$current_version" ]; then
        current_version="0.0.0"
        warn "Versão não encontrada, usando padrão: $current_version"
    fi
    
    log "Versão atual: $current_version"
}

# Calcular próxima versão
calculate_next_version() {
    local version=$1
    local type=$2
    
    # Remove 'v' prefix se existir
    version=${version#v}
    
    # Split version into parts
    IFS='.' read -r major minor patch <<< "$version"
    
    case $type in
        "patch")
            patch=$((patch + 1))
            ;;
        "minor")
            minor=$((minor + 1))
            patch=0
            ;;
        "major")
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        *)
            error "Tipo de release inválido: $type"
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

# Selecionar tipo de release
select_release_type() {
    echo ""
    echo -e "${CYAN}📦 Selecione o tipo de release:${NC}"
    echo ""
    echo -e "${YELLOW}1)${NC} 🐛 patch (${current_version} -> $(calculate_next_version $current_version patch)) - Bug fixes e correções"
    echo -e "${YELLOW}2)${NC} ✨ minor (${current_version} -> $(calculate_next_version $current_version minor)) - Novas funcionalidades"
    echo -e "${YELLOW}3)${NC} 💥 major (${current_version} -> $(calculate_next_version $current_version major)) - Breaking changes"
    echo -e "${YELLOW}4)${NC} 🎯 Versão personalizada"
    echo ""
    
    while true; do
        read -p "Escolha uma opção (1-4): " release_type
        
        case $release_type in
            1)
                new_version=$(calculate_next_version $current_version patch)
                release_name="patch"
                break
                ;;
            2)
                new_version=$(calculate_next_version $current_version minor)
                release_name="minor"
                break
                ;;
            3)
                new_version=$(calculate_next_version $current_version major)
                release_name="major"
                break
                ;;
            4)
                while true; do
                    read -p "Digite a nova versão (ex: 1.2.3): " custom_version
                    if [[ $custom_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                        new_version="$custom_version"
                        release_name="custom"
                        break
                    else
                        error "Formato de versão inválido. Use: x.y.z (exemplo: 1.2.3)"
                    fi
                done
                break
                ;;
            *)
                warn "Opção inválida. Escolha entre 1-4."
                ;;
        esac
    done
    
    log "Nova versão selecionada: $new_version ($release_name)"
}

# Atualizar arquivos de versão
update_version_files() {
    log "Atualizando arquivos de versão..."
    
    # Atualizar package.json se existir
    if [ -f "package.json" ] && command -v node >/dev/null 2>&1; then
        npm version $new_version --no-git-tag-version --allow-same-version
        success "package.json atualizado"
    fi
    
    # Atualizar VERSION se existir
    if [ -f "VERSION" ]; then
        echo "$new_version" > VERSION
        success "VERSION atualizado"
    fi
    
    # Atualizar CHANGELOG.md
    update_changelog
}

# Atualizar CHANGELOG
update_changelog() {
    log "Atualizando CHANGELOG.md..."
    
    if [ ! -f "CHANGELOG.md" ]; then
        create_changelog_template
    fi
    
    current_date=$(date +"%Y-%m-%d")
    
    # Backup do changelog atual
    cp CHANGELOG.md CHANGELOG.md.backup
    
    # Criar nova entrada no changelog
    {
        echo "# Changelog"
        echo ""
        echo "Todas as mudanças notáveis neste projeto serão documentadas neste arquivo."
        echo ""
        echo "## [Não lançado]"
        echo ""
        echo "## [v$new_version] - $current_date"
        echo ""
        
        # Adicionar commits recentes como changelog
        echo "### Adicionado"
        git log --oneline --pretty=format:'- %s' --since='1 month ago' | grep -E '^- (feat|add)' | head -5 || echo "- Melhorias gerais"
        echo ""
        
        echo "### Corrigido"
        git log --oneline --pretty=format:'- %s' --since='1 month ago' | grep -E '^- (fix|bug)' | head -5 || echo "- Correções de bugs"
        echo ""
        
        echo "### Alterado"
        git log --oneline --pretty=format:'- %s' --since='1 month ago' | grep -E '^- (refactor|improve|update)' | head -5 || echo "- Melhorias de performance"
        echo ""
        
        # Adicionar conteúdo antigo do changelog (se existir)
        if [ -f "CHANGELOG.md.backup" ]; then
            tail -n +6 CHANGELOG.md.backup 2>/dev/null || true
        fi
    } > CHANGELOG.md
    
    rm -f CHANGELOG.md.backup
    success "CHANGELOG.md atualizado"
}

# Criar template do changelog
create_changelog_template() {
    log "Criando template do CHANGELOG.md..."
    cat > CHANGELOG.md << 'EOF'
# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

## [Não lançado]

EOF
    success "Template do CHANGELOG.md criado"
}

# Executar testes e build
run_tests_and_build() {
    log "Executando testes e build..."
    
    # Instalar dependências se necessário
    if [ ! -d "node_modules" ]; then
        log "Instalando dependências..."
        npm install
    fi
    
    # Executar testes se existir script de test
    if npm run | grep -q "test"; then
        log "Executando testes..."
        npm test || error "Testes falharam"
        success "Testes passaram"
    else
        info "Nenhum script de teste encontrado, pulando..."
    fi
    
    # Executar build
    if npm run | grep -q "build"; then
        log "Executando build..."
        npm run build || error "Build falhou"
        success "Build executado com sucesso"
    elif npm run | grep -q "build:linux"; then
        log "Executando build Linux..."
        npm run build:linux || error "Build Linux falhou"
        success "Build Linux executado com sucesso"
    else
        warn "Nenhum script de build encontrado"
    fi
}

# Confirmar release
confirm_release() {
    echo ""
    echo -e "${CYAN}📋 Resumo do Release:${NC}"
    echo -e "${YELLOW}  Versão atual:${NC} $current_version"
    echo -e "${YELLOW}  Nova versão:${NC} v$new_version"
    echo -e "${YELLOW}  Tipo:${NC} $release_name"
    echo -e "${YELLOW}  Branch:${NC} $(git branch --show-current)"
    echo -e "${YELLOW}  Commits desde última tag:${NC} $(git rev-list --count HEAD ^$(git describe --tags --abbrev=0 2>/dev/null || echo 'HEAD') 2>/dev/null || echo '?')"
    echo ""
    
    read -p "Confirma o release? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        error "Release cancelado pelo usuário"
    fi
}

# Fazer commit e tag
commit_and_tag() {
    log "Fazendo commit das alterações..."
    
    # Adicionar arquivos modificados
    git add package.json VERSION CHANGELOG.md 2>/dev/null || true
    
    # Commit das alterações
    git commit -m "chore(release): bump version to v$new_version

- Update package.json version
- Update CHANGELOG.md with release notes
- Prepare for v$new_version release" || error "Falha ao fazer commit"
    
    success "Commit realizado"
    
    # Criar tag
    log "Criando tag v$new_version..."
    
    # Gerar mensagem da tag
    tag_message="Release v$new_version

## Principais alterações:
$(git log --oneline --pretty=format:'- %s' --since='1 month ago' | head -5)

## Arquivos disponíveis:
- zapdesk_${new_version}_amd64.deb (Ubuntu/Debian)
- zapdesk-${new_version}-x86_64.AppImage (Linux Universal)  
- zapdesk-${new_version}-linux-x64.tar.gz (Portátil)

Veja CHANGELOG.md para detalhes completos.

---
Gerado automaticamente pelo release script"
    
    git tag -a "v$new_version" -m "$tag_message" || error "Falha ao criar tag"
    success "Tag v$new_version criada"
}

# Push para repositório remoto
push_release() {
    log "Fazendo push para repositório remoto..."
    
    # Verificar se existe remote
    if ! git remote | grep -q origin; then
        error "Remote 'origin' não configurado. Configure com: git remote add origin <url>"
    fi
    
    # Push da branch
    git push origin $(git branch --show-current) || error "Falha ao fazer push da branch"
    success "Branch enviada para o repositório remoto"
    
    # Push da tag
    git push origin "v$new_version" || error "Falha ao fazer push da tag"
    success "Tag enviada para o repositório remoto"
}

# Mostrar próximos passos
show_next_steps() {
    # Usar link fixo do repositório
    github_url="https://github.com/felipemacedo1/zapdesk"

    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════╗"
    echo -e "║         RELEASE CRIADO COM SUCESSO       ║"
    echo -e "╚══════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${GREEN}🎉 Release v$new_version criado com sucesso!${NC}"
    echo ""
    echo -e "${CYAN}📋 Próximos passos:${NC}"
    echo ""
    echo -e "${YELLOW}1. 🔍 Verificar GitHub Actions:${NC}"
    echo "   $github_url/actions"
    echo ""
    echo -e "${YELLOW}2. 📦 Aguardar builds automáticos:${NC}"
    echo "   • Os artefatos serão gerados automaticamente"
    echo "   • Verifique os workflows no GitHub"
    echo ""
    echo -e "${YELLOW}3. 📄 Verificar release publicado:${NC}"
    echo "   $github_url/releases/tag/v$new_version"
    echo ""
    echo -e "${YELLOW}4. 📢 Divulgar release (opcional):${NC}"
    echo "   • Redes sociais"
    echo "   • Comunidades técnicas"
    echo "   • Blog/site pessoal"
    echo ""
    echo -e "${CYAN}📦 Arquivos que serão disponibilizados:${NC}"
    echo "   • zapdesk_${new_version}_amd64.deb (Ubuntu/Debian)"
    echo "   • zapdesk-${new_version}-x86_64.AppImage (Linux Universal)"
    echo "   • zapdesk-${new_version}-linux-x64.tar.gz (Portátil)"
    echo ""

    # Opcional: Abrir página de releases no navegador
    read -p "Abrir página de releases no navegador? (y/N): " open_browser
    if [[ $open_browser =~ ^[Yy]$ ]]; then
        if command -v xdg-open >/dev/null 2>&1; then
            xdg-open "$github_url/releases" 2>/dev/null &
        elif command -v open >/dev/null 2>&1; then
            open "$github_url/releases" 2>/dev/null &
        else
            info "Abra manualmente: $github_url/releases"
        fi
    fi

    success "Processo de release concluído! 🚀"
}

# Função principal
main() {
    pre_flight_checks
    get_current_version
    select_release_type
    confirm_release
    update_version_files
    run_tests_and_build
    commit_and_tag
    push_release
    show_next_steps
}

# Tratamento de interrupção
trap 'echo -e "\n${RED}❌ Release interrompido pelo usuário${NC}"; exit 1' INT

# Executar função principal
main "$@"