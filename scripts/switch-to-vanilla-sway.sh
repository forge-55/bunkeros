#!/bin/bash
# BunkerOS - Switch from SwayFX to Vanilla Sway
# This script safely swaps the compositor packages

set -e

echo "=========================================="
echo "BunkerOS: Switch to Vanilla Sway"
echo "=========================================="
echo ""
echo "This will:"
echo "  ✓ Remove swayfx package"
echo "  ✓ Install sway package (vanilla)"
echo "  ✓ Keep all your BunkerOS configs"
echo "  ✓ Eliminate workspace switching flicker"
echo ""
echo "You will lose:"
echo "  ✗ Rounded corners"
echo "  ✗ SwayFX visual effects"
echo ""
echo "You will gain:"
echo "  ✓ Zero workspace switching flicker"
echo "  ✓ Better stability"
echo "  ✓ Lower resource usage"
echo ""
read -p "Continue? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "Step 1: Updating package database..."
sudo pacman -Sy

echo ""
echo "Step 2: Swapping swayfx for sway..."
echo "(You may see a prompt about package conflicts - choose to replace swayfx)"
sudo pacman -S sway --noconfirm

echo ""
echo "=========================================="
echo "✓ Successfully installed vanilla Sway!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Log out of your current session"
echo "  2. At the login screen, select 'BunkerOS Standard'"
echo "     (or just 'Sway' if using a different login manager)"
echo "  3. Log back in"
echo ""
echo "Your Sway config is already prepared for vanilla Sway."
echo "Everything will work exactly the same, just without the flicker!"
echo ""
echo "To logout now, press: Super + Shift + E"
echo "(You'll need to uncomment the logout keybinding first)"
echo ""
