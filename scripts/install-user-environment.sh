#!/usr/bin/env bash

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== BunkerOS User Environment Configuration ==="
echo ""

# PipeWire services
echo "Enabling PipeWire audio services..."
echo ""

if ! systemctl --user is-enabled pipewire.service >/dev/null 2>&1; then
    systemctl --user enable --now pipewire.service >/dev/null 2>&1 || true
    echo "  ✓ PipeWire service enabled"
else
    echo "  ✓ PipeWire already enabled"
fi

if ! systemctl --user is-enabled pipewire-pulse.service >/dev/null 2>&1; then
    systemctl --user enable --now pipewire-pulse.service >/dev/null 2>&1 || true
    echo "  ✓ PipeWire PulseAudio replacement enabled"
else
    echo "  ✓ PipeWire PulseAudio already enabled"
fi

if ! systemctl --user is-enabled wireplumber.service >/dev/null 2>&1; then
    systemctl --user enable --now wireplumber.service >/dev/null 2>&1 || true
    echo "  ✓ WirePlumber session manager enabled"
else
    echo "  ✓ WirePlumber already enabled"
fi

echo ""
echo "Configuring browsers for Wayland screen sharing..."
"$PROJECT_DIR/scripts/configure-browser-wayland.sh"

echo ""
echo "Configuring dark theme for GTK applications..."
if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
    echo "  ✓ Dark theme preference set"
else
    echo "  ⚠ gsettings not available, skipping theme preference"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ User environment configured successfully"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
