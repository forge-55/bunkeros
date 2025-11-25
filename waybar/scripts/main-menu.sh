#!/bin/bash
# BunkerOS Main Menu - Organized and tactical

# If wofi is already running, close it instead of opening a new menu
if pgrep -x wofi > /dev/null 2>&1; then
    pkill -x wofi
    exit 0
fi

options="󰒓  System\n󱐋  Actions\n󰏘  Theme\n󰀉  Preferences\n󰏖  Install\n󰐥  Power"

# Count number of items
num_items=6

# Main menu always appears centered
# Use cache-file=/dev/null to prevent menu items from reordering
selected=$(echo -e "$options" | wofi --dmenu \
    --prompt "Search..." \
    --width 220 \
    --lines "$num_items" \
    --location center \
    --cache-file=/dev/null)

case $selected in
    "󰒓  System")
        ~/.config/waybar/scripts/system-menu.sh center
        ;;
    "󱐋  Actions")
        ~/.config/waybar/scripts/actions-menu.sh center
        ;;
    "󰏘  Theme")
        ~/.local/bin/theme-switcher.sh menu center
        ;;
    "󰀉  Preferences")
        ~/.config/waybar/scripts/preferences-menu.sh center
        ;;
    "󰏖  Install")
        ~/.config/waybar/scripts/install-menu.sh center
        ;;
    "󰐥  Power")
        ~/.config/waybar/scripts/power-menu.sh center
        ;;
esac
