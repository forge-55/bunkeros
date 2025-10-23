#!/bin/bash
# Test workspace switching with shadows disabled

CONFIG_FILE="$HOME/.config/sway/config.d/swayfx-effects"

if grep -q "^shadows on" "$CONFIG_FILE"; then
    echo "Disabling shadows..."
    sed -i 's/^shadows on/shadows off/' "$CONFIG_FILE"
    echo "Shadows disabled. Reloading Sway..."
    swaymsg reload
    echo ""
    echo "Test workspace switching now. Is the flicker gone?"
    echo ""
    echo "To re-enable shadows, run this script again."
elif grep -q "^shadows off" "$CONFIG_FILE"; then
    echo "Re-enabling shadows..."
    sed -i 's/^shadows off/shadows on/' "$CONFIG_FILE"
    echo "Shadows enabled. Reloading Sway..."
    swaymsg reload
    echo "Shadows restored."
else
    echo "Could not find shadows setting in $CONFIG_FILE"
fi
