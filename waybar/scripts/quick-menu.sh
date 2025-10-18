#!/bin/bash
# BunkerOS Quick Actions Menu

options="󰐥 Power\n󰏘 Change Theme\n󰃟 Theme\n󰒓 System\n⌨️ Keybindings\n󰖔 Night Mode\n󰄀 Screenshot\n📱 Web Apps\n󰍃 File Manager\n󰠮 Notes\n󰃬 Calculator\n 󰊶 Terminal"

selected=$(echo -e "$options" | wofi --dmenu --prompt "BunkerOS Quick Actions" --width 400 --height 650)

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
    "⌨️ Keybindings")
        ~/.config/waybar/scripts/keybinding-manager.sh
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
        nautilus &
        ;;
    "󰠮 Notes")
        lite-xl ~/Documents/Notes &
        ;;
    "󰃬 Calculator")
        mate-calc &
        ;;
    " 󰊶 Terminal")
        foot &
        ;;
esac

