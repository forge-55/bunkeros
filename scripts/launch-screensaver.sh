#!/bin/bash
# BunkerOS Screensaver Launch Script

# Path to screensaver command script
SCREENSAVER_CMD="$HOME/.config/sway-config/scripts/bunkeros-screensaver.sh"

# Fallback to repo location if symlink doesn't exist
if [[ ! -f "$SCREENSAVER_CMD" ]]; then
    SCREENSAVER_CMD="$HOME/Projects/bunkeros/scripts/bunkeros-screensaver.sh"
fi

# Final check
if [[ ! -f "$SCREENSAVER_CMD" ]]; then
    echo "Error: Screensaver command script not found" >&2
    notify-send "BunkerOS Screensaver" "Error: Screensaver script not found" -u critical
    exit 1
fi

# Kill any existing instances
swaymsg "[app_id=BunkerOS-Screensaver]" kill 2>/dev/null
pkill -f "foot.*BunkerOS-Screensaver" 2>/dev/null
sleep 0.2

# Get all outputs
OUTPUTS=$(swaymsg -t get_outputs | jq -r '.[].name' 2>/dev/null)

# If jq fails or no outputs, just launch one screensaver
if [ -z "$OUTPUTS" ]; then
    exec foot --fullscreen \
        --font="monospace:size=14" \
        --app-id=BunkerOS-Screensaver \
        -e "$SCREENSAVER_CMD"
    exit 0
fi

# For multi-monitor: Launch screensaver on each output
# Note: Due to 'sticky' window rule, we can't move windows between outputs
# So we disable sticky temporarily for initial positioning
for OUTPUT in $OUTPUTS; do
    # Create a unique app_id for this output
    APP_ID="BunkerOS-Screensaver-${OUTPUT}"
    
    # Launch foot for this specific output in background
    foot --fullscreen \
        --font="monospace:size=14" \
        --app-id="$APP_ID" \
        -e "$SCREENSAVER_CMD" &
    
    sleep 0.3
    
    # Move to correct output (if we have multiple)
    swaymsg "[app_id=\"$APP_ID\"] move to output $OUTPUT, fullscreen enable" 2>/dev/null
done

# Wait a moment for all windows to stabilize
sleep 0.5

# Now make all screensaver windows sticky so they appear on all workspaces
# Loop through each output to apply sticky individually (since regex doesn't work in criteria)
for OUTPUT in $OUTPUTS; do
    APP_ID="BunkerOS-Screensaver-${OUTPUT}"
    swaymsg "[app_id=\"$APP_ID\"] sticky enable" 2>/dev/null
done

# Success exit
exit 0