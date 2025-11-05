# BunkerOS Screensaver Critical Bug Fix

## Issues Fixed

### 1. System Never Suspends
**Root Cause**: The `swayidle -w` flag creates a systemd delay inhibitor that blocks suspend.

**Evidence**:
```bash
$ systemd-inhibit --list
...
swayidle    1000 ryan 1249591 swayidle  sleep  Swayidle is preventing sleep  delay
```

**The Fix**:
- Removed `-w` flag from swayidle configuration
- Added explicit `timeout 600 'systemctl suspend'` to swayidle
- Disabled systemd-logind's `IdleAction` to prevent conflicts

### 2. Screensaver Only Shows on One Monitor
**Root Cause**: The screensaver launched a single `foot` terminal window which only appeared on the focused monitor.

**The Fix**:
- Modified `launch-screensaver.sh` to enumerate all outputs using `swaymsg -t get_outputs`
- Launch one screensaver instance per monitor
- Use `swaymsg move to output` to position each instance correctly
- Added unique random seed per instance to vary star patterns

## Technical Details

### The `-w` Flag Problem
From the swayidle man page, the `-w` flag:
> "Wait for command to finish executing before continuing"

This seems innocent, but it creates a **delay inhibitor** in systemd-logind. Here's why this breaks suspend:

1. When swayidle runs with `-w`, it takes a delay inhibitor lock
2. The inhibitor tells systemd: "wait for me before suspending"
3. systemd-logind sees the inhibitor and never triggers its own `IdleAction`
4. Result: System never suspends automatically

### Why This Affects Modern Wayland Systems
On Wayland compositors like Sway:
- The compositor has total control over display management
- systemd-logind coordinates with the compositor for power management
- Inhibitors are respected system-wide
- You cannot bypass inhibitors without elevated privileges

### The Correct Pattern
Based on research into Omarchy, Hyprland, and other modern Linux systems:

```bash
# WRONG - Creates inhibitor
swayidle -w \
    timeout 300 'screensaver' \
    # suspend managed by systemd-logind

# RIGHT - Let swayidle handle everything
swayidle \
    timeout 300 'screensaver' \
    timeout 600 'systemctl suspend' \
    resume 'cleanup'
```

## Files Modified

### 1. `/home/ryan/Projects/bunkeros/sway/config`
**Before**:
```bash
exec_always "killall swayidle 2>/dev/null; swayidle -w \
    timeout 300 '~/.config/sway-config/scripts/launch-screensaver.sh' \
    resume 'swaymsg \"[app_id=BunkerOS-Screensaver]\" kill' \
    before-sleep 'swaymsg \"[app_id=BunkerOS-Screensaver]\" kill'"
```

**After**:
```bash
exec_always "killall swayidle 2>/dev/null; swayidle \
    timeout 300 '~/.config/sway-config/scripts/launch-screensaver.sh' \
    timeout 600 'systemctl suspend' \
    resume 'swaymsg \"[app_id=BunkerOS-Screensaver]\" kill' \
    before-sleep 'swaymsg \"[app_id=BunkerOS-Screensaver]\" kill'"
```

**Key Changes**:
- Removed `-w` flag
- Added `timeout 600 'systemctl suspend'` for automatic suspend after 10 minutes

### 2. `/home/ryan/Projects/bunkeros/scripts/launch-screensaver.sh`
**Key Changes**:
- Enumerate all outputs: `swaymsg -t get_outputs | jq -r '.[].name'`
- Launch one `foot` instance per output
- Position each instance: `swaymsg "[app_id=BunkerOS-Screensaver] move to output $OUTPUT"`

### 3. `/home/ryan/Projects/bunkeros/scripts/bunkeros-screensaver.sh`
**Key Changes**:
- Added unique random seed per instance: `RANDOM_SEED=$$`
- Ensures different star patterns on each monitor

### 4. `/home/ryan/Projects/bunkeros/systemd/logind.conf.d/bunkeros-power.conf`
**Key Changes**:
- Changed `IdleAction=suspend` to `IdleAction=ignore`
- Prevents conflict between swayidle and systemd-logind

## Testing Instructions

### Test 1: Verify No Inhibitors
```bash
# Check that swayidle doesn't create sleep inhibitors
systemd-inhibit --list | grep -i swayidle
# Should show NO "sleep" inhibitors, only possibly "idle" inhibitors
```

### Test 2: Test Screensaver (Quick)
```bash
# Edit sway config temporarily with SHORT timeouts for testing
swayidle \
    timeout 30 '~/.config/sway-config/scripts/launch-screensaver.sh' \
    timeout 60 'systemctl suspend' \
    resume 'swaymsg "[app_id=BunkerOS-Screensaver]" kill' &

# Wait 30 seconds without touching mouse/keyboard
# Expected: Screensaver appears on ALL monitors
```

### Test 3: Test Suspend (Quick)
```bash
# After screensaver appears, wait another 30 seconds
# Expected: System suspends automatically
```

### Test 4: Verify Multi-Monitor
```bash
# With multiple monitors connected:
swaymsg -t get_outputs | jq -r '.[].name'
# Note output names

# Trigger screensaver
# Expected: Each output should show the screensaver
# Bonus: Star patterns should be different on each monitor
```

### Test 5: Resume Behavior
```bash
# After system suspends:
# - Wake system (power button, mouse, etc.)
# Expected: 
#   - Screensaver windows are killed
#   - Desktop is visible
#   - No zombie processes
```

## Deployment Steps

### Option 1: Reload Sway Config (No Logout Required)
```bash
# Reload sway configuration
swaymsg reload

# Verify swayidle restarted correctly
ps aux | grep swayidle
```

### Option 2: Full Session Restart (Recommended)
```bash
# Log out and log back in
# This ensures all changes take effect cleanly
```

### Option 3: Apply Systemd Changes (For logind.conf changes)
```bash
# Copy the new logind config
sudo cp ~/Projects/bunkeros/systemd/logind.conf.d/bunkeros-power.conf \
        /etc/systemd/logind.conf.d/

# Restart systemd-logind
sudo systemctl restart systemd-logind.service

# Log out and back in (session must be recreated)
```

## Debugging Commands

### Check Current Inhibitors
```bash
systemd-inhibit --list
```

### Monitor Idle State
```bash
# Check if systemd-logind sees the session as idle
loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}' | head -1) | grep Idle
```

### Test Swayidle in Debug Mode
```bash
# Kill existing swayidle
killall swayidle

# Run with debug output
swayidle -d \
    timeout 30 'echo "Screensaver would launch now"' \
    timeout 60 'echo "Suspend would happen now"'
```

### Check Screensaver Processes
```bash
# List all screensaver instances
ps aux | grep -E '(bunkeros-screensaver|BunkerOS-Screensaver)'

# Count foot instances
pgrep -f "foot.*BunkerOS-Screensaver" | wc -l
# Should equal number of monitors when screensaver is active
```

## Known Limitations

1. **Wayland-Only**: This solution requires a wlroots-based compositor (Sway, Hyprland, River, etc.)
2. **jq Dependency**: The multi-monitor launcher requires `jq` for JSON parsing
3. **No Hot-Plug**: If you connect/disconnect monitors while screensaver is active, it won't automatically adjust

## References

This fix is based on extensive research into:
- Omarchy's hypridle implementation
- wlroots compositor patterns
- systemd-logind inhibitor system
- Wayland idle management protocols

Key insights came from:
- `ext-idle-notify-v1` Wayland protocol documentation
- systemd-logind source code analysis
- Real-world implementations in Hyprland, Sway, and River compositors

## Verification Checklist

After applying the fix, verify:

- [ ] `systemd-inhibit --list` shows NO "sleep" inhibitors from swayidle
- [ ] Screensaver appears on ALL monitors after 5 minutes
- [ ] System suspends after 10 minutes total (5 min after screensaver)
- [ ] Pressing any key exits screensaver on all monitors
- [ ] After resume from suspend, no zombie processes remain
- [ ] Different star patterns visible on each monitor

## Rollback Instructions

If you need to revert these changes:

```bash
cd ~/Projects/bunkeros
git diff sway/config
git diff scripts/launch-screensaver.sh
git diff scripts/bunkeros-screensaver.sh
git diff systemd/logind.conf.d/bunkeros-power.conf

# To revert:
git checkout sway/config
git checkout scripts/launch-screensaver.sh
git checkout scripts/bunkeros-screensaver.sh
git checkout systemd/logind.conf.d/bunkeros-power.conf

# Then reload sway
swaymsg reload
```
