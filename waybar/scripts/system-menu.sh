#!/bin/bash
# BunkerOS System Menu

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Accept position parameter (default: top_right for waybar button)
POSITION=${1:-top_right}

options="󰖩  Network\n󰂯  Bluetooth\n󰕾  Audio\n󰍹  Display\n󰹑  Display Scaling\n󰌑  Back"
num_items=6

# Set location based on position parameter
if [ "$POSITION" = "center" ]; then
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "System" \
        --width 240 \
        --lines "$num_items" \
        --location center \
        --cache-file=/dev/null)
else
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "System" \
        --width 240 \
        --lines "$num_items" \
        --location top_right \
        --xoffset -10 \
        --yoffset 40 \
        --cache-file=/dev/null)
fi

case $selected in
    "󰖩  Network")
        foot -e nmtui &
        ;;
    "󰂯  Bluetooth")
        ~/.config/waybar/scripts/bluetooth-manager.sh &
        ;;
    "󰕾  Audio")
        if command -v pulsemixer &> /dev/null; then
            foot -e pulsemixer &
        elif command -v pavucontrol &> /dev/null; then
            pavucontrol &
        else
            notify-send "BunkerOS" "No audio mixer found. Install pulsemixer or pavucontrol"
        fi
        ;;
    "󰍹  Display")
        if command -v wdisplays &> /dev/null; then
            wdisplays &
        elif command -v wlr-randr &> /dev/null; then
            foot -e wlr-randr &
        else
            notify-send "BunkerOS" "No display manager found. Install wdisplays or wlr-randr"
        fi
        ;;
    "󰹑  Display Scaling")
        if [ -f "$PROJECT_DIR/scripts/configure-display-scaling.sh" ]; then
            foot -T "BunkerOS Display Scaling" -e "$PROJECT_DIR/scripts/configure-display-scaling.sh" --interactive &
        else
            notify-send "BunkerOS" "Display scaling script not found"
        fi
        ;;
    "󰌑  Back")
        if [ "$POSITION" = "center" ]; then
            ~/.config/waybar/scripts/main-menu.sh
        fi
        ;;
esac
