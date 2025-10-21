# BunkerOS Menu System

## Overview

The BunkerOS menu system has been redesigned with a clean, hierarchical structure that aligns with BunkerOS's tactical, productivity-focused philosophy. The new menu provides logical organization, consistent positioning, and no scrolling required.

## Menu Structure

### 🎯 Main Menu (`main-menu.sh`)
The primary entry point accessed from waybar or keybindings (Super+M or Super+Alt+Space):
- **🎨 Appearance** - Visual customization options
- **⚙️ System** - System controls and settings
- **� Install** - Install packages and web apps
- **⌨️ Settings** - System configuration and utilities
- **󰐥 Power** - Power management options

### 🎨 Appearance Menu (`appearance-menu.sh`)
Visual customization and theming:
- **󰏘 Theme** - Switch between BunkerOS themes (Tactical, Gruvbox, Nord, Everforest, Tokyo Night)
- **󰸉 Wallpaper** - Manage wallpapers with graphical selector
- **󰖔 Night Mode** - Toggle color temperature (one-click blue light filter)
- **󰹑 Window Gaps** - Submenu for gap controls
  - Toggle Gaps (0px ↔ 8px)
  - Increase Gaps (+2px)
  - Decrease Gaps (-2px)
- **󰂚 Opacity** - Submenu for window opacity
  - Increase Opacity (+5%)
  - Decrease Opacity (-5%)

### ⚙️ System Menu (`system-menu.sh`)
System controls and monitoring:
- **󰖩 Network** - Network configuration (nmtui)
- **󰂯 Bluetooth** - Bluetooth manager
- **󰕾 Audio** - Audio settings (pulsemixer)
- **󰍹 Display** - Display configuration (wdisplays)
- **󰍛 Monitor** - System monitor (btop)

### � Install Menu (`install-menu.sh`)
Package and application installation:
- **📱 Web Apps** - Install websites as desktop applications
- *Future*: Package manager (pacman/AUR) interface

### ⌨️ Settings Menu (`settings-menu.sh`)
System configuration and utilities:
- **⌨️ Keybindings** - Interactive keybinding manager (view/edit/add)
- **󰄀 Screenshot** - GNOME/COSMIC-style screenshot workflow
- **󰆊 Reload Config** - Reload Sway configuration

### 󰐥 Power Menu (`power-menu.sh`)
Power management:
- **󰔎 Screensaver** - Lock screen with screensaver
- **󰐥 Shutdown** - Power off system
- **󰜉 Reboot** - Restart system
- **󰤄 Suspend** - Suspend to RAM
- **󰍃 Logout** - Exit Sway session

## Design Principles

### 1. **Hierarchical Organization**
- Clear 6-category top-level structure
- Logical grouping of related functions
- Consistent "Back" navigation throughout

### 2. **Consistent UX**
- All menus appear in **top-right corner** (near trigger button)
- **Auto-sizing** based on number of items (no scrolling)
- **Compact width** (180-200px) for efficiency
- **40px item height** + 50px padding formula

### 3. **Tactical Design**
- Minimal text, clear icons
- Fast keyboard-driven navigation
- No unnecessary animations or delays
- Professional, distraction-free appearance

### 4. **Smart Positioning**
```bash
--location top_right    # Appear under button
--xoffset -10          # 10px from right edge
--yoffset 40           # 40px from top (below waybar)
```

### 5. **Dynamic Height Calculation**
```bash
item_height=40
num_items=6
total_height=$((num_items * item_height + 50))
```
This ensures all items are visible without scrolling.

## Comparison with Previous System

### Before (quick-menu.sh)
❌ 14 flat items in single menu
❌ Required scrolling to see all options
❌ No logical organization
❌ Appeared in screen center
❌ Fixed height caused scrollbar
❌ Duplicate/redundant entries
❌ Mixed applications with system controls

### After (New System)
✅ 5 streamlined top-level categories
✅ Hierarchical organization
✅ All items visible (no scrolling)
✅ Appears under button (top-right)
✅ Dynamic auto-sizing
✅ Clean, logical structure
✅ Apps launched via wofi (Super+Space), not menu

## Integration

### Waybar Integration
To use the new menu from waybar, update waybar config:

```json
"custom/menu": {
    "format": "󰍜",
    "on-click": "~/.config/waybar/scripts/main-menu.sh",
    "tooltip": false
}
```

### Keybinding Integration
Add to Sway config:
```
bindsym $mod+m exec ~/.config/waybar/scripts/main-menu.sh
```

## Migration Notes

The old `quick-menu.sh` is preserved but no longer used. The new system provides:
- Better organization with clear categories
- Eliminated redundancy (removed duplicate Theme/Wallpaper entries)
- Added missing features (Reload Config)
- Removed clutter (moved apps to Launch menu)

## File Locations

All menu scripts located in: `/home/ryan/Projects/bunkeros/waybar/scripts/`

**Active Scripts:**
- `main-menu.sh` - Primary entry point (5 categories)
- `appearance-menu.sh` - Visual customization
- `system-menu.sh` - System controls
- `install-menu.sh` - Package/app installation
- `settings-menu.sh` - Configuration and utilities
- `power-menu.sh` - Power management

**Deprecated:**
- `quick-menu.sh` - Old flat menu (preserved for reference)
- `launch-menu.sh` - Removed (apps via wofi instead)
- `actions-menu.sh` - Removed (items merged into other menus)

## Philosophy Alignment

This menu structure reflects BunkerOS's core values:

**Productivity-First**: Clear categories, fast navigation, no clutter
**Tactical Design**: Minimal, functional, professional appearance
**Efficiency**: Keyboard-driven, logical grouping, no wasted clicks
**Polish**: Consistent positioning, auto-sizing, smooth UX

The menu is a tool, not a toy. It gets you where you need to go, fast.
