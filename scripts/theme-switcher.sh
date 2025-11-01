#!/bin/bash
# BunkerOS Theme Switcher
# Manages and applies themes across all BunkerOS components

# Use fixed config directory instead of relative path
# This ensures the script works whether run from symlink or directly
CONFIG_DIR="$HOME/.config/bunkeros"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# If running from symlink (e.g., ~/.local/bin), use the real project directory
if [[ "$(readlink -f "${BASH_SOURCE[0]}")" == *"/Projects/bunkeros/"* ]]; then
    PROJECT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
fi

THEMES_DIR="$PROJECT_DIR/themes"
CURRENT_THEME_FILE="$PROJECT_DIR/.current-theme"

get_current_theme() {
    if [ -f "$CURRENT_THEME_FILE" ]; then
        cat "$CURRENT_THEME_FILE"
    else
        echo "tactical"
    fi
}

list_themes() {
    # Tactical first (default), then alphabetical
    echo "tactical"
    for theme_dir in "$THEMES_DIR"/*; do
        if [ -d "$theme_dir" ] && [ -f "$theme_dir/theme.conf" ]; then
            theme_name=$(basename "$theme_dir")
            if [ "$theme_name" != "tactical" ]; then
                echo "$theme_name"
            fi
        fi
    done | sort
}

get_theme_info() {
    local theme=$1
    local theme_conf="$THEMES_DIR/$theme/theme.conf"
    
    if [ ! -f "$theme_conf" ]; then
        echo "Unknown theme"
        return 1
    fi
    
    # Extract just the description
    grep "^DESCRIPTION=" "$theme_conf" | cut -d'=' -f2- | tr -d '"'
}

apply_theme() {
    local theme=$1
    local theme_dir="$THEMES_DIR/$theme"
    
    if [ ! -d "$theme_dir" ]; then
        notify-send "Theme Error" "Theme '$theme' not found"
        return 1
    fi
    
    notify-send "BunkerOS" "Applying $theme theme..."
    
    # Get wallpaper path from theme config
    local wallpaper_path=""
    if [ -f "$theme_dir/theme.conf" ]; then
        wallpaper_path=$(grep "^WALLPAPER=" "$theme_dir/theme.conf" | cut -d'=' -f2- | tr -d '"')
        # Expand $HOME variable
        wallpaper_path=$(eval echo "$wallpaper_path")
    fi
    
    # Update project directory (source of truth)
    cp "$theme_dir/waybar-style.css.template" "$PROJECT_DIR/waybar/style.css"
    cp "$theme_dir/wofi-style.css.template" "$PROJECT_DIR/wofi/style.css"
    cp "$theme_dir/mako-config" "$PROJECT_DIR/mako/config"
    cp "$theme_dir/swayosd-style.css" "$PROJECT_DIR/swayosd/style.css"
    cp "$theme_dir/btop.theme" "$PROJECT_DIR/btop/themes/active.theme"
    cp "$theme_dir/foot.ini.template" "$PROJECT_DIR/foot/foot.ini"
    cp "$theme_dir/dircolors" "$PROJECT_DIR/dircolors"
    
    # Also update active config locations
    cp "$theme_dir/waybar-style.css.template" "$HOME/.config/waybar/style.css"
    cp "$theme_dir/wofi-style.css.template" "$HOME/.config/wofi/style.css"
    cp "$theme_dir/mako-config" "$HOME/.config/mako/config"
    cp "$theme_dir/swayosd-style.css" "$HOME/.config/swayosd/style.css"
    cp "$theme_dir/btop.theme" "$HOME/.config/btop/themes/active.theme"
    cp "$theme_dir/foot.ini.template" "$HOME/.config/foot/foot.ini"
    cp "$theme_dir/dircolors" "$HOME/.dircolors"
    
    if grep -q "^# THEME COLORS START" "$PROJECT_DIR/sway/config" 2>/dev/null; then
        sed -i '/^# THEME COLORS START/,/^# THEME COLORS END/d' "$PROJECT_DIR/sway/config"
    fi
    
    echo "" >> "$PROJECT_DIR/sway/config"
    echo "# THEME COLORS START" >> "$PROJECT_DIR/sway/config"
    cat "$theme_dir/sway-colors.conf" >> "$PROJECT_DIR/sway/config"
    echo "# THEME COLORS END" >> "$PROJECT_DIR/sway/config"
    
    if grep -q "^# THEME PROMPT START" "$PROJECT_DIR/bashrc" 2>/dev/null; then
        sed -i '/^# THEME PROMPT START/,/^# THEME PROMPT END/d' "$PROJECT_DIR/bashrc"
    fi
    
    line_num=$(grep -n "^C_RESET=" "$PROJECT_DIR/bashrc" | cut -d: -f1 | head -1)
    if [ -n "$line_num" ]; then
        sed -i "${line_num},$((line_num + 5))d" "$PROJECT_DIR/bashrc"
    fi
    
    insert_line=$(grep -n "^PROMPT_COMMAND=" "$PROJECT_DIR/bashrc" | cut -d: -f1 | head -1)
    if [ -n "$insert_line" ]; then
        insert_line=$((insert_line - 1))
        temp_file=$(mktemp)
        {
            head -n "$insert_line" "$PROJECT_DIR/bashrc"
            echo "# THEME PROMPT START"
            cat "$theme_dir/bashrc-colors"
            echo "# THEME PROMPT END"
            echo ""
            tail -n +"$((insert_line + 1))" "$PROJECT_DIR/bashrc"
        } > "$temp_file"
        mv "$temp_file" "$PROJECT_DIR/bashrc"
    fi
    
    echo "$theme" > "$CURRENT_THEME_FILE"
    
    # Apply user's workspace style preference (if set) - AFTER saving current theme
    local workspace_style_pref="$CONFIG_DIR/workspace-style"
    if [ -f "$workspace_style_pref" ]; then
        local preferred_style=$(cat "$workspace_style_pref")
        if [ -x "$PROJECT_DIR/scripts/workspace-style-switcher.sh" ]; then
            # Don't restart waybar here - we'll do it below
            "$PROJECT_DIR/scripts/workspace-style-switcher.sh" apply "$preferred_style" 2>/dev/null || true
        fi
    fi
    
    # Simply restart waybar to apply new CSS
    killall -q waybar
    sleep 0.5
    swaymsg exec waybar &
    
    # Restart other services
    pkill mako 2>/dev/null
    sleep 0.2
    swaymsg exec mako
    
    pkill swayosd-server 2>/dev/null
    sleep 0.2
    swaymsg exec "swayosd-server --style ~/.config/swayosd/style.css --top-margin 0.5"
    
    # Apply window border colors dynamically (no sway reload needed!)
    local focused=$(grep "^client.focused " "$theme_dir/sway-colors.conf" | awk '{print $2,$3,$4,$5,$6}')
    local unfocused=$(grep "^client.unfocused " "$theme_dir/sway-colors.conf" | awk '{print $2,$3,$4,$5,$6}')
    local focused_inactive=$(grep "^client.focused_inactive " "$theme_dir/sway-colors.conf" | awk '{print $2,$3,$4,$5,$6}')
    local urgent=$(grep "^client.urgent " "$theme_dir/sway-colors.conf" | awk '{print $2,$3,$4,$5,$6}')
    local placeholder=$(grep "^client.placeholder " "$theme_dir/sway-colors.conf" | awk '{print $2,$3,$4,$5,$6}')
    local background=$(grep "^client.background " "$theme_dir/sway-colors.conf" | awk '{print $2}')
    
    swaymsg client.focused $focused
    swaymsg client.unfocused $unfocused
    swaymsg client.focused_inactive $focused_inactive
    swaymsg client.urgent $urgent
    swaymsg client.placeholder $placeholder
    swaymsg client.background $background
    
    if [ -f ~/.dircolors ]; then
        eval "$(dircolors -b ~/.dircolors)"
    fi
    
    # Update wallpaper based on mode (theme or custom)
    local wallpaper_mode_file="$HOME/.config/bunkeros/wallpaper-mode"
    local wallpaper_mode="theme"
    
    if [ -f "$wallpaper_mode_file" ]; then
        wallpaper_mode=$(cat "$wallpaper_mode_file")
    fi
    
    if [ "$wallpaper_mode" = "custom" ]; then
        # User has set a custom wallpaper - don't change it
        echo "Keeping custom wallpaper (mode: custom)"
    elif [ -n "$wallpaper_path" ] && [ -f "$wallpaper_path" ]; then
        # Apply theme's wallpaper
        killall swaybg 2>/dev/null
        sleep 0.2
        swaymsg exec "swaybg -i $wallpaper_path -m fill" &
    fi
    
    notify-send "BunkerOS Theme Applied" "Now using $theme theme"
}

show_theme_menu() {
    local position=${1:-center}
    local current_theme=$(get_current_theme)
    local theme_list=""
    
    while IFS= read -r theme; do
        local marker=""
        
        if [ "$theme" = "$current_theme" ]; then
            marker="●"
        else
            marker=" "
        fi
        
        # Simple format: ● THEME-NAME
        theme_list+="$marker ${theme^}\n"
    done < <(list_themes)
    
    selected=$(echo -e "$theme_list" | wofi \
        --dmenu \
        --prompt "Theme" \
        --width 200 \
        --height 220 \
        --cache-file=/dev/null \
        --insensitive \
        --lines 5)
    
    if [ -n "$selected" ]; then
        # Extract theme name from "● Tactical" or "  Gruvbox" format
        theme_name=$(echo "$selected" | sed 's/^[● ] //' | awk '{print tolower($1)}')
        if [ -n "$theme_name" ] && [ "$theme_name" != "" ]; then
            apply_theme "$theme_name"
            # Return to appearance menu after applying theme
            ~/.config/waybar/scripts/appearance-menu.sh "$position"
        fi
    fi
}

case "${1:-menu}" in
    menu)
        show_theme_menu "${2:-center}"
        ;;
    list)
        list_themes
        ;;
    current)
        get_current_theme
        ;;
    *)
        if list_themes | grep -q "^$1$"; then
            apply_theme "$1"
        else
            echo "Usage: $0 [menu|list|current|THEME_NAME]"
            echo "Available themes:"
            list_themes
            exit 1
        fi
        ;;
esac

