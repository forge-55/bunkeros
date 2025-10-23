#!/bin/bash
# Show current SwayFX configuration and performance analysis

CONFIG_FILE="$HOME/.config/sway/config.d/swayfx-effects"
SWAY_CONFIG="$HOME/.config/sway/config"

echo "=========================================="
echo "BunkerOS SwayFX Configuration Analysis"
echo "=========================================="
echo ""

# Check compositor
if pgrep -x "sway" > /dev/null; then
    COMPOSITOR=$(sway --version 2>&1 | head -n1)
    echo "Compositor: $COMPOSITOR"
else
    echo "⚠ Sway is not running"
    exit 1
fi

echo ""
echo "--- Active SwayFX Effects ---"
echo ""

# Check each effect
check_effect() {
    local effect=$1
    local friendly_name=$2
    local performance_impact=$3
    
    if grep -q "^$effect" "$CONFIG_FILE" 2>/dev/null; then
        local value=$(grep "^$effect" "$CONFIG_FILE" | head -n1)
        echo "✓ $friendly_name: ENABLED"
        echo "  $value"
        echo "  Performance impact: $performance_impact"
    else
        echo "✗ $friendly_name: DISABLED"
    fi
    echo ""
}

check_effect "corner_radius" "Rounded Corners" "Minimal ⚡"
check_effect "shadows on" "Shadows" "HIGH ⚠️"
check_effect "blur on" "Blur" "VERY HIGH ⚠️⚠️"
check_effect "default_dim_inactive" "Dim Inactive" "Medium ⚠️"
check_effect "scratchpad_minimize enable" "Scratchpad Animation" "Low"

# Check opacity
echo "--- Window Opacity ---"
echo ""
OPACITY=$(grep "set \$opacity" "$SWAY_CONFIG" | awk '{print $3}')
if [ "$OPACITY" = "1.0" ] || [ "$OPACITY" = "1" ]; then
    echo "✓ Opacity: $OPACITY (fully opaque, no transparency overhead)"
elif [ "$OPACITY" = "0.95" ]; then
    echo "⚠ Opacity: $OPACITY (slight transparency, minor performance cost)"
else
    echo "⚠ Opacity: $OPACITY (transparency calculations may impact performance)"
fi

echo ""
echo "--- Performance Rating ---"
echo ""

# Calculate performance score
SCORE=100
FLICKER_RISK="None"

if grep -q "^shadows on" "$CONFIG_FILE" 2>/dev/null; then
    SCORE=$((SCORE - 30))
    FLICKER_RISK="Medium-High"
fi

if grep -q "^blur on" "$CONFIG_FILE" 2>/dev/null; then
    SCORE=$((SCORE - 40))
    FLICKER_RISK="High"
fi

if grep -q "^default_dim_inactive [0-9]" "$CONFIG_FILE" 2>/dev/null; then
    SCORE=$((SCORE - 15))
    if [ "$FLICKER_RISK" = "None" ]; then
        FLICKER_RISK="Low"
    fi
fi

if [ "$OPACITY" != "1.0" ] && [ "$OPACITY" != "1" ]; then
    SCORE=$((SCORE - 10))
fi

echo "Performance Score: $SCORE/100"
echo "Workspace Switching Flicker Risk: $FLICKER_RISK"
echo ""

if [ $SCORE -ge 90 ]; then
    echo "🚀 Excellent! Minimal performance overhead."
    echo "   Workspace switching should be very smooth."
elif [ $SCORE -ge 70 ]; then
    echo "✅ Good. Some effects enabled with acceptable performance."
    echo "   You may notice slight flicker during workspace switching."
elif [ $SCORE -ge 50 ]; then
    echo "⚠️  Moderate. Multiple effects may impact performance."
    echo "   Noticeable flicker likely during workspace switching."
else
    echo "❌ Heavy. Many performance-intensive effects enabled."
    echo "   Significant flicker expected during workspace switching."
fi

echo ""
echo "--- Recommendations ---"
echo ""

if [ $SCORE -lt 90 ]; then
    echo "To reduce workspace switching flicker:"
    echo "  1. Run: ~/Projects/bunkeros/scripts/toggle-swayfx-mode.sh"
    echo "     (Switches to minimal/performance mode)"
    echo ""
    echo "  2. Or manually disable shadows and blur in:"
    echo "     ~/.config/sway/config.d/swayfx-effects"
    echo ""
fi

echo "To test current performance:"
echo "  ~/Projects/bunkeros/scripts/debug-workspace-switching.sh"
echo ""

echo "=========================================="
