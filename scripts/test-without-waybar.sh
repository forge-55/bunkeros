#!/bin/bash
# Quick test: Disable Waybar temporarily to see if it's causing the flicker

echo "Stopping Waybar to test workspace switching..."
killall waybar

echo ""
echo "Waybar stopped. Now try switching workspaces (Super+1, Super+2, etc.)"
echo "Do you still see flicker?"
echo ""
echo "Press Enter to restart Waybar..."
read

waybar -b bar-0 >/dev/null 2>&1 &
echo "Waybar restarted."
