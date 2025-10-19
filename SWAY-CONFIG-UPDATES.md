# Sway Config Updates - Smart Close & Editor Change

## Changes Made

### 1. Smart Close for Menus (mod+q)

**Previous Behavior:**
- `mod+q` always killed the focused window
- If a wofi menu was open, it would kill the window underneath instead

**New Behavior:**
- `mod+q` now runs `smart-close.sh` which:
  - **If wofi menu is open:** Closes all wofi menus immediately
  - **If no menu is open:** Closes the focused window normally

This matches your earlier design decision and makes it quick to exit menus!

### 2. Default Editor Changed

**Previous:** `cursor`
**New:** `code` (Visual Studio Code)

Now pressing `mod+e` will launch VS Code instead of Cursor.

## Files Modified

- `sway/config`:
  - Line 22: Changed `set $editor cursor` → `set $editor code`
  - Line 159: Changed `bindsym $mod+q kill` → `bindsym $mod+q exec ~/.config/waybar/scripts/smart-close.sh`

## How Smart Close Works

The script checks if any wofi process is running:

```bash
if pgrep wofi > /dev/null 2>&1; then
    # Kill all wofi instances (menus)
    pkill -9 -x wofi
else
    # Close focused window normally
    swaymsg kill
fi
```

This works for:
- WiFi picker menu
- Power menu
- Quick menu
- Theme menu
- Any other wofi-based menu

## To Apply Changes

**Reload Sway config:**
Press: `Super + Shift + R`

## Testing

1. **Test Smart Close:**
   - Open the WiFi picker (click WiFi icon)
   - Press `mod+q`
   - Menu should close immediately without affecting windows underneath

2. **Test Editor:**
   - Press `mod+e`
   - VS Code should launch

## Additional Notes

The smart-close script was already in place from a previous design decision. We just needed to wire it up to the `mod+q` keybinding in the Sway config. This ensures consistent behavior across all wofi menus in BunkerOS.

Perfect for quick menu navigation! 🎯
