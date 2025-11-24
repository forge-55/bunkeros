#!/bin/bash
# BunkerOS Appearance Menu

# Resolve PROJECT_DIR from the actual script location (follow symlinks)
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
PROJECT_DIR="$(cd "$(dirname "$SCRIPT_PATH")/../.." && pwd)"

# Accept position parameter (default: top_right for waybar button)
POSITION=${1:-top_right}

options="󰏘  Theme\n󰸉  Wallpaper\n󰖔  Night Mode\n󰹑  Window Gaps\n󰂚  Opacity\n󰌑  Back"
num_items=6

# Set location based on position parameter
if [ "$POSITION" = "center" ]; then
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "Appearance" \
        --width 220 \
        --lines "$num_items" \
        --location center \
        --cache-file=/dev/null)
else
    selected=$(echo -e "$options" | wofi --dmenu \
        --prompt "Appearance" \
        --width 220 \
        --lines "$num_items" \
        --location top_right \
        --xoffset -10 \
        --yoffset 40 \
        --cache-file=/dev/null)
fi

case $selected in
    "󰏘  Theme")
        ~/.local/bin/theme-switcher.sh menu "$POSITION"
        ;;
    "󰸉  Wallpaper")
        ~/.config/waybar/scripts/wallpaper-manager.sh
        ;;
    "󰖔  Night Mode")
        ~/.config/waybar/scripts/night-mode-toggle.sh
        notify-send "Night Mode" "Toggled color temperature"
        ;;
    "󰹑  Window Gaps")
        # Toggle gaps submenu
        gap_options="󰹑  Toggle Gaps\n󰙵  Increase Gaps\n󰙴  Decrease Gaps\n󰌑  Back"
        num_gap_items=4
        
        if [ "$POSITION" = "center" ]; then
            gap_choice=$(echo -e "$gap_options" | wofi --dmenu \
                --prompt "Window Gaps" \
                --width 220 \
                --lines "$num_gap_items" \
                --location center \
                --cache-file=/dev/null)
        else
            gap_choice=$(echo -e "$gap_options" | wofi --dmenu \
                --prompt "Window Gaps" \
                --width 220 \
                --lines "$num_gap_items" \
                --location top_right \
                --xoffset -10 \
                --yoffset 40 \
                --cache-file=/dev/null)
        fi
        
        case $gap_choice in
            "󰹑  Toggle Gaps")
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
            "󰙵  Increase Gaps")
                swaymsg gaps inner all plus 2
                swaymsg gaps outer all plus 2
                notify-send "Gaps Increased" "Gap size increased by 2px"
                ;;
            "󰙴  Decrease Gaps")
                swaymsg gaps inner all minus 2
                swaymsg gaps outer all minus 2
                notify-send "Gaps Decreased" "Gap size decreased by 2px"
                ;;
            "󰌑  Back")
                ~/.config/waybar/scripts/appearance-menu.sh "$POSITION"
                ;;
        esac
        ;;
    "󰂚  Opacity")
        # Opacity submenu
        opacity_options="󰂚  Increase Opacity\n󰂙  Decrease Opacity\n󰌑  Back"
        num_opacity_items=3
        
        if [ "$POSITION" = "center" ]; then
            opacity_choice=$(echo -e "$opacity_options" | wofi --dmenu \
                --prompt "Opacity" \
                --width 220 \
                --lines "$num_opacity_items" \
                --location center \
                --cache-file=/dev/null)
        else
            opacity_choice=$(echo -e "$opacity_options" | wofi --dmenu \
                --prompt "Opacity" \
                --width 220 \
                --lines "$num_opacity_items" \
                --location top_right \
                --xoffset -10 \
                --yoffset 40 \
                --cache-file=/dev/null)
        fi
        
        case $opacity_choice in
            "󰂚  Increase Opacity")
                swaymsg '[app_id=".*"]' opacity plus 0.05
                swaymsg '[class=".*"]' opacity plus 0.05
                notify-send "Opacity Increased" "Window opacity increased"
                ;;
            "󰂙  Decrease Opacity")
                swaymsg '[app_id=".*"]' opacity minus 0.05
                swaymsg '[class=".*"]' opacity minus 0.05
                notify-send "Opacity Decreased" "Window opacity decreased"
                ;;
            "󰌑  Back")
                ~/.config/waybar/scripts/appearance-menu.sh "$POSITION"
                ;;
        esac
        ;;
    "󰌑  Back")
        if [ "$POSITION" = "center" ]; then
            ~/.config/waybar/scripts/main-menu.sh
        fi
        ;;
esac
