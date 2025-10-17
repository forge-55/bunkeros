# Switching Between Sway and SwayFX

BunkerOS supports both vanilla Sway (Standard Edition) and SwayFX (Enhanced Edition) with a single configuration.

## The Problem

SwayFX includes visual effect commands (`corner_radius`, `shadows`, `blur`, etc.) that vanilla Sway doesn't understand. If these commands are loaded in vanilla Sway, you'll see a red error bar saying "There are errors in your config file."

## The Solution

BunkerOS uses launcher scripts that automatically enable/disable SwayFX effects based on which edition you're running:

### Standard Edition (Vanilla Sway)
- Launcher: `/home/ryan/Projects/bunkeros/scripts/launch-bunkeros-standard.sh`
- Creates an empty `swayfx-effects.conf` file
- No visual effects loaded
- Maximum performance

### Enhanced Edition (SwayFX)
- Launcher: `/home/ryan/Projects/bunkeros/scripts/launch-bunkeros-enhanced.sh`
- Symlinks the actual SwayFX effects configuration
- Enables rounded corners, shadows, blur, etc.
- Modern visual aesthetics

## How It Works

1. The main Sway config includes: `~/.config/sway/config.d/swayfx-effects.conf`

2. Standard Edition launcher creates an **empty** file at that location

3. Enhanced Edition launcher **symlinks** the actual effects file to that location

4. Both editions use the same config - the effects are just enabled/disabled dynamically

## Session Files

The SDDM session files use these launchers:

- **BunkerOS (Standard)**: Runs `launch-bunkeros-standard.sh` → vanilla Sway
- **BunkerOS (Enhanced)**: Runs `launch-bunkeros-enhanced.sh` → SwayFX

## Manual Switching (Without SDDM)

If you want to manually launch from a TTY:

```bash
# Launch Standard Edition
/home/ryan/Projects/bunkeros/scripts/launch-bunkeros-standard.sh

# Launch Enhanced Edition
/home/ryan/Projects/bunkeros/scripts/launch-bunkeros-enhanced.sh
```

## Installation

After updating the session files, reinstall them:

```bash
cd /home/ryan/Projects/bunkeros/sddm
sudo ./install-theme.sh
```

This copies the updated session files to `/usr/share/wayland-sessions/`.

