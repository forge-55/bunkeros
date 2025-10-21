#!/bin/bash
# BunkerOS Main Menu - Organized and tactical

options="🎨 Appearance\n⚙️  System\n📦 Install\n󰄀 Screenshot\n⌨️  Settings\n󰐥 Power"

# Count number of items
num_items=6

# Main menu always appears centered
selected=$(echo -e "$options" | wofi --dmenu \
    --prompt "Search..." \
    --width 200 \
    --lines "$num_items" \
    --location center)

case $selected in
    "🎨 Appearance")
        ~/.config/waybar/scripts/appearance-menu.sh center
        ;;
    "⚙️  System")
        ~/.config/waybar/scripts/system-menu.sh center
        ;;
    "📦 Install")
        ~/.config/waybar/scripts/install-menu.sh center
        ;;
    "󰄀 Screenshot")
        ~/.config/waybar/scripts/screenshot-area.sh
        ;;
    "⌨️  Settings")
        ~/.config/waybar/scripts/settings-menu.sh center
        ;;
    "󰐥 Power")
        ~/.config/waybar/scripts/power-menu.sh center
        ;;
esac
