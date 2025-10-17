# BunkerOS Edition Switching

BunkerOS provides two editions (Standard and Enhanced) using a single SwayFX compositor with effects toggled on/off.

## Architecture

**Both editions use SwayFX** - the difference is whether visual effects are enabled or disabled:

### Standard Edition
- **Compositor**: SwayFX with effects disabled
- **Performance**: Maximum (~332 MB RAM, minimal GPU usage)
- **Behavior**: Identical to vanilla Sway
- **Use case**: Older hardware, production environments, performance-focused users

### Enhanced Edition  
- **Compositor**: SwayFX with effects enabled
- **Performance**: Excellent (~360 MB RAM, moderate GPU usage)
- **Features**: Rounded corners, shadows, blur, fade animations
- **Use case**: Modern hardware, users wanting visual polish

## How It Works

Visual effects are controlled via a config file:
```
~/.config/sway/config.d/swayfx-effects.conf
```

The launcher scripts manage this file:

**Standard Edition Launcher:**
- Creates an **empty** `swayfx-effects.conf` file
- SwayFX runs with no effects
- Performs like vanilla Sway

**Enhanced Edition Launcher:**
- **Symlinks** the actual effects config to `swayfx-effects.conf`
- SwayFX runs with all effects enabled
- Modern visual aesthetics

## Session Files

SDDM session files use launcher scripts:

**bunkeros-standard.desktop:**
```
Exec=/home/ryan/Projects/bunkeros/scripts/launch-bunkeros-standard.sh
```

**bunkeros-enhanced.desktop:**
```
Exec=/home/ryan/Projects/bunkeros/scripts/launch-bunkeros-enhanced.sh
```

Both execute the same `sway` binary (which is SwayFX).

## Manual Switching

Launch from TTY without SDDM:

```bash
# Standard Edition (effects off)
/home/ryan/Projects/bunkeros/scripts/launch-bunkeros-standard.sh

# Enhanced Edition (effects on)
/home/ryan/Projects/bunkeros/scripts/launch-bunkeros-enhanced.sh
```

## Why SwayFX for Both?

The `swayfx` package from Arch/CachyOS repositories **replaces** the `sway` binary - it doesn't create a separate `swayfx` command. This means:

- Cannot have both vanilla Sway and SwayFX installed simultaneously
- SwayFX conflicts with the `sway` package
- `/usr/bin/sway` is SwayFX when the package is installed

Since SwayFX with effects disabled performs identically to vanilla Sway, using it for both editions provides:

✅ Single compositor to install and maintain
✅ Flexibility to enable/disable effects per session
✅ Same performance as vanilla Sway (Standard)
✅ Visual polish when desired (Enhanced)

## Installation

After updating session files:

```bash
cd /home/ryan/Projects/bunkeros/sddm
sudo ./install-theme.sh
```

This installs the session files to `/usr/share/wayland-sessions/`.

## Package Requirements

Only one package needed:

```bash
sudo pacman -S swayfx
```

The `swayfx` package provides everything for both editions. Do NOT install the `sway` package alongside it (they conflict).
