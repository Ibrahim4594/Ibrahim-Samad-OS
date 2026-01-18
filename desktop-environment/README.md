# GameOS Desktop Environment

A modern, gaming-focused desktop environment built with Electron.

## Visual Preview

```
┌─────────────────────────────────────────────────────────────────────────┐
│ 🎮 GameOS    [Search games and apps...]    CPU:23% GPU:45% RAM:32% 14:23 ⚙️ ⏻ │
├──────────┬──────────────────────────────────────────────────────────────┤
│          │  Game Library                        🎯 Recently  ⭐ Favorites  ⊞ │
│  🎮      │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│ Library  │  │          │  │          │  │          │  │          │      │
│          │  │ Add Games│  │  Game 1  │  │  Game 2  │  │  Game 3  │      │
│  🛒      │  │          │  │          │  │          │  │          │      │
│  Store   │  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
│          │  Install Steam, Lutris or add games manually                 │
│  📦      │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  Apps    │  │          │  │          │  │          │  │          │      │
│          │  │  Game 4  │  │  Game 5  │  │  Game 6  │  │  Game 7  │      │
│  ⬇️      │  │          │  │          │  │          │  │          │      │
│Downloads │  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
│          │                                                               │
│  📊      │                                                               │
│Performance│                                                              │
│          │                                                               │
└──────────┴──────────────────────────────────────────────────────────────┘
```

## Features

### Modern UI
- **Dark Theme**: Optimized for gaming sessions
- **Neon Accent**: Customizable accent color (#00FF88)
- **Smooth Animations**: Hardware-accelerated rendering
- **Responsive Layout**: Adapts to different screen sizes

### Views

#### 🎮 Library View
- Grid layout of installed games
- Game covers with hover effects
- Quick launch functionality
- Filter by recently played, favorites

#### 📦 Applications View
- All installed applications
- Quick launch icons
- Search functionality

#### 📊 Performance View
- Real-time CPU usage graph
- GPU monitoring
- RAM usage tracking
- System stats dashboard

### Top Bar Features
- **Search**: Find games and apps instantly
- **System Stats**: Live CPU, GPU, RAM monitoring
- **Clock**: Current time display
- **Settings**: Quick access to system settings
- **Power Menu**: Logout, restart, shutdown

## Technology Stack

- **Framework**: Electron 28.0.0
- **UI**: HTML5 + CSS3 + Vanilla JavaScript
- **IPC**: Electron IPC for system integration
- **Node**: System command execution

## Development

### Setup
```bash
npm install
```

### Run in Development Mode
```bash
npm start
# or
npm run dev
```

### Build for Production
```bash
npm run build
```

### Project Structure
```
src/
├── main.js              # Electron main process
│   ├── Window creation
│   ├── IPC handlers
│   └── System integration
│
└── renderer/
    ├── index.html       # UI structure
    ├── styles.css       # Visual styling
    └── renderer.js      # UI logic & interactions
```

## Customization

### Change Accent Color
Edit `src/renderer/styles.css`:
```css
:root {
    --accent: #00ff88;  /* Your color here */
}
```

### Add New Views
1. Add HTML in `index.html` inside `.content-area`
2. Add nav button in `.sidebar`
3. Add view switching logic in `renderer.js`

### Modify Layout
Edit `src/renderer/styles.css`:
- Grid layouts: `.games-grid`
- Sidebar width: `.sidebar { width: 200px; }`
- Top bar height: `.top-bar { height: 60px; }`

## IPC Communication

The desktop environment communicates with the system via Electron IPC:

### Available IPC Handlers

```javascript
// Launch application
ipcRenderer.invoke('launch-app', 'steam')

// Get installed games
const games = await ipcRenderer.invoke('get-installed-games')

// Power actions
await ipcRenderer.invoke('shutdown')
await ipcRenderer.invoke('restart')
await ipcRenderer.invoke('logout')
```

### Adding New IPC Handlers

In `src/main.js`:
```javascript
ipcMain.handle('your-handler', async (event, ...args) => {
    // Your logic here
    return result;
});
```

In `src/renderer/renderer.js`:
```javascript
const result = await ipcRenderer.invoke('your-handler', ...args);
```

## Game Detection

The desktop scans for games in:
- Steam library (`~/.steam/steam/steamapps/`)
- Lutris games
- Custom game directories (configurable)

## Theming System

### Current Theme Variables
```css
--bg-primary: #0a0a0a      /* Main background */
--bg-secondary: #141414     /* Cards, panels */
--bg-tertiary: #1e1e1e      /* Inputs, buttons */
--accent: #00ff88           /* Highlight color */
--text-primary: #ffffff     /* Main text */
--text-secondary: #b0b0b0   /* Dimmed text */
--border: #2a2a2a           /* Borders */
```

### Creating New Themes
1. Copy `styles.css` to `themes/mytheme.css`
2. Change CSS variables
3. Import in `index.html`

## Performance Optimization

The desktop is optimized for:
- **Low Memory Usage**: ~200-300MB RAM
- **Fast Startup**: < 2 seconds
- **Smooth Animations**: 60 FPS rendering
- **Efficient Updates**: Only re-render changed elements

## Integration Points

### System Commands
Execute system commands via IPC:
```javascript
exec('steam', (error, stdout, stderr) => {
    // Handle output
});
```

### File System Access
Read game libraries and config files:
```javascript
const steamPath = path.join(process.env.HOME, '.steam');
```

### Process Management
Launch and manage game processes:
```javascript
spawn('game-executable', ['--args']);
```

## Keyboard Shortcuts (Planned)

- `Ctrl+F`: Focus search
- `Ctrl+Q`: Quit
- `Ctrl+,`: Settings
- `Alt+1-5`: Switch views
- `Super`: App launcher

## Accessibility

- High contrast theme
- Keyboard navigation
- Screen reader support (planned)
- Customizable font sizes

## Browser Compatibility

Built with Electron, so uses Chromium:
- Full CSS Grid support
- Modern JavaScript (ES2020+)
- WebGL for performance graphs
- No polyfills needed

## Debugging

### Enable Developer Tools
```bash
npm run dev
```

Or in production:
```javascript
mainWindow.webContents.openDevTools();
```

### Logging
Check logs:
```bash
# Electron logs
~/.config/gameos-desktop/logs/

# System integration logs
journalctl --user -u gameos-desktop
```

## Contributing

### Adding Features
1. Create feature branch
2. Implement in `src/renderer/`
3. Test in dev mode
4. Submit pull request

### Code Style
- Use semicolons
- 2-space indentation
- camelCase for variables
- PascalCase for classes

## License

GPL-3.0 - See LICENSE file

## Credits

- UI Design: Inspired by Steam Deck, modern game launchers
- Icons: System emoji (temporary)
- Framework: Electron.js
- Base: Ubuntu/Linux

---

**Want to improve the UI?** Fork and submit a PR!
