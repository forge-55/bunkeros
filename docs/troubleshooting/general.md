# Troubleshooting Guide

This document covers common issues encountered during BunkerOS installation and use.

## Critical Issues

### 🚨 Keybindings Not Working / Can't Open Terminal

**Symptoms:**
- Logged into BunkerOS but keybindings don't work
- `Super+t` or `Super+Return` don't open terminal
- Can't access applications or menus

**EASIEST FIX: Use Emergency Mode**

1. **Logout** (if needed, reboot and wait at login screen)
2. At SDDM login screen, click the **session selector** (usually top-right or bottom-left)
3. Select **"BunkerOS Emergency Terminal"**
4. Login with your password
5. You'll boot into a fullscreen terminal with instructions
6. Run the fix command:
   ```bash
   cd ~/Projects/bunkeros && ./setup.sh
   ```
7. Press `Super+Shift+e` to logout
8. Select "BunkerOS" (normal) at login screen
9. Login - everything should work!

**Alternative: Use TTY** (if Emergency Mode isn't available)

**Important:** TTY shortcuts only work AFTER logging in, not at the SDDM login screen!
1. Press `Ctrl+Alt+F2` to switch to TTY
2. Login with username/password
3. Run the fix command:
```bash
cd ~/Projects/bunkeros
./setup.sh
```
4. Press `Ctrl+Alt+F1` to return to Sway
5. Press `Super+Shift+r` to reload configuration

**Option 3: Manual Emergency Terminal**
1. Press `Ctrl+Alt+F2` (switch to TTY)
2. Login
3. Run: `WAYLAND_DISPLAY=wayland-1 foot &`
4. Press `Ctrl+Alt+F1` to return

**Root Cause:**
The `~/.config/bunkeros/defaults.conf` file is missing or wasn't created during setup.

**Permanent Fix:**
```bash
# From terminal or TTY
cd ~/Projects/bunkeros
./setup.sh

# Then reload Sway
# Press Super+Shift+r
# OR from terminal: swaymsg reload
```

**What This Does:**
Creates `~/.config/bunkeros/defaults.conf` with proper application defaults, which the Sway config needs to function.

---

### 🚨 Black Screen After SDDM Login (No Signal)

**Symptoms:**
- SDDM login screen works fine
- After entering password, screen goes black
- Monitor displays "No Signal"
- Computer is still running

**Immediate Fix:**
1. Press `Ctrl+Alt+F2` to switch to TTY
2. Login with your username and password
3. Run: `which sway` to check if Sway is installed
4. If not found, install it: `sudo pacman -S sway`
5. If found, test manually: `sway`

**Common Causes:**
- Sway not installed or not in PATH
- Missing dependencies
- Sway config syntax errors
- Session files not properly installed

**Full diagnostic and fix guide:** See [TROUBLESHOOTING-SDDM.md](TROUBLESHOOTING-SDDM.md)

**Quick Reinstall:**
```bash
```bash
# From TTY (Ctrl+Alt+F2)
cd ~/Projects/bunkeros

# Ensure Sway is installed
sudo pacman -S sway

# Reinstall session files
sudo cp scripts/launch-bunkeros.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/launch-bunkeros.sh
sudo cp sddm/sessions/bunkeros.desktop /usr/share/wayland-sessions/

# Re-run installation
./install.sh

# Restart SDDM
sudo systemctl restart sddm
```
```

---

## Quick Troubleshooting Tools

Before diving into specific issues, try these automated tools:

```bash
# Diagnose SDDM/login issues (if you get black screen)
./scripts/diagnose-sddm-login.sh

# Check system compatibility
./scripts/check-compatibility.sh

# Verify all packages are installed
./scripts/verify-packages.sh

# List all required packages with status check
./scripts/list-all-packages.sh --check

# Test BunkerOS sessions before logging out
./scripts/test-sessions.sh

# Fix current session environment
./scripts/fix-environment.sh

# Full installation validation
./scripts/validate-installation.sh

# View installation log (if using robust installer)
cat /tmp/bunkeros-install.log
```

## Installation Issues

### Issue: BunkerOS session causes black screen or "no signal"

**Symptoms:**
- Selecting BunkerOS results in black screen
- Monitor shows "no signal" message
- Need to select regular "Sway" session to get back in

**Root Cause:**
Corrupted or outdated launch script in `/usr/local/bin/`

**Solution:**
```bash
# Test sessions before logging out
./scripts/test-sessions.sh

# If test fails, reinstall launch scripts
cd ~/Projects/bunkeros/sddm
sudo ./install-theme.sh

# Test again
./scripts/test-sessions.sh
```

**Prevention:**
- Always run `./scripts/test-sessions.sh` after pulling repository updates
- Check `/tmp/bunkeros-launch-error.log` if sessions fail to start

---

### Issue: SDDM theme not showing (default theme instead of BunkerOS tactical theme)

**Symptoms:**
- SDDM shows default blue/gray theme instead of dark tactical theme
- Login screen doesn't have BunkerOS branding

**Root Cause:**
Missing Qt QML packages required for SDDM theme rendering.

**Solution:**
```bash
# Install required Qt packages
sudo pacman -S qt5-declarative qt5-quickcontrols2

# Restart SDDM to load theme
sudo systemctl restart sddm.service
# OR reboot for full reset
sudo reboot
```

**Verification:**
You should see the BunkerOS tactical theme with:
- Dark charcoal background
- Centered login box with tactical colors
- Session selector for BunkerOS
- Power management buttons

---

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
2. **Launch script environment** - `launch-bunkeros.sh` now exports Wayland variables
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
    exec ~/Projects/bunkeros/scripts/launch-bunkeros.sh
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

1. **Launch script copied to system location** - Script is now in `/usr/local/bin/` instead of user-specific paths
2. **Proper environment variable export** - All necessary Wayland variables are set during session startup

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
   ./install-robust.sh
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
