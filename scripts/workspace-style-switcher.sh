#!/bin/bash
# BunkerOS Workspace Style Switcher
# Toggles between different workspace button styles

CONFIG_DIR="$HOME/.config/bunkeros"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STYLE_PREFERENCE_FILE="$CONFIG_DIR/workspace-style"
WORKSPACE_STYLES_DIR="$PROJECT_DIR/waybar/workspace-styles"

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"

get_current_style() {
    if [ -f "$STYLE_PREFERENCE_FILE" ]; then
        cat "$STYLE_PREFERENCE_FILE"
    else
        echo "bottom-border"  # Default style
    fi
}

list_styles() {
    echo "bottom-border"
    echo "box"
    echo "dots"
}

get_style_name() {
    local style=$1
    case "$style" in
        dots)
            echo "Abstract"
            ;;
        bottom-border)
            echo "Numbered (Underline)"
            ;;
        box)
            echo "Numbered (Border)"
            ;;
        *)
            echo "Unknown"
            ;;
    esac
}

get_theme_colors() {
    # Get current theme
    local current_theme_file="$PROJECT_DIR/.current-theme"
    local theme="tactical"
    if [ -f "$current_theme_file" ]; then
        theme=$(cat "$current_theme_file")
    fi
    
    # Read theme colors from theme.conf
    local theme_conf="$PROJECT_DIR/themes/$theme/theme.conf"
    if [ ! -f "$theme_conf" ]; then
        echo "Error: Theme config not found" >&2
        return 1
    fi
    
    # Extract colors
    PRIMARY=$(grep "^PRIMARY=" "$theme_conf" | cut -d'=' -f2 | tr -d ' "' | cut -d'#' -f2)
    SECONDARY=$(grep "^SECONDARY=" "$theme_conf" | cut -d'=' -f2 | tr -d ' "' | cut -d'#' -f2)
    ACCENT_MUTED=$(grep "^ACCENT_MUTED=" "$theme_conf" | cut -d'=' -f2 | tr -d ' "' | cut -d'#' -f2)
    ACCENT_DIM=$(grep "^ACCENT_DIM=" "$theme_conf" | cut -d'=' -f2 | tr -d ' "' | cut -d'#' -f2)
    URGENT=$(grep "^URGENT=" "$theme_conf" | cut -d'=' -f2 | tr -d ' "' | cut -d'#' -f2)
    
    # Convert hex to rgba for alpha versions
    hex_to_rgb() {
        local hex=$1
        printf "%d, %d, %d" 0x${hex:0:2} 0x${hex:2:2} 0x${hex:4:2}
    }
    
    PRIMARY_RGB=$(hex_to_rgb "$PRIMARY")
    ACCENT_MUTED_RGB=$(hex_to_rgb "$ACCENT_MUTED")
    ACCENT_DIM_RGB=$(hex_to_rgb "$ACCENT_DIM")
    URGENT_RGB=$(hex_to_rgb "$URGENT")
}

apply_workspace_style() {
    local style=$1
    local no_restart=$2
    local style_template="$WORKSPACE_STYLES_DIR/${style}.template"
    
    if [ ! -f "$style_template" ]; then
        notify-send "Error" "Workspace style '$style' not found"
        return 1
    fi
    
    # Get theme colors
    get_theme_colors
    
    # Save preference
    echo "$style" > "$STYLE_PREFERENCE_FILE"
    
    # Generate workspace CSS from template with theme colors
    local workspace_css=$(cat "$style_template" | \
        sed "s|__PRIMARY__|#$PRIMARY|g" | \
        sed "s|__SECONDARY__|#$SECONDARY|g" | \
        sed "s|__ACCENT_MUTED__|#$ACCENT_MUTED|g" | \
        sed "s|__ACCENT_DIM__|#$ACCENT_DIM|g" | \
        sed "s|__URGENT__|#$URGENT|g" | \
        sed "s|__PRIMARY_ALPHA__|rgba($PRIMARY_RGB, 0.4)|g" | \
        sed "s|__ACCENT_MUTED_ALPHA__|rgba($ACCENT_MUTED_RGB, 0.3)|g" | \
        sed "s|__ACCENT_DIM_ALPHA__|rgba($ACCENT_DIM_RGB, 0.3)|g" | \
        sed "s|__URGENT_ALPHA_LOW__|rgba($URGENT_RGB, 0.4)|g" | \
        sed "s|__URGENT_ALPHA_HIGH__|rgba($URGENT_RGB, 0.8)|g")
    
    # Update the active waybar style.css by replacing the workspace section
    local waybar_style="$HOME/.config/waybar/style.css"
    local temp_file=$(mktemp)
    
    # Check if placeholder exists
    if grep -q "WORKSPACE_STYLE_PLACEHOLDER" "$waybar_style"; then
        # Replace placeholder with actual styles
        awk -v ws="$workspace_css" '
            /\/\* WORKSPACE_STYLE_PLACEHOLDER \*\// {
                print ws
                next
            }
            {print}
        ' "$waybar_style" > "$temp_file"
    else
        # Placeholder already replaced - replace existing workspace button styles
        awk -v ws="$workspace_css" '
            BEGIN { in_workspace=0; skip_until_mode=0 }
            /^\/\* Workspace Button Style:/ {
                if (!skip_until_mode) {
                    print ws
                    skip_until_mode=1
                }
                next
            }
            skip_until_mode && /^#mode / {
                skip_until_mode=0
            }
            !skip_until_mode {print}
        ' "$waybar_style" > "$temp_file"
    fi
    
    mv "$temp_file" "$waybar_style"
    
    # Switch waybar config for abstract style (uses icons instead of numbers)
    local waybar_config="$HOME/.config/waybar/config"
    if [ "$style" = "dots" ]; then
        # Use abstract config with icon-based workspaces
        if [ -f "$PROJECT_DIR/waybar/config.abstract" ]; then
            cp "$PROJECT_DIR/waybar/config.abstract" "$waybar_config"
        fi
    else
        # Use numbered config with numbered workspaces
        if [ -f "$PROJECT_DIR/waybar/config.numbered" ]; then
            cp "$PROJECT_DIR/waybar/config.numbered" "$waybar_config"
        fi
    fi
    
    # Restart waybar to apply changes (unless --no-restart flag is set)
    if [ "$no_restart" != "--no-restart" ]; then
        killall -q waybar
        sleep 0.5
        swaymsg exec waybar &
        notify-send "BunkerOS" "Workspace style: $(get_style_name "$style")"
    fi
}

toggle_style() {
    local current=$(get_current_style)
    local new_style
    
    # Cycle through all three styles
    if [ "$current" = "bottom-border" ]; then
        new_style="box"
    elif [ "$current" = "box" ]; then
        new_style="dots"
    else
        new_style="bottom-border"
    fi
    
    apply_workspace_style "$new_style" ""
}

show_menu() {
    local current=$(get_current_style)
    local menu_items=""
    
    while IFS= read -r style; do
        local marker=""
        if [ "$style" = "$current" ]; then
            marker="●"
        else
            marker=" "
        fi
        
        local name=$(get_style_name "$style")
        menu_items+="$marker $name\n"
    done < <(list_styles)
    
    selected=$(echo -e "$menu_items" | wofi \
        --dmenu \
        --prompt "Workspace Style" \
        --width 280 \
        --height 180 \
        --cache-file=/dev/null \
        --insensitive)
    
    if [ -n "$selected" ]; then
        # Extract style from selection
        if echo "$selected" | grep -q "Numbered (Underline)"; then
            apply_workspace_style "bottom-border"
        elif echo "$selected" | grep -q "Numbered (Border)"; then
            apply_workspace_style "box"
        elif echo "$selected" | grep -q "Abstract"; then
            apply_workspace_style "dots"
        fi
    fi
}

case "${1:-toggle}" in
    toggle)
        toggle_style
        ;;
    menu)
        show_menu
        ;;
    list)
        list_styles
        ;;
    current)
        get_current_style
        ;;
    apply)
        if [ -z "$2" ]; then
            echo "Usage: $0 apply STYLE_NAME [--no-restart]"
            exit 1
        fi
        apply_workspace_style "$2" "$3"
        ;;
    *)
        echo "Usage: $0 [toggle|menu|list|current|apply STYLE_NAME]"
        exit 1
        ;;
esac
