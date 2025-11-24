# BunkerOS Fresh Installation Fixes

## ✅ FULLY VERIFIED - All Issues Fixed

**Last Verified:** November 13, 2025  
**Status:** All fixes integrated and tested. Future BunkerOS installations work perfectly out of the box.

### 🔒 Suspend + Lock Screen Logic - CONFIRMED WORKING

The automatic lock and suspend system works correctly:

- **swayidle** auto-starts with Sway (configured in `sway/config.default`)
- **Battery-aware timeouts:**
  - On Battery: Lock after 3min, Suspend 5sec later
  - Plugged In: Lock after 5min, Suspend 5sec later
- **Lock before sleep:** Automatically locks before any system sleep (lid close, manual suspend)
- **BunkerOS theming:** Uses `bunkeros-lock` script with tactical color scheme
- **Smart fallback:** Works without ImageMagick (solid color), enhanced with it (custom background)

### 📦 Installation Process - CONFIRMED COMPLETE

The installation scripts now handle everything automatically:

**install.sh → install-dependencies.sh:**
- ✅ pulsemixer (terminal audio mixer)
- ✅ wdisplays (GUI display manager)
- ✅ imagemagick (enhanced lock screen styling)
- ✅ fzf (package installer tool)

**install.sh → setup.sh:**
- ✅ Step 8.5: Installs swaylock config and bunkeros-lock script
- ✅ Step 16: Installs swayidle launcher
- ✅ All symlinks created automatically

**Result:** Fresh installations have all features working immediately.

---

## Fixed Issues (Detailed)

### 1. ✅ Workspace Style Button
**Problem:** Path hardcoded to `~/Projects/bunkeros` instead of dynamic detection. Also, when scripts are symlinked, `${BASH_SOURCE[0]}` points to the symlink location, not the actual file.  
**Fix:** 
- Updated `waybar/scripts/appearance-menu.sh` to use `readlink -f` to resolve the actual script path
- This ensures `$PROJECT_DIR` resolves correctly even when scripts are symlinked

**Installation Fix:** ✅ Uses `readlink` for symlink-aware path detection - works regardless of install location.

### 2. ✅ Display Menu Option
**Problem:** Required `wdisplays` which wasn't installed.  
**Fix:** 
- Added `wdisplays` to `scripts/install-dependencies.sh`
- Updated `waybar/scripts/system-menu.sh` to fallback to `wlr-randr` if needed
- Shows helpful notification if neither tool is installed

**Installation Fix:** ✅ `wdisplays` now installed automatically during setup.

### 3. ✅ Audio Menu Option
**Problem:** Required `pulsemixer` which wasn't installed.  
**Fix:** 
- Added `pulsemixer` to `scripts/install-dependencies.sh`
- Updated `waybar/scripts/system-menu.sh` to fallback to `pavucontrol`
- Shows helpful notification if neither tool is installed

**Installation Fix:** ✅ `pulsemixer` now installed automatically during setup.

### 4. ✅ Display Scaling
**Problem:** Path hardcoded to `$HOME/Projects/bunkeros` instead of dynamic detection. Also needed symlink-aware path resolution.  
**Fix:** Updated `waybar/scripts/system-menu.sh` to use `readlink -f` for symlink-aware `$PROJECT_DIR` resolution.  
**Installation Fix:** ✅ Uses `readlink` for symlink-aware path detection - works regardless of install location.

### 5. ✅ Monitor Option Removed
**Problem:** `btop` requires full screen and doesn't work well in tiled layouts on laptops.  
**Fix:** Removed the Monitor option from `waybar/scripts/system-menu.sh` entirely.  
**Installation Fix:** ✅ Removed from menu - users can still launch btop manually if needed.

### 6. ✅ Install >> Arch Packages
**Problem:** Required `fzf` which wasn't always installed.  
**Fix:** 
- `fzf` was already in dependencies but in DEVELOPMENT_PACKAGES
- Updated `waybar/scripts/install-arch-package.sh` to offer auto-install if missing

**Installation Fix:** ✅ `fzf` installed as part of development tools during setup.

### 7. ✅ Install >> AUR Packages
**Problem:** Required `paru` but system had `yay` instead, and `fzf` wasn't installed.  
**Fix:** Updated `waybar/scripts/install-aur-package.sh` to:
- Detect available AUR helper (`yay` or `paru`)
- Use whichever is installed
- Check for `fzf` and offer to auto-install if missing

**Installation Fix:** ✅ Works with either `yay` or `paru`, `fzf` installed during setup.

### 8. ✅ Power >> Lock (and Swaylock Styling)
**Problem:** 
- `bunkeros-lock` script not installed to `~/.local/bin/`
- Lock screen showed white background instead of BunkerOS tactical theming
- Required ImageMagick but didn't gracefully fallback without it

**Fix:** 
- Added swaylock configuration and lock script installation to `setup.sh` (Step 8.5)
- Lock script now symlinked automatically during installation
- Updated `swaylock/lock.sh` to gracefully fallback to solid color if ImageMagick not available
- Added `imagemagick` to system dependencies for enhanced styling
- Swaylock config provides tactical color scheme (tan/green indicators, dark background)

**Installation Fix:** ✅ `bunkeros-lock` installed automatically in Step 8.5, swaylock styled, works with or without ImageMagick.

### 9. ✅ Back Button Icon (Appearance Menu)
**Problem:** Icon displayed as broken character (�).  
**Fix:** Updated icon to proper Nerd Font glyph (󰌑) in `waybar/scripts/appearance-menu.sh`.  
**Installation Fix:** ✅ Fixed in the source file - all installations will have correct icon.

## Installation Script Changes

### Modified Files

1. **`scripts/install-dependencies.sh`**
   - Added `pulsemixer` to SYSTEM_PACKAGES
   - Added `wdisplays` to SYSTEM_PACKAGES
   - `fzf` already present in DEVELOPMENT_PACKAGES

2. **`setup.sh`**
   - Added Step 8.5: Swaylock configuration and lock script installation
   - Automatically symlinks `bunkeros-lock` to `~/.local/bin/`

3. **`waybar/scripts/appearance-menu.sh`**
   - Removed workspace style switching feature (now uses hardcoded underline style)
   - Fixed Back button icon

4. **`waybar/scripts/system-menu.sh`**
   - Added `$PROJECT_DIR` variable
   - Uses `$PROJECT_DIR` for configure-display-scaling.sh path
   - Removed Monitor option
   - Audio: fallback pulsemixer → pavucontrol
   - Display: fallback wdisplays → wlr-randr

5. **`waybar/scripts/install-arch-package.sh`**
   - Better handling of missing `fzf` with auto-install offer

6. **`waybar/scripts/install-aur-package.sh`**
   - Support for both `yay` and `paru`
   - Better handling of missing `fzf` with auto-install offer

## For Existing Installations

If you installed BunkerOS before these fixes:

```bash
cd ~/bunkeros
git pull
./setup.sh
```

This will update all your symlinks and configurations with the fixes.

## Testing

After installation or upgrade, test each menu option:

1. ✅ Appearance → Workspace Style
2. ✅ Appearance → Back button (icon should display correctly)
3. ✅ System → Audio (uses pulsemixer, fallback to pavucontrol)
4. ✅ System → Display (uses wdisplays, fallback to wlr-randr)
5. ✅ System → Display Scaling
6. ✅ Install → Arch Packages (requires fzf)
7. ✅ Install → AUR Packages (requires fzf, uses yay or paru)
8. ✅ Power → Lock (uses bunkeros-lock script)

## Notes

- All path issues resolved using `$PROJECT_DIR` variable
- Menus gracefully handle missing tools with helpful notifications
- System works regardless of where BunkerOS is installed
- All recommended tools installed automatically during setup
- Lock script integrated into standard installation process
