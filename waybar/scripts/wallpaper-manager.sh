#!/bin/bash
# BunkerOS Wallpaper Manager
# Provides easy wallpaper selection with visual preview

WALLPAPER_DIR="$HOME/.local/share/bunkeros/wallpapers"
CUSTOM_WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CONFIG_FILE="$HOME/.config/bunkeros/wallpaper-mode"

# Find bunkeros directory
if [ -d "$HOME/bunkeros" ]; then
    PROJECT_DIR="$HOME/bunkeros"
elif [ -d "$HOME/Projects/bunkeros" ]; then
    PROJECT_DIR="$HOME/Projects/bunkeros"
else
    PROJECT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../.." && pwd)"
fi

CURRENT_THEME_FILE="$PROJECT_DIR/.current-theme"

# Ensure directories exist
mkdir -p "$CUSTOM_WALLPAPER_DIR"
mkdir -p "$(dirname "$CONFIG_FILE")"

# Get current wallpaper mode (theme or custom)
get_wallpaper_mode() {
    if [ -f "$CONFIG_FILE" ]; then
        cat "$CONFIG_FILE"
    else
        echo "theme"
    fi
}

# Set wallpaper mode
set_wallpaper_mode() {
    echo "$1" > "$CONFIG_FILE"
}

# Get current theme
get_current_theme() {
    if [ -f "$CURRENT_THEME_FILE" ]; then
        cat "$CURRENT_THEME_FILE"
    else
        echo "tactical"
    fi
}

# Apply wallpaper
apply_wallpaper() {
    local wallpaper="$1"
    killall swaybg 2>/dev/null
    swaymsg exec "swaybg -i \"$wallpaper\" -m fill" &
    # Save the wallpaper path for session persistence
    echo "$wallpaper" > "$HOME/.config/bunkeros/last-wallpaper"
}

# Main menu
show_main_menu() {
    local current_mode=$(get_wallpaper_mode)
    local mode_status
    
    if [ "$current_mode" = "theme" ]; then
        mode_status="✓ Using Theme Wallpapers"
    else
        mode_status="✓ Using Custom Wallpaper"
    fi
    
    local choice=$(echo -e "📁 Upload New Wallpaper\n🖼️ Browse & Select Wallpaper\n🎨 Use Theme Wallpapers\n⬅️ Back" | \
        wofi --dmenu --prompt "$mode_status" --width 450 --height 300)
    
    case "$choice" in
        "📁 Upload New Wallpaper")
            upload_wallpaper
            ;;
        "🖼️ Browse & Select Wallpaper")
            browse_custom_wallpapers
            ;;
        "🎨 Use Theme Wallpapers")
            enable_theme_wallpapers
            ;;
        "⬅️ Back")
            ~/.config/waybar/scripts/quick-menu.sh
            ;;
    esac
}

# Enable theme wallpapers mode
enable_theme_wallpapers() {
    set_wallpaper_mode "theme"
    
    # Apply current theme's wallpaper
    local theme=$(get_current_theme)
    local theme_conf="$PROJECT_DIR/themes/$theme/theme.conf"
    
    if [ -f "$theme_conf" ]; then
        # Source the theme config to get WALLPAPER path
        source "$theme_conf"
        if [ -n "$WALLPAPER" ]; then
            # Expand ~ in path
            local wallpaper_path="${WALLPAPER/#\~/$HOME}"
            apply_wallpaper "$wallpaper_path"
            notify-send "Wallpaper" "Switched to theme wallpapers\nTheme: $NAME" -i preferences-desktop-wallpaper
        fi
    fi
    
    show_main_menu
}

# Browse and select custom wallpapers (using wofi menu)
browse_custom_wallpapers() {
    # Get list of image files (-L to follow symlinks)
    local images=$(find -L "$CUSTOM_WALLPAPER_DIR" "$WALLPAPER_DIR" -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null | sort)
    
    if [ -z "$images" ]; then
        notify-send "No Wallpapers" "No wallpapers found. Upload one first!" -i dialog-warning
        show_main_menu
        return
    fi
    
    # Use wofi menu (reliable, matches BunkerOS theme, intuitive)
    # Build a user-friendly menu with cleaned-up names and emoji indicators
    local menu_items=""
    declare -A path_map  # Associate display names with full paths
    
    while IFS= read -r fullpath; do
        local filename=$(basename "$fullpath")
        local display_name="${filename%.*}"  # Remove extension
        
        # Capitalize and add emoji indicators
        if [[ "$fullpath" == *"/wallpapers/"* ]] || [[ "$fullpath" == *"bunkeros/wallpapers"* ]]; then
            # Theme wallpaper (from the 5 bundled themes)
            display_name="🎨 ${display_name^}"  # Capitalize first letter
        else
            # Custom wallpaper (user uploaded)
            display_name="📷 ${display_name}"
        fi
        
        menu_items+="$display_name\n"
        path_map["$display_name"]="$fullpath"
    done <<< "$images"
    
    # Show wofi menu - uses BunkerOS theme automatically
    local selected=$(echo -e "$menu_items" | wofi --dmenu \
        --prompt "🖼️ Select Wallpaper" \
        --height 450 \
        --width 600 \
        --cache-file /dev/null)
    
    if [ -n "$selected" ]; then
        local fullpath="${path_map[$selected]}"
        
        if [ -f "$fullpath" ]; then
            # Set custom mode and apply
            set_wallpaper_mode "custom"
            echo "$fullpath" > "$CONFIG_FILE.custom-path"
            apply_wallpaper "$fullpath"
            
            local filename=$(basename "$fullpath")
            notify-send "Wallpaper Changed" "✓ Applied: $filename\nMode: Custom (persists across themes)" -i preferences-desktop-wallpaper
        fi
    fi
    
    show_main_menu
}


# Upload new wallpaper
upload_wallpaper() {
    # Use file picker to select an image
    local selected=$(zenity --file-selection --title="Select Wallpaper Image" \
        --file-filter="Images | *.jpg *.jpeg *.png *.webp *.JPG *.JPEG *.PNG *.WEBP" 2>/dev/null)
    
    if [ -n "$selected" ] && [ -f "$selected" ]; then
        local filename=$(basename "$selected")
        local destination="$CUSTOM_WALLPAPER_DIR/$filename"
        
        # Copy to custom wallpapers directory
        cp "$selected" "$destination"
        
        # Ask if they want to apply it now
        if zenity --question --text="Wallpaper uploaded!\n\nApply it now?" --title="Apply Wallpaper" 2>/dev/null; then
            set_wallpaper_mode "custom"
            echo "$destination" > "$CONFIG_FILE.custom-path"
            apply_wallpaper "$destination"
            notify-send "Wallpaper Applied" "Applied: $filename" -i preferences-desktop-wallpaper
        else
            notify-send "Wallpaper Uploaded" "Saved to: ~/Pictures/Wallpapers/\nYou can select it later from the menu" -i document-save
        fi
    fi
    
    show_main_menu
}

# Run main menu
show_main_menu

