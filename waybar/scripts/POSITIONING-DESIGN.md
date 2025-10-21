# BunkerOS Menu Positioning Design

## Overview

BunkerOS menus now support **context-aware positioning** to provide optimal UX based on how the menu is accessed.

## Positioning Contexts

### 1. Main Menu (Super+M / Super+Alt+Space)
**Position**: `center`
**Rationale**: Keyboard-triggered menus should appear centrally for easy visibility and access
**Behavior**: 
- Main menu appears centered
- All submenus inherit centered positioning
- Back button returns to main menu

### 2. Waybar Button (Power Icon)
**Position**: `top_right`
**Rationale**: Mouse-triggered menus should appear near the trigger button
**Behavior**:
- Menu appears directly under power button (top-right corner)
- Offset: 10px from right, 40px from top
- Back button exits menu (no parent)

## Implementation

All menu scripts accept an optional position parameter:

```bash
~/.config/waybar/scripts/menu-name.sh [center|top_right]
```

**Default**: `top_right` (for waybar button compatibility)

### Script Pattern

```bash
# Accept position parameter (default: top_right for waybar button)
POSITION=${1:-top_right}

# Set location based on position parameter
if [ "$POSITION" = "center" ]; then
    selected=$(echo -e "$options" | wofi --dmenu \
        --location center \
        ...)
else
    selected=$(echo -e "$options" | wofi --dmenu \
        --location top_right \
        --xoffset -10 \
        --yoffset 40 \
        ...)
fi
```

## Menu Flow

### Keyboard Flow (Super+M)
```
main-menu.sh (center)
├─ appearance-menu.sh center
├─ system-menu.sh center
├─ install-menu.sh center
├─ settings-menu.sh center
└─ power-menu.sh center
```

### Waybar Button Flow
```
power-menu.sh (top_right, default)
└─ (no submenus)
```

## Dynamic Height

All menus calculate height dynamically based on number of items:

```bash
item_height=40
num_items=6
total_height=$((num_items * item_height + 50))
```

**Formula**: `(items × 40px) + 50px padding`

This ensures:
- ✓ No scrolling needed
- ✓ No wasted space
- ✓ Consistent item sizing
- ✓ Clean, professional appearance

## Benefits

1. **Context Awareness**: Menu position matches trigger method
2. **Optimal UX**: Centered for keyboard, near-button for mouse
3. **No Dead Space**: Dynamic sizing fits content
4. **Consistent Width**: 200px for all menus (clean, predictable)
5. **Future-Proof**: Easy to add new positioning contexts

## Files Using This Pattern

- `main-menu.sh` - Always centered (entry point)
- `appearance-menu.sh` - Inherits position
- `system-menu.sh` - Inherits position
- `install-menu.sh` - Inherits position
- `settings-menu.sh` - Inherits position
- `power-menu.sh` - Supports both contexts

## Testing

**Test Centered (Keyboard)**:
```bash
~/.config/waybar/scripts/main-menu.sh
```

**Test Top-Right (Waybar)**:
```bash
~/.config/waybar/scripts/power-menu.sh
```

Both should work perfectly in their respective contexts!

## Update: Dynamic Sizing Fix

### Issue
The `--height` parameter was being overridden by wofi's config file (`height=400`).

### Solution
Changed from `--height` to `--lines` parameter:

```bash
# Before (didn't work)
--height "$total_height"

# After (works perfectly)
--lines "$num_items"
```

### Why This Works
- `--lines` tells wofi exactly how many items to display
- Wofi calculates the perfect height automatically
- No config file override issues
- True dynamic sizing with zero dead space

### Example
```bash
# 2 items = compact menu
options="📱 Web Apps\n⬅️  Back"
num_items=2
wofi --dmenu --lines "$num_items"  # Fits perfectly!

# 6 items = taller menu
options="item1\nitem2\nitem3\nitem4\nitem5\nitem6"
num_items=6
wofi --dmenu --lines "$num_items"  # Also fits perfectly!
```

Each menu and submenu now auto-sizes to show exactly the right number of items with no scrolling and no wasted space.
