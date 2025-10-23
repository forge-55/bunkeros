#!/bin/bash
# BunkerOS Preferences Menu

# Accept position parameter (default: top_right for waybar button)
POSITION=${1:-top_right}

# Check autotiling status for display
if pgrep -x autotiling-rs > /dev/null; then
    autotiling_status="󰹳 Autotiling: ON"
else
    autotiling_status="󰹳 Autotiling: OFF"
fi

options="󰒓  Default Apps\n󰌌  Keybindings\n${autotiling_status}\n󰑓  Reload Config\n󰌑  Back"
num_items=5

# Set location based on position parameter
if [ "$POSITION" = "center" ]; then
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "Preferences" \
        --width 220 \
        --lines "$num_items" \
        --location center \
        --cache-file=/dev/null)
else
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "Preferences" \
        --width 220 \
        --lines "$num_items" \
        --location top_right \
        --xoffset -10 \
        --yoffset 40 \
        --cache-file=/dev/null)
fi

case $selected in
    "󰒓  Default Apps")
        ~/.config/waybar/scripts/default-apps-manager.sh "$POSITION"
        ;;
    "󰌌  Keybindings")
        ~/.config/waybar/scripts/keybinding-manager.sh
        ;;
    "󰹳 Autotiling: ON")
        ~/.config/waybar/scripts/toggle-autotiling.sh
        ;;
    "󰹳 Autotiling: OFF")
        ~/.config/waybar/scripts/toggle-autotiling.sh
        ;;
    "󰑓  Reload Config")
        swaymsg reload
        notify-send "BunkerOS" "Configuration reloaded"
        ;;
    "󰌑  Back")
        if [ "$POSITION" = "center" ]; then
            ~/.config/waybar/scripts/main-menu.sh
        fi
        ;;
esac
