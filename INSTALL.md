# BunkerOS Installation Guide

Complete installation instructions for BunkerOS with robust error handling, automatic recovery, and two-phase installation process.

## System Requirements

**BunkerOS**:
- RAM: 4GB minimum, 8GB recommended
- GPU: Any (Intel integrated graphics work excellently)
- CPU: x86-64 compatible (modern processors recommended)
- Disk: 20GB free space (2GB minimum for installation)
- Network: Active internet connection required
- OS: Arch Linux or Arch-based distribution (Manjaro, EndeavourOS, etc.)

**Note**: BunkerOS uses minimal effects (rounded corners only) by default for maximum performance. Users with modern GPUs who want additional effects can enable them after installation using the effects toggle script.

## Installation Overview

BunkerOS uses a **two-phase installation** for maximum safety and reliability:

### **Phase 1: User Environment** (`install.sh`)
- System preparation and package installation
- User configuration deployment
- Service setup (PipeWire, etc.)
- Configuration validation
- **Safe to run while graphical session is active**

### **Phase 2: SDDM Installation** (`install-sddm.sh`)
- Display manager installation
- SDDM theme installation
- System-wide session files
- **Requires reboot to take effect**

This approach prevents issues with switching display managers mid-session and allows you to test BunkerOS before committing to SDDM.

## Quick Installation (Recommended)

### Step 1: Install User Environment

```bash
# Clone repository
cd ~/Projects
git clone https://github.com/forge-55/bunkeros.git
cd bunkeros

# Check system compatibility (recommended)
./scripts/check-compatibility.sh

# Phase 1: Install user environment
./install.sh
```

The Phase 1 installer features:
- ✅ **Preflight checks**: Verifies internet, disk space, and package database
- ✅ **Checkpoint system**: Resume from interruptions automatically
- ✅ **Automatic recovery**: Handles package conflicts intelligently
- ✅ **Backup creation**: Saves existing configs before changes
- ✅ **Configuration validation**: Tests Sway config before completion
- ✅ **Detailed logging**: All operations logged to `/tmp/bunkeros-install.log`
- ✅ **User environment**: Configures PipeWire and other user services

**If installation is interrupted**, simply re-run `./install.sh` and it will resume from the last successful checkpoint.

### Step 2: Test BunkerOS

Before installing SDDM, test that BunkerOS works:

```bash
# Launch BunkerOS directly
sway
```

**What to test:**
- Waybar appears at the top
- Keybindings work (Super+Return for terminal)
- Audio works (PipeWire running)
- Displays configured correctly

**Exit BunkerOS:**
- Press `Super+Shift+E` → Click "Exit"
- You'll return to your current desktop environment

### Step 3: Install SDDM (Optional but Recommended)

Once you've verified BunkerOS works:

```bash
# Phase 2: Install SDDM display manager
./install-sddm.sh
```

The Phase 2 installer:
- ✅ **Verifies Phase 1**: Checks user environment is installed
- ✅ **Safe switching**: Doesn't interrupt your current session
- ✅ **Smart detection**: Handles existing display managers intelligently
- ✅ **SDDM theme**: Installs custom BunkerOS login screen
- ✅ **Session files**: Makes BunkerOS available at login

**After installation:**
```bash
sudo reboot
```

At the SDDM login screen, you'll see:
- BunkerOS themed login screen
- Session options in the menu
- Select "BunkerOS" and log in

## Troubleshooting During Installation

If you encounter issues:

1. **Check installation log**:
   ```bash
   cat /tmp/bunkeros-install.log
   ```

2. **Run validation script**:
   ```bash
   ~/Projects/bunkeros/scripts/validate-installation.sh
   ```
   This will show exactly what's wrong and how to fix it.

3. **Use Emergency Recovery session**:
   - At login screen, select "BunkerOS Emergency"
   - This boots to a terminal where you can fix issues

4. **Rollback installation**:
   ```bash
   ~/Projects/bunkeros/scripts/rollback-installation.sh
   ```
   This restores your previous configuration from backup.

5. **Check system logs**:
   ```bash
   journalctl --user -b          # User session logs
   journalctl -b                 # System logs
   ```

### Common Issues and Fixes

#### Black Screen on Login

**Cause**: Sway configuration errors or missing packages

**Fix**:
```bash
# Use Emergency Recovery session to access terminal
# Then run validation:
~/Projects/bunkeros/scripts/validate-installation.sh

# Check Sway config:
sway --validate

# View detailed errors:
cat /tmp/bunkeros-launch.log
```

#### "Atomic Operation" Errors

**Cause**: Symlinked environment.d files (systemd can't read symlinks)

**Fix**: The new installer copies (not symlinks) environment.d files. If upgrading:
```bash
cd ~/Projects/bunkeros
rm ~/.config/environment.d/10-bunkeros-wayland.conf
cp environment.d/10-bunkeros-wayland.conf ~/.config/environment.d/
```

#### Session Not Listed at Login

**Cause**: SDDM theme/session files not installed

**Fix**:
```bash
cd ~/Projects/bunkeros/sddm
sudo ./install-theme.sh
```

#### No Audio

**Cause**: PipeWire services not enabled

**Fix**:
```bash
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service
systemctl --user enable --now wireplumber.service
```

## Why Two-Phase Installation?

### The Problem with Single-Phase Installation

Traditional desktop environment installers often try to:
1. Install packages
2. Configure user environment
3. **Switch display managers** (GDM → SDDM, etc.)
4. Enable system services

All in one script, while you're logged into a graphical session.

**This is risky** because:
- Stopping the active display manager can kill your session → **blank screen**
- You might get locked out without TTY access
- System is in an unstable transition state
- If anything fails mid-process, you're stuck

### The BunkerOS Solution

**Phase 1** (`install.sh`):
- Runs safely in your current graphical environment
- Installs all packages and user configurations
- Sets up services (PipeWire, etc.)
- Validates Sway configuration
- **Doesn't touch your display manager**

**Result**: You have a working BunkerOS environment you can test with `sway` command.

**Phase 2** (`install-sddm.sh`):
- Run this **after** you've tested BunkerOS
- Installs SDDM theme and session files
- Handles display manager switching safely
- **Takes effect only after reboot**

**Result**: If Phase 2 fails, you still have:
- Working BunkerOS (launch with `sway`)
- Your original display manager
- A stable system

This approach prioritizes **safety** and **testability** over convenience.

## Manual Installation

If you prefer step-by-step control:

### Step 1: Update System

```bash
sudo pacman -Syu
```

### Step 2: Clone Repository

```bash
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/forge-55/bunkeros.git
cd bunkeros
```

### Step 3: Install Manually

```bash
# Check compatibility
./scripts/check-compatibility.sh

# Phase 1: User environment
./install.sh

# Test BunkerOS
sway
# (Exit with Super+Shift+E)

# Phase 2: SDDM (optional)
./install-sddm.sh

# Reboot
sudo reboot
```

**Note**: The automated `install.sh` handles all package installation, service setup, and configuration. Manual package installation is no longer necessary.

## Post-Installation

## Post-Installation

### First Launch

After rebooting and logging into BunkerOS:

1. **Auto-Scaling**: BunkerOS automatically detects your display resolution and applies optimal font sizes
   - This happens on first login only - your manual font changes are preserved
   - To disable: `touch ~/.config/bunkeros/scaling-disabled`
   - To reset to auto-detected settings: `rm ~/.config/bunkeros/user-preferences.conf`
   - See [ADAPTIVE-SCALING.md](ADAPTIVE-SCALING.md) for details

2. **Test key features**:
   - `Super+Return` - Open terminal
   - `Super+d` - Application launcher
   - `Super+m` - Quick actions menu
   - `Super+w` - Workspace overview

3. **Multi-Monitor Setup** (if applicable):
   ```bash
   # Detect connected monitors
   bash ~/Projects/bunkeros/scripts/detect-monitors.sh
   
   # Configure monitors interactively
   bash ~/Projects/bunkeros/scripts/setup-monitors.sh
   
   # Or configure automatically
   bash ~/Projects/bunkeros/scripts/setup-monitors.sh --auto
   ```
   
   See [MULTI-MONITOR.md](MULTI-MONITOR.md) for complete documentation.

### Optional Applications

BunkerOS works best with these additional applications:

#### Web Browsers

```bash
# Brave (recommended for web apps)
yay -S brave-bin

# Firefox (alternative)
sudo pacman -S firefox
```

#### Code Editor

```bash
# VS Code, Cursor, or VSCodium
yay -S visual-studio-code-bin
# OR
yay -S cursor-bin
# OR
sudo pacman -S vscodium
```

#### Other Tools

```bash
# As needed
sudo pacman -S gimp vlc libreoffice-fresh
```

### Power Management (Laptops)

For improved battery life on laptops:

**Option 1: auto-cpufreq (Recommended)**
```bash
sudo pacman -S auto-cpufreq
sudo systemctl enable --now auto-cpufreq
```

**Option 2: TLP (Alternative)**
```bash
sudo pacman -S tlp tlp-rdw
sudo systemctl enable --now tlp
```

**Note:** Don't install both - they conflict. See [POWER-MANAGEMENT.md](POWER-MANAGEMENT.md) for details.

### Validation

Verify everything is working:

```bash
cd ~/Projects/bunkeros
./scripts/validate-installation.sh
```

## Troubleshooting

### Installation Issues

**Check logs:**
```bash
cat /tmp/bunkeros-install.log        # Phase 1
cat /tmp/bunkeros-sddm-install.log   # Phase 2
```

**Run validation:**
```bash
~/Projects/bunkeros/scripts/validate-installation.sh
```

**Rollback if needed:**
```bash
~/Projects/bunkeros/scripts/rollback-installation.sh
```

### Common Issues

#### Session Not Available at Login

**Solution:**
```bash
# Re-run Phase 2
cd ~/Projects/bunkeros
./install-sddm.sh
```

#### Waybar Not Showing

```bash
# Check if running
pgrep waybar

# Restart
killall waybar
waybar &
```

#### No Audio

```bash
# Enable PipeWire services
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

### Emergency Recovery

If you can't log in normally:

1. At SDDM, select **"BunkerOS Emergency Recovery"**
2. Fix issues in the minimal terminal environment
3. Use `Super+Shift+E` to exit when done

### Advanced Troubleshooting

See detailed guides:
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - General issues
- [TROUBLESHOOTING-SDDM.md](TROUBLESHOOTING-SDDM.md) - Display manager issues

## Uninstallation

```bash
# Disable and remove SDDM
sudo systemctl disable sddm.service
sudo pacman -Rns sddm qt5-declarative qt5-quickcontrols2

# Remove configurations
rm -rf ~/.config/{sway,waybar,wofi,mako,foot,btop,swayosd,bunkeros}
rm -rf ~/.config/{gtk-3.0,gtk-4.0}/gtk.css
rm -rf ~/.config/themes
rm -rf ~/.local/bin/{theme-switcher.sh,webapp-*}

# Remove system files (requires sudo)
sudo rm -rf /usr/share/sddm/themes/tactical
sudo rm /usr/share/wayland-sessions/bunkeros*.desktop
sudo rm /usr/local/bin/launch-bunkeros.sh

# Restore bashrc (edit manually to remove BunkerOS section)
```

## Next Steps

After installation:
1. **Learn keybindings**: `Super+m` → Quick Actions
2. **Explore themes**: `Super+m` → Change Theme
3. **Read documentation**: See [README.md](README.md) for features
4. **Install web apps**: `Super+m` → Web Apps
5. **Configure power**: See [POWER-MANAGEMENT.md](POWER-MANAGEMENT.md)
6. **Multi-monitor**: See [MULTI-MONITOR.md](MULTI-MONITOR.md)

## Getting Help

- **Issues**: https://github.com/forge-55/bunkeros/issues
- **Architecture**: See [ARCHITECTURE.md](ARCHITECTURE.md)
- **Security**: See [SECURITY.md](SECURITY.md)