#!/usr/bin/env bash
#
# BunkerOS Browser Wayland Configuration
#
# Automatically configures Chromium-based browsers for optimal Wayland support,
# including screen sharing for video conferencing (Zoom, Teams, Meet, etc.)
#
# This script creates browser-specific flag files that enable:
# - Native Wayland rendering (better performance)
# - PipeWire screen capture (required for screen sharing)
# - Hardware video decode acceleration
#
# Supported browsers: Chromium, Google Chrome, Brave, Microsoft Edge, Vivaldi

set -e

echo "=== BunkerOS Browser Wayland Configuration ==="
echo ""

# Wayland flags for optimal performance and screen sharing
WAYLAND_FLAGS="--enable-features=WebRTCPipeWireCapturer,VaapiVideoDecodeLinuxGL
--ozone-platform-hint=auto
--enable-wayland-ime"

# Browser configurations: config_dir, display_name
declare -A BROWSERS=(
    ["chromium"]="$HOME/.config/chromium-flags.conf|Chromium"
    ["chrome"]="$HOME/.config/chrome-flags.conf|Google Chrome"
    ["brave"]="$HOME/.config/brave-flags.conf|Brave"
    ["edge"]="$HOME/.config/microsoft-edge-flags.conf|Microsoft Edge"
    ["vivaldi"]="$HOME/.config/vivaldi-flags.conf|Vivaldi"
)

CONFIGURED_COUNT=0

for browser in "${!BROWSERS[@]}"; do
    IFS='|' read -r config_file display_name <<< "${BROWSERS[$browser]}"
    
    # Check if browser is installed
    if command -v "$browser" &> /dev/null || [ -d "$HOME/.config/${browser}" ]; then
        echo "📦 Configuring $display_name..."
        
        # Create config directory if needed
        mkdir -p "$(dirname "$config_file")"
        
        # Check if already configured
        if [ -f "$config_file" ] && grep -q "WebRTCPipeWireCapturer" "$config_file" 2>/dev/null; then
            echo "   ✓ Already configured"
        else
            # Backup existing config
            if [ -f "$config_file" ]; then
                backup="$config_file.backup.$(date +%Y%m%d-%H%M%S)"
                cp "$config_file" "$backup"
                echo "   ℹ Backed up existing config to: $(basename "$backup")"
            fi
            
            # Write Wayland flags
            echo "$WAYLAND_FLAGS" > "$config_file"
            echo "   ✓ Wayland flags configured"
            ((CONFIGURED_COUNT++))
        fi
        echo ""
    fi
done

echo ""

if [ $CONFIGURED_COUNT -eq 0 ]; then
    echo "ℹ No browsers were newly configured (either not installed or already configured)"
    echo ""
    echo "Supported browsers:"
    echo "  • Chromium - Install: sudo pacman -S chromium"
    echo "  • Google Chrome - Install: yay -S google-chrome"
    echo "  • Brave - Install: yay -S brave-bin"
    echo "  • Microsoft Edge - Install: yay -S microsoft-edge-stable-bin"
    echo "  • Vivaldi - Install: yay -S vivaldi"
else
    echo "✅ Configured $CONFIGURED_COUNT browser(s) for Wayland screen sharing"
    echo ""
    echo "Changes applied:"
    echo "  • WebRTCPipeWireCapturer - Enables PipeWire screen capture"
    echo "  • Ozone auto platform - Uses native Wayland when available"
    echo "  • VaapiVideoDecodeLinuxGL - Hardware video acceleration"
    echo "  • Wayland IME - Better input method support"
fi

echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Restart your browser(s) for changes to take effect"
echo "2. Test screen sharing:"
echo "   • Join a video call (Google Meet, Zoom web, Teams web, etc.)"
echo "   • Click 'Share screen' or 'Present'"
echo "   • You should see a screen picker dialog"
echo ""
echo "3. If screen sharing doesn't work:"
echo "   • Verify PipeWire is running: systemctl --user status pipewire"
echo "   • Check portal: systemctl --user status xdg-desktop-portal"
echo "   • See VIDEOCONFERENCING.md for troubleshooting"
echo ""
echo "🎥 Video conferencing apps that work:"
echo "   • Google Meet (web)"
echo "   • Zoom (web or native app)"
echo "   • Microsoft Teams (web)"
echo "   • Slack calls (web)"
echo "   • Discord (native app or web)"
echo "   • Jitsi Meet (web)"
echo ""

exit 0
