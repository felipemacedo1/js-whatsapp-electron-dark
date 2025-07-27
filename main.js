const { app, BrowserWindow, nativeImage, Menu, Tray, shell, dialog, ipcMain } = require('electron');
const path = require('path');
const os = require('os');

// Configurações globais
const isDev = process.argv.includes('--dev');
const isLinux = os.platform() === 'linux';

// Desabilita aceleração de hardware para compatibilidade no Linux
app.disableHardwareAcceleration();

// Evita múltiplas instâncias
const gotTheLock = app.requestSingleInstanceLock();
if (!gotTheLock) {
  app.quit();
} else {
  app.on('second-instance', () => {
    // Quando tentar abrir segunda instância, foca na janela existente
    if (mainWindow) {
      if (mainWindow.isMinimized()) mainWindow.restore();
      mainWindow.focus();
    }
  });
}

let mainWindow;
let tray = null;

function createWindow() {
  // Caminho do ícone
  const iconPath = path.join(__dirname, '..', 'build', 'icon.png');
  
  // Cria a janela principal
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    minWidth: 800,
    minHeight: 600,
    backgroundColor: '#111b21', // Cor do WhatsApp Dark
    icon: nativeImage.createFromPath(iconPath),
    title: 'ZapDesk - WhatsApp Desktop',
    titleBarStyle: isLinux ? 'default' : 'hiddenInset',
    webPreferences: {
      contextIsolation: true,
      enableRemoteModule: false,
      nodeIntegration: false,
      webSecurity: true,
      partition: 'persist:zapdesk', // Sessão persistente
      preload: path.join(__dirname, 'preload.js')
    },
    show: false // Não mostra até carregar
  });

  // User-Agent moderno para evitar erro "Chrome 60+"
  const userAgent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
  mainWindow.webContents.setUserAgent(userAgent);

  // Carrega o WhatsApp Web
  mainWindow.loadURL('https://web.whatsapp.com');

  // Mostra janela quando estiver pronta
  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
    
    if (isDev) {
      mainWindow.webContents.openDevTools();
    }
  });

  // Configurações de comportamento da janela
  mainWindow.on('closed', () => {
    mainWindow = null;
  });

  // Minimizar para a bandeja no Linux
  mainWindow.on('minimize', (event) => {
    if (isLinux && tray) {
      event.preventDefault();
      mainWindow.hide();
      
      // Mostra notificação na primeira vez
      if (!global.minimizeNotified) {
        tray.displayBalloon({
          title: 'ZapDesk',
          content: 'O aplicativo foi minimizado para a bandeja do sistema',
          icon: iconPath
        });
        global.minimizeNotified = true;
      }
    }
  });

  // Intercepta links externos
  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
    shell.openExternal(url);
    return { action: 'deny' };
  });

  // Configura notificações
  mainWindow.webContents.on('did-finish-load', () => {
    // Injeta script para interceptar notificações do WhatsApp
    mainWindow.webContents.executeJavaScript(`
      // Intercepta notificações do WhatsApp
      const originalNotification = window.Notification;
      window.Notification = function(title, options) {
        // Envia para o processo principal
        window.electronAPI?.showNotification(title, options);
        return new originalNotification(title, options);
      };
      
      // Aplica tema escuro se necessário
      document.documentElement.setAttribute('data-theme', 'dark');
    `);
  });

  // Menu da aplicação
  createMenu();
  
  // Cria tray icon
  createTray(iconPath);
}

function createMenu() {
  const template = [
    {
      label: 'ZapDesk',
      submenu: [
        {
          label: 'Sobre ZapDesk',
          click: showAbout
        },
        { type: 'separator' },
        {
          label: 'Recarregar',
          accelerator: 'CmdOrCtrl+R',
          click: () => mainWindow.reload()
        },
        {
          label: 'Forçar Recarregar',
          accelerator: 'CmdOrCtrl+Shift+R',
          click: () => mainWindow.webContents.reloadIgnoringCache()
        },
        { type: 'separator' },
        {
          label: 'Minimizar',
          accelerator: 'CmdOrCtrl+M',
          click: () => mainWindow.minimize()
        },
        {
          label: 'Fechar',
          accelerator: 'CmdOrCtrl+W',
          click: () => mainWindow.close()
        },
        { type: 'separator' },
        {
          label: 'Sair',
          accelerator: 'CmdOrCtrl+Q',
          click: () => app.quit()
        }
      ]
    },
    {
      label: 'Editar',
      submenu: [
        { label: 'Desfazer', accelerator: 'CmdOrCtrl+Z', role: 'undo' },
        { label: 'Refazer', accelerator: 'Shift+CmdOrCtrl+Z', role: 'redo' },
        { type: 'separator' },
        { label: 'Recortar', accelerator: 'CmdOrCtrl+X', role: 'cut' },
        { label: 'Copiar', accelerator: 'CmdOrCtrl+C', role: 'copy' },
        { label: 'Colar', accelerator: 'CmdOrCtrl+V', role: 'paste' },
        { label: 'Selecionar Tudo', accelerator: 'CmdOrCtrl+A', role: 'selectall' }
      ]
    },
    {
      label: 'Visualizar',
      submenu: [
        { label: 'Tela Cheia', accelerator: 'F11', role: 'togglefullscreen' },
        { type: 'separator' },
        { label: 'Aumentar Zoom', accelerator: 'CmdOrCtrl+Plus', role: 'zoomin' },
        { label: 'Diminuir Zoom', accelerator: 'CmdOrCtrl+-', role: 'zoomout' },
        { label: 'Zoom Real', accelerator: 'CmdOrCtrl+0', role: 'resetzoom' }
      ]
    }
  ];

  if (isDev) {
    template.push({
      label: 'Desenvolvedor',
      submenu: [
        { label: 'DevTools', accelerator: 'F12', role: 'toggledevtools' }
      ]
    });
  }

  const menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);
}

function createTray(iconPath) {
  if (!isLinux) return;
  
  tray = new Tray(iconPath);
  
  const contextMenu = Menu.buildFromTemplate([
    {
      label: 'Abrir ZapDesk',
      click: () => {
        mainWindow.show();
        mainWindow.focus();
      }
    },
    {
      label: 'Sobre',
      click: showAbout
    },
    { type: 'separator' },
    {
      label: 'Sair',
      click: () => app.quit()
    }
  ]);
  
  tray.setToolTip('ZapDesk - WhatsApp Desktop');
  tray.setContextMenu(contextMenu);
  
  tray.on('click', () => {
    if (mainWindow.isVisible()) {
      mainWindow.hide();
    } else {
      mainWindow.show();
      mainWindow.focus();
    }
  });
}

function showAbout() {
  dialog.showMessageBox(mainWindow, {
    type: 'info',
    title: 'Sobre ZapDesk',
    message: 'ZapDesk v1.0.0',
    detail: `Cliente Desktop moderno para WhatsApp Web
    
• Interface escura otimizada
• Notificações nativas
• Suporte a bandeja do sistema
• Código aberto (MIT License)

Desenvolvido por Felipe Macedo
Projeto não oficial - WhatsApp é marca registrada da Meta Inc.`,
    buttons: ['OK', 'GitHub'],
    defaultId: 0
  }).then((result) => {
    if (result.response === 1) {
      shell.openExternal('https://github.com/felipemacedo1/zapdesk');
    }
  });
}

// Eventos do app
app.whenReady().then(() => {
  createWindow();
  
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('before-quit', () => {
  // Força fechamento da janela
  if (mainWindow) {
    mainWindow.removeAllListeners('close');
    mainWindow.close();
  }
});

// IPC handlers
ipcMain.handle('show-notification', (event, title, options) => {
  // Cria notificação nativa do sistema
  const notification = new Notification({
    title: title || 'ZapDesk',
    body: options?.body || '',
    icon: path.join(__dirname, '..', 'build', 'icon.png'),
    silent: false,
    urgency: 'normal'
  });
  
  notification.on('click', () => {
    if (mainWindow) {
      mainWindow.show();
      mainWindow.focus();
    }
  });
  
  notification.show();
});