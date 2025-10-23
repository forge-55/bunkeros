#!/usr/bin/env bash

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEME_DIR="/usr/share/sddm/themes/tactical"
SOURCE_DIR="$PROJECT_DIR/sddm/tactical"
SESSION_DIR="/usr/share/wayland-sessions"
SESSION_SOURCE="$PROJECT_DIR/sddm/sessions"

echo "=== BunkerOS SDDM Installation ==="
echo ""

echo "Checking compositor installations..."
if ! command -v sway &> /dev/null; then
    echo "WARNING: sway not found. Install with: sudo pacman -S sway"
fi

echo ""
echo "Installing BunkerOS SDDM theme..."
sudo mkdir -p "$THEME_DIR"
sudo cp -r "$SOURCE_DIR"/* "$THEME_DIR/"

echo "Installing BunkerOS session file..."
sudo mkdir -p "$SESSION_DIR"
sudo cp "$SESSION_SOURCE/bunkeros.desktop" "$SESSION_DIR/"

echo "Installing launch scripts to /usr/local/bin..."
echo "Installing BunkerOS launch script..."
sudo cp "$PROJECT_DIR/scripts/launch-bunkeros.sh" /usr/local/bin/
sudo chmod +x /usr/local/bin/launch-bunkeros.sh

if [ ! -f /etc/sddm.conf ]; then
    echo "Creating /etc/sddm.conf..."
    sudo touch /etc/sddm.conf
fi

if ! grep -q "^\[Theme\]" /etc/sddm.conf; then
    echo "Adding theme configuration..."
    echo "" | sudo tee -a /etc/sddm.conf > /dev/null
    echo "[Theme]" | sudo tee -a /etc/sddm.conf > /dev/null
    echo "Current=tactical" | sudo tee -a /etc/sddm.conf > /dev/null
else
    echo "Updating theme configuration..."
    sudo sed -i 's/^Current=.*/Current=tactical/' /etc/sddm.conf
fi

echo ""
echo "=== BunkerOS SDDM Installation Complete! ==="
echo ""
echo "Available session at login:"
echo "  - BunkerOS - Vanilla Sway compositor"
echo ""
echo "Enabling SDDM as your display manager..."
sudo systemctl enable sddm.service

echo ""
echo "✓ SDDM enabled and will start at next boot"
echo ""
echo "To start SDDM now (log out of current session first):"
echo "  sudo systemctl start sddm.service"
echo ""
echo "To preview the theme (test mode):"
echo "  sddm-greeter --test-mode --theme /usr/share/sddm/themes/tactical"
echo ""

