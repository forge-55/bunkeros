#!/bin/bash

# Power menu using wofi

options="󰔎 Screensaver\n󰐥 Shutdown\n󰜉 Reboot\n󰤄 Suspend\n󰍃 Logout\n⬅️  Back"

# Calculate height based on number of items (6 items * 40px per item + 50px for prompt/padding)
item_height=40
num_items=6
total_height=$((num_items * item_height + 50))

chosen=$(echo -e "$options" | wofi --dmenu \
    --prompt "Power Options" \
    --width 200 \
    --height "$total_height" \
    --location top_right \
    --xoffset -10 \
    --yoffset 40)

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
        ~/.config/waybar/scripts/quick-menu.sh
        ;;
esac

