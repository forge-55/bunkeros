# BunkerOS Fresh Installation Fixes

This document summarizes the fixes applied to resolve broken menu features on a fresh BunkerOS installation.

## ✅ All Issues Fixed for Future Installations

**Status:** All fixes have been integrated into the main installation scripts. Future BunkerOS installations will have all these features working out of the box.

## Fixed Issues

### 1. ✅ Workspace Style Button
**Problem:** Path hardcoded to `~/Projects/bunkeros` instead of dynamic detection.  
**Fix:** Updated `waybar/scripts/appearance-menu.sh` to use `$PROJECT_DIR` variable.  
**Installation Fix:** ✅ Uses dynamic path detection - works regardless of install location.

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
**Problem:** Path hardcoded to `$HOME/Projects/bunkeros` instead of dynamic detection.  
**Fix:** Updated `waybar/scripts/system-menu.sh` to use `$PROJECT_DIR` variable.  
**Installation Fix:** ✅ Uses dynamic path detection - works regardless of install location.

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

### 8. ✅ Power >> Lock
**Problem:** `bunkeros-lock` script not installed to `~/.local/bin/`.  
**Fix:** 
- Added swaylock configuration and lock script installation to `setup.sh`
- Lock script now symlinked automatically during installation

**Installation Fix:** ✅ `bunkeros-lock` now installed automatically in Step 8.5 of setup.sh.

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
   - Uses `$PROJECT_DIR` for workspace-style-switcher.sh path
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

### New Files

- **`scripts/install-missing-tools.sh`** - Helper script for existing installations to install missing optional tools

## For Existing Installations

If you installed BunkerOS before these fixes, you have two options:

### Option 1: Install Missing Tools Only
```bash
~/bunkeros/scripts/install-missing-tools.sh
```

This will install:
- `fzf` (required for package installers)
- `pulsemixer` (terminal audio mixer)
- `wdisplays` (GUI display manager)

The menu scripts already have the fixes, so after installing the tools, everything will work.

### Option 2: Re-run Setup (Recommended)
```bash
cd ~/bunkeros
git pull
./setup.sh
```

This will update all your symlinks and install the lock script automatically.

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
