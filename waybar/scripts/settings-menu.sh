#!/bin/bash
# BunkerOS Settings Menu

# Accept position parameter (default: top_right for waybar button)
POSITION=${1:-top_right}

options="⌨️  Keybindings\n󰆊 Reload Config\n⬅️  Back"
num_items=3

# Set location based on position parameter
if [ "$POSITION" = "center" ]; then
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "Settings" \
        --width 200 \
        --lines "$num_items" \
        --location center)
else
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "Settings" \
        --width 200 \
        --lines "$num_items" \
        --location top_right \
        --xoffset -10 \
        --yoffset 40)
fi

case $selected in
    "⌨️  Keybindings")
        ~/.config/waybar/scripts/keybinding-manager.sh
        ;;
    "󰆊 Reload Config")
        swaymsg reload
        notify-send "BunkerOS" "Configuration reloaded"
        ;;
    "⬅️  Back")
        if [ "$POSITION" = "center" ]; then
            ~/.config/waybar/scripts/main-menu.sh
        fi
        ;;
esac
