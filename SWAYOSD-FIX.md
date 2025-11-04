# Quick Fix for SwayOSD "LibInput Backend isn't available" Error

## Problem
After running `setup.sh`, SwayOSD shows error: "SwayOSD LibInput Backend isn't available, waiting..."

## Root Cause
Your user is not in the `input` group, which is required for SwayOSD to access input devices.

## Immediate Fix

```bash
# Add your user to the input group
sudo usermod -a -G input $USER

# Log out completely and log back in
# (Group changes only take effect after re-login)

# Verify you're in the group after logging back in
groups | grep input
```

## Prevention
This is now fixed in the installer. Future installations will automatically add users to the `input` group.

## What Happened

You ran `setup.sh` which still had old SDDM installation code. This has been removed. The correct flow is now:

1. `./install.sh` - Installs everything including adding to input group
2. `sway` - Test it works
3. `./install-sddm.sh` - Install SDDM separately

## If You Already Installed SDDM

If you accepted the SDDM installation prompt in `setup.sh` and things are broken:

### Option 1: Complete the Installation Properly

```bash
# Fix the input group issue
sudo usermod -a -G input $USER

# Log out and back in (REQUIRED)
# Then verify SwayOSD works

# Run the proper installer to ensure everything is configured
cd ~/Projects/bunkeros
./install.sh

# This will complete any missing steps
```

### Option 2: Rollback and Start Fresh

```bash
# Disable SDDM if it was enabled
sudo systemctl disable sddm.service

# Remove SDDM if you don't want it yet
sudo pacman -Rns sddm qt5-declarative qt5-quickcontrols2

# Fix input group
sudo usermod -a -G input $USER

# Log out and back in

# Run the proper two-phase installation
cd ~/Projects/bunkeros
./install.sh           # Phase 1
sway                   # Test
./install-sddm.sh      # Phase 2 (when ready)
```

## Verification

After fixing and logging back in:

```bash
# Check you're in input group
groups | grep input

# Test SwayOSD
# Adjust volume with media keys or:
pactl set-sink-volume @DEFAULT_SINK@ +5%
# You should see a volume overlay

# If still broken, check logs
journalctl --user -u swayosd -n 50
```

## Notes

- **setup.sh is now fixed** - it no longer prompts for SDDM installation
- **install.sh handles input group** - via install-user-environment.sh
- **You MUST log out and back in** - group changes don't apply to running sessions
