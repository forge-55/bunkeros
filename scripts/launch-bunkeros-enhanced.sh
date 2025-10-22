#!/usr/bin/env bash
# BunkerOS Enhanced Edition Launcher
# Launches SwayFX with visual effects enabled

# Set up Wayland environment variables
export WAYLAND_DISPLAY=wayland-1
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=sway

# Qt Wayland support
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

# Mozilla/Firefox
export MOZ_ENABLE_WAYLAND=1

# SDL2
export SDL_VIDEODRIVER=wayland

# Clutter
export CLUTTER_BACKEND=wayland

# Electron apps (VS Code, Cursor, Discord, etc.)
export ELECTRON_OZONE_PLATFORM_HINT=auto

# Find the BunkerOS project directory
# Check common locations
if [ -d "$HOME/Projects/bunkeros" ]; then
    BUNKEROS_DIR="$HOME/Projects/bunkeros"
elif [ -d "$HOME/bunkeros" ]; then
    BUNKEROS_DIR="$HOME/bunkeros"
elif [ -d "/opt/bunkeros" ]; then
    BUNKEROS_DIR="/opt/bunkeros"
else
    # Fall back to trying to find it
    BUNKEROS_DIR=$(find "$HOME" -maxdepth 3 -type d -name "bunkeros" 2>/dev/null | head -1)
fi

if [ -z "$BUNKEROS_DIR" ]; then
    echo "Error: Could not find bunkeros directory"
    echo "Please ensure the BunkerOS repository is cloned"
    exit 1
fi

EFFECTS_SOURCE="$BUNKEROS_DIR/sway/config.d/swayfx-effects"
EFFECTS_FILE="$HOME/.config/sway/config.d/swayfx-effects.conf"

rm -f "$EFFECTS_FILE"

ln -sf "$EFFECTS_SOURCE" "$EFFECTS_FILE"

if command -v sway &> /dev/null; then
    exec sway "$@"
else
    echo "Error: sway/swayfx not found in PATH"
    exit 1
fi

