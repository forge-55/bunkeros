#!/bin/bash
# BunkerOS Default Applications Manager
# Allows users to easily change default applications for common keybindings

CONFIG_DIR="$HOME/.config/bunkeros"
DEFAULTS_FILE="$CONFIG_DIR/defaults.conf"
SWAY_CONFIG="$HOME/.config/sway/config"

# Accept position parameter
POSITION=${1:-top_right}

# Ensure config directory and defaults file exist
mkdir -p "$CONFIG_DIR"
if [ ! -f "$DEFAULTS_FILE" ]; then
    # Create default config if it doesn't exist
    cat > "$DEFAULTS_FILE" << 'EOF'
# BunkerOS Default Applications Configuration
# This file stores user preferences for default applications
# Managed via: Super+m → Preferences → Default Apps
#
# Format: VARIABLE=command
# These variables are sourced by ~/.config/sway/config

# Terminal emulator (mod+t, mod+Return)
BUNKEROS_TERM=foot

# Application launcher
BUNKEROS_MENU=wofi --show drun

# Text/code editor (mod+e)
BUNKEROS_EDITOR=code

# File manager (mod+f)
BUNKEROS_FILEMANAGER=nautilus

# Note-taking application (mod+n)
BUNKEROS_NOTES=lite-xl
EOF
fi

# Source current defaults
source "$DEFAULTS_FILE"

# Function to get current value for a variable
get_current_value() {
    local var_name="$1"
    grep "^${var_name}=" "$DEFAULTS_FILE" | cut -d'=' -f2-
}

# Function to update defaults file
update_default() {
    local var_name="$1"
    local new_value="$2"
    
    # Escape special characters for sed
    local escaped_value=$(echo "$new_value" | sed 's/[\/&]/\\&/g')
    
    # Update the value in the config file
    sed -i "s|^${var_name}=.*|${var_name}=${escaped_value}|" "$DEFAULTS_FILE"
}

# Function to detect installed applications for a category
detect_apps() {
    local category="$1"
    local apps=()
    
    case "$category" in
        "terminal")
            local terminal_apps=("foot" "alacritty" "kitty" "wezterm" "terminator" "gnome-terminal" "xterm" "konsole")
            for app in "${terminal_apps[@]}"; do
                if command -v "$app" &> /dev/null; then
                    apps+=("$app")
                fi
            done
            ;;
        "editor")
            local editor_apps=("code" "cursor" "vscodium" "lite-xl" "gedit" "kate" "vim" "nvim" "nano" "micro" "emacs" "geany" "sublime_text")
            for app in "${editor_apps[@]}"; do
                if command -v "$app" &> /dev/null; then
                    apps+=("$app")
                fi
            done
            ;;
        "filemanager")
            local fm_apps=("nautilus" "thunar" "dolphin" "nemo" "pcmanfm" "ranger" "lf")
            for app in "${fm_apps[@]}"; do
                if command -v "$app" &> /dev/null; then
                    apps+=("$app")
                fi
            done
            ;;
        "notes")
            local notes_apps=("lite-xl" "obsidian" "notion" "logseq" "joplin" "code" "cursor" "gedit" "kate" "vim" "nvim")
            for app in "${notes_apps[@]}"; do
                if command -v "$app" &> /dev/null; then
                    apps+=("$app")
                fi
            done
            ;;
    esac
    
    printf '%s\n' "${apps[@]}"
}

# Function to get display name for keybinding
get_keybinding_display() {
    local category="$1"
    case "$category" in
        "terminal") echo "mod+t" ;;
        "editor") echo "mod+e" ;;
        "filemanager") echo "mod+f" ;;
        "notes") echo "mod+n" ;;
    esac
}

# Function to get friendly name for category
get_category_name() {
    local category="$1"
    case "$category" in
        "terminal") echo "Terminal" ;;
        "editor") echo "Editor" ;;
        "filemanager") echo "File Manager" ;;
        "notes") echo "Notes" ;;
    esac
}

# Function to select app for a category
select_app() {
    local category="$1"
    local var_name="$2"
    local keybinding=$(get_keybinding_display "$category")
    local category_name=$(get_category_name "$category")
    local current=$(get_current_value "$var_name")
    
    # Get installed apps
    local apps=($(detect_apps "$category"))
    
    if [ ${#apps[@]} -eq 0 ]; then
        notify-send "No Apps Found" "No $category_name applications detected on your system"
        return
    fi
    
    # Build menu options with current selection marked
    local options=""
    for app in "${apps[@]}"; do
        if [ "$app" = "$current" ]; then
            options+="󰄬  $app (current)\n"
        else
            options+="   $app\n"
        fi
    done
    options+="󰌑  Back"
    
    local num_items=$((${#apps[@]} + 1))
    
    # Show selection menu
    local selected
    if [ "$POSITION" = "center" ]; then
        selected=$(echo -e "$options" | wofi --dmenu \
            --prompt "$category_name ($keybinding)" \
            --width 320 \
            --lines "$num_items" \
            --location center \
            --cache-file=/dev/null)
    else
        selected=$(echo -e "$options" | wofi --dmenu \
            --prompt "$category_name ($keybinding)" \
            --width 320 \
            --lines "$num_items" \
            --location top_right \
            --xoffset -10 \
            --yoffset 40 \
            --cache-file=/dev/null)
    fi
    
    # Process selection
    if [ -z "$selected" ] || [ "$selected" = "󰌑  Back" ]; then
        show_main_menu
        return
    fi
    
    # Remove checkmark and "(current)" if present
    selected=$(echo "$selected" | sed 's/^󰄬  //' | sed 's/ (current)$//' | sed 's/^   //')
    
    # Update the config
    update_default "$var_name" "$selected"
    
    # Reload Sway config to apply changes
    swaymsg reload &> /dev/null
    
    notify-send "Default $category_name Changed" "Now using: $selected\nKeybinding: $keybinding"
    
    # Return to main menu
    show_main_menu
}

# Main menu
show_main_menu() {
    local current_term=$(get_current_value "BUNKEROS_TERM")
    local current_editor=$(get_current_value "BUNKEROS_EDITOR")
    local current_fm=$(get_current_value "BUNKEROS_FILEMANAGER")
    local current_notes=$(get_current_value "BUNKEROS_NOTES")
    
    local options="󰆍  Terminal (mod+t): $current_term
󰷉  Editor (mod+e): $current_editor
󰉋  File Manager (mod+f): $current_fm
󰠮  Notes (mod+n): $current_notes
󰌑  Back"
    
    local num_items=5
    
    local selected
    if [ "$POSITION" = "center" ]; then
        selected=$(echo -e "$options" | wofi --dmenu \
            --prompt "󰒓  Default Apps" \
            --width 450 \
            --lines "$num_items" \
            --location center \
            --cache-file=/dev/null)
    else
        selected=$(echo -e "$options" | wofi --dmenu \
            --prompt "󰒓  Default Apps" \
            --width 450 \
            --lines "$num_items" \
            --location top_right \
            --xoffset -10 \
            --yoffset 40 \
            --cache-file=/dev/null)
    fi
    
    case $selected in
        "󰆍  Terminal (mod+t):"*)
            select_app "terminal" "BUNKEROS_TERM"
            ;;
        "󰷉  Editor (mod+e):"*)
            select_app "editor" "BUNKEROS_EDITOR"
            ;;
        "󰉋  File Manager (mod+f):"*)
            select_app "filemanager" "BUNKEROS_FILEMANAGER"
            ;;
        "󰠮  Notes (mod+n):"*)
            select_app "notes" "BUNKEROS_NOTES"
            ;;
        "󰌑  Back")
            if [ "$POSITION" = "center" ]; then
                ~/.config/waybar/scripts/preferences-menu.sh center
            fi
            ;;
    esac
}

# Start the menu
show_main_menu
