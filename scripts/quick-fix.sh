#!/usr/bin/env bash
# BunkerOS Quick Fix Script
#
# This script automatically fixes the most common installation issues
# Run this if you're experiencing problems after installation

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║          BunkerOS Quick Fix                                ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo "This script will fix common installation issues:"
echo "  • Environment.d symlink issue (atomic operation errors)"
echo "  • Missing SDDM session files"
echo "  • Disabled user services"
echo "  • Configuration file issues"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. Fixing environment.d file (atomic operation error fix)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -L "$HOME/.config/environment.d/10-bunkeros-wayland.conf" ]; then
    echo "  ⚠️  Found symlinked environment.d file (this causes atomic operation errors)"
    rm "$HOME/.config/environment.d/10-bunkeros-wayland.conf"
    cp "$PROJECT_DIR/environment.d/10-bunkeros-wayland.conf" "$HOME/.config/environment.d/"
    echo "  ✅ Fixed: environment.d file now copied (not symlinked)"
elif [ ! -f "$HOME/.config/environment.d/10-bunkeros-wayland.conf" ]; then
    echo "  ⚠️  Environment.d file missing"
    mkdir -p "$HOME/.config/environment.d"
    cp "$PROJECT_DIR/environment.d/10-bunkeros-wayland.conf" "$HOME/.config/environment.d/"
    echo "  ✅ Created: environment.d file"
else
    echo "  ✅ Environment.d file is already correct"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2. Installing SDDM theme and session files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ ! -f /usr/share/wayland-sessions/bunkeros.desktop ]; then
    echo "  ⚠️  BunkerOS session file missing"
    cd "$PROJECT_DIR/sddm"
    if sudo ./install-theme.sh; then
        echo "  ✅ Installed: SDDM theme and sessions"
    else
        echo "  ❌ Failed to install SDDM theme (non-critical)"
    fi
else
    echo "  ✅ SDDM session files already installed"
    # Still update launch scripts in case they changed
    echo "  Updating launch scripts..."
    sudo cp "$PROJECT_DIR/scripts/launch-bunkeros.sh" /usr/local/bin/
    sudo chmod +x /usr/local/bin/launch-bunkeros.sh
    sudo cp "$PROJECT_DIR/scripts/launch-bunkeros-emergency.sh" /usr/local/bin/
    sudo chmod +x /usr/local/bin/launch-bunkeros-emergency.sh
    echo "  ✅ Launch scripts updated"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3. Enabling user services"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# PipeWire services
for service in pipewire.service pipewire-pulse.service wireplumber.service; do
    if ! systemctl --user is-enabled "$service" &>/dev/null; then
        echo "  Enabling $service..."
        systemctl --user enable "$service" || echo "  ⚠️  Failed to enable $service (will try on login)"
        echo "  ✅ $service enabled"
    else
        echo "  ✅ $service already enabled"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4. Checking configuration files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ ! -f "$HOME/.config/sway/config" ]; then
    echo "  ⚠️  Sway config missing - running setup.sh"
    cd "$PROJECT_DIR"
    ./setup.sh
    echo "  ✅ Configuration installed"
else
    echo "  ✅ Sway config exists"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "5. Validating Sway configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "  Validating Sway config..."
echo "  ℹ️  Note: DRM/HDMI/atomic errors are normal when not in a graphical session"
echo ""

VALIDATION_OUTPUT=$(sway --validate 2>&1)
SYNTAX_ERRORS=$(echo "$VALIDATION_OUTPUT" | grep -i "error" | grep -v "permission denied\|atomic\|HDMI\|DRM\|connector\|Failed to open")

if [ -z "$SYNTAX_ERRORS" ]; then
    echo "  ✅ Sway configuration is valid"
else
    echo "  ❌ Sway configuration has errors:"
    echo "$SYNTAX_ERRORS" | head -10
    echo ""
    echo "  Please fix these errors before logging in."
    echo "  Config file: ~/.config/sway/config"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "6. Checking SDDM service"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if systemctl is-enabled sddm.service &>/dev/null; then
    echo "  ✅ SDDM service is enabled"
else
    echo "  ⚠️  SDDM service not enabled"
    read -p "  Enable SDDM? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo systemctl enable sddm.service
        echo "  ✅ SDDM enabled"
    fi
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║          Quick Fix Complete!                               ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo ""
echo "  1. Run full validation:"
echo "     $PROJECT_DIR/scripts/validate-installation.sh"
echo ""
echo "  2. Log out and log back in"
echo ""
echo "  3. Select 'BunkerOS' at the login screen"
echo ""
echo "If you still have issues:"
echo "  • Use 'BunkerOS Emergency' session for recovery"
echo "  • Check logs: /tmp/bunkeros-launch.log"
echo "  • See: TROUBLESHOOTING-INSTALLATION.md"
echo ""
