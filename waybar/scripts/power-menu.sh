#!/bin/bash

# Power menu using wofi

options="󰐥 Shutdown\n󰜉 Reboot\n󰤄 Suspend\n󰍃 Logout\n⬅️  Back"

chosen=$(echo -e "$options" | wofi --dmenu --prompt "Power Options" --width 220 --height 220)

case $chosen in
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

