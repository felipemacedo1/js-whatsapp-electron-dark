# 🚀 ZapDesk – Cliente Desktop para WhatsApp Web

**ZapDesk** é um cliente desktop de código aberto para o WhatsApp Web, com foco em:
- Interface escura moderna (Dark Mode)
- Integração nativa com sistemas Linux (e futuramente Windows/macOS)
- Persistência de login
- Notificações de mensagens
- Otimização de recursos (GPU desativada por padrão para compatibilidade)
- Ícone e nome próprios, evitando qualquer violação de marca

O objetivo final é disponibilizar o ZapDesk como uma alternativa leve, confiável e personalizável ao cliente oficial, sem uso de bibliotecas não-autorizadas ou engenharia reversa.

---

## ✅ Checklist de Desenvolvimento

### 🧱 Estrutura do Projeto
- [x] Pasta raiz com:
  - [ ] `src/` (arquivos como `main.js`, `preload.js`)
  - [ ] `public/` ou `build/` com `icon.png`, recursos visuais
  - [ ] `README.md`, `LICENSE`, `CHANGELOG.md`
- [x] Nome do projeto atualizado para `ZapDesk` no `package.json`
- [ ] AppId único no `package.json`: `"com.felipemacedo.zapdesk"`

### 🎨 Identidade Visual
- [x] Nome do aplicativo: **ZapDesk**
- [x] Ícone original (1024x1024 PNG)
- [ ] Splash screen opcional (imagem carregando...)
- [ ] Arquivo `.desktop` com:
  - [ ] Nome amigável
  - [ ] Comentário explicativo
  - [ ] Caminho de ícone
  - [ ] Categoria `Network;InstantMessaging;`

### ⚙️ Funcionalidades técnicas (mínimo viável)
- [x] Tela do WhatsApp Web usando `loadURL`
- [x] User-Agent moderno (Chrome 120+)
- [x] `app.disableHardwareAcceleration()`
- [x] Ícone carregado via `nativeImage`
- [ ] Persistência de sessão (`partition: 'persist:zapdesk'`)
- [ ] Notificações nativas via `new Notification(...)`
- [ ] Suporte a minimizar para a bandeja (`Tray`)
- [ ] Proteção contra múltiplas instâncias (`app.requestSingleInstanceLock()`)

### 📦 Empacotamento e Build
- [x] Build `.deb` com `electron-builder`
- [ ] Build `.AppImage`
- [ ] Build `.zip` para Linux portátil
- [ ] (Futuro) Build para Windows `.exe` via `nsis`
- [ ] Configurar `scripts` no `package.json`

### 🚀 Publicação
- [ ] Criar repositório no GitHub: `zapdesk`
- [ ] Adicionar:
  - [ ] README com badges, screenshot e instruções
  - [ ] Licença (ex: MIT)
  - [ ] Release com `.deb` e `.AppImage`
- [ ] Criar página de download com:
  - [ ] Nome, ícone, screenshots
  - [ ] Botões de download (Linux)
  - [ ] Link para GitHub

### 🧪 Automação (CI/CD)
- [ ] Configurar GitHub Actions:
  - [ ] Testar build no push/tag
  - [ ] Upload automático para Releases

### 🔒 Considerações Legais
- [x] Não usar o nome “WhatsApp” no nome final
- [x] Não usar o logo oficial
- [x] Usar apenas `https://web.whatsapp.com` como frontend
- [x] Incluir aviso no README sobre “projeto não oficial”

### 📑 Futuras melhorias
- [ ] Múltiplas contas (via WebViews com `partition`)
- [ ] Customização de tema (dark/light)
- [ ] Settings local (armazenamento com JSON/SQLite)
- [ ] Atalhos globais (ex: abrir com `Ctrl+Alt+Z`)
