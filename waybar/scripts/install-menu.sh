#!/bin/bash
# BunkerOS Install Menu

# Accept position parameter (default: top_right for waybar button)
POSITION=${1:-top_right}

options="󰏖 Arch Packages\n󰣇 AUR Packages\n󰖟 Web Apps\n⬅️  Back"
num_items=4

# Set location based on position parameter
if [ "$POSITION" = "center" ]; then
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "Install" \
        --width 200 \
        --lines "$num_items" \
        --location center \
        --cache-file=/dev/null)
else
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "Install" \
        --width 200 \
        --lines "$num_items" \
        --location top_right \
        --xoffset -10 \
        --yoffset 40 \
        --cache-file=/dev/null)
fi

case $selected in
    "󰏖 Arch Packages")
        ~/.config/waybar/scripts/install-arch-package.sh
        ;;
    "󰣇 AUR Packages")
        ~/.config/waybar/scripts/install-aur-package.sh
        ;;
    "󰖟 Web Apps")
        ~/.config/waybar/scripts/webapp-menu.sh
        ;;
    "⬅️  Back")
        if [ "$POSITION" = "center" ]; then
            ~/.config/waybar/scripts/main-menu.sh
        fi
        ;;
esac
