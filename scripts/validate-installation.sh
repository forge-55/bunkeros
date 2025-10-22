#!/usr/bin/env bash
# BunkerOS Installation Validation Script
#
# This script checks if BunkerOS is properly installed and configured.
# Run this after installation to verify everything is working correctly.

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║          BunkerOS Installation Validator                   ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

PASS="✅"
FAIL="❌"
WARN="⚠️ "
INFO="ℹ️ "

# Track issues
ISSUES=0
WARNINGS=0

# Function to check and report
check() {
    local description="$1"
    local command="$2"
    local is_warning="${3:-false}"
    
    echo -n "Checking $description... "
    
    if eval "$command" &>/dev/null; then
        echo "$PASS"
        return 0
    else
        if [ "$is_warning" = "true" ]; then
            echo "$WARN"
            ((WARNINGS++))
        else
            echo "$FAIL"
            ((ISSUES++))
        fi
        return 1
    fi
}

echo "═══════════════════════════════════════════════════════════════"
echo "1. Core Packages"
echo "═══════════════════════════════════════════════════════════════"
echo ""

check "Sway/SwayFX installed" "command -v sway"
check "Waybar installed" "command -v waybar"
check "Wofi installed" "command -v wofi"
check "Foot terminal installed" "command -v foot"
check "SDDM installed" "command -v sddm"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "2. Desktop Portal Support"
echo "═══════════════════════════════════════════════════════════════"
echo ""

check "xdg-desktop-portal" "pacman -Q xdg-desktop-portal"
check "xdg-desktop-portal-wlr" "pacman -Q xdg-desktop-portal-wlr"
check "xdg-desktop-portal-gtk" "pacman -Q xdg-desktop-portal-gtk"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "3. Configuration Files"
echo "═══════════════════════════════════════════════════════════════"
echo ""

check "Sway config exists" "test -f ~/.config/sway/config"
check "Waybar config exists" "test -f ~/.config/waybar/config"
check "Wofi config exists" "test -f ~/.config/wofi/config"
check "Foot config exists" "test -f ~/.config/foot/foot.ini"
check "Environment.d config exists" "test -f ~/.config/environment.d/10-bunkeros-wayland.conf"
check "Desktop portal config exists" "test -f ~/.config/xdg-desktop-portal/portals.conf"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "4. SDDM Configuration"
echo "═══════════════════════════════════════════════════════════════"
echo ""

check "SDDM service enabled" "systemctl is-enabled sddm.service"
check "BunkerOS Standard session file" "test -f /usr/share/wayland-sessions/bunkeros-standard.desktop"
check "BunkerOS Enhanced session file" "test -f /usr/share/wayland-sessions/bunkeros-enhanced.desktop"
check "Launch script (Standard) in /usr/local/bin" "test -f /usr/local/bin/launch-bunkeros-standard.sh"
check "Launch script (Enhanced) in /usr/local/bin" "test -f /usr/local/bin/launch-bunkeros-enhanced.sh"
check "Launch scripts are executable" "test -x /usr/local/bin/launch-bunkeros-standard.sh && test -x /usr/local/bin/launch-bunkeros-enhanced.sh"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "5. Environment Variables (if in Sway session)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

if [ -n "$WAYLAND_DISPLAY" ]; then
    check "WAYLAND_DISPLAY set" "test -n \"$WAYLAND_DISPLAY\""
    check "XDG_CURRENT_DESKTOP set" "test -n \"$XDG_CURRENT_DESKTOP\""
    check "XDG_SESSION_TYPE is wayland" "[ \"$XDG_SESSION_TYPE\" = \"wayland\" ]"
    check "ELECTRON_OZONE_PLATFORM_HINT set" "test -n \"$ELECTRON_OZONE_PLATFORM_HINT\"" "true"
    
    echo ""
    echo "${INFO}Current environment:"
    echo "  WAYLAND_DISPLAY: $WAYLAND_DISPLAY"
    echo "  XDG_CURRENT_DESKTOP: $XDG_CURRENT_DESKTOP"
    echo "  XDG_SESSION_TYPE: $XDG_SESSION_TYPE"
    echo "  ELECTRON_OZONE_PLATFORM_HINT: $ELECTRON_OZONE_PLATFORM_HINT"
else
    echo "${INFO}Not running in Wayland session - environment checks skipped"
    echo "   (This is normal if you're in TTY or X11)"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "6. Audio System"
echo "═══════════════════════════════════════════════════════════════"
echo ""

check "PipeWire installed" "pacman -Q pipewire"
check "PipeWire-Pulse installed" "pacman -Q pipewire-pulse"
check "WirePlumber installed" "pacman -Q wireplumber"

if [ -n "$WAYLAND_DISPLAY" ]; then
    check "PipeWire service running" "systemctl --user is-active pipewire" "true"
    check "PipeWire-Pulse service running" "systemctl --user is-active pipewire-pulse" "true"
    check "WirePlumber service running" "systemctl --user is-active wireplumber" "true"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "7. BunkerOS Project"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Try to find BunkerOS directory
BUNKEROS_DIR=""
if [ -d "$HOME/Projects/bunkeros" ]; then
    BUNKEROS_DIR="$HOME/Projects/bunkeros"
elif [ -d "$HOME/bunkeros" ]; then
    BUNKEROS_DIR="$HOME/bunkeros"
elif [ -d "/opt/bunkeros" ]; then
    BUNKEROS_DIR="/opt/bunkeros"
fi

if [ -n "$BUNKEROS_DIR" ]; then
    echo "${PASS} BunkerOS directory found: $BUNKEROS_DIR"
    check "BunkerOS git repo" "test -d \"$BUNKEROS_DIR/.git\""
else
    echo "${WARN} BunkerOS directory not found in standard locations"
    echo "   Searched: ~/Projects/bunkeros, ~/bunkeros, /opt/bunkeros"
    ((WARNINGS++))
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "8. Optional: Electron Apps"
echo "═══════════════════════════════════════════════════════════════"
echo ""

check "VS Code installed" "command -v code" "true"
check "Cursor installed" "command -v cursor" "true"
check "Discord installed" "command -v discord" "true"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    Validation Summary                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

if [ $ISSUES -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "${PASS} All checks passed! BunkerOS is properly installed."
    echo ""
    echo "Next steps:"
    echo "  1. Reboot: sudo reboot"
    echo "  2. At login screen, select a BunkerOS session"
    echo "  3. Enjoy your productivity environment!"
    exit 0
elif [ $ISSUES -eq 0 ]; then
    echo "${WARN} $WARNINGS warning(s) found, but installation looks good."
    echo ""
    echo "The warnings are typically for optional components."
    echo "You can proceed with using BunkerOS."
    exit 0
else
    echo "${FAIL} $ISSUES critical issue(s) found!"
    if [ $WARNINGS -gt 0 ]; then
        echo "${WARN} $WARNINGS warning(s) found."
    fi
    echo ""
    echo "Recommended actions:"
    echo "  1. Review the failed checks above"
    echo "  2. Re-run: cd ~/Projects/bunkeros && ./install.sh"
    echo "  3. Check TROUBLESHOOTING.md for specific issues"
    echo "  4. Run this validation script again"
    exit 1
fi
