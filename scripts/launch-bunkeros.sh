#!/usr/bin/env bash
# BunkerOS Launcher
# Launches vanilla Sway with proper environment setup and validation

# Error logging
LOG_FILE="/tmp/bunkeros-launch.log"
exec 1> >(tee -a "$LOG_FILE")
exec 2>&1

echo "=== BunkerOS Launch $(date) ==="

# Preflight validation
echo "Running preflight checks..."

# Check if sway is installed
if ! command -v sway &> /dev/null; then
    echo "ERROR: sway not found in PATH"
    echo "PATH=$PATH"
    echo "Please install: sudo pacman -S sway"
    
    if command -v zenity &> /dev/null; then
        zenity --error --text="Sway not found!\n\nPlease install: sudo pacman -S sway\n\nSee $LOG_FILE for details" --width=400
    fi
    exit 1
fi

# Check if sway config exists
if [ ! -f "$HOME/.config/sway/config" ]; then
    echo "ERROR: Sway configuration not found at ~/.config/sway/config"
    echo "Please run the BunkerOS installer: ./install.sh"
    
    if command -v zenity &> /dev/null; then
        zenity --error --text="Sway configuration missing!\n\nPlease run: ./install.sh\n\nSee $LOG_FILE for details" --width=400
    fi
    exit 1
fi

# Validate sway config syntax
echo "Validating Sway configuration..."
if sway --validate 2>&1 | grep -qi "error"; then
    echo "ERROR: Sway configuration has syntax errors"
    echo "Please check ~/.config/sway/config"
    
    if command -v zenity &> /dev/null; then
        zenity --error --text="Sway configuration has errors!\n\nPlease check your config file\n\nSee $LOG_FILE for details" --width=400
    fi
    exit 1
else
    echo "✓ Sway configuration validated (warnings are normal)"
fi

echo "✓ Preflight checks passed"

# Set up Wayland environment variables
# Note: These are also set in ~/.config/environment.d/10-bunkeros-wayland.conf
# but we set them here as well for robustness
echo "Setting up environment..."

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

# Ensure XDG directories exist
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/applications"

# Find the BunkerOS directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run auto-scaling on first login (or when user hasn't disabled it)
if [ -x "$SCRIPT_DIR/auto-scaling-service-v2.sh" ]; then
    echo "Starting auto-scaling service..."
    "$SCRIPT_DIR/auto-scaling-service-v2.sh" &
fi

# Start user services if not already running
echo "Ensuring user services are running..."

# PipeWire audio
if ! systemctl --user is-active --quiet pipewire.service; then
    echo "Starting PipeWire..."
    systemctl --user start pipewire.service || echo "Warning: Failed to start PipeWire"
fi

if ! systemctl --user is-active --quiet pipewire-pulse.service; then
    echo "Starting PipeWire PulseAudio replacement..."
    systemctl --user start pipewire-pulse.service || echo "Warning: Failed to start PipeWire Pulse"
fi

if ! systemctl --user is-active --quiet wireplumber.service; then
    echo "Starting WirePlumber..."
    systemctl --user start wireplumber.service || echo "Warning: Failed to start WirePlumber"
fi

# Import environment into systemd user manager
echo "Importing environment to systemd..."
systemctl --user import-environment XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP
systemctl --user import-environment QT_QPA_PLATFORM MOZ_ENABLE_WAYLAND ELECTRON_OZONE_PLATFORM_HINT

echo "✓ Environment setup complete"
echo "Launching Sway..."

# Launch Sway
exec sway "$@"

