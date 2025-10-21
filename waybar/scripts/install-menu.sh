#!/bin/bash
# BunkerOS Install Menu

# Accept position parameter (default: top_right for waybar button)
POSITION=${1:-top_right}

options="📱 Web Apps\n⬅️  Back"
num_items=2

# Set location based on position parameter
if [ "$POSITION" = "center" ]; then
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "Install" \
        --width 200 \
        --lines "$num_items" \
        --location center)
else
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "Install" \
        --width 200 \
        --lines "$num_items" \
        --location top_right \
        --xoffset -10 \
        --yoffset 40)
fi

case $selected in
    "📱 Web Apps")
        ~/.config/waybar/scripts/webapp-menu.sh
        ;;
    "⬅️  Back")
        if [ "$POSITION" = "center" ]; then
            ~/.config/waybar/scripts/main-menu.sh
        fi
        ;;
esac
