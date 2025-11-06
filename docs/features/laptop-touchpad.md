# Laptop Touchpad Features

BunkerOS provides touchpad support out of the box, making laptop usage smooth and intuitive.

## Features Enabled by Default

### Tap-to-Click
- **1 finger tap**: Left click
- **2 finger tap**: Right click  
- **3 finger tap**: Middle click

### Smart Typing Protection
- **Disable While Typing (dwt)**: Automatically disables the touchpad while you're typing to prevent accidental cursor jumps
- **TrackPoint Support (dwtp)**: Disables touchpad when using ThinkPad TrackPoint

### Natural Scrolling
- MacBook-style reverse scrolling is enabled by default
- To disable: Comment out `natural_scroll enabled` in `~/.config/sway/config`

### Middle-Click Emulation
- Click left and right buttons simultaneously for middle-click
- Useful for opening links in new tabs

## Touchpad Gestures

BunkerOS uses Sway's native gesture support (Sway 1.8+) for smooth, responsive gestures.

### Workspace Navigation
- **3-finger swipe left**: Next workspace
- **3-finger swipe right**: Previous workspace

These gestures work seamlessly alongside keyboard shortcuts (Page Up/Down or Super+1-9).

## Customization

All touchpad settings are configured in `~/.config/sway/config`:

```bash
input type:touchpad {
    tap enabled                    # Tap to click
    tap_button_map lrm             # Button mapping
    dwt enabled                    # Disable while typing
    dwtp enabled                   # Disable while using TrackPoint
    natural_scroll enabled         # Reverse scrolling
    middle_emulation enabled       # Middle-click emulation
}
```

### Common Customizations

**Disable natural scrolling** (traditional direction):
```bash
input type:touchpad {
    # ... other settings ...
    # natural_scroll enabled     # Comment this out
}
```

**Adjust scroll speed**:
```bash
input type:touchpad {
    # ... other settings ...
    scroll_factor 0.5              # Slower scrolling (default is 1.0)
}
```

**Use 2-finger swipes** (may conflict with scrolling):
```bash
# In the keybindings section
bindgesture swipe:2:right workspace prev
bindgesture swipe:2:left workspace next
```

### Additional Gestures

You can add custom gestures to `~/.config/sway/config`:

```bash
# Pinch gestures
bindgesture pinch:inward+up exec your-app-launcher
bindgesture pinch:outward+down workspace back_and_forth

# 4-finger swipes
bindgesture swipe:4:up exec wofi --show drun
bindgesture swipe:4:down exec ~/.config/waybar/scripts/main-menu.sh
```

## Verification

After editing the config, reload Sway with **Super+Shift+R**.

### Check Touchpad Detection
```bash
swaymsg -t get_inputs | grep -A 20 "Touchpad"
```

### View Current Input Configuration
```bash
swaymsg -t get_inputs
```

## Troubleshooting

### Tap-to-click not working

1. Verify your touchpad is detected:
   ```bash
   libinput list-devices | grep -A 5 Touchpad
   ```

2. Check if the configuration is applied:
   ```bash
   swaymsg -t get_inputs | grep -A 20 "type:touchpad"
   ```

3. Reload Sway configuration: **Super+Shift+R**

### Gestures not responding

1. Ensure you're using Sway 1.8 or later:
   ```bash
   sway --version
   ```

2. Check for conflicting gesture handlers:
   ```bash
   ps aux | grep -i gesture
   ```
   
   Kill any `libinput-gestures` processes (not needed with Sway 1.8+):
   ```bash
   killall libinput-gestures
   systemctl --user disable libinput-gestures
   ```

3. Test gestures are being detected:
   ```bash
   libinput debug-events
   ```
   Then perform a swipe gesture and look for `GESTURE_SWIPE` events.

### Touchpad too sensitive/not sensitive enough

Adjust the `accel_profile` and `pointer_accel`:

```bash
input type:touchpad {
    # ... other settings ...
    accel_profile "adaptive"       # or "flat"
    pointer_accel 0.3              # Range: -1.0 to 1.0 (negative = slower)
}
```

### Disable touchpad completely

```bash
input type:touchpad {
    events disabled
}
```

Or toggle on/off with a keybinding:
```bash
bindsym $mod+F9 input type:touchpad events toggle enabled disabled
```

## Per-Device Configuration

If you have multiple touchpads or want device-specific settings:

1. Find your device identifier:
   ```bash
   swaymsg -t get_inputs | grep -i touchpad
   ```

2. Configure by exact device name:
   ```bash
   input "1267:12624:ELAN1200:00_04F3:3150_Touchpad" {
       tap enabled
       natural_scroll disabled    # Different from the global setting
   }
   ```

## References

- [Sway Input Documentation](https://man.archlinux.org/man/sway-input.5)
- [libinput Configuration](https://wayland.freedesktop.org/libinput/doc/latest/)
- See also: [Arch Wiki - Sway](https://wiki.archlinux.org/title/Sway)
