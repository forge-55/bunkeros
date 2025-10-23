#!/usr/bin/env bash
# BunkerOS Launcher
# Launches vanilla Sway

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

# Find the BunkerOS directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run auto-scaling on first login (or when user hasn't disabled it)
if [ -x "$SCRIPT_DIR/auto-scaling-service-v2.sh" ]; then
    "$SCRIPT_DIR/auto-scaling-service-v2.sh" &
fi

# Check for sway installation
if ! command -v sway &> /dev/null; then
    # Log to a file that user can check
    LOG_FILE="/tmp/bunkeros-launch-error.log"
    echo "ERROR: sway not found in PATH" > "$LOG_FILE"
    echo "Installation check:" >> "$LOG_FILE"
    echo "PATH=$PATH" >> "$LOG_FILE"
    pacman -Q sway >> "$LOG_FILE" 2>&1
    
    # Try to show error to user
    if command -v zenity &> /dev/null; then
        zenity --error --text="Sway not found!\n\nPlease install: sudo pacman -S sway\n\nSee /tmp/bunkeros-launch-error.log for details" --width=400
    fi
    
    exit 1
fi

# Launch Sway
exec sway "$@"

