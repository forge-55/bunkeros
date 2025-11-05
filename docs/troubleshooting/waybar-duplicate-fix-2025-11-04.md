# Waybar Duplication on Theme Switch - Root Cause & Fix

**Date:** November 4, 2025  
**Issue:** After fresh BunkerOS installation, switching themes creates duplicate waybar instances  
**Status:** ✅ **RESOLVED**

## Problem Summary

On fresh BunkerOS installations, when switching themes:
- Initial login shows one waybar correctly
- After changing themes, **two waybar instances appear**
- User must press `Super+Shift+R` to refresh and get back to one waybar
- This created poor user experience on new installations

## Root Cause Analysis

The issue was a **race condition in waybar restart logic**:

1. User switches themes via `theme-switcher.sh`
2. `theme-switcher.sh` calls `workspace-style-switcher.sh apply` to apply user's workspace style preference
3. `workspace-style-switcher.sh apply` restarts waybar (lines 145-147)
4. `theme-switcher.sh` **also** restarts waybar (lines 129-131)
5. This creates two waybar processes running simultaneously

### Code Flow (Before Fix)
```bash
theme-switcher.sh apply_theme()
├── Copy theme templates to user configs
├── Call workspace-style-switcher.sh apply → RESTARTS WAYBAR #1
└── Restart waybar directly → STARTS WAYBAR #2
```

## Solution Implemented

Added `--no-restart` flag to `workspace-style-switcher.sh` to prevent duplicate waybar restarts when called from theme switcher.

### Files Modified

#### 1. `scripts/workspace-style-switcher.sh`
- Added `--no-restart` parameter to `apply_workspace_style()` function
- Modified restart logic to skip waybar restart when flag is present
- Updated usage documentation

#### 2. `scripts/theme-switcher.sh`  
- Modified workspace style application to pass `--no-restart` flag
- Ensures only one waybar restart per theme switch

### Code Flow (After Fix)
```bash
theme-switcher.sh apply_theme()
├── Copy theme templates to user configs
├── Call workspace-style-switcher.sh apply --no-restart → NO RESTART
└── Restart waybar once → STARTS WAYBAR #1 ONLY
```

## Technical Details

### Before Fix
```bash
# workspace-style-switcher.sh always restarted waybar
apply_workspace_style() {
    # ... apply styles ...
    killall -q waybar
    sleep 0.5
    swaymsg exec waybar &
}
```

### After Fix
```bash
# workspace-style-switcher.sh conditionally restarts waybar
apply_workspace_style() {
    local style=$1
    local no_restart=$2
    # ... apply styles ...
    
    # Only restart if --no-restart flag is NOT set
    if [ "$no_restart" != "--no-restart" ]; then
        killall -q waybar
        sleep 0.5
        swaymsg exec waybar &
    fi
}
```

## Testing Results

✅ **Theme switching** now creates only one waybar instance  
✅ **Independent workspace style switching** still works correctly  
✅ **No manual refresh required** after theme changes  
✅ **Backward compatibility** maintained for direct workspace style switching  

## Prevention

### For Future Development
1. **Coordinate restarts**: When multiple scripts manage the same service, coordinate who does the restart
2. **Use flags/parameters**: Implement `--no-restart` or similar flags for composed operations  
3. **Single responsibility**: Consider having one script responsible for service restarts
4. **Race condition testing**: Test scenarios where multiple scripts might restart services

### Code Review Checklist
- [ ] Does this script restart any services?
- [ ] Is this script called by other scripts that also restart services?
- [ ] Should restart behavior be configurable?
- [ ] Are there timing considerations for service restarts?

## Commit Reference

**Files Changed:**
- `scripts/workspace-style-switcher.sh` - Added `--no-restart` flag
- `scripts/theme-switcher.sh` - Use `--no-restart` when calling workspace style switcher

**Behavior Change:**
- Theme switching now performs only one waybar restart instead of two
- Eliminates race condition that caused duplicate waybar instances