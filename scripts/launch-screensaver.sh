#!/bin/bash
# BunkerOS Screensaver Launch Script - Ultra Reliable Version

# Path to screensaver command script
SCREENSAVER_CMD="$HOME/.config/sway-config/scripts/bunkeros-screensaver.sh"

# Fallback to repo location if symlink doesn't exist
if [[ ! -f "$SCREENSAVER_CMD" ]]; then
    SCREENSAVER_CMD="$HOME/Projects/bunkeros/scripts/bunkeros-screensaver.sh"
fi

# Final check
if [[ ! -f "$SCREENSAVER_CMD" ]]; then
    echo "Error: Screensaver command script not found"
    notify-send "BunkerOS Screensaver" "Error: Screensaver script not found" -u critical
    exit 1
fi

# Kill any existing instances
swaymsg "[app_id=BunkerOS-Screensaver]" kill 2>/dev/null
pkill -f "foot.*BunkerOS-Screensaver" 2>/dev/null

# Simple, reliable approach: just launch foot with a command that handles everything
foot --fullscreen --font="monospace:size=14" --app-id=BunkerOS-Screensaver -e bash -c '
    # Save original terminal settings
    ORIGINAL_STTY=$(stty -g)
    
    # Cleanup function that ALWAYS restores terminal
    cleanup() {
        # Restore terminal settings
        stty "$ORIGINAL_STTY" 2>/dev/null
        # Kill all child processes
        kill $(jobs -p) 2>/dev/null
        exit 0
    }
    
    # Set cleanup trap
    trap cleanup EXIT INT TERM HUP
    
    # Run screensaver in background
    '"$SCREENSAVER_CMD"' &
    SCREENSAVER_PID=$!
    
    # Set up for single key detection
    stty -echo -icanon min 1 time 0
    
    # Wait for ANY single character input
    read -n 1 -s
    
    # Kill screensaver and exit
    kill $SCREENSAVER_PID 2>/dev/null
    cleanup
'
