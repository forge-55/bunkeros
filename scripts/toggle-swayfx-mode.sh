#!/bin/bash
# BunkerOS - Toggle between minimal and full SwayFX effects
# Useful for testing and personal preference

CONFIG_FILE="$HOME/.config/sway/config.d/swayfx-effects"
BACKUP_FILE="$HOME/.config/sway/config.d/swayfx-effects.backup"

# Check current mode by looking for "Minimal/Performance Mode" in the file
if grep -q "Minimal/Performance Mode" "$CONFIG_FILE" 2>/dev/null; then
    CURRENT_MODE="minimal"
else
    CURRENT_MODE="full"
fi

echo "=========================================="
echo "BunkerOS SwayFX Effects Toggler"
echo "=========================================="
echo ""
echo "Current mode: $CURRENT_MODE"
echo ""

if [ "$CURRENT_MODE" = "minimal" ]; then
    echo "Switching to FULL effects mode..."
    echo "(This will enable shadows and may cause workspace switching flicker)"
    echo ""
    
    cat > "$CONFIG_FILE" << 'EOF'
# BunkerOS Enhanced - SwayFX Visual Effects (Full Mode)
# Maximum visual appeal with some workspace switching flicker

# Rounded corners
corner_radius 8

# Shadows for depth
shadows on
shadows_on_csd off
shadow_blur_radius 25
shadow_color #000000AA
shadow_offset 0 6

# Light blur (optional - uncomment to enable)
# blur on
# blur_xray off
# blur_passes 2
# blur_radius 5

# Layer effects
layer_effects "waybar" shadows on; corner_radius 0
layer_effects "notifications" shadows on; corner_radius 10
layer_effects "wofi" shadows on; corner_radius 8

# Scratchpad animation
scratchpad_minimize enable

# Floating windows enhancement
for_window [floating] corner_radius 12
for_window [floating] shadow_blur_radius 35
EOF

    echo "✓ Switched to FULL effects mode"
    echo ""
    echo "Effects enabled:"
    echo "  - Rounded corners (8px)"
    echo "  - Shadows"
    echo "  - Enhanced floating windows"
    echo ""
    echo "⚠ You may notice flicker during workspace switching"
    
else
    echo "Switching to MINIMAL effects mode..."
    echo "(Optimized for smooth workspace switching)"
    echo ""
    
    cat > "$CONFIG_FILE" << 'EOF'
# BunkerOS Enhanced - SwayFX Visual Effects (Minimal/Performance Mode)
# These directives are ignored by vanilla Sway
#
# This configuration uses ONLY the most impactful SwayFX features with minimal
# performance overhead to eliminate workspace switching flicker while maintaining
# a modern, polished appearance.

# ============================================================================
# ENABLED EFFECTS (Performance-friendly)
# ============================================================================

# Rounded corners - minimal CPU/GPU impact, maximum visual improvement
# This is SwayFX's best feature with negligible performance cost
corner_radius 6

# ============================================================================
# DISABLED EFFECTS (Performance drains during workspace switching)
# ============================================================================

# Shadows - MAJOR cause of workspace switching flicker
# Shadows must be recalculated for every window during transitions
shadows off

# Blur - MAJOR performance impact, especially during transitions
# blur off

# Dim inactive windows - Causes flicker during workspace focus changes
# default_dim_inactive off

# Scratchpad animations - Can cause lag
scratchpad_minimize disable
EOF

    echo "✓ Switched to MINIMAL effects mode"
    echo ""
    echo "Effects enabled:"
    echo "  - Rounded corners (6px)"
    echo ""
    echo "Effects disabled:"
    echo "  - Shadows (prevents flicker)"
    echo "  - Blur (prevents lag)"
    echo "  - Dim inactive (prevents flicker)"
fi

echo ""
echo "Reloading Sway configuration..."
swaymsg reload

echo ""
echo "=========================================="
echo "Done! Test workspace switching now."
echo "Run this script again to toggle back."
echo "=========================================="
