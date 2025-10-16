#!/bin/bash

PROJECT_DIR="/home/ryan/Projects/sway-config"
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
    for theme_dir in "$THEMES_DIR"/*; do
        if [ -d "$theme_dir" ] && [ -f "$theme_dir/theme.conf" ]; then
            basename "$theme_dir"
        fi
    done
}

get_theme_info() {
    local theme=$1
    local theme_conf="$THEMES_DIR/$theme/theme.conf"
    
    if [ ! -f "$theme_conf" ]; then
        echo "Unknown theme"
        return 1
    fi
    
    source "$theme_conf"
    echo "$NAME - $DESCRIPTION"
}

apply_theme() {
    local theme=$1
    local theme_dir="$THEMES_DIR/$theme"
    
    if [ ! -d "$theme_dir" ]; then
        notify-send "Theme Error" "Theme '$theme' not found"
        return 1
    fi
    
    notify-send "Applying Theme" "Switching to $theme..."
    
    cp "$theme_dir/waybar-style.css" "$PROJECT_DIR/waybar/style.css"
    cp "$theme_dir/wofi-style.css" "$PROJECT_DIR/wofi/style.css"
    cp "$theme_dir/mako-config" "$PROJECT_DIR/mako/config"
    cp "$theme_dir/swayosd-style.css" "$PROJECT_DIR/swayosd/style.css"
    cp "$theme_dir/btop.theme" "$PROJECT_DIR/btop/themes/active.theme"
    cp "$theme_dir/foot.ini" "$PROJECT_DIR/foot/foot.ini"
    cp "$theme_dir/dircolors" "$PROJECT_DIR/dircolors"
    
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
    
    notify-send "Theme Applied" "Now using $theme theme"
}

show_theme_menu() {
    local current_theme=$(get_current_theme)
    local theme_list=""
    
    while IFS= read -r theme; do
        local info=$(get_theme_info "$theme")
        local marker=""
        if [ "$theme" = "$current_theme" ]; then
            marker=" ▸"
        fi
        theme_list+="$theme - $info$marker\n"
    done < <(list_themes)
    
    selected=$(echo -e "$theme_list" | wofi \
        --dmenu \
        --prompt "Select Theme" \
        --width 700 \
        --height 400 \
        --cache-file=/dev/null \
        --insensitive \
        --columns 1)
    
    if [ -n "$selected" ]; then
        theme_name=$(echo "$selected" | awk '{print $1}')
        apply_theme "$theme_name"
    fi
}

case "${1:-menu}" in
    menu)
        show_theme_menu
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

