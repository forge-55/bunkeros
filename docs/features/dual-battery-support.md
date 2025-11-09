# Dual Battery Support for ThinkPad PowerBridge Systems

## Overview

BunkerOS now includes enhanced battery indicator support specifically designed for ThinkPad laptops with PowerBridge dual battery systems (like the T480, T470, T450s, and similar models).

## What Changed

### Before
- Battery indicator only showed the status of a single battery (usually BAT0)
- On T480 systems, when the internal battery was low (~5%) and the system switched to the external battery, the indicator would show "critically low battery" even though the external battery was full

### After  
- Battery indicator calculates and displays **combined battery capacity** from both internal and external batteries
- Shows realistic battery percentage based on total energy available
- Provides detailed information about both batteries in tooltips and notifications
- Maintains full compatibility with single-battery laptops and desktops

## Features

### Combined Battery Calculation
- Calculates total battery capacity based on energy levels (Wh) from both batteries
- Provides accurate representation of actual power remaining
- Accounts for different battery capacities (internal ~24Wh, external ~61Wh on T480)

### Detailed Information
- **Waybar tooltip**: Shows combined percentage plus individual battery levels
- **Notifications**: Display both internal and external battery percentages
- **Status awareness**: Correctly handles charging, discharging, and "not charging" states

### PowerBridge Logic
- Understands ThinkPad PowerBridge behavior (external battery drains first)
- Intelligently determines system-wide charging/power status
- Handles edge cases like mixed battery states

## Example Output

### T480 with Internal Battery at 5%, External at 94%
- **Display**: 68% (instead of misleading 5%)
- **Tooltip**: "Combined Battery: 68%\nInternal (BAT0): 5%\nExternal (BAT1): 94%\nStatus: Discharging"
- **Notification**: "Discharging: 68% (Internal: 5%, External: 94%)"

## Compatibility

### Dual Battery Systems (Automatic Detection)
- ThinkPad T480, T470, T450s, X270, etc.
- Any laptop with both BAT0 and BAT1 in `/sys/class/power_supply/`

### Single Battery Systems (No Change)
- Standard laptops with one battery
- Continues to work exactly as before
- No performance impact

### Desktop Systems (No Change)  
- Systems without batteries
- Shows AC power status as before

## Technical Details

### Files Modified
- `waybar/scripts/battery-profile-status.sh` - Main waybar battery indicator
- `waybar/scripts/battery-info.sh` - Battery notification script  
- `waybar/scripts/dual-battery-helper.sh` - New dual battery calculation logic

### Detection Method
1. Check for existence of both `/sys/class/power_supply/BAT0` and `/sys/class/power_supply/BAT1`
2. If both exist, use dual battery calculations
3. If only one exists, use single battery logic
4. If neither exists, show desktop/AC power mode

### Calculation Formula
```bash
# Combined capacity based on actual energy levels
total_energy_now = BAT0_energy_now + BAT1_energy_now
total_energy_full = BAT0_energy_full + BAT1_energy_full  
combined_capacity = (total_energy_now * 100) / total_energy_full
```

## Testing

Tested on ThinkPad T480 with:
- Internal battery: 5% (25.16 Wh capacity)
- External battery: 94% (62.14 Wh capacity)
- Result: 68% combined (accurate representation)

## Benefits

1. **No more misleading low battery warnings** when external battery is charged
2. **Accurate battery life estimates** for planning work sessions
3. **Better power management decisions** based on realistic capacity
4. **Enhanced user experience** for ThinkPad PowerBridge users
5. **Zero impact** on single battery systems

This enhancement makes BunkerOS significantly more useful for ThinkPad users while maintaining the system's lightweight, distraction-free philosophy.