# Workspace Switching Performance Guide

## Understanding the Issue

When using BunkerOS Enhanced (SwayFX), you may notice brief visual flicker when switching between workspaces. This is **expected behavior** and not a configuration bug.

### Why Does This Happen?

**SwayFX Architecture:**
- SwayFX adds visual effects (blur, shadows, animations) on top of the base Sway compositor
- During workspace switches, SwayFX must:
  1. Switch the workspace (instant)
  2. Recalculate and reapply all visual effects (2-3 frames delay)
  3. Update Waybar workspace indicators (another frame)
  
This creates a brief desync that appears as flicker.

**Hyprland Comparison:**
- Hyprland has built-in, GPU-accelerated workspace animations as part of its core rendering pipeline
- Effects are calculated in parallel with the workspace transition
- No visible flicker because everything is synchronized

### Performance Impact of Each Effect

Based on testing and SwayFX issue tracker analysis:

| Effect | Performance Impact | Visual Value | Recommendation |
|--------|-------------------|--------------|----------------|
| **Rounded Corners** | Minimal | High | ✅ **KEEP** |
| **Window Opacity** | Low-Medium | Medium | ⚠️ Consider disabling (use 1.0) |
| **Shadows** | **HIGH** | Medium | ❌ **DISABLE** for smooth switching |
| **Blur** | **VERY HIGH** | High | ❌ **DISABLE** for smooth switching |
| **Dim Inactive** | Medium | Low | ❌ **DISABLE** for smooth switching |
| **Scratchpad Animation** | Low | Low | ⚠️ Optional |

## Current Configuration (Performance Mode)

BunkerOS Enhanced is now configured for **minimal flicker** while retaining SwayFX's best visual feature:

```bash
# ENABLED
corner_radius 6          # Best visual-to-performance ratio
opacity 1.0              # Fully opaque (no transparency calculations)

# DISABLED (to eliminate flicker)
shadows off              # Major flicker cause
blur off                 # Major flicker cause
default_dim_inactive off # Causes focus change flicker
scratchpad_minimize disable
```

## Your Options

### Option 1: Current Setup (Recommended)
- **What you get:** Rounded corners only
- **Performance:** Near-zero workspace switching flicker
- **Visual appeal:** Clean, modern look without the overhead

### Option 2: Enable More Effects (Accept Minor Flicker)
If you prefer maximum visual appeal and can tolerate brief flicker:

Edit `~/.config/sway/config.d/swayfx-effects` and enable:

```bash
# Moderate visual enhancement with some flicker
shadows on
shadow_blur_radius 20
shadow_color #000000AA
shadow_offset 0 6

# Optional: Light blur (will increase flicker)
blur on
blur_passes 2
blur_radius 5
```

### Option 3: Use BunkerOS Standard (Zero Flicker)
Switch to vanilla Sway for absolutely zero flicker:

```bash
# Launch BunkerOS Standard instead of Enhanced
# This uses vanilla Sway without any SwayFX effects
```

## Testing Your Configuration

### Quick Test: Disable All Effects
```bash
~/Projects/bunkeros/scripts/test-without-shadows.sh
```

### Monitor Performance
```bash
~/Projects/bunkeros/scripts/debug-workspace-switching.sh
```

### Test Without Waybar
```bash
~/Projects/bunkeros/scripts/test-without-waybar.sh
```

## Known SwayFX Issues

Based on the SwayFX GitHub issue tracker (as of Oct 2025):

1. **#458** - Firefox lags with rounded corners (confirmed performance issue)
2. **#437** - Fullscreen blur bugs
3. **#443** - Redraw issues after scratchpad minimize
4. Multiple reports of shadow rendering causing lag

## Recommendations

For the **best balance of aesthetics and performance**:

1. ✅ Keep `corner_radius` - negligible performance cost, great visual improvement
2. ✅ Keep `opacity 1.0` - eliminates transparency calculations
3. ❌ Disable `shadows` - major flicker contributor
4. ❌ Disable `blur` - very expensive during transitions
5. ❌ Disable `default_dim_inactive` - causes focus change artifacts

This gives you a modern, polished desktop with smooth workspace transitions comparable to vanilla Sway.

## Future Improvements

The SwayFX project is actively being developed. Future versions may include:
- `smart_shadows` option (issue #463) - only render shadows when not transitioning
- Better blur optimization
- Synchronized rendering pipeline

## Summary

**The flicker is not a bug** - it's an architectural limitation of how SwayFX layers effects on top of Sway. Your current configuration minimizes this while keeping the most valuable SwayFX feature (rounded corners).

If you need **zero flicker**, use BunkerOS Standard (vanilla Sway).  
If you want **maximum effects**, accept the brief visual glitch during workspace switches.  
The current setup is the **sweet spot** between the two.
