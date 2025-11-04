# SDDM Installation Improvements

## Why SDDM Can Cause Installation Issues

SDDM (Simple Desktop Display Manager) is a system-level service that requires:
1. **Root/sudo access** - Installs files to `/usr/share/` and `/etc/`
2. **Systemd service management** - Enable/disable services
3. **Potential conflicts** - May conflict with existing display managers (GDM, LightDM, etc.)
4. **System-wide changes** - Affects all users on the system

### Common SDDM Installation Problems

1. **Multiple Display Managers**
   - User already has GDM/LightDM/etc enabled
   - Both display managers try to run simultaneously
   - Login screen conflicts

2. **Permission Issues**
   - Installing theme files requires sudo
   - Session files need specific permissions
   - Config file modifications

3. **Service State Confusion**
   - SDDM enabled but old DM still active
   - Services fighting for control of TTY
   - Race conditions on boot

4. **Configuration File Conflicts**
   - `/etc/sddm.conf` already exists with custom settings
   - Multiple theme sections
   - Malformed configuration

## Improvements Implemented

### 1. Better Display Manager Detection

**Old approach:**
- Only checked if services were enabled
- Didn't handle running services

**New approach:**
```bash
# Check all common display managers
for dm in gdm sddm lightdm ly lxdm; do
    if systemctl is-enabled "${dm}.service" &>/dev/null; then
        current_dm="$dm"
        break
    fi
done
```

### 2. Proper Service Transition

**Old approach:**
- Just disabled old DM and enabled SDDM
- Didn't stop running services

**New approach:**
```bash
# Stop current display manager if running
if systemctl is-active "$dm_service" &>/dev/null; then
    sudo systemctl stop "$dm_service"
fi

# Disable old, enable new
sudo systemctl disable "$dm_service"
sudo systemctl enable sddm.service
```

### 3. Non-Interactive Installation

**Old approach:**
- Used `sudo pacman -S` (required interaction)
- No error handling

**New approach:**
```bash
# Use --noconfirm for automated installation
sudo pacman -S --needed --noconfirm sddm qt5-declarative qt5-quickcontrols2 2>&1 | tee -a "$LOG_FILE"
```

### 4. Comprehensive Error Handling

**Old approach:**
- Basic error checking
- Failed silently in places

**New approach:**
```bash
set -e  # Exit on any error

# Verify source files exist before proceeding
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: SDDM theme source directory not found"
    exit 1
fi

# Check each operation
if sudo cp theme_files...; then
    echo "✓ Success"
else
    echo "ERROR: Failed"
    exit 1
fi
```

### 5. Better SDDM Configuration Management

**Old approach:**
- Simple append to `/etc/sddm.conf`
- Could create duplicate sections

**New approach:**
```bash
if [ ! -f /etc/sddm.conf ]; then
    # Create new config
    echo -e "[Theme]\nCurrent=tactical" | sudo tee /etc/sddm.conf
else
    if ! grep -q "^\[Theme\]" /etc/sddm.conf; then
        # Add Theme section
        echo -e "\n[Theme]\nCurrent=tactical" | sudo tee -a /etc/sddm.conf
    else
        # Update existing Theme section
        sudo sed -i '/^\[Theme\]/,/^\[/{s/^Current=.*/Current=tactical/}' /etc/sddm.conf
    fi
fi
```

### 6. Detailed Logging

All SDDM operations now log to `/tmp/bunkeros-install.log`:
```bash
sudo pacman -S ... 2>&1 | tee -a "$LOG_FILE"
sudo systemctl enable sddm.service 2>&1 | tee -a "$LOG_FILE"
```

### 7. User Choice Preserved

Users can now:
- Keep their existing display manager
- Skip SDDM installation entirely
- BunkerOS sessions work with any display manager

**Old approach:**
- Forced SDDM installation

**New approach:**
```bash
echo "Options:"
echo "  1) Switch to SDDM (recommended)"
echo "  2) Keep $current_dm (sessions still work)"
echo "  3) Cancel installation"
```

## Reduced Error Likelihood

| Issue | Old Installer | New Installer |
|-------|---------------|---------------|
| Multiple DMs conflict | ⚠️ Common | ✅ Prevented |
| Service not stopped | ⚠️ Common | ✅ Handled |
| Permission errors | ⚠️ Possible | ✅ Checked early |
| Config corruption | ⚠️ Possible | ✅ Validated |
| Silent failures | ⚠️ Common | ✅ Logged & reported |
| Interactive prompts hang | ⚠️ Common | ✅ Non-interactive |
| Missing source files | ⚠️ Crashes | ✅ Validated first |

## Testing Checklist

After SDDM installation, the installer now verifies:

- ✅ SDDM package installed
- ✅ SDDM service enabled (not started during install)
- ✅ Old display manager disabled
- ✅ Theme files in `/usr/share/sddm/themes/tactical/`
- ✅ Session files in `/usr/share/wayland-sessions/`
- ✅ Launch scripts in `/usr/local/bin/` with execute permissions
- ✅ `/etc/sddm.conf` has correct theme configuration
- ✅ All operations logged

## What Happens on Reboot

1. **SDDM starts** (enabled service)
2. **Old DM doesn't start** (disabled service)
3. **SDDM shows themed login screen** (tactical theme configured)
4. **BunkerOS sessions available** (session files installed)
5. **User selects "BunkerOS"** (from session dropdown)
6. **Launch script executes** (properly validated environment)
7. **Sway starts successfully** (with all required services)

## Rollback if Needed

If SDDM installation fails or causes issues:

```bash
# Disable SDDM
sudo systemctl disable sddm.service

# Re-enable your old display manager (e.g., GDM)
sudo systemctl enable gdm.service

# Reboot
sudo reboot
```

## Best Practices

1. **Always check existing display manager first**
2. **Stop services before disabling them**
3. **Use --noconfirm for automated installations**
4. **Validate all file operations**
5. **Log everything for troubleshooting**
6. **Don't start SDDM during installation** (will start on reboot)
7. **Verify configurations before enabling services**
8. **Provide clear user choice and information**

## Summary

The improved SDDM installation:
- ✅ **Safer** - Validates before acting
- ✅ **Cleaner** - Properly transitions from old DM
- ✅ **Transparent** - Logs all operations
- ✅ **Flexible** - User can keep existing DM
- ✅ **Robust** - Comprehensive error handling
- ✅ **Non-interactive** - Works in automated scripts
- ✅ **Recoverable** - Clear rollback path

These improvements significantly reduce the likelihood of SDDM-related installation failures.
