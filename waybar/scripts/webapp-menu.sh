#!/bin/bash

WEBAPP_BIN="/home/ryan/Projects/bunkeros/webapp/bin"

options="󰐖 Install Web App\n󰆴 Remove Web App\n󰋗 List Web Apps\n⬅️  Back"

selected=$(echo -e "$options" | wofi --dmenu --prompt "Web Apps" --width 400 --height 280)

case $selected in
    "󰐖 Install Web App")
        "$WEBAPP_BIN/webapp-install"
        ;;
    "󰆴 Remove Web App")
        "$WEBAPP_BIN/webapp-remove"
        ;;
    "󰋗 List Web Apps")
        "$WEBAPP_BIN/webapp-list"
        ;;
    "⬅️  Back")
        ~/.config/waybar/scripts/quick-menu.sh
        ;;
esac

