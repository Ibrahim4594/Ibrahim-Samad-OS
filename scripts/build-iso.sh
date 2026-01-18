#!/bin/bash
# Ibrahim Samad OS - WSL COMPATIBLE Build Script

set +e

echo "=============================================="
echo "   Ibrahim Samad OS - ISO Builder"
echo "   WSL Compatible Version"
echo "=============================================="

if [ "$EUID" -ne 0 ]; then
    echo "Error: Run with sudo"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_ROOT/build"
ISO_DIR="$BUILD_DIR/iso"
CHROOT_DIR="$BUILD_DIR/chroot"

echo "[1/7] Cleaning..."
rm -rf "$BUILD_DIR" 2>/dev/null
mkdir -p "$BUILD_DIR" "$ISO_DIR/casper" "$ISO_DIR/isolinux" "$ISO_DIR/boot/grub" "$CHROOT_DIR"

echo "[2/7] Downloading Ubuntu base (10-15 min)..."
debootstrap --arch=amd64 --variant=minbase noble "$CHROOT_DIR" http://archive.ubuntu.com/ubuntu/

if [ ! -d "$CHROOT_DIR/bin" ]; then
    echo "ERROR: Bootstrap failed!"
    exit 1
fi

echo "[3/7] Configuring system..."

# Configure sources
cat > "$CHROOT_DIR/etc/apt/sources.list" << 'EOF'
deb http://archive.ubuntu.com/ubuntu noble main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-updates main restricted universe multiverse
EOF

# Create setup script
cat > "$CHROOT_DIR/setup.sh" << 'SETUPSCRIPT'
#!/bin/bash
set +e
export DEBIAN_FRONTEND=noninteractive
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

apt update
apt install -y linux-generic casper grub-pc locales sudo

# Desktop
apt install -y xorg xfce4 lightdm firefox nano htop

# Gaming
dpkg --add-architecture i386
apt update
apt install -y steam-installer wine gamemode 2>/dev/null || true

# User
useradd -m -s /bin/bash -G sudo ibrahim 2>/dev/null || true
echo "ibrahim:ibrahim" | chpasswd
echo "ibrahim ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ibrahim

echo "ibrahimsamados" > /etc/hostname
locale-gen en_US.UTF-8

apt clean
SETUPSCRIPT

chmod +x "$CHROOT_DIR/setup.sh"

echo "[4/7] Installing packages (20-30 min)..."
# Use unshare instead of mount for WSL compatibility
unshare --mount --fork chroot "$CHROOT_DIR" /setup.sh || \
chroot "$CHROOT_DIR" /setup.sh || \
echo "Warning: Some packages may not have installed"

echo "[5/7] Copying kernel..."
KERNEL=$(ls "$CHROOT_DIR/boot/vmlinuz-"* 2>/dev/null | head -1)
INITRD=$(ls "$CHROOT_DIR/boot/initrd.img-"* 2>/dev/null | head -1)

if [ -f "$KERNEL" ]; then
    cp "$KERNEL" "$ISO_DIR/casper/vmlinuz"
    cp "$INITRD" "$ISO_DIR/casper/initrd"
    echo "Kernel copied successfully"
else
    echo "Warning: Kernel not found, downloading..."
    apt download linux-image-generic -o Dir::Cache="$BUILD_DIR" 2>/dev/null || true
fi

echo "[6/7] Creating filesystem..."

# Boot config
cat > "$ISO_DIR/isolinux/isolinux.cfg" << 'EOF'
DEFAULT live
LABEL live
  KERNEL /casper/vmlinuz
  APPEND initrd=/casper/initrd boot=casper quiet splash ---
EOF

cat > "$ISO_DIR/boot/grub/grub.cfg" << 'EOF'
set timeout=10
menuentry "Ibrahim Samad OS" {
    linux /casper/vmlinuz boot=casper quiet splash ---
    initrd /casper/initrd
}
EOF

# Create squashfs
echo "Creating squashfs (10-20 min)..."
mksquashfs "$CHROOT_DIR" "$ISO_DIR/casper/filesystem.squashfs" -comp xz -e boot -e proc -e sys -e dev

# Copy isolinux
cp /usr/lib/ISOLINUX/isolinux.bin "$ISO_DIR/isolinux/" 2>/dev/null || true
cp /usr/lib/syslinux/modules/bios/ldlinux.c32 "$ISO_DIR/isolinux/" 2>/dev/null || true

echo "[7/7] Building ISO..."
cd "$ISO_DIR"

xorriso -as mkisofs \
    -iso-level 3 \
    -volid "IbrahimSamadOS" \
    -output "$BUILD_DIR/ibrahim-samad-os-v1.0.iso" \
    . 2>/dev/null || \
genisoimage -o "$BUILD_DIR/ibrahim-samad-os-v1.0.iso" -V "IbrahimSamadOS" -r -J . 2>/dev/null || \
echo "ISO tools failed - trying mkisofs..."

# Check if ISO was created
if [ -f "$BUILD_DIR/ibrahim-samad-os-v1.0.iso" ]; then
    SIZE=$(du -h "$BUILD_DIR/ibrahim-samad-os-v1.0.iso" | cut -f1)
    echo ""
    echo "=============================================="
    echo "  BUILD COMPLETE!"
    echo "=============================================="
    echo ""
    echo "ISO: $BUILD_DIR/ibrahim-samad-os-v1.0.iso"
    echo "Size: $SIZE"
    echo ""
    echo "Copy to Windows:"
    echo "cp $BUILD_DIR/ibrahim-samad-os-v1.0.iso /mnt/c/Users/ibrah/Desktop/"
else
    echo ""
    echo "=============================================="
    echo "  BUILD PARTIALLY COMPLETE"
    echo "=============================================="
    echo ""
    echo "Filesystem created at: $ISO_DIR/casper/filesystem.squashfs"
    echo "You can create ISO manually or use the files"
fi
