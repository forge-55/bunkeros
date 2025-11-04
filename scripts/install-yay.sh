#!/usr/bin/env bash
# Quick script to install yay AUR helper

echo "=== Installing yay AUR Helper ==="
echo ""

# Check if yay is already installed
if command -v yay &>/dev/null; then
    echo "✓ yay is already installed"
    yay --version
    exit 0
fi

# Create temporary directory
YAY_BUILD_DIR="/tmp/yay-install-$$"
mkdir -p "$YAY_BUILD_DIR"

echo "Cloning yay from AUR..."
if git clone https://aur.archlinux.org/yay.git "$YAY_BUILD_DIR"; then
    cd "$YAY_BUILD_DIR"
    
    echo "Building and installing yay..."
    if makepkg -si --noconfirm; then
        echo ""
        echo "✓ yay installed successfully!"
        yay --version
        
        # Cleanup
        cd /
        rm -rf "$YAY_BUILD_DIR"
        exit 0
    else
        echo ""
        echo "✗ Failed to build yay"
        cd /
        rm -rf "$YAY_BUILD_DIR"
        exit 1
    fi
else
    echo "✗ Failed to clone yay repository"
    rm -rf "$YAY_BUILD_DIR"
    exit 1
fi
