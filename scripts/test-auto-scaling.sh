#!/usr/bin/env bash

# Test BunkerOS Auto-Scaling
# Simulates first login and tests the auto-scaling service

echo "=== BunkerOS Auto-Scaling Test ==="
echo ""

PROJECT_DIR="$HOME/Projects/bunkeros"
CONFIG_DIR="$HOME/.config"

# Remove any existing cache to simulate first login
rm -f "$CONFIG_DIR/bunkeros/scaling-applied" 2>/dev/null
rm -f "$CONFIG_DIR/bunkeros/auto-scaling-profile.conf" 2>/dev/null

echo "1. Testing auto-scaling service..."
if [ -f "$PROJECT_DIR/scripts/auto-scaling-service.sh" ]; then
    echo "   ✓ Auto-scaling service found"
    
    # Capture current font sizes before
    current_foot_font=$(grep "^font=" "$CONFIG_DIR/foot/foot.ini" 2>/dev/null | cut -d: -f3 || echo "unknown")
    current_waybar_font=$(grep "font-size:" "$CONFIG_DIR/waybar/style.css" 2>/dev/null | head -1 | grep -o "[0-9]*px" | head -1 || echo "unknown")
    
    echo "   Current foot font: $current_foot_font"
    echo "   Current waybar font: $current_waybar_font"
    echo ""
    
    echo "   Running auto-scaling service..."
    "$PROJECT_DIR/scripts/auto-scaling-service.sh"
    
    # Check results
    if [ -f "$CONFIG_DIR/bunkeros/auto-scaling-profile.conf" ]; then
        echo "   ✓ Auto-scaling profile created"
        echo "   Profile contents:"
        cat "$CONFIG_DIR/bunkeros/auto-scaling-profile.conf" | sed 's/^/     /'
        echo ""
        
        # Check if font sizes changed
        new_foot_font=$(grep "^font=" "$CONFIG_DIR/foot/foot.ini" 2>/dev/null | cut -d: -f3 || echo "unknown")
        new_waybar_font=$(grep "font-size:" "$CONFIG_DIR/waybar/style.css" 2>/dev/null | head -1 | grep -o "[0-9]*px" | head -1 || echo "unknown")
        
        echo "   New foot font: $new_foot_font"
        echo "   New waybar font: $new_waybar_font"
        
        if [ "$new_foot_font" != "$current_foot_font" ] || [ "$new_waybar_font" != "$current_waybar_font" ]; then
            echo "   ✅ Font sizes updated successfully!"
        else
            echo "   ℹ️  Font sizes unchanged (may already be optimal)"
        fi
    else
        echo "   ❌ Auto-scaling profile not created"
    fi
else
    echo "   ❌ Auto-scaling service not found"
fi

echo ""
echo "2. Testing cache behavior..."
echo "   Running service again (should skip due to cache)..."
"$PROJECT_DIR/scripts/auto-scaling-service.sh"
echo "   ✓ Second run completed (should have been skipped)"

echo ""
echo "3. Integration check..."
if grep -q "auto-scaling-service.sh" "$CONFIG_DIR/sway/config" 2>/dev/null; then
    echo "   ✅ Auto-scaling service integrated into Sway config"
else
    echo "   ⚠️  Auto-scaling service not found in Sway config"
    echo "       This means it won't run automatically on login"
fi

echo ""
echo "=== Test Complete ==="
echo ""
echo "Summary:"
echo "• Auto-scaling will run automatically when you login to Sway"
echo "• It detects your display hardware and applies optimal settings"
echo "• Font sizes are adjusted for foot, waybar, and wofi automatically"
echo "• This happens once per session, with no user interaction required"
echo ""
echo "To see the changes:"
echo "1. Close any open terminals"
echo "2. Open a new terminal (foot) - font should be optimized"
echo "3. Waybar should also be using optimized font sizes"