#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

show_menu() {
    options="󰏘 Change Theme\n󰹑 Toggle Gaps\n󰙵 Increase Gaps\n󰙴 Decrease Gaps\n󰂚 Increase Opacity\n󰂙 Decrease Opacity\n󰆊 Reload Config\n⬅️  Back"

    selected=$(echo -e "$options" | wofi --dmenu --prompt "Theme Options" --width 400 --height 550)

case $selected in
    "󰏘 Change Theme")
        "$PROJECT_DIR/scripts/theme-switcher.sh" menu
        ;;
    "󰹑 Toggle Gaps")
        current=$(swaymsg -t get_tree | grep -o '"gaps":{"inner":[0-9]*' | head -1 | grep -o '[0-9]*$')
        if [ "$current" -eq 0 ]; then
            swaymsg gaps inner all set 8
            swaymsg gaps outer all set 8
            notify-send "Gaps Enabled" "Window gaps set to 8px"
        else
            swaymsg gaps inner all set 0
            swaymsg gaps outer all set 0
            notify-send "Gaps Disabled" "Window gaps removed"
        fi
        ;;
    "󰙵 Increase Gaps")
        swaymsg gaps inner all plus 2
        swaymsg gaps outer all plus 2
        notify-send "Gaps Increased" "Gap size increased by 2px"
        ;;
    "󰙴 Decrease Gaps")
        swaymsg gaps inner all minus 2
        swaymsg gaps outer all minus 2
        notify-send "Gaps Decreased" "Gap size decreased by 2px"
        ;;
    "󰂚 Increase Opacity")
        swaymsg '[app_id=".*"]' opacity plus 0.05
        swaymsg '[class=".*"]' opacity plus 0.05
        notify-send "Opacity Increased" "Window opacity increased"
        ;;
    "󰂙 Decrease Opacity")
        swaymsg '[app_id=".*"]' opacity minus 0.05
        swaymsg '[class=".*"]' opacity minus 0.05
        notify-send "Opacity Decreased" "Window opacity decreased"
        ;;
    "󰆊 Reload Config")
        swaymsg reload
        notify-send "Config Reloaded" "Sway configuration reloaded"
        show_menu
        ;;
    "⬅️  Back")
        ~/.config/waybar/scripts/quick-menu.sh
        ;;
    *)
        # User pressed Esc - go back to main menu
        if [ -n "$selected" ]; then
            show_menu
        fi
        ;;
esac
}

show_menu

