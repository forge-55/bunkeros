# Wallpaper Manager

BunkerOS includes an easy-to-use graphical wallpaper manager that lets you change wallpapers without editing config files.

## How It Works

The wallpaper system has **two modes**:

### 1. Theme Wallpapers (Default)
- Each theme has its own wallpaper
- Switching themes automatically changes the wallpaper
- Maintains the cohesive theme experience

### 2. Custom Wallpaper
- Set one wallpaper that persists across all themes
- Overrides theme-specific wallpapers
- Your choice stays even when switching themes

## Accessing the Wallpaper Manager

**Quick Menu**: `Super+m` → `🖼️ Wallpaper`

## Features

### 📁 Upload New Wallpaper (Top Option)
- **Graphical file picker** - Browse your computer
- Supported formats: JPG, PNG, WebP
- Saves to `~/Pictures/Wallpapers/`
- Option to apply immediately or save for later

### 🖼️ Browse & Select Wallpaper
- **Simple menu interface** - Clean, familiar wofi menu (matches BunkerOS theme)
- Shows wallpaper names with clear emoji indicators:
  - 🎨 Theme wallpapers (5 bundled: Tactical, Gruvbox, Nord, Everforest, Tokyo-night)
  - 📷 Custom wallpapers (your uploads)
- Click to apply instantly
- Reliable, fast, and intuitive
- **Mode**: Switches to "Custom" - wallpaper persists across theme changes

### 🎨 Use Theme Wallpapers
- Return to automatic theme-based wallpapers
- Each theme applies its own wallpaper
- **Mode**: Switches to "Theme" - wallpapers change with themes

## File Locations

| Path | Purpose |
|------|---------|
| `~/.local/share/bunkeros/wallpapers/` | Theme wallpapers (5 defaults) |
| `~/Pictures/Wallpapers/` | Your custom wallpapers |
| `~/.config/bunkeros/wallpaper-mode` | Current mode (theme/custom) |
| `~/.config/bunkeros/current-theme` | Current active theme |

## Workflow Examples

### Example 1: Quick Custom Wallpaper
1. Press `Super+m` → `🖼️ Wallpaper`
2. Choose `📁 Upload New Wallpaper`
3. Browse to your image
4. Click "Apply it now?" → Yes
5. **Done!** Your wallpaper is now applied and will persist across theme changes

### Example 2: Wallpaper Selection
1. Press `Super+m` → `🖼️ Wallpaper`
2. Choose `🖼️ Browse & Select Wallpaper`
3. **See a clean menu** with all wallpaper names (🎨 = theme, 📷 = custom)
4. Click on the one you want
5. **Done!** Your wallpaper is instantly applied and persists across themes

### Example 3: Return to Theme Wallpapers
1. Press `Super+m` → `🖼️ Wallpaper`
2. Choose `🎨 Use Theme Wallpapers`
3. **Done!** Wallpapers now change automatically with themes


## Technical Details

### How Modes Work

**Theme Mode** (`wallpaper-mode = theme`):
- `theme-switcher.sh` applies the wallpaper from `theme.conf`
- Each theme's `WALLPAPER` field points to its image
- Automatic wallpaper switching on theme change

**Custom Mode** (`wallpaper-mode = custom`):
- `theme-switcher.sh` skips wallpaper changes
- User's custom wallpaper persists
- Path stored in `~/.config/bunkeros/wallpaper-mode.custom-path`

### Integration with Theme System

The wallpaper manager integrates seamlessly:
- Reads theme configs to find wallpapers
- Respects user's mode preference
- Updates `swaybg` dynamically
- No config file editing required

### Menu Technology

Uses **wofi** (BunkerOS's menu system) for wallpaper browsing:
- **Familiar interface** - Same menu you use for everything else in BunkerOS
- **Already themed** - Matches BunkerOS dark aesthetic perfectly
- **Simple workflow** - Click to apply instantly, no extra steps
- **Clear indicators** - Emoji icons show theme vs. custom wallpapers
- **Reliable** - No dependencies, just works

Uses **Zenity** for file uploads:
- Native GTK dialog
- Themed with BunkerOS colors
- File type filtering (images only)
- Simple and lightweight

## Configuration

### Default Custom Wallpaper Directory

To change where uploaded wallpapers are saved, edit:
```bash
~/.config/waybar/scripts/wallpaper-manager.sh
```

Line:
```bash
CUSTOM_WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
```

### Supported Image Formats

- JPG/JPEG
- PNG
- WebP

Formats supported by `swaybg`.

## Troubleshooting

### Wallpaper not changing when switching themes
**Cause**: You're in "Custom" mode.
**Solution**: 
- `Super+m` → `🖼️ Wallpaper` → `🎨 Use Theme Wallpapers`

### Upload button does nothing
**Cause**: Zenity not installed.
**Solution**: 
```bash
sudo pacman -S zenity
```

### Wallpaper menu doesn't show
**Cause**: Issue with wofi or the script.
**Solution**: 
- Check if wofi is installed: `which wofi`
- Reload Sway config: `Super+Shift+c`
- Check script for errors: `bash -x ~/.config/waybar/scripts/wallpaper-manager.sh`

### Custom wallpaper reverts after reboot
**Cause**: Mode file not persisting or wallpaper path lost.
**Solution**: Check files exist:
```bash
cat ~/.config/bunkeros/wallpaper-mode        # Should show "custom"
cat ~/.config/bunkeros/wallpaper-mode.custom-path  # Should show image path
```

### Wallpaper looks stretched or wrong aspect ratio
**Solution**: Wallpapers are applied with `fill` mode (fills screen, may crop). To change:
Edit `wallpaper-manager.sh` and replace `fill` with:
- `fit` - Fit entire image (may have bars)
- `center` - Center image, no scaling
- `tile` - Tile the image
- `stretch` - Stretch to fit (distorts)

### No wallpapers shown in browser
**Cause**: No wallpapers in search paths.
**Solution**: 
- Upload a wallpaper first using `📁 Upload New Wallpaper`
- Or add images manually to `~/Pictures/Wallpapers/`

## Adding Wallpapers Manually

You can add wallpapers without the upload feature:

1. **Copy images** to `~/Pictures/Wallpapers/`
   ```bash
   cp ~/Downloads/myimage.jpg ~/Pictures/Wallpapers/
   ```

2. **Browse and select** via the wallpaper manager
   - `Super+m` → `🖼️ Wallpaper` → `📷 Set Custom Wallpaper`

## Command Line Usage

For advanced users, you can set wallpapers directly:

```bash
# Apply a specific wallpaper
killall swaybg
swaybg -i ~/Pictures/Wallpapers/myimage.jpg -m fill &

# Set custom mode
echo "custom" > ~/.config/bunkeros/wallpaper-mode
echo "$HOME/Pictures/Wallpapers/myimage.jpg" > ~/.config/bunkeros/wallpaper-mode.custom-path

# Return to theme mode
echo "theme" > ~/.config/bunkeros/wallpaper-mode
```

## Philosophy

The wallpaper manager embodies BunkerOS principles:

- **User-friendly**: No config file editing
- **Flexible**: Theme or custom modes
- **Visual**: Graphical browsing and uploading
- **Non-destructive**: Easy to switch back to theme wallpapers
- **Integrated**: Works seamlessly with the theme system

---

**Quick Reference**:
- Access: `Super+m → 🖼️ Wallpaper`
- Upload: `📁 Upload New Wallpaper`
- Browse & select: `🖼️ Browse & Select Wallpaper`
- Theme mode: `🎨 Use Theme Wallpapers`

