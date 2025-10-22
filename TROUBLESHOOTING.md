# Troubleshooting Guide

This document covers common issues encountered during BunkerOS installation and use.

## Installation Issues

### Issue: Apps from AUR (VS Code, Cursor) show in launcher but won't open

**Symptoms:**
- App appears in application launcher (Super+Space)
- Clicking the app does nothing, or app crashes immediately
- No error messages visible

**Root Cause:**
Electron-based apps require proper Wayland environment variables to function correctly. Without these variables, the apps fail to initialize their window system.

**Solution:**
This issue is now fixed in BunkerOS. The fix includes:

1. **Environment variables** - Automatically configured in `~/.config/environment.d/10-bunkeros-wayland.conf`
2. **Launch script environment** - Both `launch-bunkeros-standard.sh` and `launch-bunkeros-enhanced.sh` now export Wayland variables
3. **Desktop portal support** - `xdg-desktop-portal-wlr` and `xdg-desktop-portal-gtk` are now installed by default

**To apply the fix on existing installations:**
```bash
cd ~/Projects/bunkeros  # or wherever you cloned BunkerOS
git pull
./setup.sh
# Log out and log back in
```

**To verify the fix:**
```bash
# Check environment variables are set
echo $XDG_CURRENT_DESKTOP  # Should show: sway
echo $ELECTRON_OZONE_PLATFORM_HINT  # Should show: auto

# Try launching VS Code from terminal
code
# Should open without errors
```

---

### Issue: Login goes to TTY instead of graphical login screen

**Symptoms:**
- After reboot, you see a text-based login (TTY)
- Must type `sway` manually to start the desktop
- SDDM doesn't start automatically

**Root Cause:**
SDDM service was not enabled during installation.

**Solution:**
This issue is now fixed - SDDM is automatically enabled during installation. For existing installations:

```bash
# Enable SDDM
sudo systemctl enable sddm.service

# Start it now (or reboot)
sudo systemctl start sddm.service
```

**To verify SDDM is enabled:**
```bash
systemctl is-enabled sddm.service
# Should output: enabled
```

**Alternative: If you prefer TTY login**
If you want to keep manual login and skip SDDM:
```bash
# Disable SDDM
sudo systemctl disable sddm.service
sudo systemctl stop sddm.service

# Add to ~/.bash_profile or ~/.zprofile:
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec ~/Projects/bunkeros/scripts/launch-bunkeros-standard.sh
fi
```

---

### Issue: Enabling SDDM "breaks everything"

**Symptoms:**
- After enabling SDDM, login fails or desktop doesn't start properly
- Getting back to TTY is difficult

**Root Cause:**
Session files were pointing to hardcoded paths that don't exist on other systems, or missing environment variables caused session startup failures.

**Solution:**
This is now fixed in BunkerOS. The fixes include:

1. **Launch scripts copied to system location** - Scripts are now in `/usr/local/bin/` instead of user-specific paths
2. **Dynamic BunkerOS directory detection** - Enhanced edition launcher finds BunkerOS repo automatically
3. **Proper environment variable export** - All necessary Wayland variables are set during session startup

**If you're stuck at a broken SDDM:**

1. **Switch to TTY:** Press `Ctrl+Alt+F2` (or F3, F4, etc.)
2. **Login with your username and password**
3. **Disable SDDM temporarily:**
   ```bash
   sudo systemctl disable sddm.service
   sudo systemctl stop sddm.service
   reboot
   ```
4. **After reboot, update BunkerOS:**
   ```bash
   cd ~/Projects/bunkeros
   git pull
   ./install.sh
   ```
5. **Re-enable SDDM:**
   ```bash
   sudo systemctl enable sddm.service
   reboot
   ```

---

## Runtime Issues

### Issue: Application file dialogs look broken or basic

**Solution:**
Install desktop portal packages (now included by default):
```bash
sudo pacman -S xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk
cd ~/Projects/bunkeros/xdg-desktop-portal
./install.sh
```

Restart the portal service:
```bash
pkill -f xdg-desktop-portal
# Reopen your application
```

---

### Issue: Screen sharing doesn't work in video calls

**Solution:**
1. Verify PipeWire is running:
   ```bash
   systemctl --user status pipewire pipewire-pulse wireplumber
   ```

2. Configure browsers:
   ```bash
   ~/Projects/bunkeros/scripts/configure-browser-wayland.sh
   ```

3. Restart your browser

See `VIDEOCONFERENCING.md` for detailed troubleshooting.

---

### Issue: Themes not applying correctly

**Solution:**
```bash
# Run theme switcher
Super+Shift+T
# Or from terminal:
~/.local/bin/theme-switcher.sh

# Reload Sway
Super+Shift+R
```

---

### Issue: Keybindings not working

**Solution:**
1. Check if there's a syntax error in sway config:
   ```bash
   sway -C ~/.config/sway/config
   ```

2. If config is valid, reload Sway:
   ```bash
   Super+Shift+R
   ```

3. Check for conflicting keybindings:
   ```bash
   grep "bindsym" ~/.config/sway/config | sort
   ```

---

## Post-Installation Checklist

After installing BunkerOS, verify these items:

- [ ] SDDM login screen appears at boot
- [ ] Can select BunkerOS session at login
- [ ] Desktop loads with Waybar at bottom
- [ ] Super+Space opens application launcher
- [ ] VS Code/Cursor launches (if installed)
- [ ] File dialogs work in applications
- [ ] Audio works (test with Super+C for calculator, check system sounds)
- [ ] Screen brightness controls work (if laptop)
- [ ] Volume controls work

---

## Getting Help

### Collecting Debug Information

When reporting issues, include:

```bash
# System info
uname -a
pacman -Q | grep -E "sway|wayland|electron"

# Environment check
echo "XDG_CURRENT_DESKTOP: $XDG_CURRENT_DESKTOP"
echo "WAYLAND_DISPLAY: $WAYLAND_DISPLAY"
echo "ELECTRON_OZONE_PLATFORM_HINT: $ELECTRON_OZONE_PLATFORM_HINT"

# SDDM status
systemctl status sddm.service

# Session files
ls -la /usr/share/wayland-sessions/bunkeros*

# Launch scripts
ls -la /usr/local/bin/launch-bunkeros*

# Sway config validation
sway -C ~/.config/sway/config
```

### Logs to Check

```bash
# Sway log (if running)
journalctl --user -u sway -b

# SDDM log
journalctl -u sddm -b

# X/Wayland session errors
cat ~/.local/share/sway/sway.log

# System logs
journalctl -b | tail -100
```

---

## Related Documentation

- `INSTALL.md` - Installation instructions
- `VIDEOCONFERENCING.md` - Video call troubleshooting
- `environment.d/README.md` - Environment variable details
- `xdg-desktop-portal/README.md` - Desktop portal configuration
- `ARCHITECTURE.md` - System design and structure
