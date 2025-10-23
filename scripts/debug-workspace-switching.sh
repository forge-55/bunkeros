#!/bin/bash
# BunkerOS - Workspace Switching Performance Diagnostics
# This script monitors Sway/SwayFX performance during workspace switches

echo "==================================================================="
echo "BunkerOS Workspace Switching Diagnostics"
echo "==================================================================="
echo ""
echo "This tool will help identify the cause of workspace switching flicker."
echo ""

# Check which compositor is running
if pgrep -x "sway" > /dev/null; then
    COMPOSITOR=$(sway --version 2>&1)
    echo "✓ Compositor detected: $COMPOSITOR"
else
    echo "✗ Sway is not running!"
    exit 1
fi

echo ""
echo "--- Current Configuration ---"
echo ""

# Check blur status
echo "Blur status:"
if grep -q "^blur on" ~/.config/sway/config.d/swayfx-effects 2>/dev/null; then
    echo "  ⚠ Blur is ENABLED (may cause flicker)"
else
    echo "  ✓ Blur is DISABLED"
fi

# Check fade/dim settings
echo ""
echo "Fade/Dim settings:"
if grep -q "^default_dim_inactive" ~/.config/sway/config.d/swayfx-effects 2>/dev/null; then
    DIM_VALUE=$(grep "^default_dim_inactive" ~/.config/sway/config.d/swayfx-effects | awk '{print $2}')
    echo "  ⚠ default_dim_inactive is SET to $DIM_VALUE (may cause flicker)"
else
    echo "  ✓ default_dim_inactive is DISABLED"
fi

# Check opacity settings
echo ""
echo "Opacity settings:"
OPACITY=$(grep "set \$opacity" ~/.config/sway/config | awk '{print $3}')
echo "  Window opacity: $OPACITY"

# Check waybar status
echo ""
echo "Waybar status:"
if pgrep -x "waybar" > /dev/null; then
    WAYBAR_COUNT=$(pgrep -x "waybar" | wc -l)
    if [ "$WAYBAR_COUNT" -gt 1 ]; then
        echo "  ⚠ Multiple Waybar instances running ($WAYBAR_COUNT) - may cause flicker!"
    else
        echo "  ✓ Single Waybar instance running"
    fi
else
    echo "  ✗ Waybar is not running"
fi

echo ""
echo "--- Performance Monitoring ---"
echo ""
echo "Monitoring workspace switches for 30 seconds..."
echo "Please switch between workspaces multiple times."
echo ""

# Monitor sway IPC events for workspace switches
TEMP_LOG="/tmp/bunkeros-workspace-debug.log"
> "$TEMP_LOG"

# Start monitoring in background
timeout 30 swaymsg -t subscribe -m '["workspace"]' 2>&1 | while read -r event; do
    TIMESTAMP=$(date +%H:%M:%S.%3N)
    echo "$TIMESTAMP - $event" >> "$TEMP_LOG"
done &

MONITOR_PID=$!

# Show real-time CPU usage of compositor and waybar
echo "Monitoring CPU usage (Ctrl+C to stop early)..."
echo ""
printf "%-10s %-10s %-10s %-10s\n" "TIME" "SWAY%" "WAYBAR%" "TOTAL%"
printf "%-10s %-10s %-10s %-10s\n" "----" "-----" "------" "------"

for i in {1..30}; do
    SWAY_CPU=$(ps -C sway -o %cpu= 2>/dev/null | awk '{sum+=$1} END {print sum}' || echo "0")
    WAYBAR_CPU=$(ps -C waybar -o %cpu= 2>/dev/null | awk '{sum+=$1} END {print sum}' || echo "0")
    TOTAL_CPU=$(echo "$SWAY_CPU + $WAYBAR_CPU" | bc 2>/dev/null || echo "0")
    
    printf "%-10s %-10.1f %-10.1f %-10.1f\n" "$(date +%H:%M:%S)" "$SWAY_CPU" "$WAYBAR_CPU" "$TOTAL_CPU"
    sleep 1
done

# Wait for monitor to finish
wait $MONITOR_PID 2>/dev/null

echo ""
echo "--- Workspace Switch Event Log ---"
echo ""
if [ -f "$TEMP_LOG" ]; then
    EVENT_COUNT=$(grep -c "change" "$TEMP_LOG" 2>/dev/null || echo "0")
    echo "Total workspace switches detected: $EVENT_COUNT"
    echo ""
    echo "Recent events:"
    tail -n 10 "$TEMP_LOG"
else
    echo "No events captured"
fi

echo ""
echo "==================================================================="
echo "Diagnosis Summary"
echo "==================================================================="
echo ""

# Provide recommendations
echo "Recommendations:"
echo ""

if grep -q "^blur on" ~/.config/sway/config.d/swayfx-effects 2>/dev/null; then
    echo "1. ⚠ Disable blur to test if it reduces flicker"
    echo "   Edit: ~/.config/sway/config.d/swayfx-effects"
    echo "   Change 'blur on' to 'blur off'"
    echo ""
fi

if [ "$WAYBAR_COUNT" -gt 1 ]; then
    echo "2. ⚠ Kill duplicate Waybar instances:"
    echo "   killall waybar && waybar &"
    echo ""
fi

if grep -q "exec_always.*opacity" ~/.config/sway/config 2>/dev/null; then
    echo "3. ⚠ Remove redundant exec_always opacity commands"
    echo ""
fi

echo "4. If flicker persists with blur off, the issue may be:"
echo "   - Waybar redraw timing (try disabling Waybar temporarily)"
echo "   - SwayFX shadow rendering"
echo "   - Display driver issues"
echo ""

echo "To test without Waybar:"
echo "  killall waybar"
echo "  (Switch workspaces to see if flicker remains)"
echo "  waybar &  (to restart)"
echo ""

echo "==================================================================="
echo "Log saved to: $TEMP_LOG"
echo "==================================================================="
