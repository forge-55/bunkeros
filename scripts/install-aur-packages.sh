#!/usr/bin/env bash

# Install AUR packages for BunkerOS
# This script is separate so users can run it after base installation

set -e

echo "=== BunkerOS AUR Packages Installation ==="
echo ""

# Check if an AUR helper is installed
AUR_HELPER=""
if command -v yay &>/dev/null; then
    AUR_HELPER="yay"
elif command -v paru &>/dev/null; then
    AUR_HELPER="paru"
else
    echo "No AUR helper found (yay or paru required)."
    echo ""
    echo "Install yay:"
    echo "  cd /tmp"
    echo "  git clone https://aur.archlinux.org/yay.git"
    echo "  cd yay"
    echo "  makepkg -si"
    echo ""
    read -p "Would you like to install yay now? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        AUR_HELPER="yay"
    else
        echo "Skipping AUR package installation."
        exit 0
    fi
fi

echo "Using AUR helper: $AUR_HELPER"
echo ""

# AUR packages
AUR_PACKAGES=(
    swayosd-git
    auto-cpufreq
)

echo "Installing AUR packages: ${AUR_PACKAGES[*]}"
echo ""

$AUR_HELPER -S --needed "${AUR_PACKAGES[@]}"

echo ""
echo "✓ AUR packages installed successfully"
echo ""
echo "Note: These packages are optional but recommended for full BunkerOS experience:"
echo "  - swayosd-git: On-screen display for volume/brightness"
echo "  - auto-cpufreq: Automatic CPU frequency scaling for battery life"
