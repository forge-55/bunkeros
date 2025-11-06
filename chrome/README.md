# Chrome/Chromium Rounded Corners Fix

## The Problem

Chrome/Chromium 115+ introduced a new UI design (ChromeRefresh2023) with rounded corners that cannot be fully disabled through flags alone. This creates a visual mismatch with Sway's square window borders.

## Current Status

- ✓ Flags are correctly installed and loaded
- ✓ GTK CSS is configured to force square corners
- ✗ Chrome still renders rounded corners using its internal rendering engine
- ✓ Firefox works correctly (respects GTK theming)

## Why This Happens

Chrome/Chromium on Wayland uses its own rendering pipeline that bypasses GTK CSS for window decorations. The `--disable-features=ChromeRefresh2023` flag is supposed to disable the new rounded UI, but Google has made it increasingly difficult to override in recent versions (142+).

## Solutions

### Option 1: Use Server-Side Decorations (Recommended)

Force Chrome to use Wayland/Sway's native window decorations instead of drawing its own:

Add to your flags:
```
--enable-features=UseOzonePlatform
--ozone-platform=wayland
--enable-wayland-ime
```

### Option 2: Use Custom Chrome CSS

1. Install a Chrome extension like "Stylus" or "User JavaScript and CSS"
2. Add custom CSS to override Chrome's internal styles:

```css
/* Force square corners on Chrome UI */
* {
    border-radius: 0 !important;
}
```

### Option 3: Use Chrome Canary/Dev Channel

Development versions sometimes have experimental flags:
- `chrome://flags/#chrome-refresh-2023` - Try disabling
- `chrome://flags/#rounded-windows` - If available

### Option 4: Downgrade Chrome

Chrome 114 and earlier didn't have forced rounded corners:
```bash
# Not recommended - security risks
sudo pacman -U /var/cache/pacman/pkg/chromium-114*
```

### Option 5: Switch to Firefox

Firefox properly respects GTK theming and doesn't have rounded corners on BunkerOS.

## Testing Your Current Setup

Check if flags are loaded:
```bash
# Open Chromium
chromium

# Visit: chrome://version
# Look for "Command Line" section
# Should see: --disable-features=ChromeRefresh2023
```

## Files Modified

- `chrome-flags.conf` - Chrome flags configuration
- `chromium-flags.conf` - Chromium flags configuration  
- `brave-flags.conf` - Brave flags configuration
- `install.sh` - Installation script
- `chrome-bunkeros.sh` - Launcher script with hardcoded flags

## Additional Notes

The rounded corners are purely cosmetic and don't affect functionality. If perfect visual consistency is critical, Firefox is currently the best option for BunkerOS.
