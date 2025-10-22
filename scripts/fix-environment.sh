#!/usr/bin/env bash

# BunkerOS Environment Fix Script
# Fixes environment variables and services for current session
# Run this after installation if you don't want to log out/in

set -e

echo "=== BunkerOS Environment Fix ==="
echo ""

# Set critical environment variables for current session
echo "Setting environment variables for current session..."
export ELECTRON_OZONE_PLATFORM_HINT=auto
export QT_QPA_PLATFORM=wayland
export MOZ_ENABLE_WAYLAND=1
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
export XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP:-sway}"
export XDG_SESSION_TYPE="${XDG_SESSION_TYPE:-wayland}"

echo "✓ Environment variables set"

# Restart key BunkerOS processes with new environment
echo ""
echo "Restarting BunkerOS processes..."

# Stop existing processes
pkill waybar 2>/dev/null || true
pkill mako 2>/dev/null || true
pkill autotiling-rs 2>/dev/null || true
pkill nm-applet 2>/dev/null || true

sleep 1

# Restart with proper environment
waybar &>/dev/null &
echo "✓ Waybar restarted"

mako &>/dev/null &
echo "✓ Mako restarted"

autotiling-rs &>/dev/null &
echo "✓ Autotiling restarted"

nm-applet &>/dev/null &
echo "✓ Network manager applet restarted"

# Apply current theme
echo ""
echo "Applying BunkerOS theme..."
if [ -f "$HOME/.local/bin/theme-switcher.sh" ]; then
    "$HOME/.local/bin/theme-switcher.sh" tactical &>/dev/null || true
    echo "✓ Theme applied"
else
    echo "⚠ Theme switcher not found - will be available after restart"
fi

# Reload sway configuration
echo ""
echo "Reloading Sway configuration..."
swaymsg reload &>/dev/null || true
echo "✓ Sway configuration reloaded"

echo ""
echo "=== Environment Fix Complete ==="
echo ""
echo "BunkerOS environment is now active in current session!"
echo ""
echo "For full environment, log out and select a BunkerOS session."