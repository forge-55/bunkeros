#!/usr/bin/env bash

# Smart close: If menus (wofi) are open, close them. Otherwise, close the focused window.

if pgrep wofi > /dev/null 2>&1; then
    # Menus are open - aggressively kill ALL instances
    
    # Get all wofi PIDs and kill them
    pkill -9 -x wofi 2>/dev/null
    killall -9 wofi 2>/dev/null
    
    # Wait a tiny moment and verify they're dead
    sleep 0.05
    
    # Kill any that survived (shouldn't happen but be thorough)
    while pgrep wofi > /dev/null 2>&1; do
        pkill -9 wofi 2>/dev/null
        killall -9 wofi 2>/dev/null
        sleep 0.02
    done
else
    # No menus open - close focused window normally
    swaymsg kill
fi

