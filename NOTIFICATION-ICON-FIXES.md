# Notification & Icon Color Fixes

## Issues Fixed

### 1. Waybar Icons Still Bright in Non-Tactical Themes
**Problem**: Icon colors were updated in theme files but not taking effect because theme switcher **copies** theme files rather than symlinking them.

**Root Cause**: The theme switcher copies `waybar-style.css` from theme directories to `waybar/style.css`. Changes to theme files don't appear until the theme is switched again.

**Solution**: 
- ✅ Updated all theme waybar-style.css files with muted colors
- ✅ Colors will apply when user switches to each theme
- ✅ Current tactical theme (waybar/style.css) already has muted colors

### 2. Notification "Glass-Like" Appearance
**Problem**: Notifications had excessive padding and border-radius creating a bloated, glass-like look.

**Root Cause**: 
- `padding=12-15` was too generous
- `margin=10-20` created too much space
- `border-radius=4` (or 0) wasn't sharp enough

**Solution**: Sharpened all mako configs:
- **padding**: 15→10, 12→10 (tighter text spacing)
- **margin**: 20→8, 10→8 (less whitespace around notifications)
- **border-radius**: 4→2, 0→2 (subtle rounded corners, more refined)
- **font-size**: 11→9 (consistent across themes)

### 3. Notification Border Colors Too Bright
**Problem**: Notification borders used bright accent colors instead of muted tones.

**Solution**: Updated mako border colors to match waybar icon palette:
- **Tokyo Night**: `#9ECE6A` → `#6B8E4E`
- **Nord**: `#88c0d0` → `#7A9A76`, `#a3be8c` → `#7A9A76`
- **Gruvbox**: `#98971A` → `#79771A`
- **Everforest**: `#a7c080` → `#869B6A`, `#83c092` → `#6A9978`
- **Tactical**: Already muted `#4A5240` ✅

## Files Modified

### Waybar Styles (Already Done)
- ✅ `themes/tactical/waybar-style.css`
- ✅ `themes/tokyo-night/waybar-style.css`
- ✅ `themes/nord/waybar-style.css`
- ✅ `themes/gruvbox/waybar-style.css`
- ✅ `themes/everforest/waybar-style.css`

### Mako Notification Configs (Just Updated)
- ✅ `mako/config` (main tactical)
- ✅ `themes/tactical/mako-config`
- ✅ `themes/tokyo-night/mako-config`
- ✅ `themes/nord/mako-config`
- ✅ `themes/gruvbox/mako-config`
- ✅ `themes/everforest/mako-config`

## Notification Styling Changes

### Before:
```ini
padding=15
margin=20
border-radius=0 or 4
font=monospace 11
border-color=#9ECE6A  (bright)
```

### After:
```ini
padding=10
margin=8
border-radius=2
font=monospace 9
border-color=#6B8E4E  (muted)
```

## Visual Impact

### Notifications
- **20-33% less padding** - Tighter, more refined
- **20-60% less margin** - Better screen space usage
- **Sharper borders** - Consistent 2px radius across all themes
- **Smaller font** - More compact, professional
- **Muted borders** - Matches waybar icon aesthetic

### Waybar Icons
Icons will show muted colors when themes are switched:

| Theme | Network/BT Icon | Before | After |
|-------|----------------|--------|-------|
| Tactical | ✅ | `#4A5240` | `#4A5240` (already muted) |
| Tokyo Night | 🔄 | `#9ECE6A` | `#6B8E4E` (on next switch) |
| Nord | 🔄 | `#A3BE8C` | `#7A9A76` (on next switch) |
| Gruvbox | 🔄 | `#98971A` | `#79771A` (on next switch) |
| Everforest | 🔄 | `#A7C080` | `#869B6A` (on next switch) |

## To See Icon Changes

**Option 1: Switch themes**
```bash
~/.config/scripts/theme-switcher.sh
```
Select any theme to apply the new muted waybar icons.

**Option 2: Manually apply current theme**
```bash
# Find current theme (look for CURRENT_THEME in .cache or config)
# Then run theme switcher and select same theme again
```

## To See Notification Changes

**Already Applied!** Mako has been reloaded with:
```bash
makoctl reload
```

Test with:
```bash
notify-send "Test" "Sharper, muted notification!"
```

## Theme Switcher Behavior

Important to understand:
1. Theme switcher **copies** files from `themes/[name]/` to main directories
2. Editing main files directly gets overwritten on next theme switch
3. Always edit theme-specific files in `themes/[name]/`
4. Changes appear when theme is reapplied/switched

## Comparison: Before vs After

### Tactical Theme (Current)
- ✅ Notifications: Sharper, tighter spacing
- ✅ Icons: Already muted

### Other Themes (On Next Switch)
- ✅ Notifications: Sharper, tighter spacing
- ✅ Notification borders: Muted to match icons
- ✅ Waybar icons: Muted instead of bright
- ✅ Consistent professional aesthetic

## Testing

### Test Notifications:
```bash
notify-send "WiFi" "Connected to network"
notify-send "Bluetooth" "Device paired successfully"
notify-send -u critical "Alert" "Critical notification test"
```

### Test Icon Colors:
1. Switch to Tokyo Night theme
2. Check waybar icons (should be muted green `#6B8E4E`)
3. Switch to Nord theme
4. Check waybar icons (should be muted sage `#7A9A76`)

Perfect refined aesthetic across all themes! 🎨
