# Building GameOS - Complete Guide

This guide will walk you through building your own GameOS distribution from scratch.

## Prerequisites

### Hardware Requirements
- **RAM**: Minimum 8GB (16GB recommended)
- **Storage**: At least 30GB free space for build process
- **CPU**: Multi-core processor recommended (speeds up compilation)

### Software Requirements
- **Ubuntu 24.04** or **Debian 12** (or WSL2 on Windows)
- **Root access** (sudo privileges)
- **Internet connection** (to download packages)

## Step 1: Set Up Build Environment

First, clone or navigate to the GameOS project directory:

```bash
cd /path/to/gameOS
```

Install all necessary build dependencies:

```bash
chmod +x scripts/install-deps.sh
./scripts/install-deps.sh
```

This will install:
- ISO building tools (debootstrap, xorriso, squashfs-tools)
- Development tools (git, nodejs, npm)
- Virtualization tools (qemu, virtualbox) for testing

## Step 2: Configure Your Build

Edit the configuration file to customize your OS:

```bash
nano configs/build-config.yaml
```

Key settings you might want to change:
- `distro.name`: Your OS name
- `distro.version`: Version number
- `gaming.steam`: Enable/disable Steam
- `customization.accent_color`: UI accent color

## Step 3: Build the Desktop Environment

Navigate to the desktop environment directory:

```bash
cd desktop-environment
npm install
npm run build
cd ..
```

This creates the custom Electron-based desktop environment package.

## Step 4: Build the ISO

**IMPORTANT**: This step requires root access and takes 30-60 minutes.

Make the build script executable:

```bash
chmod +x scripts/build-iso.sh
chmod +x scripts/chroot-setup.sh
```

Run the ISO builder:

```bash
sudo ./scripts/build-iso.sh
```

The script will:
1. Download Ubuntu base system (~500MB)
2. Install gaming packages and drivers
3. Configure system settings
4. Install custom desktop environment
5. Create bootable ISO file

## Step 5: Find Your ISO

Once complete, your ISO will be located at:

```
build/gameos-1.0.0-alpha-amd64.iso
```

## Testing Your ISO

### Option 1: Test in QEMU (Recommended for quick testing)

```bash
qemu-system-x86_64 \
    -cdrom build/gameos-1.0.0-alpha-amd64.iso \
    -m 4G \
    -enable-kvm \
    -cpu host \
    -smp 4
```

### Option 2: Test in VirtualBox

1. Open VirtualBox
2. Create new VM (Linux, Ubuntu 64-bit)
3. Allocate at least 4GB RAM
4. Attach ISO to optical drive
5. Boot and test

### Option 3: Create Bootable USB

**WARNING**: This will erase all data on the USB drive!

```bash
# Find your USB device
lsblk

# Write ISO to USB (replace /dev/sdX with your USB device)
sudo dd if=build/gameos-1.0.0-alpha-amd64.iso of=/dev/sdX bs=4M status=progress
sudo sync
```

## Installation on Real Hardware

1. Boot from USB/DVD with ISO
2. Select "Install GameOS"
3. Follow installation wizard:
   - Choose language
   - Select timezone
   - Partition disk (or use entire disk)
   - Create user account
4. Wait for installation (10-20 minutes)
5. Reboot and remove installation media

## First Boot

After installation:

1. **Login** with the user created during install
2. **Desktop Environment** loads automatically
3. **Steam** and other gaming tools are pre-installed
4. **Update System**: Open terminal and run:
   ```bash
   sudo apt update && sudo apt upgrade
   ```

## Customizing After Build

### Adding More Games Launchers

Install additional game platforms:

```bash
# Lutris
sudo apt install lutris

# Heroic Games Launcher (Epic, GOG)
flatpak install flathub com.heroicgameslauncher.hgl

# Bottles (Windows apps)
flatpak install flathub com.usebottles.bottles
```

### Updating Desktop Environment

To modify the UI:

1. Edit files in `desktop-environment/src/renderer/`
2. Rebuild: `cd desktop-environment && npm run build`
3. Copy new build to system

### Adding Your Own Packages

Edit `scripts/chroot-setup.sh` and add packages to the apt install commands.

## Troubleshooting

### Build Fails During Bootstrap
- Check internet connection
- Try changing Ubuntu mirror in `scripts/build-iso.sh`
- Ensure you have enough disk space

### ISO Won't Boot
- Verify ISO integrity: `md5sum build/gameos-*.iso`
- Try different USB writing tool (Etcher, Rufus)
- Check BIOS/UEFI settings (disable Secure Boot)

### Desktop Environment Doesn't Start
- Check logs: `journalctl -xe`
- Verify Electron was installed: `which electron`
- Manually start: `cd /opt/gameos-desktop && npm start`

## Advanced: Rebuilding After Changes

If you modify configs or scripts:

1. Clean previous build:
   ```bash
   sudo rm -rf build/
   ```

2. Rebuild ISO:
   ```bash
   sudo ./scripts/build-iso.sh
   ```

## Next Steps

- Join the community (Discord/forum link)
- Report bugs on GitHub
- Contribute improvements
- Share your custom builds!

## Build Time Estimates

- First build: 45-90 minutes
- Subsequent builds: 30-45 minutes
- Desktop env rebuild: 2-5 minutes

## Disk Space Usage

- Source files: ~100MB
- Build directory: ~5-8GB
- Final ISO: ~3-4GB

Happy building! 🎮
