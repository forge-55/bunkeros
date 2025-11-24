#!/bin/bash
# BunkerOS Wallpaper Loader
# Loads the current theme's default wallpaper

# Find bunkeros directory
if [ -d "$HOME/bunkeros" ]; then
    PROJECT_DIR="$HOME/bunkeros"
elif [ -d "$HOME/Projects/bunkeros" ]; then
    PROJECT_DIR="$HOME/Projects/bunkeros"
else
    PROJECT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../.." && pwd)"
fi

CURRENT_THEME_FILE="$PROJECT_DIR/.current-theme"
DEFAULT_WALLPAPER="$HOME/.local/share/bunkeros/wallpapers/tactical.jpg"

# Get the current theme's wallpaper
get_wallpaper_path() {
    local theme="tactical"
    if [ -f "$CURRENT_THEME_FILE" ]; then
        theme=$(cat "$CURRENT_THEME_FILE")
    fi
    
    # Get wallpaper from theme config
    local theme_conf="$PROJECT_DIR/themes/$theme/theme.conf"
    if [ -f "$theme_conf" ]; then
        local wallpaper=$(grep "^WALLPAPER=" "$theme_conf" | cut -d'=' -f2- | tr -d '"')
        # Expand $HOME variable
        wallpaper=$(eval echo "$wallpaper")
        if [ -f "$wallpaper" ]; then
            echo "$wallpaper"
            return
        fi
    fi
    
    # Fallback to default
    echo "$DEFAULT_WALLPAPER"
}

# Load wallpaper if swaybg is not already running
if ! pgrep -x swaybg > /dev/null; then
    killall swaybg 2>/dev/null
    sleep 0.2
    
    wallpaper_path=$(get_wallpaper_path)
    
    if [ -f "$wallpaper_path" ]; then
        swaybg -i "$wallpaper_path" -m fill &
    else
        # Final fallback
        swaybg -i "$DEFAULT_WALLPAPER" -m fill &
    fi
fi
