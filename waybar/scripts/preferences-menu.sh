#!/bin/bash
# BunkerOS Preferences Menu

# Accept position parameter (default: top_right for waybar button)
POSITION=${1:-top_right}

options="󰒓  Default Apps\n󰌌  Keybindings\n󰌑  Back"
num_items=3

# Set location based on position parameter
if [ "$POSITION" = "center" ]; then
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "Preferences" \
        --width 220 \
        --lines "$num_items" \
        --location center \
        --no-cache)
else
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "Preferences" \
        --width 220 \
        --lines "$num_items" \
        --location top_right \
        --xoffset -10 \
        --yoffset 40 \
        --no-cache)
fi

case $selected in
    "󰒓  Default Apps")
        ~/.config/waybar/scripts/default-apps-manager.sh "$POSITION"
        ;;
    "󰌌  Keybindings")
        ~/.config/waybar/scripts/keybinding-manager.sh
        ;;
    "󰌑  Back")
        if [ "$POSITION" = "center" ]; then
            ~/.config/waybar/scripts/main-menu.sh
        fi
        ;;
esac
