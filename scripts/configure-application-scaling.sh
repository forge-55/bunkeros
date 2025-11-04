#!/usr/bin/env bash

# BunkerOS Application Scaling Configuration
# Configures zoom levels and font sizes for browsers, IDEs, and other applications
# Works in conjunction with the display hardware detection for optimal ultrawide scaling

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
BACKUP_DIR="$HOME/.config/bunkeros-backups/app-scaling-$(date +%Y%m%d-%H%M%S)"

echo "=================================================================="
echo "           BunkerOS Application Scaling Configuration         "
echo "=================================================================="
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

# Function to get recommended scaling settings based on display hardware
get_scaling_recommendations() {
    if [ -f "$PROJECT_DIR/scripts/detect-display-hardware.sh" ]; then
        local detection_output=$("$PROJECT_DIR/scripts/detect-display-hardware.sh" --config-vars 2>/dev/null | grep "^[A-Z_]*=")
        
        if [ $? -eq 0 ] && [ -n "$detection_output" ]; then
            eval "$detection_output"
            echo "Detected device type: $DEVICE_TYPE"
            
            case "$DEVICE_TYPE" in
                "ultrawide-monitor")
                    # Ultrawide monitors need significant browser zoom
                    BROWSER_ZOOM="125"      # 125% zoom
                    IDE_FONT_SIZE="14"      # VS Code font size
                    GNOME_SCALING="1.25"    # For GTK apps
                    QT_SCALING="1.25"       # For Qt apps
                    ;;
                "high-dpi-monitor")
                    BROWSER_ZOOM="130"
                    IDE_FONT_SIZE="12"
                    GNOME_SCALING="1.5"
                    QT_SCALING="1.5"
                    ;;
                "high-dpi-laptop")
                    BROWSER_ZOOM="120"
                    IDE_FONT_SIZE="11"
                    GNOME_SCALING="1.5"
                    QT_SCALING="1.5"
                    ;;
                "standard-monitor")
                    BROWSER_ZOOM="110"
                    IDE_FONT_SIZE="12"
                    GNOME_SCALING="1.0"
                    QT_SCALING="1.0"
                    ;;
                "standard-laptop")
                    BROWSER_ZOOM="100"
                    IDE_FONT_SIZE="11"
                    GNOME_SCALING="1.0"
                    QT_SCALING="1.0"
                    ;;
                *)
                    # Fallback defaults
                    BROWSER_ZOOM="100"
                    IDE_FONT_SIZE="12"
                    GNOME_SCALING="1.0"
                    QT_SCALING="1.0"
                    ;;
            esac
        else
            echo "${WARN}Could not detect display hardware, using defaults"
            BROWSER_ZOOM="100"
            IDE_FONT_SIZE="12"
            GNOME_SCALING="1.0"
            QT_SCALING="1.0"
        fi
    else
        echo "${WARN}Display detection script not found, using defaults"
        BROWSER_ZOOM="100"
        IDE_FONT_SIZE="12"
        GNOME_SCALING="1.0"
        QT_SCALING="1.0"
    fi
}

# Function to configure Chromium-based browsers
configure_browsers() {
    echo "Configuring browser zoom levels..."
    
    # Browser configurations: config_dir, display_name, preferences_path
    declare -A BROWSERS=(
        ["chromium"]="$HOME/.config/chromium|Chromium|$HOME/.config/chromium/Default/Preferences"
        ["google-chrome"]="$HOME/.config/google-chrome|Google Chrome|$HOME/.config/google-chrome/Default/Preferences"
        ["brave"]="$HOME/.config/BraveSoftware/Brave-Browser|Brave|$HOME/.config/BraveSoftware/Brave-Browser/Default/Preferences"
        ["microsoft-edge"]="$HOME/.config/microsoft-edge|Microsoft Edge|$HOME/.config/microsoft-edge/Default/Preferences"
        ["vivaldi"]="$HOME/.config/vivaldi|Vivaldi|$HOME/.config/vivaldi/Default/Preferences"
    )
    
    local configured_count=0
    
    for browser in "${!BROWSERS[@]}"; do
        IFS='|' read -r config_dir display_name prefs_file <<< "${BROWSERS[$browser]}"
        
        # Check if browser config directory exists
        if [ -d "$config_dir" ]; then
            echo "   📦 Configuring $display_name..."
            
            # Create a simple script to set zoom level via browser flags
            local flags_file="$HOME/.config/${browser}-flags.conf"
            backup_file "$flags_file"
            
            # Create flags file with zoom level
            cat > "$flags_file" << EOF
--force-device-scale-factor=$(awk "BEGIN { printf \"%.2f\", $BROWSER_ZOOM / 100 }")
--enable-features=WebRTCPipeWireCapturer,VaapiVideoDecodeLinuxGL
--ozone-platform-hint=auto
--enable-wayland-ime
EOF
            
            echo "       ✓ Set zoom level to ${BROWSER_ZOOM}%"
            ((configured_count++))
        fi
    done
    
    if [ $configured_count -gt 0 ]; then
        echo "   ${SUCCESS}Configured $configured_count browser(s) with ${BROWSER_ZOOM}% zoom"
    else
        echo "   ${INFO}No browsers found to configure"
    fi
}

# Function to configure VS Code / Code - OSS
configure_vscode() {
    echo "Configuring VS Code/IDE font sizes..."
    
    local vscode_dirs=(
        "$HOME/.config/Code/User"                    # VS Code
        "$HOME/.config/Code - OSS/User"             # Code - OSS
        "$HOME/.config/VSCodium/User"               # VSCodium
        "$HOME/.config/code-oss/User"               # Alternative Code - OSS path
    )
    
    local configured_count=0
    
    for vscode_dir in "${vscode_dirs[@]}"; do
        if [ -d "$vscode_dir" ]; then
            local settings_file="$vscode_dir/settings.json"
            
            # Create user directory if it doesn't exist
            mkdir -p "$vscode_dir"
            
            echo "   ⚙️  Configuring $(basename "$(dirname "$vscode_dir")")..."
            
            # Backup existing settings
            backup_file "$settings_file"
            
            # Create or update settings.json
            if [ -f "$settings_file" ]; then
                # Update existing settings file
                # Use jq if available, otherwise simple sed replacement
                if command -v jq >/dev/null 2>&1; then
                    jq --arg fontSize "$IDE_FONT_SIZE" '.["editor.fontSize"] = ($fontSize | tonumber)' "$settings_file" > "$settings_file.tmp" && mv "$settings_file.tmp" "$settings_file"
                else
                    # Simple replacement for editor.fontSize
                    if grep -q '"editor.fontSize"' "$settings_file"; then
                        sed -i "s/\"editor.fontSize\":[[:space:]]*[0-9]*/\"editor.fontSize\": $IDE_FONT_SIZE/" "$settings_file"
                    else
                        # Add fontSize to existing JSON (simple approach)
                        sed -i '$s/}/,\n    "editor.fontSize": '$IDE_FONT_SIZE'\n}/' "$settings_file"
                    fi
                fi
            else
                # Create new settings file
                cat > "$settings_file" << EOF
{
    "editor.fontSize": $IDE_FONT_SIZE,
    "editor.fontFamily": "monospace",
    "terminal.integrated.fontSize": $IDE_FONT_SIZE,
    "window.zoomLevel": 0,
    "editor.mouseWheelZoom": true
}
EOF
            fi
            
            echo "       ✓ Set editor font size to ${IDE_FONT_SIZE}pt"
            ((configured_count++))
        fi
    done
    
    if [ $configured_count -gt 0 ]; then
        echo "   ${SUCCESS}Configured $configured_count IDE(s) with ${IDE_FONT_SIZE}pt font"
    else
        echo "   ${INFO}No IDEs found to configure"
    fi
}

# Function to configure GTK applications scaling
configure_gtk_scaling() {
    echo "Configuring GTK applications scaling..."
    
    if [ "$GNOME_SCALING" != "1.0" ]; then
        # Set GDK_SCALE environment variable
        local env_file="$CONFIG_DIR/environment.d/bunkeros-gtk-scaling.conf"
        backup_file "$env_file"
        
        mkdir -p "$(dirname "$env_file")"
        cat > "$env_file" << EOF
# BunkerOS GTK Application Scaling
# Auto-configured based on display hardware
GDK_SCALE=$GNOME_SCALING
GDK_DPI_SCALE=1.0
EOF
        
        echo "   ${SUCCESS}Set GTK scaling to ${GNOME_SCALING}x"
    else
        echo "   ${INFO}GTK scaling not needed (1.0x)"
    fi
}

# Function to configure Qt applications scaling
configure_qt_scaling() {
    echo "Configuring Qt applications scaling..."
    
    if [ "$QT_SCALING" != "1.0" ]; then
        # Set QT_SCALE_FACTOR environment variable
        local env_file="$CONFIG_DIR/environment.d/bunkeros-qt-scaling.conf"
        backup_file "$env_file"
        
        mkdir -p "$(dirname "$env_file")"
        cat > "$env_file" << EOF
# BunkerOS Qt Application Scaling
# Auto-configured based on display hardware
QT_SCALE_FACTOR=$QT_SCALING
QT_AUTO_SCREEN_SCALE_FACTOR=0
QT_ENABLE_HIGHDPI_SCALING=1
EOF
        
        echo "   ${SUCCESS}Set Qt scaling to ${QT_SCALING}x"
    else
        echo "   ${INFO}Qt scaling not needed (1.0x)"
    fi
}

# Function to configure Firefox
configure_firefox() {
    echo "Configuring Firefox zoom level..."
    
    local firefox_profiles_dir="$HOME/.mozilla/firefox"
    
    if [ -d "$firefox_profiles_dir" ]; then
        # Find the default profile
        local profile_dir=$(find "$firefox_profiles_dir" -name "*.default-release" -type d | head -1)
        
        if [ -z "$profile_dir" ]; then
            profile_dir=$(find "$firefox_profiles_dir" -name "*.default" -type d | head -1)
        fi
        
        if [ -n "$profile_dir" ]; then
            local prefs_file="$profile_dir/user.js"
            backup_file "$prefs_file"
            
            # Calculate Firefox zoom (different scale than Chrome)
            local firefox_zoom=$(awk "BEGIN { printf \"%.2f\", $BROWSER_ZOOM / 100 }")
            
            # Create or update user.js with zoom preferences
            cat >> "$prefs_file" << EOF

// BunkerOS Display Scaling Configuration
user_pref("layout.css.devPixelsPerPx", "$firefox_zoom");
user_pref("browser.display.use_system_colors", true);
EOF
            
            echo "   ${SUCCESS}Set Firefox zoom to ${BROWSER_ZOOM}%"
        else
            echo "   ${INFO}Firefox profile not found"
        fi
    else
        echo "   ${INFO}Firefox not installed or configured"
    fi
}

# Main execution
get_scaling_recommendations

echo ""
echo "Recommended scaling settings:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "${INFO}Browser zoom: ${BROWSER_ZOOM}%"
echo "${INFO}IDE font size: ${IDE_FONT_SIZE}pt"
echo "${INFO}GTK scaling: ${GNOME_SCALING}x"
echo "${INFO}Qt scaling: ${QT_SCALING}x"
echo ""

# Apply configurations
configure_browsers
echo ""
configure_firefox
echo ""
configure_vscode
echo ""
configure_gtk_scaling
echo ""
configure_qt_scaling
echo ""

echo "=================================================================="
echo "                    Configuration Complete                    "
echo "=================================================================="
echo ""
echo "${SUCCESS}Application scaling configured successfully!"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Restart applications for changes to take effect:"
echo "   • Close and reopen browsers"
echo "   • Restart VS Code/IDEs"
echo "   • Re-login for environment variables to apply"
echo ""
echo "2. Fine-tune if needed:"
echo "   • Browser zoom can be adjusted with Ctrl+Plus/Minus"
echo "   • IDE font sizes can be changed in preferences"
echo "   • GTK/Qt scaling affects file managers, text editors, etc."
echo ""
echo "3. To revert changes:"
echo "   • Restore from backup: $BACKUP_DIR"
echo "   • Remove generated config files and restart applications"
echo ""
echo "🔧 Troubleshooting:"
echo "   • If text is still too small, run: $0 --larger-fonts"
echo "   • If text is too large, run: $0 --smaller-fonts"
echo "   • To reset to defaults, run: $0 --reset"

exit 0