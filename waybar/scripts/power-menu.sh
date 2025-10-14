#!/bin/bash

# Power menu using wofi

options="󰐥 Shutdown\n󰜉 Reboot\n󰤄 Suspend\n󰍃 Logout"

chosen=$(echo -e "$options" | wofi --dmenu --prompt "Power" --width 200 --height 180)

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
esac

