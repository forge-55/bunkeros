# BunkerOS Scripts Directory

This directory contains all utility scripts for BunkerOS installation, configuration, and maintenance.

## Installation Scripts

### Core Installation
- **`../install.sh`** - Main installer (run this first!)
  - Installs all packages
  - Runs setup.sh automatically
  - Installs SDDM theme and sessions
  - Configures user services
  - Validates everything

- **`../setup.sh`** - Configuration setup
  - Creates symlinks to config files
  - Copies theme-switchable files
  - Sets up user environment
  - Called automatically by install.sh

### System Integration
- **`install-system-services.sh`** - System-wide service installation
  - SDDM theme and session installation wrapper
  - Interactive version for manual setup

- **`install-user-environment.sh`** - User service configuration
  - Enables PipeWire audio services
  - Configures browser Wayland support
  - Sets dark theme preference

## Validation & Troubleshooting

### Primary Tools
- **`validate-installation.sh`** ⭐ **RUN THIS AFTER INSTALL**
  - Comprehensive installation checker
  - Validates 80+ components
  - Provides exact fix commands for issues
  - Exit code 0 = success, 1 = errors found

- **`quick-fix.sh`** ⭐ **FIRST THING TO TRY IF BROKEN**
  - Fixes most common installation issues
  - Repairs environment.d symlink problem
  - Reinstalls SDDM sessions
  - Enables services
  - One-command recovery

- **`rollback-installation.sh`** - Restore from backup
  - Finds latest backup automatically
  - Restores all configurations
  - Safe and interactive

### Diagnostic Tools
- **`check-compatibility.sh`** - Pre-installation check
  - Verifies Arch Linux system
  - Checks disk space
  - Validates internet connection

- **`verify-packages.sh`** - Package verification
  - Lists missing packages
  - Provides install commands

- **`diagnose-sddm-login.sh`** - SDDM diagnostics
  - Checks SDDM configuration
  - Validates session files
  - Tests login manager setup

## Session Management

### Launch Scripts
- **`launch-bunkeros.sh`** - Main BunkerOS launcher
  - Installed to `/usr/local/bin/`
  - Called by SDDM to start BunkerOS session
  - Validates environment before starting Sway
  - Starts required services
  - Logs to `/tmp/bunkeros-launch.log`

- **`launch-bunkeros-emergency.sh`** - Emergency recovery launcher
  - Boots to foot terminal
  - For troubleshooting and recovery
  - Access via "BunkerOS Emergency" session

### Session Testing
- **`test-sessions.sh`** - Test session configuration
- **`debug-sessions.sh`** - Debug session issues

## Display & Monitor Management

### Monitor Configuration
- **`detect-monitors.sh`** - Detect connected monitors
  - Shows monitor details
  - Outputs workspace distribution recommendations

- **`setup-monitors.sh`** - Multi-monitor workspace setup
  - Interactive monitor configuration
  - Workspace distribution across displays
  - Creates Sway config snippets

- **`detect-display-hardware.sh`** - Display hardware detection
  - GPU information
  - Driver details

## Power & Performance Optimization ⚡ NEW

### Advanced Performance Suite
- **`install-advanced-performance.sh`** ⭐ **ALL-IN-ONE OPTIMIZER**
  - Runs all performance optimization scripts
  - Configures GPU, I/O, and kernel parameters
  - Interactive installer with verification
  - **Use this to upgrade existing systems to full optimization**

### Individual Optimization Scripts
- **`configure-gpu-power.sh`** - GPU power management
  - Auto-detects Intel/AMD/Nvidia GPUs
  - Enables runtime power management
  - Configures vendor-specific power features
  - Saves 2-8W at idle

- **`configure-io-scheduler.sh`** - I/O scheduler optimization
  - Detects NVMe/SSD/HDD storage types
  - Sets optimal I/O scheduler per device
  - Configures read-ahead and queue depth
  - Improves performance 15-25%

- **`install-power-management.sh`** - Core power management (EXISTING)
  - Installs auto-cpufreq
  - Configures systemd-logind
  - Sets up profile switching
  - Base CPU frequency management

### Power Analysis Tools
- **`power-usage-report.sh`** - Power consumption diagnostics (PLANNED)
- **`benchmark-power-performance.sh`** - Performance benchmarking (PLANNED)

**Documentation:**
- User Guide: `../docs/features/power-optimization.md`
- Technical Details: `../docs/development/performance-optimization-plan.md`
- Quick Reference: `../docs/PERFORMANCE-OPTIMIZATION.md`


### Display Scaling
- **`configure-display-scaling.sh`** - Manual scaling configuration
- **`auto-scaling-service-v2.sh`** - Automatic scaling (runs on login)
- **`auto-scaling-service.sh`** - Legacy auto-scaling
- **`test-auto-scaling.sh`** - Test scaling detection
- **`migrate-to-scaling-v2.sh`** - Migrate to v2 scaling

## Environment & Configuration

### Environment Setup
- **`fix-environment.sh`** - Fix environment variables
  - Repairs Wayland environment
  - Restarts affected processes

- **`configure-browser-wayland.sh`** - Browser Wayland configuration
  - Sets up screen sharing support
  - Configures browser flags

### Theme Management
- **`theme-switcher.sh`** - Switch BunkerOS themes
  - 5 themes available: tactical, night-ops, sahara, abyss, winter
  - Updates all components (Waybar, Wofi, Mako, etc.)

- **`workspace-style-switcher.sh`** - Waybar workspace styles
  - Changes workspace indicator appearance

## Application Management

### Default Applications
- **`install-default-apps.sh`** - Install recommended applications
  - Browsers, editors, utilities
  - Optional applications

- **`apply-mime-types.sh`** - Configure file associations
- **`verify-mime-types.sh`** - Verify MIME type configuration

## Power Management

- **`install-power-management.sh`** - Power configuration
  - Configures auto-suspend
  - Sets up screen timeout
  - Installs systemd-logind config

## Screensaver

- **`bunkeros-screensaver.sh`** - Terminal screensaver
  - Matrix effect with TerminalTextEffects
  
- **`launch-screensaver.sh`** - Screensaver launcher

## Waybar Integration

Located in `../waybar/scripts/`:
- `workspaces.sh` - Workspace indicator
- `battery.sh` - Battery status
- `clock.sh` - Clock display
- And more...

## File Previews

- **`lf-preview.sh`** - File preview for lf file manager

## Utility Scripts

- **`list-all-packages.sh`** - List all installed BunkerOS packages
- **`test-without-waybar.sh`** - Test Sway without Waybar

## Usage Examples

### Fresh Installation
```bash
cd ~/Projects/bunkeros
./install.sh
./scripts/validate-installation.sh
# Log out and select "BunkerOS" session
```

### Fix Broken Installation
```bash
cd ~/Projects/bunkeros
./scripts/quick-fix.sh
./scripts/validate-installation.sh
```

### Rollback Changes
```bash
cd ~/Projects/bunkeros
./scripts/rollback-installation.sh
```

### Multi-Monitor Setup
```bash
~/Projects/bunkeros/scripts/detect-monitors.sh
~/Projects/bunkeros/scripts/setup-monitors.sh
```

### Switch Theme
```bash
~/Projects/bunkeros/scripts/theme-switcher.sh tactical
```

## Common Workflows

### After Installation
1. Run `validate-installation.sh`
2. Check for errors
3. Log out
4. Select "BunkerOS" session
5. Log in

### Troubleshooting
1. Use "BunkerOS Emergency" session to access terminal
2. Run `quick-fix.sh`
3. Run `validate-installation.sh`
4. Check `/tmp/bunkeros-launch.log`
5. See `TROUBLESHOOTING-INSTALLATION.md`

### Updating BunkerOS
```bash
cd ~/Projects/bunkeros
git pull
./scripts/validate-installation.sh
# If changes needed:
./setup.sh
```

## File Permissions

All scripts should be executable. If not:
```bash
chmod +x ~/Projects/bunkeros/scripts/*.sh
```

## Logging

Most scripts log to:
- `/tmp/bunkeros-install.log` - Installation log
- `/tmp/bunkeros-launch.log` - Session launch log
- User journal: `journalctl --user -b`
- System journal: `journalctl -b`

## Getting Help

1. Run validation: `./scripts/validate-installation.sh`
2. Check logs: `cat /tmp/bunkeros-launch.log`
3. Read: `TROUBLESHOOTING-INSTALLATION.md`
4. Open GitHub issue with validation output

## Script Maintenance

When adding new scripts:
1. Add shebang: `#!/usr/bin/env bash`
2. Add description comment
3. Make executable: `chmod +x script.sh`
4. Test thoroughly
5. Update this README
