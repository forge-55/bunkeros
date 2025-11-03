# Quick Fix Guide for Your Current Installation

## Your Issue: Black Screen and Atomic Operation Errors

Based on your description, here's what happened and how to fix it:

### What Went Wrong

1. **Atomic Operation Errors**: The environment.d file was symlinked instead of copied. Systemd cannot read symlinked environment files.
2. **Black Screen**: Likely caused by Sway not starting due to configuration errors or missing environment variables.

### Immediate Fix Steps

#### Option 1: Use Emergency Recovery Session (Recommended)

1. **Restart your computer**
2. **At the login screen**, click the session dropdown
3. **Select "BunkerOS Emergency"** instead of "BunkerOS"
4. **Log in** - you'll get a terminal
5. **Run these commands**:

```bash
# Fix the environment.d file (this is critical!)
rm ~/.config/environment.d/10-bunkeros-wayland.conf
cp ~/Projects/bunkeros/environment.d/10-bunkeros-wayland.conf ~/.config/environment.d/

# Reinstall SDDM theme and session files
cd ~/Projects/bunkeros/sddm
sudo ./install-theme.sh

# Enable user services
systemctl --user enable pipewire.service pipewire-pulse.service wireplumber.service

# Validate the installation
cd ~/Projects/bunkeros
./scripts/validate-installation.sh

# Check Sway configuration
sway --validate
```

6. **Log out** and select **"BunkerOS"** session
7. **Log in** - should work now!

#### Option 2: TTY Terminal Access

If you can't access Emergency Recovery:

1. **At the login screen**, press `Ctrl+Alt+F2` to switch to TTY2
2. **Log in** with your username and password
3. **Run the same commands as Option 1**
4. **Press `Ctrl+Alt+F1`** to return to the login screen
5. **Select "BunkerOS"** and log in

### Complete Reinstall (If needed)

If the above doesn't work:

```bash
# Access terminal (Emergency Recovery or TTY)
cd ~/Projects/bunkeros

# Rollback to previous state
./scripts/rollback-installation.sh

# Pull latest fixes
git pull

# Clean reinstall
./install.sh

# Validate
./scripts/validate-installation.sh

# Log out and log back in
```

## What Was Fixed

The following critical issues have been resolved in the latest version:

1. ✅ **environment.d file**: Now copied instead of symlinked
2. ✅ **Launch script**: Added preflight validation and service startup
3. ✅ **SDDM installation**: Automatically installed by install.sh
4. ✅ **User services**: Automatically configured by install.sh
5. ✅ **Validation script**: Comprehensive checks with fix commands
6. ✅ **Rollback mechanism**: Easy restoration from backup
7. ✅ **Documentation**: Detailed troubleshooting guide

## Verification

After fixing, verify everything works:

```bash
# Run validation
~/Projects/bunkeros/scripts/validate-installation.sh

# Check environment.d file is NOT a symlink
file ~/.config/environment.d/10-bunkeros-wayland.conf
# Should show: "ASCII text" not "symbolic link"

# Verify Sway config
sway --validate

# Check services
systemctl --user status pipewire.service
```

## Next Time

For future installations on new machines:

```bash
cd ~/Projects
git clone https://github.com/forge-55/bunkeros.git
cd bunkeros

# Single command - installs everything properly
./install.sh

# Always validate after install
./scripts/validate-installation.sh
```

The installer now:
- ✅ Copies environment.d files (not symlinks)
- ✅ Installs SDDM theme and sessions
- ✅ Configures user services
- ✅ Validates Sway config
- ✅ Creates backups
- ✅ Provides recovery options

## Getting Help

If you still have issues:

1. Run: `~/Projects/bunkeros/scripts/validate-installation.sh`
2. Save the output
3. Check: `/tmp/bunkeros-launch.log`
4. Review: `TROUBLESHOOTING-INSTALLATION.md` (just created)
5. Open a GitHub issue with the validation output

Good luck! 🚀
