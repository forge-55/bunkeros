# BunkerOS Power Management Simplification

## Summary

Removed the custom screensaver feature and simplified power management to use a straightforward swayidle-based approach with automatic lock and suspend.

## What Was Removed

### Files Deleted
- `scripts/bunkeros-screensaver.sh` - Custom terminal-based screensaver
- `scripts/launch-screensaver.sh` - Multi-monitor screensaver launcher
- `scripts/test-screensaver-fix.sh` - Screensaver testing script
- `scripts/quick-test-screensaver.sh` - Quick screensaver test script
- `docs/troubleshooting/SCREENSAVER-FIX-FINAL.md` - Screensaver troubleshooting docs

### Dependencies Removed
- TerminalTextEffects (Python package via pipx)
- References from installation scripts
- Menu options from waybar scripts

## What Was Added

### New File
- `scripts/launch-swayidle.sh` - Battery-aware idle management launcher
  - 3 minutes on battery → lock → suspend
  - 5 minutes plugged in → lock → suspend
  - Automatically detects power state
  - Locks before any sleep event (lid close, manual suspend)

## Architecture Changes

### Before (Complex)
```
User Idle (5 min)
    ↓
Screensaver launches (multi-monitor, terminal-based)
    ↓
User Idle continues (10 min total)
    ↓
Lock screen activates
    ↓
System suspends (5 seconds later)
```

**Issues:**
- Custom screensaver was unreliable
- Complex multi-monitor logic
- Never worked perfectly
- Added unnecessary complexity

### After (Simple)
```
User Idle (timeout based on power state)
    ↓
Lock screen activates immediately
    ↓
System suspends (5 seconds later)
```

**Benefits:**
- ✅ Much simpler architecture
- ✅ More reliable
- ✅ Battery-aware (different timeouts)
- ✅ Less code to maintain
- ✅ Faster response
- ✅ Standard approach used by other compositors

## Configuration

### Default Timeouts

**On Battery:**
- 180 seconds (3 min) idle → Lock
- 185 seconds → Suspend

**Plugged In:**
- 300 seconds (5 min) idle → Lock
- 305 seconds → Suspend

### Customization

Edit `~/Projects/bunkeros/scripts/launch-swayidle.sh`:

```bash
# Change these values (in seconds)
LOCK_TIMEOUT=180      # Time until lock
SUSPEND_TIMEOUT=185   # Time until suspend (usually LOCK_TIMEOUT + 5)
```

Then reload Sway: `Super+Shift+R`

### Disable Auto-Suspend

To keep auto-lock but disable auto-suspend, edit `launch-swayidle.sh` and comment out the suspend timeout:

```bash
exec swayidle -w \
    timeout $LOCK_TIMEOUT "$HOME/.local/bin/bunkeros-lock" \
    # timeout $SUSPEND_TIMEOUT 'systemctl suspend' \
    before-sleep "$HOME/.local/bin/bunkeros-lock"
```

## Manual Lock

You can manually lock the screen anytime:
- **Via menu:** Power Menu → Lock
- **Via command:** `~/.local/bin/bunkeros-lock`
- **Keybinding:** Add to Sway config if desired

## Files Modified

### Core Configuration
- `sway/config.default` - Removed screensaver window rules, simplified idle config
- `scripts/launch-swayidle.sh` - NEW: Battery-aware idle management
- `systemd/logind.conf.d/bunkeros-power.conf` - Updated comments to reflect new approach

### Installation Scripts
- `setup.sh` - Updated to symlink swayidle launcher instead of screensaver scripts
- `scripts/install-dependencies.sh` - Removed TerminalTextEffects installation
- `scripts/list-all-packages.sh` - Removed TerminalTextEffects from package list
- `install.sh` - Removed TerminalTextEffects installation step

### Menu Scripts
- `waybar/scripts/power-menu.sh` - Replaced "Screensaver" with "Lock" option
- `waybar/scripts/quick-menu.sh` - Removed screensaver option
- `waybar/scripts/actions-menu.sh` - Replaced "Screensaver" with "Lock Screen"

### Documentation
- `docs/features/power-management.md` - Completely rewritten for new approach
- `docs/troubleshooting/emergency-recovery.md` - Updated disable instructions
- `docs/TODO.md` - Marked screensaver/suspend issue as completed
- `scripts/README.md` - Replaced screensaver section with idle management section
- `waybar/scripts/MENU-SYSTEM.md` - Updated power menu documentation
- `tmux/README.md` - Minor update to integration notes

## Testing the New System

### Quick Test
1. Don't touch keyboard/mouse for configured timeout (3 or 5 minutes)
2. Lock screen should appear
3. System should suspend ~5 seconds later
4. Wake system (press power button)
5. You should be at lock screen - enter password to unlock

### Verify swayidle is Running
```bash
ps aux | grep swayidle
# Should show: swayidle -w timeout ... bunkeros-lock ... systemctl suspend ... before-sleep ...
```

### Check Current Power State
```bash
~/Projects/bunkeros/scripts/launch-swayidle.sh
# Will show current timeouts based on battery/AC state
```

## Rollback Instructions

If you need to rollback to the previous screensaver-based approach:

1. Check out the previous commit before this change
2. Restore deleted screensaver scripts
3. Install TerminalTextEffects: `pipx install terminaltexteffects`
4. Restore old Sway config
5. Reload Sway: `Super+Shift+R`

However, the new approach is recommended for reliability and simplicity.
