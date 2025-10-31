# BunkerOS Installation Improvements

## Overview

This document describes the comprehensive improvements made to the BunkerOS installation process to ensure reliability across all Arch-based distributions.

## Issues Addressed

### 1. Broken Keybindings on Fresh Install
**Problem:** Terminal shortcuts (Super+T, Super+Return) didn't work after installation.

**Root Cause:** `~/.config/bunkeros/defaults.conf` was not created, leaving Sway variables undefined.

**Solution:**
- Added fallback defaults in `sway/config` (lines 15-31)
- `setup.sh` now auto-creates `defaults.conf` if missing (lines 30-36)
- System works even if setup fails

### 2. Desktop Portal File Conflicts
**Problem:** Installation failed with "Atomic commit failed: Permission denied" errors.

**Root Cause:** `xdg-desktop-portal-wlr` and `xdg-desktop-portal-gtk` share configuration files.

**Solution:**
- Separated portal package installation with `--overwrite='*'` flag
- Individual package retry on failure
- Non-blocking (continues on error since these are optional)

### 3. SDDM Installation Timing
**Problem:** Installer tried to enable SDDM before it was installed.

**Root Cause:** `handle_display_manager()` called `systemctl enable` before package check.

**Solution:**
- Check if SDDM installed first
- Auto-install if missing
- Only then enable/configure service

### 4. Emergency Session Ordering
**Problem:** "BunkerOS Emergency Terminal" appeared as default login option.

**Root Cause:** Alphabetical sorting placed "Emergency" before "BunkerOS".

**Solution:**
- Renamed to `bunkeros-recovery.desktop`
- Changed display name to "BunkerOS Emergency Recovery"
- Now sorts after main "BunkerOS" session

### 5. No TTY Access from SDDM
**Problem:** Ctrl+Alt+F2 shortcuts didn't work at SDDM login screen.

**Root Cause:** SDDM intercepts all keyboard input before login.

**Solution:**
- Created emergency recovery session accessible from login menu
- Minimal Sway config with fullscreen terminal
- Shows recovery instructions and troubleshooting commands
- Works without any user configuration

### 6. Missing AUR Helper
**Problem:** Fresh systems don't have yay/paru installed for AUR packages.

**Current Handling:**
- Prompts user to install AUR helper
- Offers to skip AUR packages (they're optional)
- Continues installation without blocking

## New Features

### Preflight Checks
Before installation begins, the script now validates:

- **Internet Connectivity:** Ping test to archlinux.org
- **Pacman Availability:** Verify on Arch-based system
- **Package Database:** Update with `pacman -Sy`
- **Pacman Locks:** Detect and remove stale lock files
- **Disk Space:** Ensure at least 2GB free space

### Checkpoint System
Installation saves progress after each major stage:

- `backup_complete` - Configuration backed up
- `sddm_configured` - Display manager ready
- `core_packages_installed` - Core Sway packages installed
- `app_packages_installed` - Application packages installed
- `media_packages_installed` - Media/audio packages installed
- `system_packages_installed` - System packages installed
- `portal_packages_installed` - Desktop portals configured
- `aur_packages_installed` - AUR packages built
- `setup_complete` - Configuration symlinked
- `sway_validated` - Sway config verified
- `python_tools_installed` - Python tools ready
- `services_verified` - Systemd services checked
- `power_management_complete` - Power optimization configured
- `session_fixed` - Current session updated
- `installation_complete` - All validation passed

**Benefits:**
- Resume interrupted installations
- Skip completed stages
- Easier troubleshooting

### Improved Package Installation
The `install_packages()` function now:

- Tries batch installation first (faster)
- Falls back to individual package retry
- Uses `--overwrite='*'` for known conflicts
- Logs all output to installation log
- Reports failed packages with manual install commands
- Offers to continue on non-critical failures

### Sway Configuration Validation
Before completing installation:

- Runs `sway --validate` on final config
- Reports syntax errors immediately
- Prevents broken desktop sessions
- User can still continue (emergency session available)

### Comprehensive Logging
All operations logged to timestamped file:

- Package installation output
- Error messages with context
- Service status checks
- Validation results
- Location: `/tmp/bunkeros-install-<timestamp>.log`

## Installation Flow

```
1. Preflight Checks
   ├─ Internet connectivity
   ├─ Pacman available
   ├─ Remove stale locks
   ├─ Update package database
   └─ Verify disk space

2. Backup Current Config
   └─ Save to ~/.config/.bunkeros-backup-<timestamp>

3. Configure SDDM
   ├─ Install if missing
   ├─ Enable service
   ├─ Install tactical theme
   ├─ Install BunkerOS session
   └─ Install Emergency Recovery session

4. Install Packages (with checkpoints)
   ├─ Core Sway packages
   ├─ Application packages
   ├─ Media/audio packages
   ├─ System packages
   ├─ Desktop portals (with --overwrite)
   └─ AUR packages (optional)

5. Run Configuration Setup
   ├─ Create symlinks to git repo
   ├─ Auto-create defaults.conf
   └─ Set up user directories

6. Validate Sway Configuration
   └─ Run sway --validate

7. Install Optional Tools
   ├─ Python tools (pipx)
   └─ Power management (auto-cpufreq or TLP)

8. Verify Services
   └─ Check systemd service status

9. Fix Current Session
   └─ Update environment for immediate use

10. Final Validation
    └─ Run validate-installation.sh
```

## Testing Checklist

Before considering this stable, test on:

- [ ] Fresh CachyOS installation
- [ ] Fresh EndeavourOS installation
- [ ] Fresh Arch Linux installation
- [ ] System with existing Sway config
- [ ] System without AUR helper
- [ ] Installation with interruption (test resume)
- [ ] Emergency recovery session boots
- [ ] All keybindings work after install

## Rollback Procedure

If installation fails or produces broken system:

1. **Use Emergency Recovery Session**
   - Select "BunkerOS Emergency Recovery" from SDDM
   - Terminal opens automatically with instructions

2. **Restore Configuration**
   ```bash
   # Find backup directory
   ls ~/.config/.bunkeros-backup-*
   
   # Restore (replace timestamp)
   cp -r ~/.config/.bunkeros-backup-TIMESTAMP/* ~/.config/
   ```

3. **Check Installation Log**
   ```bash
   # Find log file
   ls /tmp/bunkeros-install-*.log
   
   # View errors
   grep -i "error\|fail" /tmp/bunkeros-install-*.log
   ```

4. **Re-run Installation**
   ```bash
   cd /path/to/bunkeros
   ./install.sh
   ```
   Installation will resume from last checkpoint.

## Comparison to Other Installers

These improvements were modeled after best practices from:

### EndeavourOS
- Package conflict handling with --overwrite
- Individual package retry logic
- Comprehensive logging

### ArchCraft
- Preflight system checks
- Service verification
- Post-install validation

### SwayFX
- Configuration validation before reboot
- Emergency fallback options
- Clear installation progress

## Future Improvements

Consider adding:

- [ ] Network connectivity retry logic
- [ ] Mirror selection for faster downloads
- [ ] Parallel package downloads
- [ ] System snapshot before installation (timeshift/snapper)
- [ ] Graphical installation progress
- [ ] Automatic bug reporting
- [ ] Post-install optimization wizard

## Maintenance Notes

### When Adding New Packages

1. Add to appropriate package array in `install.sh`
2. Test on fresh system
3. Document any known conflicts
4. Update validation script if needed

### When Modifying Config Files

1. Test with `sway --validate` before committing
2. Update fallback defaults if needed
3. Document breaking changes
4. Consider backward compatibility

### When Updating Dependencies

1. Check for new file conflicts
2. Update package installation logic if needed
3. Test emergency recovery session still works
4. Update documentation

## Support Resources

- **Main Documentation:** [README.md](README.md)
- **Installation Guide:** [INSTALL.md](INSTALL.md)
- **Troubleshooting:** [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **SDDM Issues:** [TROUBLESHOOTING-SDDM.md](TROUBLESHOOTING-SDDM.md)
- **Emergency Recovery:** [EMERGENCY-RECOVERY.md](EMERGENCY-RECOVERY.md)

## Credits

Improvements designed to match the robustness of:
- EndeavourOS installer team
- ArchCraft project
- SwayFX project

Testing and bug reports by: Ryan (X1 Carbon Gen9, CachyOS)
