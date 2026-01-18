# GameOS Quick Start Guide

Get your gaming-focused Linux distribution running in minutes!

## TL;DR - Fast Track

```bash
# 1. Install dependencies
./scripts/install-deps.sh

# 2. Build the desktop environment
cd desktop-environment && npm install && npm run build && cd ..

# 3. Build ISO (takes 30-60 min)
sudo ./scripts/build-iso.sh

# 4. Test in QEMU
qemu-system-x86_64 -cdrom build/gameos-1.0.0-alpha-amd64.iso -m 4G
```

## What You're Building

**GameOS** is a custom Linux distribution featuring:

- 🎮 **Gaming First**: Steam, Lutris, ProtonGE pre-installed
- 🎨 **Modern UI**: Custom Electron-based desktop with dark theme
- ⚡ **Performance**: Gaming-optimized kernel and GPU drivers
- 🔒 **Stable Base**: Built on Ubuntu 24.04 LTS

## System Requirements for Building

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| OS | Ubuntu 20.04+ | Ubuntu 24.04 |
| RAM | 8GB | 16GB |
| Storage | 30GB free | 50GB free |
| CPU | Dual-core | Quad-core+ |

## Three Ways to Get Started

### 1. Virtual Machine (Safest - Start Here!)

Perfect for testing before installing on real hardware.

```bash
# Install VirtualBox
sudo apt install virtualbox

# Build ISO (see TL;DR above)

# Create VM and attach ISO
```

### 2. Dual Boot (Keep Your Current OS)

Install alongside Windows/Linux.

```bash
# Create bootable USB
sudo dd if=build/gameos-*.iso of=/dev/sdX bs=4M

# Boot from USB, choose "Install alongside..."
```

### 3. Full Install (Replace Everything)

For dedicated gaming machine.

```bash
# Same as dual boot, but choose "Erase disk and install"
```

## What Happens During Build?

The build process:

1. ✅ Downloads Ubuntu base system (~500MB)
2. ✅ Installs gaming software (Steam, Lutris, drivers)
3. ✅ Configures performance optimizations
4. ✅ Installs custom desktop environment
5. ✅ Creates bootable ISO (~3-4GB)

## Your First Boot

After installing GameOS:

```
1. Boot up → Custom GameOS splash screen
2. Login → Your created user account
3. Desktop → Modern gaming interface loads
4. Library → Add your games from Steam/Lutris
```

### Desktop Features

- **Top Bar**: Search, system stats, power options
- **Sidebar**:
  - 🎮 Library: Your games
  - 📦 Applications: Installed apps
  - 📊 Performance: System monitoring
- **Quick Launch**: Click any game to play

## Essential Commands

### Update System
```bash
sudo apt update && sudo apt upgrade
```

### Install More Games
```bash
# From Steam (already installed)
steam

# Install Lutris
sudo apt install lutris

# Install Heroic (Epic/GOG)
flatpak install flathub com.heroicgameslauncher.hgl
```

### Fix Graphics Issues
```bash
# NVIDIA
sudo ubuntu-drivers autoinstall

# AMD (already included)
# Intel (already included)
```

## Customization Quick Tips

### Change Accent Color
Edit `desktop-environment/src/renderer/styles.css`:
```css
--accent: #00ff88;  /* Change to your color */
```

### Add Startup Apps
```bash
mkdir -p ~/.config/autostart
# Add .desktop files here
```

### Change Wallpaper
Place image in `~/Pictures/` and right-click desktop → Set Wallpaper

## Common Issues & Fixes

| Problem | Solution |
|---------|----------|
| Build fails | Check internet, ensure 30GB free space |
| ISO won't boot | Disable Secure Boot in BIOS |
| No desktop | Alt+F2, type `gameos-desktop` |
| No WiFi | `sudo apt install linux-firmware` |
| Steam won't start | `sudo apt install --reinstall steam` |

## Testing Without Installing

### QEMU (Command Line)
```bash
qemu-system-x86_64 \
    -cdrom build/gameos-*.iso \
    -m 4G \
    -enable-kvm
```

### VirtualBox (GUI)
1. New VM → Linux → Ubuntu 64-bit
2. 4GB RAM minimum
3. Attach ISO to optical drive
4. Start

## File Structure Explained

```
gameOS/
├── configs/           # Build settings (edit these!)
├── desktop-environment/ # Custom UI source code
├── scripts/           # Build automation
│   ├── install-deps.sh    # Run this first
│   ├── build-iso.sh       # Main build script
│   └── chroot-setup.sh    # Package installation
├── build/            # Generated during build
│   └── gameos-*.iso  # Your final ISO! (Created after build)
└── README.md         # Project overview
```

## Next Steps After Installation

1. **Update Everything**
   ```bash
   sudo apt update && sudo apt full-upgrade
   ```

2. **Install Your Games**
   - Steam: Already installed, just login
   - Epic/GOG: Install Heroic Launcher
   - Windows games: Use Lutris + Wine

3. **Optimize Performance**
   - Enable GameMode (already installed)
   - Install gamemode: `sudo apt install gamemode`
   - Launch games with: `gamemoderun %command%`

4. **Join Community**
   - Share your build
   - Report bugs
   - Request features

## Performance Tips

- **CPU Governor**: Already set to performance mode
- **MangoHUD**: Press `Shift+F12` in games for FPS overlay
- **GameMode**: Automatically optimizes performance
- **Disable Compositor**: For older hardware

## Build Time FAQ

**Q: How long does building take?**
A: First build: 45-90 minutes. Updates: 30-45 minutes.

**Q: Can I pause the build?**
A: Not recommended. Ensure stable power/internet.

**Q: How much bandwidth needed?**
A: ~2-3GB download during build.

**Q: Can I build on Windows?**
A: Yes, using WSL2 (Windows Subsystem for Linux).

## Getting Help

- Check `BUILDING.md` for detailed instructions
- Review logs in `build/build.log` (after build)
- Search issues on GitHub
- Ask in community forums

## Legal & Credits

- Based on Ubuntu (Canonical Ltd.)
- Uses Electron (MIT License)
- Gaming tools: Steam (Valve), Lutris (GPL)
- This is a community project - not affiliated with Ubuntu/Valve

---

**Ready to build?** Start with `./scripts/install-deps.sh` and follow the prompts!

Happy gaming! 🎮✨
