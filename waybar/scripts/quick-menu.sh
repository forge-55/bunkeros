#!/bin/bash
# BunkerOS Quick Actions Menu

options="󰐥 Power\n󰏘 Change Theme\n󰃟 Theme\n󰒓 System\n󰖔 Night Mode\n󰄀 Screenshot\n📱 Web Apps\n󰍃 File Manager\n󰃬 Calculator\n 󰊶 Terminal"

selected=$(echo -e "$options" | wofi --dmenu --prompt "BunkerOS Quick Actions" --width 400 --height 550)

case $selected in
    "󰐥 Power")
        ~/.config/waybar/scripts/power-menu.sh
        ;;
    "󰏘 Change Theme")
        /home/ryan/Projects/bunkeros/scripts/theme-switcher.sh menu
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
    "📱 Web Apps")
        ~/.config/waybar/scripts/webapp-menu.sh
        ;;
    "󰍃 File Manager")
        thunar &
        ;;
    "󰃬 Calculator")
        mate-calc &
        ;;
    " 󰊶 Terminal")
        foot &
        ;;
esac

