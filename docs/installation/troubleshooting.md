# BunkerOS Installation Troubleshooting Guide

This guide covers common installation issues and their solutions.

## Table of Contents

1. [HDMI/DRM Atomic Commit Errors During Installation](#hdmidrm-atomic-commit-errors-during-installation)
2. [Black Screen on Login](#black-screen-on-login)
3. [Atomic Operation Errors](#atomic-operation-errors)
4. [Session Not Listed at Login](#session-not-listed-at-login)
5. [Sway Configuration Errors](#sway-configuration-errors)
6. [Audio Not Working](#audio-not-working)
7. [Display Manager Issues](#display-manager-issues)
8. [Environment Variables Not Set](#environment-variables-not-set)
9. [Package Installation Failures](#package-installation-failures)

## HDMI/DRM Atomic Commit Errors During Installation

### Symptoms
- During installation, you see errors like:
  ```
  00:00:00.001 [ERROR] [wlr] [backend/drm/drm.c:464] Failed to open DRM device
  00:00:00.002 [ERROR] [wlr] [types/wlr_output.c:689] Atomic commit failed
  00:00:00.003 [ERROR] [wlr] [types/wlr_output.c:689] HDMI-A-1 connector: permission denied
  ```
- Hundreds of similar messages scroll by
- Installation completes but you're worried

### Cause
These errors are **COMPLETELY NORMAL** and **HARMLESS** during installation. They occur when:
- Running `sway --validate` to check configuration syntax
- Sway tries to probe display hardware but you're not in a graphical session
- The installer is run from a TTY or SSH session
- SDDM is checking available sessions

### Why This Happens
Wayland compositors (like Sway) need direct access to display hardware (DRM devices). When validating configuration outside of an active graphical session:
- The user doesn't have active access to `/dev/dri/cardX` 
- Sway can still validate configuration syntax
- But it can't initialize actual display output
- These permission/atomic commit errors are expected

### Solution
**No action needed!** These errors are cosmetic and don't affect:
- Configuration validation
- Installation success  
- Ability to login and use BunkerOS

The installer now filters these out and only shows actual syntax errors.

### Verification
After installation, when you actually log into BunkerOS session:
- Sway will have proper access to display hardware
- No permission errors will occur
- Display will work normally

**Bottom line**: If installation completes and validation passes, ignore these DRM errors during installation.

## Black Screen on Login

### Symptoms
- Login screen appears
- Enter credentials
- Screen goes black
- No desktop appears
- May return to login screen

### Causes
1. Sway configuration syntax errors
2. Missing required packages
3. Launch script not executable
4. Environment variables not set correctly

### Solutions

#### Solution 1: Use Emergency Recovery Session
1. At the login screen, select "BunkerOS Emergency" instead of "BunkerOS"
2. This will boot to a terminal
3. Run the validation script:
   ```bash
   ~/Projects/bunkeros/scripts/validate-installation.sh
   ```
4. Follow the fix commands provided

#### Solution 2: Check Sway Configuration
```bash
# Validate Sway config
sway --validate

# If errors found, check the config file
nano ~/.config/sway/config

# Compare with default
diff ~/.config/sway/config ~/Projects/bunkeros/sway/config.default
```

#### Solution 3: Check Launch Logs
```bash
# View launch script logs
cat /tmp/bunkeros-launch.log

# View Sway logs
journalctl --user -b | grep sway
```

#### Solution 4: Reinstall Configuration
```bash
cd ~/Projects/bunkeros
./setup.sh
```

## Atomic Operation Errors

### Symptoms
- Hundreds of error messages about "atomic operations"
- Errors about "operation not permitted"
- Session fails to start properly

### Cause
The `~/.config/environment.d/10-bunkeros-wayland.conf` file is a symlink. Systemd's `systemd-environment-d-generator` cannot read symlinked environment files due to security restrictions.

### Solution
```bash
# Remove symlink and copy the file instead
rm ~/.config/environment.d/10-bunkeros-wayland.conf
cp ~/Projects/bunkeros/environment.d/10-bunkeros-wayland.conf ~/.config/environment.d/

# Verify it's a regular file, not a symlink
file ~/.config/environment.d/10-bunkeros-wayland.conf
# Should output: "ASCII text" not "symbolic link"
```

**Note**: The latest installer (post-fix) automatically copies this file instead of symlinking it.

## Session Not Listed at Login

### Symptoms
- "BunkerOS" option doesn't appear in session dropdown at login screen
- Only default sessions available (Plasma, GNOME, etc.)

### Cause
SDDM session files not installed to system directories

### Solution
```bash
cd ~/Projects/bunkeros/sddm
sudo ./install-theme.sh

# Verify installation
ls -l /usr/share/wayland-sessions/bunkeros*.desktop
ls -l /usr/local/bin/launch-bunkeros*.sh

# Restart SDDM
sudo systemctl restart sddm.service
```

## Sway Configuration Errors

### Symptoms
- Error messages when logging in
- Sway fails to start
- Specific features not working

### Diagnosis
```bash
# Validate configuration
sway --validate

# Check for specific errors
sway --validate 2>&1 | less
```

### Common Configuration Issues

#### Missing Default Applications Config
```bash
# Ensure defaults.conf exists
ls -l ~/.config/bunkeros/defaults.conf

# If missing, copy from template
cp ~/Projects/bunkeros/bunkeros/defaults.conf ~/.config/bunkeros/
```

#### Wallpaper Path Issues
```bash
# Check wallpaper exists
ls -l ~/.local/share/bunkeros/wallpapers/

# If missing
ln -sf ~/Projects/bunkeros/wallpapers ~/.local/share/bunkeros/wallpapers
```

#### Missing Config Includes
```bash
# Check multi-monitor configs
ls ~/.config/sway/config.d/

# If missing
cp ~/Projects/bunkeros/sway/config.d/*.conf ~/.config/sway/config.d/
```

## Audio Not Working

### Symptoms
- No sound output
- Audio controls don't work
- Microphone not detected

### Cause
PipeWire services not enabled or running

### Solution
```bash
# Enable and start PipeWire services
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service
systemctl --user enable --now wireplumber.service

# Check service status
systemctl --user status pipewire.service
systemctl --user status pipewire-pulse.service
systemctl --user status wireplumber.service

# Check audio devices
pactl info
pactl list sinks
pactl list sources

# Test audio
speaker-test -c 2
```

### Advanced Audio Troubleshooting
```bash
# Restart all audio services
systemctl --user restart pipewire.service pipewire-pulse.service wireplumber.service

# Check for conflicts with PulseAudio
ps aux | grep pulseaudio
# If PulseAudio is running, kill it:
killall pulseaudio

# View detailed logs
journalctl --user -u pipewire.service -n 50
journalctl --user -u wireplumber.service -n 50
```

## Display Manager Issues

### SDDM Not Starting

#### Check service status
```bash
systemctl status sddm.service

# If not enabled
sudo systemctl enable sddm.service

# If failed to start, check logs
journalctl -u sddm.service -n 50
```

#### Multiple Display Managers Conflict
```bash
# List all display managers
systemctl list-unit-files | grep dm

# Disable old display manager (example: gdm)
sudo systemctl disable gdm.service

# Enable SDDM
sudo systemctl enable sddm.service
```

### SDDM Theme Not Applied

```bash
# Check SDDM configuration
cat /etc/sddm.conf | grep -A 2 "\[Theme\]"

# Should show:
# [Theme]
# Current=tactical

# If not, reinstall
cd ~/Projects/bunkeros/sddm
sudo ./install-theme.sh
```

## Environment Variables Not Set

### Symptoms
- Electron apps (VS Code, Cursor) show X11 warnings
- Screen sharing doesn't work
- Qt apps look wrong

### Diagnosis
```bash
# Check if environment.d file exists
ls -l ~/.config/environment.d/10-bunkeros-wayland.conf

# Verify it's not a symlink
file ~/.config/environment.d/10-bunkeros-wayland.conf

# Check variables in current session
echo $XDG_CURRENT_DESKTOP
echo $QT_QPA_PLATFORM
echo $MOZ_ENABLE_WAYLAND
```

### Solution
```bash
# Ensure file is copied, not symlinked
rm ~/.config/environment.d/10-bunkeros-wayland.conf
cp ~/Projects/bunkeros/environment.d/10-bunkeros-wayland.conf ~/.config/environment.d/

# Log out and log back in for changes to take effect
```

## Package Installation Failures

### Pacman Database Locked
```bash
# Check for lock file
ls -l /var/lib/pacman/db.lck

# If exists and no pacman is running, remove it
sudo rm /var/lib/pacman/db.lck

# Update database
sudo pacman -Sy
```

### Package Conflicts
```bash
# If packages conflict, try --overwrite
sudo pacman -S --overwrite='*' <package-name>

# For desktop portal conflicts specifically
sudo pacman -S --overwrite='*' xdg-desktop-portal-wlr xdg-desktop-portal-gtk
```

### AUR Helper Not Installed
```bash
# Install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### Missing Dependencies
```bash
# Run dependency verification
~/Projects/bunkeros/scripts/verify-packages.sh

# Install all core packages at once
sudo pacman -S --needed sway autotiling-rs waybar wofi mako foot \
    swaylock swayidle swaybg brightnessctl playerctl wl-clipboard \
    grim slurp wlsunset network-manager-applet blueman pavucontrol \
    nautilus sushi eog evince lite-xl btop mate-calc zenity \
    pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber \
    v4l-utils sddm qt5-declarative qt5-quickcontrols2 ttf-meslo-nerd \
    xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
    python-pipx jq
```

## Complete Reinstall

If all else fails, perform a complete reinstall:

```bash
# 1. Rollback current installation
cd ~/Projects/bunkeros
./scripts/rollback-installation.sh

# 2. Clean install
./install.sh

# 3. Validate
./scripts/validate-installation.sh

# 4. Log out and log back in
```

## Getting Help

If you're still experiencing issues:

1. **Run the validation script** and save the output:
   ```bash
   ~/Projects/bunkeros/scripts/validate-installation.sh > ~/bunkeros-validation.txt
   ```

2. **Collect logs**:
   ```bash
   journalctl --user -b > ~/bunkeros-user-logs.txt
   cat /tmp/bunkeros-launch.log > ~/bunkeros-launch-logs.txt
   sway --validate &> ~/bunkeros-sway-validation.txt
   ```

3. **Open an issue** on GitHub with:
   - Your distribution and version (`cat /etc/os-release`)
   - Validation output
   - Relevant log files
   - Description of the problem

4. **Check existing issues** at https://github.com/forge-55/bunkeros/issues
