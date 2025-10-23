#!/usr/bin/env bash
# BunkerOS Enhanced Edition Launcher
# Launches SwayFX with visual effects enabled

# Set up Wayland environment variables
# WAYLAND_DISPLAY is set by SDDM - don't override
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

# Run auto-scaling on first login (or when user hasn't disabled it)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -x "$SCRIPT_DIR/auto-scaling-service-v2.sh" ]; then
    "$SCRIPT_DIR/auto-scaling-service-v2.sh" &
fi

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

# Check for sway/swayfx installation
if ! command -v sway &> /dev/null; then
    # Log to a file that user can check
    LOG_FILE="/tmp/bunkeros-launch-error.log"
    echo "ERROR: sway/swayfx not found in PATH" > "$LOG_FILE"
    echo "Installation check:" >> "$LOG_FILE"
    echo "PATH=$PATH" >> "$LOG_FILE"
    pacman -Q swayfx >> "$LOG_FILE" 2>&1
    
    # Try to show error to user
    if command -v zenity &> /dev/null; then
        zenity --error --text="SwayFX not found!\n\nPlease install: yay -S swayfx\n\nSee /tmp/bunkeros-launch-error.log for details" --width=400
    fi
    
    exit 1
fi

# Launch Sway
exec sway "$@"
