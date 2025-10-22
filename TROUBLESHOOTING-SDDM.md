# Troubleshooting: Black Screen After SDDM Login

## Symptom
- SDDM login screen works fine
- After entering password, screen goes black
- Monitor says "No Signal"
- Computer is still running

## Common Causes

### 1. SwayFX Not in PATH for SDDM
SDDM runs as a system service and may not have the same PATH as your user account.

### 2. Missing Dependencies
SwayFX requires specific packages that may not have been installed.

### 3. Configuration Errors
Syntax errors in Sway config prevent startup.

---

## Diagnostic Steps

### Step 1: Switch to TTY
At the black screen:
1. Press `Ctrl+Alt+F2`
2. Login with your username/password
3. You're now at a terminal

### Step 2: Check if Sway is Installed
```bash
which sway
# Should output: /usr/bin/sway or similar

pacman -Q swayfx
# Should show: swayfx <version>
```

**If sway is not found:**
```bash
# Install SwayFX
yay -S swayfx
# or
paru -S swayfx
```

### Step 3: Check Sway Config
```bash
# Test your Sway config for errors
sway --validate

# If there are errors, check the config:
nano ~/.config/sway/config
```

### Step 4: Test Manual Launch
```bash
# Try launching Sway manually
sway
```

**If Sway launches:** The problem is with SDDM session files (see Fix #1)
**If Sway fails:** Check the error message and proceed to Fix #2

---

## Fixes

### Fix #1: Reinstall Session Files

If Sway works manually but not from SDDM:

```bash
cd ~/Projects/bunkeros  # or wherever you cloned it

# Reinstall the launch scripts
sudo cp scripts/launch-bunkeros-standard.sh /usr/local/bin/
sudo cp scripts/launch-bunkeros-enhanced.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/launch-bunkeros-*.sh

# Reinstall the session files
sudo cp sddm/sessions/*.desktop /usr/share/wayland-sessions/

# Restart SDDM
sudo systemctl restart sddm
```

### Fix #2: Missing Dependencies

```bash
# Install all required dependencies
cd ~/Projects/bunkeros
bash scripts/install-dependencies.sh
```

### Fix #3: SwayFX from AUR

If SwayFX isn't installed:

```bash
# Install an AUR helper if you don't have one
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

# Install SwayFX
yay -S swayfx
```

### Fix #4: Check Logs

View Sway startup logs to see what failed:

```bash
# Check SDDM logs
sudo journalctl -u sddm -b

# Check user session logs
journalctl --user -b | grep -i sway

# Check for X/Wayland errors
cat ~/.local/share/sway/sway.log
```

### Fix #5: Fallback - Start from TTY

As a temporary workaround:

```bash
# From TTY (Ctrl+Alt+F2)
# Login, then run:
sway
```

---

## Prevention: Validate Before Reboot

After setup, always validate:

```bash
# Test Sway config
sway --validate

# Check session files exist
ls -la /usr/share/wayland-sessions/bunkeros-*.desktop

# Check launch scripts exist and are executable
ls -la /usr/local/bin/launch-bunkeros-*.sh
```

---

## Still Not Working?

### Emergency Recovery

1. **Disable SDDM and use TTY temporarily:**
   ```bash
   sudo systemctl disable sddm
   sudo systemctl reboot
   
   # After reboot, login from TTY and run:
   sway
   ```

2. **Switch to a different display manager:**
   ```bash
   sudo pacman -S lightdm lightdm-gtk-greeter
   sudo systemctl disable sddm
   sudo systemctl enable lightdm
   sudo reboot
   ```

3. **Check GPU drivers:**
   ```bash
   # For Intel
   sudo pacman -S mesa vulkan-intel
   
   # For AMD
   sudo pacman -S mesa vulkan-radeon
   
   # For NVIDIA (not recommended with Wayland)
   sudo pacman -S nvidia nvidia-utils
   ```

---

## Common Error Messages

### "sway: command not found"
- SwayFX is not installed → Use Fix #3

### "Unable to retrieve DRM resources"
- GPU driver issue → Install proper mesa/vulkan packages

### "Unable to create backend"
- Missing Wayland dependencies → Run `install-dependencies.sh`

### Config validation fails
- Syntax error in `~/.config/sway/config` → Check config file

---

## Getting Help

If none of these fixes work:

1. Collect diagnostic info:
   ```bash
   # Create diagnostic report
   echo "=== System Info ===" > ~/bunkeros-debug.txt
   uname -a >> ~/bunkeros-debug.txt
   echo -e "\n=== SwayFX ===" >> ~/bunkeros-debug.txt
   pacman -Q swayfx >> ~/bunkeros-debug.txt
   echo -e "\n=== Graphics ===" >> ~/bunkeros-debug.txt
   lspci | grep -i vga >> ~/bunkeros-debug.txt
   echo -e "\n=== Sway Log ===" >> ~/bunkeros-debug.txt
   tail -50 ~/.local/share/sway/sway.log >> ~/bunkeros-debug.txt
   echo -e "\n=== SDDM Log ===" >> ~/bunkeros-debug.txt
   sudo journalctl -u sddm -n 50 >> ~/bunkeros-debug.txt
   ```

2. Post an issue on GitHub with the `bunkeros-debug.txt` contents

3. Check Arch Wiki: https://wiki.archlinux.org/title/Sway
