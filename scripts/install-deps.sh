#!/bin/bash
# GameOS - Install build dependencies

set -e

echo "======================================"
echo "GameOS - Installing Build Dependencies"
echo "======================================"

# Check if running on Ubuntu/Debian
if ! command -v apt &> /dev/null; then
    echo "Error: This script requires Ubuntu/Debian with apt package manager"
    exit 1
fi

echo ""
echo "[1/4] Updating package lists..."
sudo apt update

echo ""
echo "[2/4] Installing ISO building tools..."
sudo apt install -y \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-efi \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools

echo ""
echo "[3/4] Installing development tools..."
sudo apt install -y \
    git \
    curl \
    wget \
    build-essential \
    nodejs \
    npm \
    python3 \
    python3-pip \
    python3-yaml

echo ""
echo "[4/4] Installing optional tools..."
sudo apt install -y \
    qemu-system-x86 \
    qemu-utils \
    virtualbox

echo ""
echo "======================================"
echo "Dependencies installed successfully!"
echo "======================================"
echo ""
echo "Next steps:"
echo "1. Review configs/build-config.yaml"
echo "2. Run ./scripts/build-iso.sh to build your ISO"
echo ""
