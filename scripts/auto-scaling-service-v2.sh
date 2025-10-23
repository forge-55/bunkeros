#!/usr/bin/env bash

# BunkerOS Auto-Scaling Service (Improved)
# Automatically detects and applies optimal display scaling
# RESPECTS user preferences and never modifies theme source files

set -e

# Project directory detection
if [ -d "$HOME/Projects/bunkeros" ]; then
    PROJECT_DIR="$HOME/Projects/bunkeros"
else
    exit 0  # Silent exit if BunkerOS not found
fi

CONFIG_DIR="$HOME/.config"
BUNKEROS_CONFIG="$CONFIG_DIR/bunkeros"
USER_PREFS="$BUNKEROS_CONFIG/user-preferences.conf"
SCALING_PROFILE="$BUNKEROS_CONFIG/scaling-profile.conf"
SCALING_DISABLED="$BUNKEROS_CONFIG/scaling-disabled"
FIRST_RUN_FLAG="$BUNKEROS_CONFIG/scaling-first-run-done"
LOCKFILE="/tmp/bunkeros-scaling-lock"

# Check if user has disabled auto-scaling
if [ -f "$SCALING_DISABLED" ]; then
    exit 0
fi

# Prevent multiple instances
if [ -f "$LOCKFILE" ]; then
    exit 0
fi
echo $$ > "$LOCKFILE"
trap 'rm -f "$LOCKFILE"' EXIT

# Wait for display to be ready
sleep 2

# Check if we have display information
if [ -z "$WAYLAND_DISPLAY" ] || ! command -v swaymsg &>/dev/null; then
    exit 0
fi

# Ensure sway is fully started
timeout=10
while ! swaymsg -t get_outputs &>/dev/null && [ $timeout -gt 0 ]; do
    sleep 1
    ((timeout--))
done

if [ $timeout -eq 0 ]; then
    exit 0  # Sway not ready
fi

# Create config directory
mkdir -p "$BUNKEROS_CONFIG"

# Function to check if user has manually customized configs
has_user_preferences() {
    [ -f "$USER_PREFS" ]
}

# Function to read current font sizes from active configs
get_current_config() {
    local foot_size=$(grep "^font=monospace:size=" "$CONFIG_DIR/foot/foot.ini" 2>/dev/null | grep -o "size=[0-9]*" | cut -d= -f2)
    local waybar_size=$(grep "font-size:" "$CONFIG_DIR/waybar/style.css" 2>/dev/null | head -1 | grep -o "[0-9]*px" | tr -d 'px')
    local wofi_size=$(grep "font-size:" "$CONFIG_DIR/wofi/style.css" 2>/dev/null | head -1 | grep -o "[0-9]*px" | tr -d 'px')
    
    echo "FOOT_FONT_SIZE=$foot_size"
    echo "WAYBAR_FONT_SIZE=$waybar_size"
    echo "WOFI_FONT_SIZE=$wofi_size"
}

# Function to detect if user has modified configs since last auto-scaling
configs_modified_by_user() {
    if [ ! -f "$SCALING_PROFILE" ]; then
        return 1  # No profile yet, not modified
    fi
    
    # Load last auto-applied settings
    source "$SCALING_PROFILE"
    local last_foot="$FOOT_FONT_SIZE"
    local last_waybar="$WAYBAR_FONT_SIZE"
    local last_wofi="$WOFI_FONT_SIZE"
    
    # Get current settings
    eval "$(get_current_config)"
    
    # If current differs from last auto-applied, user modified it
    if [ "$FOOT_FONT_SIZE" != "$last_foot" ] || \
       [ "$WAYBAR_FONT_SIZE" != "$last_waybar" ] || \
       [ "$WOFI_FONT_SIZE" != "$last_wofi" ]; then
        return 0  # Modified
    fi
    
    return 1  # Not modified
}

# If user has customized configs, save them as preferences and exit
if [ -f "$FIRST_RUN_FLAG" ] && configs_modified_by_user; then
    eval "$(get_current_config)"
    
    # Save user preferences
    cat > "$USER_PREFS" << EOF
# BunkerOS User Preferences
# Auto-detected user customization on: $(date)
# To reset to auto-scaling, delete this file
FOOT_FONT_SIZE="$FOOT_FONT_SIZE"
WAYBAR_FONT_SIZE="$WAYBAR_FONT_SIZE"
WOFI_FONT_SIZE="$WOFI_FONT_SIZE"
USER_CUSTOMIZED="true"
USER_CUSTOMIZED_DATE="$(date +%s)"
EOF
    
    # Notify user (only once)
    if command -v notify-send &>/dev/null && [ ! -f "$BUNKEROS_CONFIG/user-pref-notified" ]; then
        notify-send "BunkerOS Scaling" "Custom font sizes detected. Auto-scaling disabled.\n\nTo re-enable: rm ~/.config/bunkeros/user-preferences.conf" -t 5000
        touch "$BUNKEROS_CONFIG/user-pref-notified"
    fi
    
    exit 0
fi

# If user preferences exist, respect them and don't auto-scale
if has_user_preferences; then
    exit 0
fi

# Run detection and apply ONLY to user config files (not theme sources)
if [ -f "$PROJECT_DIR/scripts/detect-display-hardware.sh" ]; then
    detection_output=$("$PROJECT_DIR/scripts/detect-display-hardware.sh" --config-vars 2>/dev/null | grep "^[A-Z_]*=")
    
    if [ $? -eq 0 ] && [ -n "$detection_output" ]; then
        eval "$detection_output"
        
        # Apply to USER config files only (symlinked from theme)
        # These are ~/.config/foot/foot.ini, ~/.config/waybar/style.css, etc.
        
        # Update foot terminal config (USER copy)
        if [ -f "$CONFIG_DIR/foot/foot.ini" ]; then
            sed -i "s/^font=monospace:size=[0-9]*/font=monospace:size=$FOOT_FONT_SIZE/" "$CONFIG_DIR/foot/foot.ini"
        fi
        
        # Update Waybar config (USER copy)
        if [ -f "$CONFIG_DIR/waybar/style.css" ]; then
            sed -i "s/font-size: [0-9]*px;/font-size: ${WAYBAR_FONT_SIZE}px;/g" "$CONFIG_DIR/waybar/style.css"
        fi
        
        # Update Wofi config (USER copy)
        if [ -f "$CONFIG_DIR/wofi/style.css" ]; then
            sed -i "s/font-size: [0-9]*px;/font-size: ${WOFI_FONT_SIZE}px;/g" "$CONFIG_DIR/wofi/style.css"
        fi
        
        # Apply Wayland scaling if needed
        if [ "$DISPLAY_SCALE" != "1.0" ] && [ -f "$CONFIG_DIR/sway/config" ]; then
            if ! grep -q "output \* scale" "$CONFIG_DIR/sway/config"; then
                sed -i '/### Output configuration/a\\n# Auto-configured display scaling\noutput * scale '"$DISPLAY_SCALE" "$CONFIG_DIR/sway/config"
            else
                sed -i "s/^output \* scale.*/output * scale $DISPLAY_SCALE/" "$CONFIG_DIR/sway/config"
            fi
        fi
        
        # Restart Waybar to apply changes
        if pgrep waybar >/dev/null; then
            pkill waybar
            sleep 1
            waybar -b bar-0 >/dev/null 2>&1 &
        fi
        
        # Save profile to track what we applied
        cat > "$SCALING_PROFILE" << EOF
# BunkerOS Auto-Applied Scaling Profile
# Applied: $(date)
DEVICE_TYPE="$DEVICE_TYPE"
DISPLAY_SCALE="$DISPLAY_SCALE"
FOOT_FONT_SIZE="$FOOT_FONT_SIZE"
WAYBAR_FONT_SIZE="$WAYBAR_FONT_SIZE"
WOFI_FONT_SIZE="$WOFI_FONT_SIZE"
AUTO_APPLIED="$(date +%s)"
EOF
        
        # Mark first run as complete
        touch "$FIRST_RUN_FLAG"
    fi
fi

# Clean up
rm -f "$LOCKFILE"
