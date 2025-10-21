#!/bin/bash
# BunkerOS Actions Menu - Quick actions

options="󰄀 Screenshot\n󰔎 Screensaver\n⬅️  Back"

# Calculate height dynamically
item_height=40
num_items=3
total_height=$((num_items * item_height + 50))

selected=$(echo -e "$options" | wofi --dmenu \
    --prompt "Actions" \
    --width 180 \
    --height "$total_height" \
    --location top_right \
    --xoffset -10 \
    --yoffset 40)

case $selected in
    "󰄀 Screenshot")
        ~/.config/waybar/scripts/screenshot-area.sh
        ;;
    "󰔎 Screensaver")
        ~/.config/sway-config/scripts/launch-screensaver.sh
        ;;
    "⬅️  Back")
        ~/.config/waybar/scripts/main-menu.sh
        ;;
esac
