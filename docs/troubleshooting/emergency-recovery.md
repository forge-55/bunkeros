# Emergency Recovery Guide

If you encounter a black screen, broken keybindings, or can't access your system after installation, follow these steps:

## 🚨 Can't Open Terminal / Keybindings Don't Work

### Symptoms:
- You're logged into BunkerOS
- Desktop appears but nothing happens when you press keys
- `Super+t` or `Super+Return` don't open terminal

### Quick Fix (From TTY):

1. **Switch to TTY**: Press `Ctrl+Alt+F2`
2. **Login** with your username and password
3. **Run setup script**:
   ```bash
   cd ~/Projects/bunkeros
   ./setup.sh
   ```
4. **Return to desktop**: Press `Ctrl+Alt+F1`
5. **Reload Sway**: Press `Super+Shift+r`
6. **Test terminal**: Press `Super+t` or `Super+Return`

### What This Does:
Creates the missing `~/.config/bunkeros/defaults.conf` file that contains application mappings for keybindings.

### Emergency Terminal Access (Without TTY):

If you need a terminal RIGHT NOW without switching to TTY:

1. Press `Ctrl+Alt+F2` to switch to TTY
2. Login
3. Run: `WAYLAND_DISPLAY=wayland-1 foot &`
4. Press `Ctrl+Alt+F1` to return
5. You should now have a terminal window

---

## 🚨 Black Screen After Login (No Display)

### If you see SDDM login screen but get black screen after logging in:

1. **Switch to TTY**: Press `Ctrl+Alt+F2`
2. **Login** with your username and password (typing is blind, but works)
3. **Restore working config**:
   ```bash
   cp ~/.config/sway/config.KNOWN_WORKING_BACKUP_* ~/.config/sway/config
   ```
4. **Restart SDDM**:
   ```bash
   sudo systemctl restart sddm
   ```
5. **Switch back**: Press `Ctrl+Alt+F1`
6. **Login again** - Should work now

### If you get black screen BEFORE login screen:

This is NOT related to our changes, but here's how to fix:

1. **Boot into TTY**: System should show TTY by default
2. **Login** with username/password
3. **Start SDDM**:
   ```bash
   sudo systemctl start sddm
   ```

## Disable Auto-Lock and Auto-Suspend (if needed)

If you want to disable the automatic lock and suspend features:

```bash
# From TTY or terminal - kill swayidle
killall swayidle
```

To permanently disable, edit `~/.config/sway/config` and comment out the swayidle launch line:

```bash
# exec_always --no-startup-id ~/.config/sway-config/scripts/launch-swayidle.sh
```

Then reload Sway: `Super+Shift+R`

## Verify Sway Config

```bash
# Check for syntax errors
sway -C

# If errors appear, restore backup:
cp ~/.config/sway/config.KNOWN_WORKING_BACKUP_* ~/.config/sway/config
```

## Important Notes

**What power management affects:**
- ✓ When system suspends after idle time
- ✗ Does NOT affect login, graphics, or display

**What CAN cause black screen:**
- ❌ Sway config syntax errors (checked: none found)
- ❌ Missing Sway executable (checked: installed)
- ❌ GPU driver issues (unrelated to our changes)
- ❌ SDDM not running (checked: running)

**What our changes do:**
- Remove suspend command from swayidle
- Add systemd-logind configuration for auto-suspend
- Both are completely separate from display/graphics

## Full Reset to Stock

If you want to completely reset power management:

```bash
# Remove systemd-logind config
sudo rm /etc/systemd/logind.conf.d/bunkeros-power.conf

# Restore original Sway config (from project)
cd ~/Projects/bunkeros
git checkout sway/config
cp sway/config ~/.config/sway/config

# Restart
sudo systemctl restart systemd-logind
swaymsg reload
```

## Contact Information

If you need help:
1. Check BunkerOS documentation
2. Review TROUBLESHOOTING.md
3. Check system logs: `journalctl -b | grep -i error`

## Verification That System Is OK

Run these checks before rebooting:

```bash
# 1. Sway config is valid
sway -C

# 2. SDDM is enabled and running
systemctl status sddm

# 3. Backup exists
ls -la ~/.config/sway/config.KNOWN_WORKING_BACKUP_*
```

All should pass with no errors.
