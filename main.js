const { app, BrowserWindow, nativeImage } = require('electron');
const path = require('path');
app.disableHardwareAcceleration();

function createWindow() {
  const iconPath = path.join(__dirname, 'icon.png'); // 👈 Garante caminho correto

  const win = new BrowserWindow({
    width: 1200,
    height: 800,
    backgroundColor: '#1e1e1e',
    icon: nativeImage.createFromPath(iconPath), // 👈 Define ícone
    webPreferences: {
      contextIsolation: true
    }
  });

  win.webContents.setUserAgent(
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36'
  );

  win.loadURL('https://web.whatsapp.com');
}

app.whenReady().then(createWindow);
