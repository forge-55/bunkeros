# BunkerOS Installation System v2.0

## Overview

The improved BunkerOS installation system provides robust error handling, compatibility checking, and recovery options for reliable deployment across different Arch-based systems.

## Installation Scripts

### 1. Pre-Installation Check
```bash
./scripts/check-compatibility.sh
```
**Purpose**: Verifies system compatibility before installation
**Checks**:
- Arch-based system with pacman
- Internet connectivity 
- Display manager conflicts
- Disk space requirements
- Graphics and audio drivers
- Existing configuration conflicts

### 2. Robust Installer
```bash
./install-robust.sh
```
**Purpose**: Main installation script with improved error handling
**Features**:
- Automatic configuration backup
- Display manager conflict resolution
- Package verification with individual retry
- Service verification and startup
- Current session environment fixes
- Comprehensive logging
- Rollback instructions

### 3. Package Verification
```bash
./scripts/verify-packages.sh
```
**Purpose**: Verify all required packages are installed
**Features**:
- Checks all package categories
- Installs missing packages interactively
- Handles AUR packages separately
- Can be run standalone for troubleshooting

### 4. Environment Fix
```bash
./scripts/fix-environment.sh
```
**Purpose**: Fix environment variables and restart services in current session
**Fixes**:
- Electron app environment variables
- Wayland environment variables
- Restarts BunkerOS services (Waybar, Mako, autotiling)
- Applies current theme
- Reloads Sway configuration

## Quick Start

### New Installation
```bash
# 1. Check compatibility
./scripts/check-compatibility.sh

# 2. Install BunkerOS
./install-robust.sh

# 3. (Optional) Fix current session without logout
./scripts/fix-environment.sh
```

### Troubleshooting Existing Installation
```bash
# Check for missing packages
./scripts/verify-packages.sh

# Fix current session environment
./scripts/fix-environment.sh

# Full validation
./scripts/validate-installation.sh
```

## Key Improvements

### 1. **Error Recovery**
- Automatic configuration backup before installation
- Clear rollback instructions if installation fails
- Individual package verification and retry
- Service verification with automatic restart

### 2. **Display Manager Handling**
- Detects existing display managers (GDM, SDDM, LightDM, ly)
- Interactive choice to switch or keep existing
- Proper service management during transition

### 3. **Environment Variable Fixes**
- Critical Electron app variables set for current session
- Wayland environment properly configured
- Services restarted with correct environment
- No need to log out/in for basic functionality

### 4. **Package Management**
- Individual package verification
- Separate AUR package handling
- Missing package reports with manual install commands
- Graceful handling of package failures

### 5. **Comprehensive Logging**
- All actions logged to `/tmp/bunkeros-install.log`
- Color-coded output for different message types
- Timestamp tracking for troubleshooting

## Common Issues Fixed

### Issue 1: Autotiling Not Working
**Cause**: Missing `autotiling-rs` package
**Fix**: `./scripts/verify-packages.sh` detects and installs

### Issue 2: Electron Apps (VS Code, Cursor) Issues
**Cause**: Missing `ELECTRON_OZONE_PLATFORM_HINT` variable
**Fix**: `./scripts/fix-environment.sh` sets variables and restarts services

### Issue 3: Display Manager Conflicts
**Cause**: Multiple display managers enabled
**Fix**: `./install-robust.sh` detects conflicts and offers resolution

### Issue 4: Partial Installation Failures
**Cause**: Original installer's fragile multi-stage architecture
**Fix**: Robust installer with individual package verification and retry

### Issue 5: Missing Network/Bluetooth Management
**Cause**: Missing `network-manager-applet` and `blueman` packages
**Fix**: Package verification script ensures all utilities are installed

## File Structure

```
bunkeros/
├── install-robust.sh              # New robust installer
├── scripts/
│   ├── check-compatibility.sh     # Pre-installation compatibility check
│   ├── verify-packages.sh         # Package verification and installation
│   ├── fix-environment.sh         # Current session environment fixes
│   └── validate-installation.sh   # Existing validation script
└── INSTALLATION-v2.md             # This documentation
```

## Testing

The improved installation system has been tested on:
- ✅ CachyOS (Arch-based)
- ✅ Systems with existing Sway configurations
- ✅ Systems with different display managers (ly, GDM)
- ✅ Partial installation recovery scenarios

## Backwards Compatibility

- Original `install.sh` remains unchanged
- Original `setup.sh` used by robust installer
- All existing configuration files unchanged
- Git repository structure preserved

## Future Enhancements

1. **Distribution Detection**: Extend support beyond Arch-based systems
2. **Configuration Migration**: Import settings from other tiling WMs
3. **Hardware Optimization**: Automatic performance tuning based on hardware
4. **Remote Installation**: Support for network/cloud deployments
5. **Container Support**: Docker/Podman deployment options