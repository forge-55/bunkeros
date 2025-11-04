# BunkerOS Development Roadmap

This document outlines planned improvements and long-term goals for BunkerOS.

---

## Short-term Improvements & Enhancements


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

---

## Long-term Goal: Custom BunkerOS ISO


## Current State: Configuration Layer

**What BunkerOS is now:**
- Sway-based desktop environment configuration
- Runs on top of existing Arch-based distributions
- Installation scripts to deploy configs
- Works on: Arch, Manjaro, EndeavourOS, **CachyOS**, etc.

**Current Installation Process:**
1. User has existing Arch-based system (CachyOS, etc.)
2. Runs `install.sh` (Phase 1)
3. Runs `install-sddm.sh` (Phase 2)
4. Inherits base system quirks (CachyOS ships `ly`, etc.)

## Vision: Standalone Distribution

**What BunkerOS should become:**
- **Complete Arch-based distribution** from the ground up
- **BunkerOS ISO** that users flash to USB and install
- **Vanilla Arch base** with BunkerOS defaults
- **No inherited quirks** from other distros
- **Optimized kernel** (CachyOS optimizations + BunkerOS tuning)

## Why This Matters

### Current Problems with Derivative Installs

**CachyOS Example:**
- Ships with `ly` display manager by default
- Our install script must detect and replace it
- User might have CachyOS-specific configs that conflict
- Can't guarantee clean state
- Two-phase install needed to prevent breaking sessions

**Manjaro Example:**
- Ships with specific kernel versions
- Has its own pamac/octopi package managers
- Different default configs than vanilla Arch
- Potential conflicts with BunkerOS assumptions

**The Core Issue:**
- We're building on top of someone else's foundation
- Each derivative has its own opinions
- More complexity in installation scripts
- Harder to troubleshoot user issues

### Benefits of Standalone ISO

**1. Clean Slate**
- Start from vanilla Arch
- No pre-installed display managers to replace
- No conflicting configs
- Predictable base state

**2. Simpler Installation**
- Single-phase install (no existing DM to worry about)
- Can configure everything during ISO install
- No need to detect/handle 10 different scenarios

**3. Better User Experience**
- Flash USB → Install → Done
- Just like any other Linux distro
- No "install on top of X" instructions
- Professional appearance

**4. Optimization Control**
- Custom kernel with BunkerOS-specific optimizations
- Pre-tuned for Sway/Wayland performance
- Power management configured correctly from start
- No bloat from base distro

**5. Branding & Identity**
- BunkerOS is THE distro, not a config pack
- Can ship with custom boot splash
- Custom installer with BunkerOS theming
- Positions as complete solution

## Roadmap to Standalone ISO

### Phase 1: ISO Creation (Current Priority) ✅

**Goal:** Create bootable BunkerOS ISO

**Steps:**
1. Start with vanilla Arch base
2. Use `archiso` to build custom ISO
3. Pre-configure:
   - SDDM as display manager
   - BunkerOS session files
   - All configs in place
   - PipeWire enabled by default
   - Power management configured
4. Test in VM (QEMU/VirtualBox)
5. Test on real hardware

**Deliverable:** `bunkeros-YYYY.MM.DD-x86_64.iso`

### Phase 2: Custom Installer

**Goal:** Professional installation experience

**Options:**
1. **Calamares Installer** (Most professional)
   - Used by Manjaro, EndeavourOS, etc.
   - Graphical, user-friendly
   - Easy to customize
   
2. **Archinstall** (Arch's official installer)
   - TUI-based
   - Lightweight
   - Good for advanced users
   
3. **Custom Script-based Installer**
   - Full control
   - Can be very BunkerOS-specific
   - More work to maintain

**Recommendation:** Start with Archinstall, move to Calamares later

### Phase 3: Kernel Optimization

**Goal:** Custom kernel for Sway/Wayland performance

**Optimizations:**
- CachyOS kernel patches (performance)
- Wayland-specific optimizations
- Power management tuning
- Disable unused kernel modules
- Optimize for modern hardware (2015+)

**Build System:**
- Automated kernel builds
- Version management
- Test before release

### Phase 4: Package Repository

**Goal:** BunkerOS-specific package repository

**Packages to Host:**
- Custom kernel builds
- BunkerOS configurations
- Patched/optimized versions of key software
- AUR packages we depend on (pre-built)

**Benefits:**
- Users don't need AUR helpers
- Faster installation
- Version control
- Can patch upstream bugs

### Phase 5: Automated Builds & Releases

**Goal:** Monthly ISO releases

**System:**
- GitHub Actions to build ISOs
- Automated testing in VM
- Release on schedule (e.g., monthly)
- Versioning: `bunkeros-2025.11.03-x86_64.iso`

**Distribution:**
- GitHub Releases
- Torrent support (bandwidth)
- Mirrors (if needed)

## Technical Implementation

### Directory Structure for ISO Build

```
bunkeros/
├── iso/
│   ├── archiso/           # Base archiso configs
│   ├── airootfs/          # Files to include in live environment
│   │   ├── etc/
│   │   │   └── sddm.conf
│   │   ├── usr/
│   │   │   └── share/
│   │   │       ├── sddm/themes/tactical/
│   │   │       └── wayland-sessions/
│   │   └── root/
│   │       └── install-to-disk.sh
│   ├── packages.x86_64    # Packages to include
│   └── build-iso.sh       # ISO build script
├── configs/               # Current BunkerOS configs
└── scripts/               # Current scripts
```

### Minimal packages.x86_64

```
# Base system
base
base-devel
linux
linux-firmware

# Boot
grub
efibootmgr

# Network
networkmanager
iwd

# Display
sddm
qt5-declarative
qt5-quickcontrols2

# Wayland/Sway
sway
swaybg
swaylock
swayidle
waybar
wofi
mako
foot

# BunkerOS essentials
autotiling-rs
pipewire
pipewire-pulse
wireplumber
brightnessctl
playerctl
grim
slurp
wl-clipboard

# Utilities
nautilus
btop
lite-xl
mate-calc
```

### Build ISO Command

```bash
cd bunkeros/iso
sudo mkarchiso -v -w work/ -o out/ archiso/
```

**Output:** `bunkeros-YYYY.MM.DD-x86_64.iso`

## Migration Path for Existing Users

Users who installed BunkerOS on CachyOS/Manjaro/etc. can:

**Option 1: Keep current setup**
- Continue using BunkerOS configs on their distro
- Use two-phase installation
- Update configs via git pull

**Option 2: Migrate to BunkerOS ISO**
- Backup home directory
- Install BunkerOS ISO fresh
- Restore home directory
- Cleaner, more maintainable

## Timeline Estimate

**Immediate (Next 2 weeks):**
- ✅ Two-phase installation (DONE)
- Create basic ISO with archiso
- Test in VM

**Short-term (1-2 months):**
- Refine ISO build process
- Add archinstall integration
- First public ISO release
- Documentation for ISO installation

**Medium-term (3-6 months):**
- Custom kernel builds
- Package repository setup
- Automated monthly releases
- Calamares installer integration

**Long-term (6-12 months):**
- Full-featured custom installer
- Optimized kernel performance
- Large user base on standalone ISO
- Community mirrors

## Decision Points

### Should we maintain both?

**Configuration Layer (Current):**
- For users who want BunkerOS on existing systems
- Lower barrier to entry (no reinstall needed)
- Good for testing/trying out

**Standalone ISO (Future):**
- For serious users who want full BunkerOS experience
- Best performance and reliability
- Recommended path forward

**Answer:** Yes, maintain both, but **recommend ISO** as primary method.

## Resources Needed

1. **Development:**
   - Learn archiso build system
   - Set up ISO build environment
   - Test on multiple hardware configs

2. **Infrastructure:**
   - GitHub Actions for builds (free)
   - GitHub Releases for distribution (free)
   - Optional: SourceForge mirrors (free)

3. **Documentation:**
   - ISO installation guide
   - Migration guide from config layer
   - Troubleshooting ISO-specific issues

4. **Testing:**
   - VM testing (QEMU, VirtualBox)
   - Real hardware testing (various machines)
   - Community beta testing

## Next Steps

**Immediate action items:**

1. **Create `iso/` directory** in repo
2. **Set up basic archiso config**
3. **Build first test ISO**
4. **Boot in VM and verify:**
   - Sway works
   - SDDM works
   - BunkerOS session available
   - Configs are applied
5. **Document ISO build process**
6. **Create installation script for ISO**

**Would you like me to start building the ISO structure?**

## Conclusion

Moving from a configuration layer to a standalone distribution is the natural evolution of BunkerOS. It will:

- **Eliminate** issues with derivative distros (CachyOS, Manjaro quirks)
- **Simplify** installation (single-phase, clean install)
- **Improve** reliability (known base state)
- **Enable** optimizations (custom kernel)
- **Position** BunkerOS as a complete solution

The two-phase installation we just built is the **interim solution** for users on existing systems. The **long-term solution** is a BunkerOS ISO that Just Works™.
