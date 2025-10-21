#!/bin/bash
# BunkerOS System Menu

# Accept position parameter (default: top_right for waybar button)
POSITION=${1:-top_right}

options="󰖩 Network\n󰂯 Bluetooth\n󰕾 Audio\n󰍹 Display\n󰍛 Monitor\n⬅️  Back"
num_items=6

# Set location based on position parameter
if [ "$POSITION" = "center" ]; then
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "System" \
        --width 200 \
        --lines "$num_items" \
        --location center \
        --cache-file=/dev/null)
else
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "System" \
        --width 200 \
        --lines "$num_items" \
        --location top_right \
        --xoffset -10 \
        --yoffset 40 \
        --cache-file=/dev/null)
fi

case $selected in
    "󰖩 Network")
        foot -e nmtui &
        ;;
    "󰂯 Bluetooth")
        ~/.config/waybar/scripts/bluetooth-manager.sh &
        ;;
    "󰕾 Audio")
        foot -e pulsemixer &
        ;;
    "󰍹 Display")
        wdisplays &
        ;;
    "󰍛 Monitor")
        foot -e btop &
        ;;
    "⬅️  Back")
        if [ "$POSITION" = "center" ]; then
            ~/.config/waybar/scripts/main-menu.sh
        fi
        ;;
esac
