#!/bin/bash
# Install Default Apps Configuration for BunkerOS
# This script sets up the new default apps feature

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/bunkeros"
DEFAULTS_FILE="$CONFIG_DIR/defaults.conf"
SWAY_CONFIG="$HOME/.config/sway/config"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  BunkerOS Default Apps Configuration Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# Create config directory if it doesn't exist
if [ ! -d "$CONFIG_DIR" ]; then
    echo "→ Creating BunkerOS config directory..."
    mkdir -p "$CONFIG_DIR"
    echo "  ✓ Created $CONFIG_DIR"
fi

# Install defaults.conf if it doesn't exist
if [ ! -f "$DEFAULTS_FILE" ]; then
    echo "→ Installing defaults.conf..."
    # Get the project root (parent of scripts directory)
    PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
    cp "$PROJECT_ROOT/bunkeros/defaults.conf" "$DEFAULTS_FILE"
    echo "  ✓ Created $DEFAULTS_FILE"
else
    echo "→ defaults.conf already exists, skipping..."
fi

# Copy the default-apps-manager script
WAYBAR_SCRIPTS="$HOME/.config/waybar/scripts"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

if [ -L "$WAYBAR_SCRIPTS/default-apps-manager.sh" ]; then
    echo "→ default-apps-manager.sh is symlinked, already up to date"
elif [ ! -f "$WAYBAR_SCRIPTS/default-apps-manager.sh" ]; then
    echo "→ Installing default-apps-manager.sh..."
    cp "$PROJECT_ROOT/waybar/scripts/default-apps-manager.sh" "$WAYBAR_SCRIPTS/"
    chmod +x "$WAYBAR_SCRIPTS/default-apps-manager.sh"
    echo "  ✓ Installed default-apps-manager.sh"
else
    echo "→ Updating default-apps-manager.sh..."
    cp "$PROJECT_ROOT/waybar/scripts/default-apps-manager.sh" "$WAYBAR_SCRIPTS/"
    chmod +x "$WAYBAR_SCRIPTS/default-apps-manager.sh"
    echo "  ✓ Updated default-apps-manager.sh"
fi

# Update preferences-menu.sh (skip if symlinked)
if [ -L "$WAYBAR_SCRIPTS/preferences-menu.sh" ]; then
    echo "→ preferences-menu.sh is symlinked, already up to date"
elif [ -f "$WAYBAR_SCRIPTS/preferences-menu.sh" ]; then
    echo "→ Updating preferences-menu.sh..."
    cp "$PROJECT_ROOT/waybar/scripts/preferences-menu.sh" "$WAYBAR_SCRIPTS/"
    echo "  ✓ Updated preferences-menu.sh"
elif [ -f "$WAYBAR_SCRIPTS/settings-menu.sh" ]; then
    echo "→ Migrating settings-menu.sh to preferences-menu.sh..."
    cp "$PROJECT_ROOT/waybar/scripts/preferences-menu.sh" "$WAYBAR_SCRIPTS/"
    echo "  ✓ Created preferences-menu.sh"
fi

# Update main-menu.sh (skip if symlinked)
if [ -L "$WAYBAR_SCRIPTS/main-menu.sh" ]; then
    echo "→ main-menu.sh is symlinked, already up to date"
else
    echo "→ Updating main-menu.sh..."
    cp "$PROJECT_ROOT/waybar/scripts/main-menu.sh" "$WAYBAR_SCRIPTS/"
    echo "  ✓ Updated main-menu.sh"
fi

# Check if Sway config needs updating
if grep -q "include ~/.config/bunkeros/defaults.conf" "$SWAY_CONFIG" 2>/dev/null; then
    echo "→ Sway config already updated, skipping..."
else
    echo
    echo "⚠️  Manual Step Required:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "Your Sway config needs to be updated to use the new defaults system."
    echo
    echo "Please update ~/.config/sway/config by replacing this section:"
    echo
    echo "  set \$term foot"
    echo "  set \$menu wofi --show drun"
    echo "  set \$editor code"
    echo "  set \$filemanager nautilus"
    echo "  set \$notes lite-xl"
    echo
    echo "With this:"
    echo
    echo "  # Load user's default applications from config file"
    echo "  include ~/.config/bunkeros/defaults.conf"
    echo "  set \$term \$BUNKEROS_TERM"
    echo "  set \$menu \$BUNKEROS_MENU"
    echo "  set \$editor \$BUNKEROS_EDITOR"
    echo "  set \$filemanager \$BUNKEROS_FILEMANAGER"
    echo "  set \$notes \$BUNKEROS_NOTES"
    echo
    echo "Or copy the updated config from:"
    echo "  $SCRIPT_DIR/sway/config"
    echo
fi

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Installation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "To use the new Default Apps feature:"
echo "  1. Press Super+m → Preferences → Default Apps"
echo "  2. Select your preferred applications"
echo "  3. Changes apply immediately!"
echo
echo "Documentation: $PROJECT_ROOT/DEFAULT-APPS.md"
echo

read -p "Reload Sway configuration now? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    swaymsg reload
    echo "✓ Sway configuration reloaded"
fi
