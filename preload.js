const { contextBridge, ipcRenderer } = require('electron');

// Expõe APIs seguras para o renderer process
contextBridge.exposeInMainWorld('electronAPI', {
  // Notificações
  showNotification: (title, options) => {
    return ipcRenderer.invoke('show-notification', title, options);
  },
  
  // Informações da aplicação
  getAppInfo: () => {
    return {
      name: 'ZapDesk',
      version: '1.0.0',
      platform: process.platform
    };
  },
  
  // Utilitários
  isElectron: true,
  platform: process.platform
});

// Injeta estilos personalizados quando a página carregar
window.addEventListener('DOMContentLoaded', () => {
  // Adiciona classe para identificar que está rodando no Electron
  document.body.classList.add('zapdesk-electron');
  
  // CSS personalizado para melhorar a interface
  const customCSS = `
    <style id="zapdesk-custom-styles">
      /* Otimizações para o tema escuro */
      :root {
        --zapdesk-primary: #00a884;
        --zapdesk-background: #111b21;
        --zapdesk-surface: #202c33;
      }
      
      /* Remove scrollbars desnecessárias */
      ::-webkit-scrollbar {
        width: 6px;
        height: 6px;
      }
      
      ::-webkit-scrollbar-track {
        background: transparent;
      }
      
      ::-webkit-scrollbar-thumb {
        background: rgba(255, 255, 255, 0.2);
        border-radius: 3px;
      }
      
      ::-webkit-scrollbar-thumb:hover {
        background: rgba(255, 255, 255, 0.3);
      }
      
      /* Melhora o contraste de alguns elementos */
      [data-theme="dark"] {
        color-scheme: dark;
      }
      
      /* Personalização sutil da interface */
      .zapdesk-electron [data-testid="conversation-header"] {
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      }
      
      /* Melhora a legibilidade */
      .zapdesk-electron [role="textbox"] {
        font-size: 14px !important;
        line-height: 1.4 !important;
      }
      
      /* Indicador personalizado para ZapDesk */
      .zapdesk-electron::before {
        content: "";
        position: fixed;
        bottom: 10px;
        right: 10px;
        width: 8px;
        height: 8px;
        background: var(--zapdesk-primary);
        border-radius: 50%;
        z-index: 9999;
        opacity: 0.6;
        pointer-events: none;
      }
    </style>
  `;
  
  document.head.insertAdjacentHTML('beforeend', customCSS);
});

// Intercepta erros de console para debug
window.addEventListener('error', (event) => {
  console.log('ZapDesk Error:', event.error);
});

window.addEventListener('unhandledrejection', (event) => {
  console.log('ZapDesk Unhandled Promise:', event.reason);
});

// Log de inicialização
console.log('🚀 ZapDesk initialized successfully!');
console.log('📱 Platform:', process.platform);
console.log('⚡ Electron version:', process.versions.electron);
console.log('🌐 Chrome version:', process.versions.chrome);