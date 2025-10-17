#!/bin/bash

options="󰖩 Network Settings\n󰂯 Bluetooth\n󰕾 Audio Settings\n󰍹 Display Settings\n󰍛 System Monitor\n󰘘 Processes\n⬅️  Back"

selected=$(echo -e "$options" | wofi --dmenu --prompt "System Controls" --width 400 --height 450)

case $selected in
    "󰖩 Network Settings")
        foot -e nmtui &
        ;;
    "󰂯 Bluetooth")
        foot -e bluetoothctl &
        ;;
    "󰕾 Audio Settings")
        foot -e pulsemixer &
        ;;
    "󰍹 Display Settings")
        wdisplays &
        ;;
    "󰍛 System Monitor")
        foot -e btop &
        ;;
    "󰘘 Processes")
        foot -e htop &
        ;;
    "⬅️  Back")
        ~/.config/waybar/scripts/quick-menu.sh
        ;;
esac

