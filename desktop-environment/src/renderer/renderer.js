const { ipcRenderer } = require('electron');

// Navigation
const navItems = document.querySelectorAll('.nav-item');
const views = document.querySelectorAll('.view');

navItems.forEach(item => {
    item.addEventListener('click', () => {
        const viewId = item.dataset.view + '-view';

        // Update active nav item
        navItems.forEach(nav => nav.classList.remove('active'));
        item.classList.add('active');

        // Update active view
        views.forEach(view => view.classList.remove('active'));
        document.getElementById(viewId).classList.add('active');
    });
});

// Power Menu
const powerBtn = document.getElementById('power-btn');
const powerMenu = document.getElementById('power-menu');
const cancelPowerBtn = document.getElementById('cancel-power');
const logoutBtn = document.getElementById('logout-btn');
const restartBtn = document.getElementById('restart-btn');
const shutdownBtn = document.getElementById('shutdown-btn');

powerBtn.addEventListener('click', () => {
    powerMenu.style.display = 'flex';
});

cancelPowerBtn.addEventListener('click', () => {
    powerMenu.style.display = 'none';
});

logoutBtn.addEventListener('click', async () => {
    await ipcRenderer.invoke('logout');
});

restartBtn.addEventListener('click', async () => {
    await ipcRenderer.invoke('restart');
});

shutdownBtn.addEventListener('click', async () => {
    await ipcRenderer.invoke('shutdown');
});

// Close power menu on outside click
powerMenu.addEventListener('click', (e) => {
    if (e.target === powerMenu) {
        powerMenu.style.display = 'none';
    }
});

// Time Update
function updateTime() {
    const now = new Date();
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    document.getElementById('time').textContent = `${hours}:${minutes}`;
}

setInterval(updateTime, 1000);
updateTime();

// System Stats (Mock data for now)
function updateSystemStats() {
    // In production, these would come from actual system monitoring
    const cpuUsage = Math.floor(Math.random() * 30 + 20);
    const gpuUsage = Math.floor(Math.random() * 40 + 30);
    const ramUsage = Math.floor(Math.random() * 50 + 30);

    document.getElementById('cpu-usage').textContent = `CPU: ${cpuUsage}%`;
    document.getElementById('gpu-usage').textContent = `GPU: ${gpuUsage}%`;
    document.getElementById('ram-usage').textContent = `RAM: ${ramUsage}%`;
}

setInterval(updateSystemStats, 2000);
updateSystemStats();

// Load Games
async function loadGames() {
    const gamesGrid = document.getElementById('games-grid');

    try {
        const games = await ipcRenderer.invoke('get-installed-games');

        if (games.length === 0) {
            // Show placeholder
            return;
        }

        gamesGrid.innerHTML = '';
        games.forEach(game => {
            const gameCard = document.createElement('div');
            gameCard.className = 'game-card';
            gameCard.innerHTML = `
                <div class="game-cover">
                    <img src="${game.cover || ''}" alt="${game.name}">
                </div>
                <div class="game-info">
                    <h3>${game.name}</h3>
                    <p>${game.playtime || '0 hours'}</p>
                </div>
            `;

            gameCard.addEventListener('click', () => {
                launchGame(game.command);
            });

            gamesGrid.appendChild(gameCard);
        });
    } catch (error) {
        console.error('Failed to load games:', error);
    }
}

async function launchGame(command) {
    try {
        await ipcRenderer.invoke('launch-app', command);
    } catch (error) {
        console.error('Failed to launch game:', error);
    }
}

// Load Applications
function loadApplications() {
    const appsGrid = document.getElementById('apps-grid');

    const defaultApps = [
        { name: 'Steam', icon: '🎮', command: 'steam' },
        { name: 'Firefox', icon: '🦊', command: 'firefox' },
        { name: 'Discord', icon: '💬', command: 'discord' },
        { name: 'Terminal', icon: '⌨️', command: 'gnome-terminal' },
        { name: 'Settings', icon: '⚙️', command: 'gnome-control-center' },
        { name: 'Files', icon: '📁', command: 'nautilus' },
    ];

    appsGrid.innerHTML = '';
    defaultApps.forEach(app => {
        const appCard = document.createElement('div');
        appCard.className = 'game-card';
        appCard.innerHTML = `
            <div class="game-cover">
                <div class="game-placeholder">${app.icon}</div>
            </div>
            <div class="game-info">
                <h3>${app.name}</h3>
            </div>
        `;

        appCard.addEventListener('click', () => {
            launchGame(app.command);
        });

        appsGrid.appendChild(appCard);
    });
}

// Search Functionality
const searchInput = document.getElementById('search');
searchInput.addEventListener('input', (e) => {
    const query = e.target.value.toLowerCase();
    const gameCards = document.querySelectorAll('.game-card');

    gameCards.forEach(card => {
        const name = card.querySelector('h3').textContent.toLowerCase();
        if (name.includes(query)) {
            card.style.display = 'block';
        } else {
            card.style.display = 'none';
        }
    });
});

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    loadGames();
    loadApplications();
});

// Performance Charts (placeholder for now)
// You can integrate Chart.js or similar library for actual charts
console.log('GameOS Desktop Environment Loaded');
