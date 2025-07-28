# 🚀 ZapDesk - Cliente Desktop para WhatsApp Web

<div align="center">

![ZapDesk Logo](build/icon.png)

**Cliente Desktop moderno para WhatsApp Web com tema escuro e notificações nativas**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/v/release/felipemacedo1/zapdesk)](https://github.com/felipemacedo1/zapdesk/releases)
[![Downloads](https://img.shields.io/github/downloads/felipemacedo1/zapdesk/total)](https://github.com/felipemacedo1/zapdesk/releases)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Windows%20%7C%20macOS-lightgrey)](https://github.com/felipemacedo1/zapdesk)

[📥 Download](#-download) • [✨ Funcionalidades](#-funcionalidades) • [🔧 Instalação](#-instalação) • [🤝 Contribuir](#-contribuir)

</div>

---

## 📱 Screenshots

<div align="center">
  <img src="screenshots/zapdesk-main.png" alt="ZapDesk Interface Principal" width="800">
  <br>
  <i>Interface principal do ZapDesk com tema escuro otimizado</i>
</div>

---

## ✨ Funcionalidades

### 🎨 **Interface Moderna**
- **Tema escuro nativo** - Interface otimizada para uso prolongado
- **Design limpo** - Sem distrações, foco nas conversas
- **Tipografia aprimorada** - Melhor legibilidade dos textos

### 🔔 **Notificações Inteligentes**
- **Notificações nativas** do sistema operacional
- **Suporte à bandeja** - Minimize para a área de notificação
- **Indicadores visuais** - Nunca perca uma mensagem importante

### ⚡ **Performance Otimizada**
- **Aceleração de hardware desabilitada** - Compatibilidade máxima com Linux
- **Sessão persistente** - Mantenha seu login entre reinicializações
- **Uso eficiente de recursos** - Otimizado para baixo consumo

### 🛡️ **Segurança & Privacidade**
- **Isolamento de contexto** - Máxima segurança do Electron
- **Sem rastreamento adicional** - Apenas o WhatsApp Web oficial
- **Código aberto** - Transparência total no desenvolvimento

### 🎯 **Recursos Exclusivos**
- **Instância única** - Evita múltiplas janelas abertas
- **Atalhos de teclado** - Produtividade aprimorada
- **Links externos seguros** - Abertura automática no navegador padrão
- **Menu contextual completo** - Todas as ações ao alcance

---

## 📥 Download

### Linux

| Formato | Descrição | Download |
|---------|-----------|----------|
| **DEB** | Para Ubuntu, Debian e derivados | [![Download DEB](https://img.shields.io/badge/Download-DEB-orange)](https://github.com/felipemacedo1/zapdesk/releases/latest/download/zapdesk_1.0.0_amd64.deb) |
| **AppImage** | Executável portátil universal | [![Download AppImage](https://img.shields.io/badge/Download-AppImage-blue)](https://github.com/felipemacedo1/zapdesk/releases/latest/download/ZapDesk-1.0.0.AppImage) |
| **TAR.GZ** | Arquivo comprimido | [![Download TAR.GZ](https://img.shields.io/badge/Download-TAR.GZ-green)](https://github.com/felipemacedo1/zapdesk/releases/latest/download/zapdesk-1.0.0-linux-x64.tar.gz) |

### Windows *(Em breve)*
- 🔄 **Executável .exe** - Em desenvolvimento

### macOS *(Em breve)*
- 🔄 **Arquivo .dmg** - Em desenvolvimento

---

## 🔧 Instalação

### Ubuntu/Debian (.deb)

```bash
# Download do arquivo DEB
wget https://github.com/felipemacedo1/zapdesk/releases/latest/download/zapdesk_1.0.0_amd64.deb

# Instalação
sudo dpkg -i zapdesk_1.0.0_amd64.deb

# Corrigir dependências (se necessário)
sudo apt-get install -f

# Executar
zapdesk
```

### Distribuições Linux Universais (AppImage)

```bash
# Download do AppImage
wget https://github.com/felipemacedo1/zapdesk/releases/latest/download/ZapDesk-1.0.0.AppImage

# Dar permissão de execução
chmod +x ZapDesk-1.0.0.AppImage

# Executar
./ZapDesk-1.0.0.AppImage
```

### Flatpak *(Planejado)*

```bash
# Em desenvolvimento
flatpak install flathub com.felipemacedo.ZapDesk
```

---

## 🛠️ Desenvolvimento

### Pré-requisitos

- **Node.js** 16+ 
- **npm** ou **yarn**
- **Git**

### Executar localmente

```bash
# Clonar repositório
git clone https://github.com/felipemacedo1/zapdesk.git
cd zapdesk

# Instalar dependências
npm install

# Executar em modo desenvolvimento
npm run dev

# Ou executar normalmente
npm start
```

### Build local

```bash
# Build para Linux
npm run build:linux

# Build para todas as plataformas
npm run build:all

# Apenas empacotamento (sem distribuição)
npm run pack
```

### Estrutura do projeto

```
zapdesk/
├── src/                    # Código fonte
│   ├── main.js            # Processo principal
│   └── preload.js         # Script de preload
├── build/                 # Recursos de build
│   ├── icon.png           # Ícone principal (1024x1024)
│   ├── icon.ico           # Ícone Windows
│   └── icon.icns          # Ícone macOS
├── screenshots/           # Capturas de tela
├── dist/                  # Builds gerados
├── package.json           # Configuração do projeto
├── README.md             # Este arquivo
└── LICENSE               # Licença MIT
```

---

## 🤝 Contribuir

Contribuições são muito bem-vindas! 

### Como contribuir

1. **Fork** o projeto
2. **Clone** seu fork: `git clone https://github.com/seunome/zapdesk.git`
3. **Crie uma branch**: `git checkout -b feature/nova-funcionalidade`
4. **Faça suas alterações** e **commit**: `git commit -m 'Adiciona nova funcionalidade'`
5. **Push** para a branch: `git push origin feature/nova-funcionalidade`
6. **Abra um Pull Request**

### Tipos de contribuição

- 🐛 **Bug reports** - Relate problemas encontrados
- 💡 **Feature requests** - Sugira novas funcionalidades  
- 📝 **Documentação** - Melhore a documentação
- 🎨 **Design** - Aprimore a interface
- 🌍 **Traduções** - Adicione suporte a novos idiomas

### Diretrizes

- Siga o [Conventional Commits](https://conventionalcommits.org/)
- Teste suas alterações antes de enviar
- Mantenha o código limpo e bem documentado
- Respeite o estilo de código existente

---

## 📄 Licença

Este projeto está licenciado sob a **Licença MIT** - veja o arquivo [LICENSE](LICENSE) para detalhes.

### ⚖️ Aviso Legal

**ZapDesk** é um projeto **não oficial** e **código aberto**. 

- ✅ Utiliza apenas o `https://web.whatsapp.com` oficial
- ✅ Não modifica ou intercepta dados do WhatsApp
- ✅ Não armazena mensagens ou dados pessoais
- ❌ Não é afiliado à Meta Inc. ou WhatsApp Inc.
- ❌ WhatsApp é marca registrada da Meta Inc.

---

## 🙏 Agradecimentos

- **Electron** - Framework que torna tudo possível
- **WhatsApp** - Pela excelente plataforma web
- **Comunidade Open Source** - Por todas as bibliotecas utilizadas
- **Beta Testers** - Obrigado pelo feedback valioso!

---

## 📞 Suporte

### 🐛 Encontrou um bug?
[Abra uma issue](https://github.com/felipemacedo1/zapdesk/issues/new?template=bug_report.md)

### 💡 Tem uma sugestão?
[Crie uma feature request](https://github.com/felipemacedo1/zapdesk/issues/new?template=feature_request.md)

### 💬 Precisa de ajuda?
[Inicie uma discussão](https://github.com/felipemacedo1/zapdesk/discussions)

---

<div align="center">

**⭐ Se você gostou do ZapDesk, deixe uma estrela no repositório!**

[![GitHub stars](https://img.shields.io/github/stars/felipemacedo1/zapdesk?style=social)](https://github.com/felipemacedo1/zapdesk/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/felipemacedo1/zapdesk?style=social)](https://github.com/felipemacedo1/zapdesk/network/members)

**Desenvolvido com ❤️ por [Felipe Macedo](https://github.com/felipemacedo1)**

</div>