#!/usr/bin/env bash

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/.config/xdg-desktop-portal"

echo "=== Installing Desktop Portal Configuration ==="
echo ""

# Create config directory
mkdir -p "$CONFIG_DIR"

# Backup existing config if it exists
if [ -f "$CONFIG_DIR/portals.conf" ] && [ ! -L "$CONFIG_DIR/portals.conf" ]; then
    backup="$CONFIG_DIR/portals.conf.backup.$(date +%Y%m%d-%H%M%S)"
    echo "Backing up existing portal config to: $backup"
    mv "$CONFIG_DIR/portals.conf" "$backup"
fi

# Remove existing symlink if present
if [ -L "$CONFIG_DIR/portals.conf" ]; then
    rm "$CONFIG_DIR/portals.conf"
fi

# Create symlink
ln -sf "$PROJECT_DIR/xdg-desktop-portal/portals.conf" "$CONFIG_DIR/portals.conf"

echo "✓ Desktop portal configuration symlinked"
echo "  Using GNOME (Nautilus) file picker instead of basic GTK chooser"
echo "  Config: $CONFIG_DIR/portals.conf"
echo ""

# Restart portal service
echo "Restarting desktop portal service..."
pkill -f xdg-desktop-portal 2>/dev/null || true
sleep 1

echo "✓ Desktop portal service restarted"
echo ""
echo "The Nautilus-based file picker will now be used in applications like Cursor."
echo "You may need to restart applications for the change to take effect."


