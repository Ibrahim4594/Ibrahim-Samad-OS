const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const { exec } = require('child_process');

let mainWindow;

function createWindow() {
  // Create fullscreen desktop window
  mainWindow = new BrowserWindow({
    fullscreen: true,
    frame: false,
    transparent: false,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
      enableRemoteModule: true
    },
    backgroundColor: '#0a0a0a'
  });

  mainWindow.loadFile('src/renderer/index.html');

  // Open DevTools in development
  if (process.argv.includes('--dev')) {
    mainWindow.webContents.openDevTools();
  }

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (mainWindow === null) {
    createWindow();
  }
});

// IPC handlers for system integration
ipcMain.handle('launch-app', async (event, appCommand) => {
  return new Promise((resolve, reject) => {
    exec(appCommand, (error, stdout, stderr) => {
      if (error) {
        reject(error);
      } else {
        resolve(stdout);
      }
    });
  });
});

ipcMain.handle('get-installed-games', async () => {
  // Scan for installed games (Steam, Lutris, etc.)
  const games = [];

  // Check Steam library
  try {
    const steamPath = path.join(process.env.HOME, '.steam/steam/steamapps');
    // TODO: Parse Steam library
  } catch (e) {
    console.log('Steam not found');
  }

  return games;
});

ipcMain.handle('shutdown', async () => {
  exec('systemctl poweroff');
});

ipcMain.handle('restart', async () => {
  exec('systemctl reboot');
});

ipcMain.handle('logout', async () => {
  app.quit();
});
