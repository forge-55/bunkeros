#!/usr/bin/env bash

# BunkerOS Package Verification and Installation Script
# Ensures all required packages are installed

set -e

echo "=== BunkerOS Package Verification ==="
echo ""

# Define all required packages
CORE_PACKAGES=(
    sway
    autotiling-rs
    waybar
    wofi
    mako
    foot
    swaylock
    swayidle
    swaybg
)

SYSTEM_PACKAGES=(
    brightnessctl
    playerctl
    wl-clipboard
    grim
    slurp
    wlsunset
    network-manager-applet
    blueman
    pavucontrol
)

APP_PACKAGES=(
    nautilus
    sushi
    eog
    evince
    lite-xl
    btop
    mate-calc
    zenity
)

MEDIA_PACKAGES=(
    pipewire
    pipewire-pulse
    pipewire-alsa
    pipewire-jack
    wireplumber
    v4l-utils
)

SYSTEM_CORE=(
    sddm
    qt5-declarative
    qt5-quickcontrols2
    ttf-meslo-nerd
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    python-pipx
)

AUR_PACKAGES=(
    swayosd-git
)

# Check if package is installed
check_package() {
    pacman -Q "$1" &>/dev/null
}

# Check and install missing packages
check_and_install() {
    local packages=("$@")
    local missing_packages=()
    
    echo "Checking packages: ${packages[*]}"
    
    for pkg in "${packages[@]}"; do
        if check_package "$pkg"; then
            echo "  ✓ $pkg"
        else
            echo "  ❌ $pkg (missing)"
            missing_packages+=("$pkg")
        fi
    done
    
    if [ ${#missing_packages[@]} -gt 0 ]; then
        echo ""
        echo "Missing packages: ${missing_packages[*]}"
        read -p "Install missing packages? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo pacman -S --needed "${missing_packages[@]}"
            echo "✓ Packages installed"
        else
            echo "⚠ Skipping package installation"
        fi
    else
        echo "✓ All packages present"
    fi
    echo ""
}

# Check AUR packages
check_aur_packages() {
    local packages=("$@")
    local missing_packages=()
    
    echo "Checking AUR packages: ${packages[*]}"
    
    for pkg in "${packages[@]}"; do
        if check_package "$pkg"; then
            echo "  ✓ $pkg"
        else
            echo "  ❌ $pkg (missing)"
            missing_packages+=("$pkg")
        fi
    done
    
    if [ ${#missing_packages[@]} -gt 0 ]; then
        echo ""
        if command -v yay &>/dev/null; then
            echo "Missing AUR packages: ${missing_packages[*]}"
            read -p "Install missing AUR packages with yay? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                yay -S --needed "${missing_packages[@]}"
                echo "✓ AUR packages installed"
            else
                echo "⚠ Skipping AUR package installation"
            fi
        else
            echo "❌ yay not found. Please install missing AUR packages manually:"
            printf '  yay -S %s\n' "${missing_packages[@]}"
        fi
    else
        echo "✓ All AUR packages present"
    fi
    echo ""
}

# Main verification
echo "Verifying BunkerOS package installation..."
echo ""

check_and_install "${CORE_PACKAGES[@]}"
check_and_install "${SYSTEM_PACKAGES[@]}"
check_and_install "${APP_PACKAGES[@]}"
check_and_install "${MEDIA_PACKAGES[@]}"
check_and_install "${SYSTEM_CORE[@]}"
check_aur_packages "${AUR_PACKAGES[@]}"

echo "=== Package Verification Complete ==="
echo ""
echo "Run './scripts/fix-environment.sh' to restart services with proper environment."