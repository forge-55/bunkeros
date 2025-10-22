#!/usr/bin/env bash

# BunkerOS Display Scaling Configuration Script
# Applies adaptive scaling settings based on hardware detection
# Similar to Pop_OS!/COSMIC dynamic scaling

set -e

# Project directory detection
if [ -d "$HOME/Projects/bunkeros" ]; then
    PROJECT_DIR="$HOME/Projects/bunkeros"
elif [ -d "$(dirname "$(realpath "$0")")/.." ]; then
    PROJECT_DIR="$(dirname "$(realpath "$0")")/.."
else
    echo "❌ Could not find BunkerOS project directory"
    exit 1
fi

# Output formatting
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

INFO="ℹ️ "
SUCCESS="✅"
WARN="⚠️ "
ERROR="❌"

CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config/bunkeros-backups/scaling-$(date +%Y%m%d-%H%M%S)"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║         BunkerOS Adaptive Display Configuration            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Function to backup file if it exists
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        cp "$file" "$BACKUP_DIR/"
        echo "   📁 Backed up: $(basename "$file")"
    fi
}

# Function to apply Wayland output scaling
apply_wayland_scaling() {
    local scale="$1"
    
    echo "Configuring Wayland output scaling..."
    
    # Add/update output scaling in sway config
    local sway_config="$CONFIG_DIR/sway/config"
    
    if [ -f "$sway_config" ]; then
        backup_file "$sway_config"
        
        # Remove existing output scaling lines
        sed -i '/^output \* scale/d' "$sway_config"
        
        # Add new scaling line after the ### Output configuration section
        sed -i '/### Output configuration/a\\n# Adaptive scaling (auto-configured)\noutput * scale '"$scale" "$sway_config"
        
        echo "   ${SUCCESS}Added output scaling: $scale to Sway config"
    else
        echo "   ${WARN}Sway config not found, skipping Wayland scaling"
    fi
}

# Function to update foot terminal configuration
update_foot_config() {
    local font_size="$1"
    local theme="$2"
    
    echo "Updating foot terminal configuration..."
    
    # Update main foot config
    local foot_config="$CONFIG_DIR/foot/foot.ini"
    backup_file "$foot_config"
    
    # Update font size in foot config
    sed -i "s/^font=monospace:size=[0-9]*/font=monospace:size=$font_size/" "$foot_config"
    echo "   ${SUCCESS}Updated foot font size: $font_size"
    
    # Update theme-specific foot configs
    for theme_dir in "$PROJECT_DIR"/themes/*/; do
        if [ -d "$theme_dir" ] && [ -f "$theme_dir/foot.ini" ]; then
            theme_name=$(basename "$theme_dir")
            backup_file "$theme_dir/foot.ini"
            sed -i "s/^font=monospace:size=[0-9]*/font=monospace:size=$font_size/" "$theme_dir/foot.ini"
            echo "   ${SUCCESS}Updated foot font for theme: $theme_name"
        fi
    done
}

# Function to update Waybar configuration
update_waybar_config() {
    local font_size="$1"
    
    echo "Updating Waybar configuration..."
    
    local waybar_style="$CONFIG_DIR/waybar/style.css"
    backup_file "$waybar_style"
    
    # Update font size in waybar style
    sed -i "s/font-size: [0-9]*px;/font-size: ${font_size}px;/" "$waybar_style"
    
    # Also update specific font size overrides
    sed -i "s/font-size: [0-9]*px;/font-size: ${font_size}px;/g" "$waybar_style"
    sed -i "s/    font-size: [0-9]*px;/    font-size: ${font_size}px;/g" "$waybar_style"
    
    echo "   ${SUCCESS}Updated Waybar font size: ${font_size}px"
    
    # Update theme-specific waybar styles
    for theme_dir in "$PROJECT_DIR"/themes/*/; do
        if [ -d "$theme_dir" ] && [ -f "$theme_dir/waybar-style.css" ]; then
            theme_name=$(basename "$theme_dir")
            backup_file "$theme_dir/waybar-style.css"
            sed -i "s/font-size: [0-9]*px;/font-size: ${font_size}px;/g" "$theme_dir/waybar-style.css"
            echo "   ${SUCCESS}Updated Waybar style for theme: $theme_name"
        fi
    done
}

# Function to update Wofi configuration
update_wofi_config() {
    local font_size="$1"
    
    echo "Updating Wofi configuration..."
    
    local wofi_style="$CONFIG_DIR/wofi/style.css"
    backup_file "$wofi_style"
    
    # Update font size in wofi style
    sed -i "s/font-size: [0-9]*px;/font-size: ${font_size}px;/" "$wofi_style"
    
    echo "   ${SUCCESS}Updated Wofi font size: ${font_size}px"
    
    # Update theme-specific wofi styles
    for theme_dir in "$PROJECT_DIR"/themes/*/; do
        if [ -d "$theme_dir" ] && [ -f "$theme_dir/wofi-style.css" ]; then
            theme_name=$(basename "$theme_dir")
            backup_file "$theme_dir/wofi-style.css"
            sed -i "s/font-size: [0-9]*px;/font-size: ${font_size}px;/g" "$theme_dir/wofi-style.css"
            echo "   ${SUCCESS}Updated Wofi style for theme: $theme_name"
        fi
    done
}

# Function to create scaling profile
save_scaling_profile() {
    local device_type="$1"
    local scale="$2"
    local foot_font="$3"
    local waybar_font="$4"
    local wofi_font="$5"
    
    local profile_dir="$CONFIG_DIR/bunkeros"
    mkdir -p "$profile_dir"
    
    cat > "$profile_dir/scaling-profile.conf" << EOF
# BunkerOS Adaptive Scaling Profile
# Generated: $(date)
# Device Type: $device_type

DEVICE_TYPE="$device_type"
WAYLAND_SCALE="$scale"
FOOT_FONT_SIZE="$foot_font"
WAYBAR_FONT_SIZE="$waybar_font"
WOFI_FONT_SIZE="$wofi_font"
PROFILE_VERSION="1.0"
EOF
    
    echo "   ${SUCCESS}Saved scaling profile: $profile_dir/scaling-profile.conf"
}

# Function to show restart instructions
show_restart_instructions() {
    echo ""
    echo "Restart Instructions:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "To apply all changes, you need to restart components:"
    echo ""
    echo "1. ${BOLD}Reload Sway configuration:${NC}"
    echo "   Super+Shift+R  (or run: swaymsg reload)"
    echo ""
    echo "2. ${BOLD}Restart Waybar:${NC}"
    echo "   pkill waybar && waybar &"
    echo ""
    echo "3. ${BOLD}Close and reopen terminals${NC} to see font changes"
    echo ""
    echo "4. ${BOLD}Alternative: Log out and back in${NC} for all changes"
    echo ""
}

# Parse command line arguments
AUTO_DETECT=true
MANUAL_SCALE=""
MANUAL_FONTS=""
INTERACTIVE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --manual-scale)
            MANUAL_SCALE="$2"
            AUTO_DETECT=false
            shift 2
            ;;
        --foot-font)
            FOOT_FONT="$2"
            shift 2
            ;;
        --waybar-font)
            WAYBAR_FONT="$2"
            shift 2
            ;;
        --wofi-font)
            WOFI_FONT="$2"
            shift 2
            ;;
        --interactive|-i)
            INTERACTIVE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --manual-scale SCALE    Set manual Wayland scaling (e.g., 1.5)"
            echo "  --foot-font SIZE        Set foot terminal font size"
            echo "  --waybar-font SIZE      Set Waybar font size"
            echo "  --wofi-font SIZE        Set Wofi font size"
            echo "  --interactive, -i       Interactive configuration mode"
            echo "  --help, -h              Show this help"
            echo ""
            echo "Examples:"
            echo "  $0                                    # Auto-detect and configure"
            echo "  $0 --manual-scale 1.5                # Force 1.5x scaling"
            echo "  $0 --foot-font 12 --waybar-font 16   # Manual font sizes"
            echo "  $0 --interactive                      # Interactive mode"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Interactive mode
if [ "$INTERACTIVE" = true ]; then
    echo "${INFO}Interactive configuration mode"
    echo ""
    
    # Run detection first to show current settings
    if [ -f "$PROJECT_DIR/scripts/detect-display-hardware.sh" ]; then
        echo "Current hardware detection:"
        "$PROJECT_DIR/scripts/detect-display-hardware.sh"
        echo ""
    fi
    
    echo "Enter custom values (press Enter to skip):"
    echo ""
    
    read -p "Wayland scaling factor (e.g., 1.0, 1.25, 1.5, 2.0): " user_scale
    read -p "Foot terminal font size (e.g., 8, 10, 12): " user_foot
    read -p "Waybar font size (e.g., 13, 14, 16): " user_waybar
    read -p "Wofi font size (e.g., 14, 15, 16): " user_wofi
    
    # Use user inputs if provided
    [ -n "$user_scale" ] && MANUAL_SCALE="$user_scale" && AUTO_DETECT=false
    [ -n "$user_foot" ] && FOOT_FONT="$user_foot"
    [ -n "$user_waybar" ] && WAYBAR_FONT="$user_waybar"
    [ -n "$user_wofi" ] && WOFI_FONT="$user_wofi"
    
    echo ""
fi

# Get configuration values
if [ "$AUTO_DETECT" = true ]; then
    echo "${INFO}Auto-detecting display hardware..."
    
    # Run hardware detection
    if [ -f "$PROJECT_DIR/scripts/detect-display-hardware.sh" ]; then
        detection_output=$("$PROJECT_DIR/scripts/detect-display-hardware.sh" --config-vars)
        eval "$detection_output"
        
        SCALE="$DISPLAY_SCALE"
        FOOT_FONT="${FOOT_FONT:-$FOOT_FONT_SIZE}"
        WAYBAR_FONT="${WAYBAR_FONT:-$WAYBAR_FONT_SIZE}"
        WOFI_FONT="${WOFI_FONT:-$WOFI_FONT_SIZE}"
        DEVICE_TYPE="$DEVICE_TYPE"
        
        echo "${SUCCESS}Detected configuration:"
        echo "   Device type: $DEVICE_TYPE"
        echo "   Wayland scale: $SCALE"
        echo "   Foot font: $FOOT_FONT"
        echo "   Waybar font: $WAYBAR_FONT"
        echo "   Wofi font: $WOFI_FONT"
    else
        echo "${ERROR}Hardware detection script not found"
        echo "      Using default values..."
        SCALE="1.0"
        FOOT_FONT="10"
        WAYBAR_FONT="14"
        WOFI_FONT="15"
        DEVICE_TYPE="unknown"
    fi
else
    echo "${INFO}Using manual configuration..."
    SCALE="$MANUAL_SCALE"
    FOOT_FONT="${FOOT_FONT:-10}"
    WAYBAR_FONT="${WAYBAR_FONT:-14}"
    WOFI_FONT="${WOFI_FONT:-15}"
    DEVICE_TYPE="manual"
    
    echo "${SUCCESS}Manual configuration:"
    echo "   Wayland scale: $SCALE"
    echo "   Foot font: $FOOT_FONT"
    echo "   Waybar font: $WAYBAR_FONT"
    echo "   Wofi font: $WOFI_FONT"
fi

echo ""
echo "Applying configuration changes..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo "${INFO}Backup directory: $BACKUP_DIR"
echo ""

# Apply configurations
if [ -n "$SCALE" ] && [ "$SCALE" != "1.0" ]; then
    apply_wayland_scaling "$SCALE"
    echo ""
fi

update_foot_config "$FOOT_FONT"
echo ""

update_waybar_config "$WAYBAR_FONT"
echo ""

update_wofi_config "$WOFI_FONT"
echo ""

# Save profile
save_scaling_profile "$DEVICE_TYPE" "$SCALE" "$FOOT_FONT" "$WAYBAR_FONT" "$WOFI_FONT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "${SUCCESS}Configuration applied successfully!"

show_restart_instructions

# Offer to restart components immediately
echo "Would you like to restart components now? (y/N): "
read -r restart_choice

if [[ "$restart_choice" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Restarting components..."
    
    # Restart Waybar
    if pgrep waybar >/dev/null; then
        pkill waybar
        sleep 1
        waybar -b bar-0 >/dev/null 2>&1 &
        echo "${SUCCESS}Waybar restarted"
    fi
    
    # Reload Sway config if in Sway session
    if [ -n "$SWAYSOCK" ]; then
        swaymsg reload >/dev/null 2>&1
        echo "${SUCCESS}Sway configuration reloaded"
    fi
    
    echo ""
    echo "${SUCCESS}Components restarted! Changes should now be visible."
    echo "   Open a new terminal to see font size changes."
else
    echo ""
    echo "${INFO}Configuration saved. Restart components when ready."
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "BunkerOS adaptive scaling configuration complete!"
echo ""
echo "💡 Tips:"
echo "   • Run this script again anytime to adjust settings"
echo "   • Use '--interactive' mode for fine-tuning"
echo "   • Backups are saved in: $BACKUP_DIR"
echo "═══════════════════════════════════════════════════════════════"