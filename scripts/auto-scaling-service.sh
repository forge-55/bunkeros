#!/usr/bin/env bash

# BunkerOS Auto-Scaling Service
# Automatically detects and applies optimal display scaling on session start
# Runs once per session and caches results

set -e

# Project directory detection
if [ -d "$HOME/Projects/bunkeros" ]; then
    PROJECT_DIR="$HOME/Projects/bunkeros"
else
    exit 0  # Silent exit if BunkerOS not found
fi

CONFIG_DIR="$HOME/.config"
CACHE_FILE="$CONFIG_DIR/bunkeros/scaling-applied"
LOCKFILE="/tmp/bunkeros-scaling-lock"

# Exit if already processed this session
if [ -f "$CACHE_FILE" ]; then
    session_start=$(cat "$CACHE_FILE" 2>/dev/null || echo "0")
    current_time=$(date +%s)
    # Only rerun if more than 30 minutes have passed (session restart)
    if [ $((current_time - session_start)) -lt 1800 ]; then
        exit 0
    fi
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

# Function to apply configuration silently
apply_scaling_config() {
    local scale="$1"
    local foot_font="$2"
    local waybar_font="$3"
    local wofi_font="$4"
    
    # Update foot terminal config
    if [ -f "$CONFIG_DIR/foot/foot.ini" ]; then
        sed -i "s/^font=monospace:size=[0-9]*/font=monospace:size=$foot_font/" "$CONFIG_DIR/foot/foot.ini"
    fi
    
    # Update theme-specific foot configs
    for theme_dir in "$PROJECT_DIR"/themes/*/; do
        if [ -f "$theme_dir/foot.ini" ]; then
            sed -i "s/^font=monospace:size=[0-9]*/font=monospace:size=$foot_font/" "$theme_dir/foot.ini"
        fi
    done
    
    # Update Waybar config
    if [ -f "$CONFIG_DIR/waybar/style.css" ]; then
        sed -i "s/font-size: [0-9]*px;/font-size: ${waybar_font}px;/g" "$CONFIG_DIR/waybar/style.css"
    fi
    
    # Update theme-specific waybar styles
    for theme_dir in "$PROJECT_DIR"/themes/*/; do
        if [ -f "$theme_dir/waybar-style.css" ]; then
            sed -i "s/font-size: [0-9]*px;/font-size: ${waybar_font}px;/g" "$theme_dir/waybar-style.css"
        fi
    done
    
    # Update Wofi config
    if [ -f "$CONFIG_DIR/wofi/style.css" ]; then
        sed -i "s/font-size: [0-9]*px;/font-size: ${wofi_font}px;/g" "$CONFIG_DIR/wofi/style.css"
    fi
    
    # Update theme-specific wofi styles
    for theme_dir in "$PROJECT_DIR"/themes/*/; do
        if [ -f "$theme_dir/wofi-style.css" ]; then
            sed -i "s/font-size: [0-9]*px;/font-size: ${wofi_font}px;/g" "$theme_dir/wofi-style.css"
        fi
    done
    
    # Apply Wayland scaling if needed
    if [ "$scale" != "1.0" ]; then
        # Add scaling to sway config if not already present
        if [ -f "$CONFIG_DIR/sway/config" ]; then
            if ! grep -q "output \* scale" "$CONFIG_DIR/sway/config"; then
                sed -i '/### Output configuration/a\\n# Auto-configured display scaling\noutput * scale '"$scale" "$CONFIG_DIR/sway/config"
            else
                sed -i "s/^output \* scale.*/output * scale $scale/" "$CONFIG_DIR/sway/config"
            fi
        fi
    fi
}

# Run detection and get config values
if [ -f "$PROJECT_DIR/scripts/detect-display-hardware.sh" ]; then
    detection_output=$("$PROJECT_DIR/scripts/detect-display-hardware.sh" --config-vars 2>/dev/null | grep "^[A-Z_]*=")
    
    if [ $? -eq 0 ] && [ -n "$detection_output" ]; then
        eval "$detection_output"
        
        # Apply the configuration
        apply_scaling_config "$DISPLAY_SCALE" "$FOOT_FONT_SIZE" "$WAYBAR_FONT_SIZE" "$WOFI_FONT_SIZE"
        
        # Restart Waybar to apply changes
        if pgrep waybar >/dev/null; then
            pkill waybar
            sleep 1
            waybar -b bar-0 >/dev/null 2>&1 &
        fi
        
        # Save cache to prevent re-running
        mkdir -p "$CONFIG_DIR/bunkeros"
        date +%s > "$CACHE_FILE"
        
        # Create a profile record
        cat > "$CONFIG_DIR/bunkeros/auto-scaling-profile.conf" << EOF
# BunkerOS Auto-Applied Scaling Profile
# Applied: $(date)
DEVICE_TYPE="$DEVICE_TYPE"
DISPLAY_SCALE="$DISPLAY_SCALE"
FOOT_FONT_SIZE="$FOOT_FONT_SIZE"
WAYBAR_FONT_SIZE="$WAYBAR_FONT_SIZE"
WOFI_FONT_SIZE="$WOFI_FONT_SIZE"
AUTO_APPLIED="$(date +%s)"
EOF
    fi
fi

# Clean up
rm -f "$LOCKFILE"