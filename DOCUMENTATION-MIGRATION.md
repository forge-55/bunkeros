# BunkerOS Documentation Migration

The BunkerOS documentation has been reorganized for clarity and includes new robust installation tools.

## Updated Documentation Structure

- **[README.md](README.md)** - Main overview, features, and quick installation
- **[INSTALL.md](INSTALL.md)** - Installation guide using robust installer
- **[INSTALLATION-v2.md](INSTALLATION-v2.md)** - Technical details about the new installation system
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Updated with new troubleshooting tools
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Technical architecture and design decisions

## New Installation Method

**Old method:**
```bash
./install.sh  # Often failed with cryptic errors
```

**New method (recommended):**
```bash
./scripts/check-compatibility.sh  # Check system first
./install-robust.sh               # Robust installer with error recovery
```

## New Troubleshooting Tools

- `./scripts/check-compatibility.sh` - Pre-installation system compatibility check
- `./scripts/verify-packages.sh` - Check and install missing packages
- `./scripts/fix-environment.sh` - Fix environment variables without logout
- `./scripts/validate-installation.sh` - Comprehensive installation validation

## What's Removed/Deprecated

- Long manual installation instructions (moved to automated scripts)
- Redundant package lists (now handled by verification script)
- Outdated troubleshooting steps (replaced with automated tools)

## Migration for Existing Users

If you have an existing BunkerOS installation:

```bash
cd ~/Projects/bunkeros
git pull

# Check for any missing packages or issues
./scripts/verify-packages.sh
./scripts/fix-environment.sh
./scripts/validate-installation.sh
```

Your existing installation will continue to work - the new tools are additive improvements.