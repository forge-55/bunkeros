#!/bin/bash
# Power menu using wofi

# If wofi is already running, close it instead of opening a new menu
if pgrep -x wofi > /dev/null 2>&1; then
    pkill -x wofi
    exit 0
fi

# Accept position parameter (default: top_right for waybar button)
POSITION=${1:-top_right}

options="󰌾  Screensaver\n󰐥  Shutdown\n󰜉  Reboot\n󰤄  Suspend\n󰍃  Logout\n󰌑  Back"
num_items=6

# Set location based on position parameter
if [ "$POSITION" = "center" ]; then
    chosen=$(echo -e "$options" | wofi --dmenu \
        --prompt "Power Options" \
        --width 220 \
        --lines "$num_items" \
        --location center \
        --cache-file=/dev/null)
else
    chosen=$(echo -e "$options" | wofi --dmenu \
        --prompt "Power Options" \
        --width 220 \
        --lines "$num_items" \
        --location top_right \
        --xoffset -10 \
        --yoffset 40 \
        --cache-file=/dev/null)
fi

case $chosen in
    "󰌾  Screensaver")
        # Launch screensaver in background (don't wait for it)
        ~/.config/sway-config/scripts/launch-screensaver.sh &
        ;;
    "󰐥  Shutdown")
        systemctl poweroff
        ;;
    "󰜉  Reboot")
        systemctl reboot
        ;;
    "󰤄  Suspend")
        # Lock screen BEFORE suspend (Omarchy pattern)
        # Script runs convert then swaylock -f daemonizes, so this returns immediately
        ~/.local/bin/bunkeros-lock
        # Brief pause to ensure lock is showing before suspend
        sleep 0.2
        systemctl suspend
        ;;
    "󰍃  Logout")
        swaymsg exit
        ;;
    "󰌑  Back")
        if [ "$POSITION" = "center" ]; then
            ~/.config/waybar/scripts/main-menu.sh
        fi
        ;;
esac