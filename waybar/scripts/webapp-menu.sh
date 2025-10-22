#!/bin/bash

# Resolve the real path (follow symlinks) to get to the actual bunkeros project directory
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
PROJECT_DIR="$(cd "$(dirname "$SCRIPT_PATH")/../.." && pwd)"
WEBAPP_BIN="$PROJECT_DIR/webapp/bin"

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

