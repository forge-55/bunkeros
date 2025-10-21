#!/bin/bash
# Power menu using wofi

# Accept position parameter (default: top_right for waybar button)
POSITION=${1:-top_right}

options="󰔎 Screensaver\n󰐥 Shutdown\n󰜉 Reboot\n󰤄 Suspend\n󰍃 Logout\n⬅️  Back"
num_items=6

# Set location based on position parameter
if [ "$POSITION" = "center" ]; then
    chosen=$(echo -e "$options" | wofi --dmenu \
        --prompt "Power Options" \
        --width 200 \
        --lines "$num_items" \
        --location center \
        --cache-file=/dev/null)
else
    chosen=$(echo -e "$options" | wofi --dmenu \
        --prompt "Power Options" \
        --width 200 \
        --lines "$num_items" \
        --location top_right \
        --xoffset -10 \
        --yoffset 40 \
        --cache-file=/dev/null)
fi

case $chosen in
    "󰔎 Screensaver")
        ~/.config/sway-config/scripts/launch-screensaver.sh
        ;;
    "󰐥 Shutdown")
        systemctl poweroff
        ;;
    "󰜉 Reboot")
        systemctl reboot
        ;;
    "󰤄 Suspend")
        systemctl suspend
        ;;
    "󰍃 Logout")
        swaymsg exit
        ;;
    "⬅️  Back")
        if [ "$POSITION" = "center" ]; then
            ~/.config/waybar/scripts/main-menu.sh
        fi
        ;;
esac
