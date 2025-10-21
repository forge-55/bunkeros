#!/bin/bash
# BunkerOS Launch Menu - Quick application launchers

options="󰍃 File Manager\n󰠮 Notes\n󰃬 Calculator\n󰊶 Terminal\n📱 Web Apps\n⬅️  Back"

# Calculate height dynamically
item_height=40
num_items=6
total_height=$((num_items * item_height + 50))

selected=$(echo -e "$options" | wofi --dmenu \
    --prompt "Launch" \
    --width 180 \
    --height "$total_height" \
    --location top_right \
    --xoffset -10 \
    --yoffset 40)

case $selected in
    "󰍃 File Manager")
        nautilus &
        ;;
    "󰠮 Notes")
        lite-xl ~/Documents/Notes &
        ;;
    "󰃬 Calculator")
        mate-calc &
        ;;
    "󰊶 Terminal")
        foot &
        ;;
    "📱 Web Apps")
        ~/.config/waybar/scripts/webapp-menu.sh
        ;;
    "⬅️  Back")
        ~/.config/waybar/scripts/main-menu.sh
        ;;
esac
