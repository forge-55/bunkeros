#!/bin/bash

options="󰐥 Power\n󰃟 Theme\n󰒓 System\n󰖔 Night Mode\n󰄀 Screenshot\n󰍃 File Manager\n 󰊶 Terminal"

selected=$(echo -e "$options" | wofi --dmenu --prompt "Quick Actions" --width 400 --height 450)

case $selected in
    "󰐥 Power")
        ~/.config/waybar/scripts/power-menu.sh
        ;;
    "󰃟 Theme")
        ~/.config/waybar/scripts/theme-menu.sh
        ;;
    "󰒓 System")
        ~/.config/waybar/scripts/system-menu.sh
        ;;
    "󰖔 Night Mode")
        ~/.config/waybar/scripts/night-mode-toggle.sh
        ;;
    "󰄀 Screenshot")
        ~/.config/waybar/scripts/screenshot-area.sh
        ;;
    "󰍃 File Manager")
        thunar &
        ;;
    " 󰊶 Terminal")
        foot &
        ;;
esac

