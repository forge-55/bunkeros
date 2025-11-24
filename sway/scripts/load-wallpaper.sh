#!/bin/bash
# BunkerOS Wallpaper Loader
# Loads the appropriate wallpaper based on wallpaper-mode and current theme

# Find bunkeros directory
if [ -d "$HOME/bunkeros" ]; then
    PROJECT_DIR="$HOME/bunkeros"
elif [ -d "$HOME/Projects/bunkeros" ]; then
    PROJECT_DIR="$HOME/Projects/bunkeros"
else
    PROJECT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../.." && pwd)"
fi

CONFIG_DIR="$HOME/.config/bunkeros"
WALLPAPER_MODE_FILE="$CONFIG_DIR/wallpaper-mode"
CUSTOM_WALLPAPER_FILE="$CONFIG_DIR/wallpaper-mode.custom-path"
LAST_WALLPAPER_FILE="$CONFIG_DIR/last-wallpaper"
CURRENT_THEME_FILE="$PROJECT_DIR/.current-theme"
DEFAULT_WALLPAPER="$HOME/.local/share/bunkeros/wallpapers/tactical.jpg"

# Determine which wallpaper to load
get_wallpaper_path() {
    # First priority: Use the last wallpaper that was applied (persists across sessions)
    if [ -f "$LAST_WALLPAPER_FILE" ]; then
        local last_wallpaper=$(cat "$LAST_WALLPAPER_FILE")
        if [ -f "$last_wallpaper" ]; then
            echo "$last_wallpaper"
            return
        fi
    fi
    
    # Second priority: Check wallpaper mode
    if [ -f "$WALLPAPER_MODE_FILE" ]; then
        local mode=$(cat "$WALLPAPER_MODE_FILE")
        
        if [ "$mode" = "custom" ] && [ -f "$CUSTOM_WALLPAPER_FILE" ]; then
            # Use custom wallpaper
            local custom_path=$(cat "$CUSTOM_WALLPAPER_FILE")
            if [ -f "$custom_path" ]; then
                echo "$custom_path"
                return
            fi
        fi
    fi
    
    # Third priority: Use theme wallpaper
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
