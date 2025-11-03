#!/usr/bin/env bash

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEME_DIR="/usr/share/sddm/themes/tactical"
SOURCE_DIR="$PROJECT_DIR/sddm/tactical"
SESSION_DIR="/usr/share/wayland-sessions"
SESSION_SOURCE="$PROJECT_DIR/sddm/sessions"

echo "=== BunkerOS SDDM Installation ==="
echo ""

# Check if we have sudo access
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo access. Please authenticate:"
    if ! sudo true; then
        echo "ERROR: Failed to get sudo access"
        exit 1
    fi
fi

echo "Checking compositor installations..."
if ! command -v sway &> /dev/null; then
    echo "WARNING: sway not found. Install with: sudo pacman -S sway"
fi

echo ""
echo "Installing BunkerOS SDDM theme..."
sudo mkdir -p "$THEME_DIR"
sudo cp -r "$SOURCE_DIR"/* "$THEME_DIR/"
echo "  ✓ Theme files installed to $THEME_DIR"

echo ""
echo "Installing BunkerOS session files..."
sudo mkdir -p "$SESSION_DIR"

echo "  Installing main BunkerOS session..."
sudo cp "$SESSION_SOURCE/bunkeros.desktop" "$SESSION_DIR/"
echo "  ✓ BunkerOS session installed"

echo "  Installing emergency recovery session..."
sudo cp "$SESSION_SOURCE/bunkeros-recovery.desktop" "$SESSION_DIR/"
echo "  ✓ Emergency recovery session installed"

echo ""
echo "Installing launch scripts to /usr/local/bin..."

echo "  Installing BunkerOS launch script..."
sudo cp "$PROJECT_DIR/scripts/launch-bunkeros.sh" /usr/local/bin/
sudo chmod +x /usr/local/bin/launch-bunkeros.sh
echo "  ✓ Launch script installed"

echo "  Installing emergency recovery script..."
sudo cp "$PROJECT_DIR/scripts/launch-bunkeros-emergency.sh" /usr/local/bin/
sudo chmod +x /usr/local/bin/launch-bunkeros-emergency.sh
echo "  ✓ Emergency recovery script installed"

echo ""
echo "Configuring SDDM theme..."
if [ ! -f /etc/sddm.conf ]; then
    echo "  Creating /etc/sddm.conf..."
    echo "[Theme]" | sudo tee /etc/sddm.conf > /dev/null
    echo "Current=tactical" | sudo tee -a /etc/sddm.conf > /dev/null
else
    if ! grep -q "^\[Theme\]" /etc/sddm.conf; then
        echo "  Adding theme configuration..."
        echo "" | sudo tee -a /etc/sddm.conf > /dev/null
        echo "[Theme]" | sudo tee -a /etc/sddm.conf > /dev/null
        echo "Current=tactical" | sudo tee -a /etc/sddm.conf > /dev/null
    else
        echo "  Updating theme configuration..."
        sudo sed -i '/^\[Theme\]/,/^\[/{s/^Current=.*/Current=tactical/}' /etc/sddm.conf
        # If Current= doesn't exist in Theme section, add it
        if ! grep -A 5 "^\[Theme\]" /etc/sddm.conf | grep -q "^Current="; then
            sudo sed -i '/^\[Theme\]/a Current=tactical' /etc/sddm.conf
        fi
    fi
fi
echo "  ✓ SDDM configured to use tactical theme"

echo ""
echo "=== BunkerOS SDDM Installation Complete! ==="
echo ""
echo "Available sessions at login:"
echo "  - BunkerOS              - Full desktop environment"
echo "  - BunkerOS Emergency    - Recovery terminal (for troubleshooting)"
echo ""
echo "✓ Installation successful"
echo ""

