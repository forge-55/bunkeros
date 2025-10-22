#!/usr/bin/env bash
# BunkerOS Standard Edition Launcher
# Launches Sway/SwayFX without visual effects

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

EFFECTS_FILE="$HOME/.config/sway/config.d/swayfx-effects.conf"

if [ -f "$EFFECTS_FILE" ] || [ -L "$EFFECTS_FILE" ]; then
    rm -f "$EFFECTS_FILE"
fi

touch "$EFFECTS_FILE"

if command -v sway &> /dev/null; then
    exec sway "$@"
else
    echo "Error: sway/swayfx not found in PATH"
    exit 1
fi

