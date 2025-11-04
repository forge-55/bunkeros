#!/usr/bin/env bash

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== BunkerOS User Environment Configuration ==="
echo ""

# Add user to input group for SwayOSD
echo "Configuring user groups..."
if ! groups | grep -q '\binput\b'; then
    echo "  Adding user to 'input' group (required for SwayOSD)..."
    if sudo usermod -a -G input "$USER" 2>/dev/null; then
        echo "  ✓ User added to input group"
        echo "  ⚠ You'll need to log out and back in for group changes to take effect"
    else
        echo "  ⚠ Failed to add user to input group (SwayOSD may not work)"
    fi
else
    echo "  ✓ User already in input group"
fi
echo ""

# PipeWire services
echo "Enabling PipeWire audio services..."
echo ""

if ! systemctl --user is-enabled pipewire.service >/dev/null 2>&1; then
    if systemctl --user enable pipewire.service >/dev/null 2>&1; then
        echo "  ✓ PipeWire service enabled"
    else
        echo "  ⚠ Failed to enable PipeWire service (will retry on login)"
    fi
else
    echo "  ✓ PipeWire already enabled"
fi

if ! systemctl --user is-enabled pipewire-pulse.service >/dev/null 2>&1; then
    if systemctl --user enable pipewire-pulse.service >/dev/null 2>&1; then
        echo "  ✓ PipeWire PulseAudio replacement enabled"
    else
        echo "  ⚠ Failed to enable PipeWire PulseAudio (will retry on login)"
    fi
else
    echo "  ✓ PipeWire PulseAudio already enabled"
fi

if ! systemctl --user is-enabled wireplumber.service >/dev/null 2>&1; then
    if systemctl --user enable wireplumber.service >/dev/null 2>&1; then
        echo "  ✓ WirePlumber session manager enabled"
    else
        echo "  ⚠ Failed to enable WirePlumber (will retry on login)"
    fi
else
    echo "  ✓ WirePlumber already enabled"
fi

echo ""
echo "Configuring browsers for Wayland screen sharing..."
if [ -x "$PROJECT_DIR/scripts/configure-browser-wayland.sh" ]; then
    "$PROJECT_DIR/scripts/configure-browser-wayland.sh"
else
    echo "  ⚠ Browser configuration script not found (non-critical)"
fi

echo ""
echo "Configuring dark theme for GTK applications..."
if command -v gsettings &> /dev/null; then
    if gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null; then
        echo "  ✓ Dark theme preference set"
    else
        echo "  ⚠ Could not set dark theme (non-critical)"
    fi
else
    echo "  ⚠ gsettings not available, skipping theme preference"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ User environment configured successfully"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
