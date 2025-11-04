# BunkerOS Multi-Monitor Support

Professional multi-monitor configuration for BunkerOS. This system provides automatic detection, easy configuration, and predictable workspace management across 1-5 displays.

## Overview

BunkerOS's multi-monitor system is designed around three principles:

1. **Works out of the box** - Single monitor setups require zero configuration
2. **Predictable workspace distribution** - Muscle memory-friendly workspace assignments
3. **Easy to customize** - Simple configuration files with clear documentation

## Quick Start

### Check Your Current Setup

```bash
# Detect connected monitors
bash ~/Projects/bunkeros/scripts/detect-monitors.sh
```

### Configure Multiple Monitors

```bash
# Interactive setup (recommended)
bash ~/Projects/bunkeros/scripts/setup-monitors.sh

# Automatic configuration
bash ~/Projects/bunkeros/scripts/setup-monitors.sh --auto
```

### Reload Configuration

After making changes to config files:

```bash
# In Sway, press:
Super + Shift + R

# Or from terminal:
swaymsg reload
```

## Architecture

Multi-monitor configuration is split into modular files:

```
~/.config/sway/
├── config                       # Main Sway config
└── config.d/
    ├── 00-variables.conf       # User-customizable monitor settings
    ├── 10-monitors.conf        # Physical monitor layout
    └── 20-workspaces.conf      # Workspace assignments
```

### File Descriptions

**00-variables.conf** - User preferences
- Monitor name variables (`$primary`, `$secondary`, `$tertiary`)
- Workspaces per monitor setting
- Auto-detection toggles

**10-monitors.conf** - Display configuration
- Resolution and position for each monitor
- HiDPI scaling settings
- Rotation and orientation
- Adaptive sync (FreeSync/G-Sync)

**20-workspaces.conf** - Workspace management
- Workspace-to-monitor assignments
- Optional workspace naming
- Multi-monitor keybindings

## Workspace Distribution

BunkerOS uses a simple, predictable workspace distribution strategy:

### Single Monitor
- **Workspaces 1-10**: Available on main display
- **Keybindings**: `Super + 1` through `Super + 0`

### Dual Monitor
- **Monitor 1 (Primary)**: Workspaces 1-5
- **Monitor 2 (Secondary)**: Workspaces 6-10
- **Keybindings**: 
  - `Super + 1-5` for primary monitor
  - `Super + 6-0` for secondary monitor

### Triple Monitor
- **Monitor 1 (Primary)**: Workspaces 1-5
- **Monitor 2 (Secondary)**: Workspaces 6-10
- **Monitor 3 (Tertiary)**: Workspaces 11-15
- **Keybindings**:
  - `Super + 1-5` for primary monitor
  - `Super + 6-0` for secondary monitor
  - `Super + F1-F5` for tertiary monitor

This distribution prevents workspace confusion and enables muscle memory - you always know which workspace is on which monitor.

## Common Configurations

### Laptop + External Monitor (Side-by-Side)

```bash
# 10-monitors.conf
output eDP-1 resolution 1920x1080 position 0,0
output DP-1 resolution 2560x1440 position 1920,0

# 20-workspaces.conf
workspace 1 output eDP-1
workspace 2 output eDP-1
workspace 3 output eDP-1
workspace 4 output eDP-1
workspace 5 output eDP-1

workspace 6 output DP-1
workspace 7 output DP-1
workspace 8 output DP-1
workspace 9 output DP-1
workspace 10 output DP-1
```

### Dual 4K Monitors with Scaling

```bash
# 10-monitors.conf
output DP-1 resolution 3840x2160 position 0,0 scale 1.5
output DP-2 resolution 3840x2160 position 2560,0 scale 1.5
```

### Triple Monitor (Center + Vertical Sides)

```bash
# 10-monitors.conf
output DP-1 resolution 2560x1440 position 1080,0          # Center
output HDMI-A-1 resolution 1920x1080 position 0,0 transform 270    # Left (portrait)
output DP-2 resolution 1920x1080 position 3640,0 transform 90      # Right (portrait)
```

### Mixed DPI Setup

```bash
# 10-monitors.conf
output eDP-1 resolution 1920x1080 position 0,0 scale 1.0    # Laptop screen
output DP-1 resolution 3840x2160 position 1920,0 scale 2.0  # 4K external
```

## Finding Monitor Names

```bash
# List all outputs
swaymsg -t get_outputs

# Just the names
swaymsg -t get_outputs | jq -r '.[] | .name'

# Detailed info with BunkerOS script
bash ~/Projects/bunkeros/scripts/detect-monitors.sh
```

Common monitor names:
- `eDP-1` - Laptop built-in display
- `DP-1`, `DP-2` - DisplayPort connections
- `HDMI-A-1`, `HDMI-A-2` - HDMI connections
- `DVI-D-1` - DVI connections

## Advanced Configuration

### Workspace Naming

Add semantic names to workspaces for better organization:

```bash
# 20-workspaces.conf
workspace 1 "1:Code"
workspace 2 "2:Browser"
workspace 3 "3:Terminal"
workspace 4 "4:Docs"
workspace 5 "5:Chat"
workspace 6 "6:Media"
workspace 7 "7:Email"
workspace 8 "8:Notes"
workspace 9 "9:Monitor"
workspace 10 "10:Scratch"
```

### Monitor Focus Shortcuts

Quickly jump between monitors:

```bash
# 20-workspaces.conf (uncomment these)
bindsym $mod+Ctrl+h focus output left
bindsym $mod+Ctrl+l focus output right
bindsym $mod+Ctrl+k focus output up
bindsym $mod+Ctrl+j focus output down
```

### Move Workspaces Between Monitors

```bash
# 20-workspaces.conf (uncomment these)
bindsym $mod+Ctrl+Shift+h move workspace to output left
bindsym $mod+Ctrl+Shift+l move workspace to output right
bindsym $mod+Ctrl+Shift+k move workspace to output up
bindsym $mod+Ctrl+Shift+j move workspace to output down
```

### Quick Monitor Jump

```bash
# 20-workspaces.conf (uncomment these)
bindsym $mod+Home workspace 1              # Primary monitor
bindsym $mod+Mod1+Home workspace 6         # Secondary monitor
bindsym $mod+Shift+Mod1+Home workspace 11  # Tertiary monitor
```

## Troubleshooting

### Monitors Not Detected

```bash
# Check if Sway sees the outputs
swaymsg -t get_outputs

# Reload Sway
swaymsg reload

# If still not working, check kernel messages
dmesg | grep -i drm
```

### Incorrect Resolution

```bash
# List available modes for a specific output
swaymsg -t get_outputs | jq '.[] | select(.name == "DP-1") | .modes'

# Set specific mode in 10-monitors.conf
output DP-1 mode 1920x1080@60Hz
```

### Workspace on Wrong Monitor

Check your workspace assignments in `20-workspaces.conf`:

```bash
# View current workspace assignments
grep "workspace .* output" ~/.config/sway/config.d/20-workspaces.conf

# Reload configuration
swaymsg reload
```

### HiDPI Scaling Issues

```bash
# Test different scale factors
swaymsg output DP-1 scale 1.5

# Once you find the right scale, update 10-monitors.conf
output DP-1 scale 1.5
```

### Monitor Position Misconfigured

```bash
# Check current positions
swaymsg -t get_outputs | jq '.[] | {name: .name, x: .rect.x, y: .rect.y}'

# Update positions in 10-monitors.conf
# X coordinate = horizontal position (0 is left)
# Y coordinate = vertical position (0 is top)
```

## Hot-Plugging Monitors

BunkerOS automatically detects when monitors are connected or disconnected. However, workspace assignments are static.

### Connecting a New Monitor

1. Connect the monitor physically
2. Run detection: `bash ~/Projects/bunkeros/scripts/detect-monitors.sh`
3. Configure: `bash ~/Projects/bunkeros/scripts/setup-monitors.sh`
4. Or manually add to `10-monitors.conf` and `20-workspaces.conf`

### Disconnecting a Monitor

Workspaces will automatically move to remaining monitors. No configuration change needed.

### Docking Station Workflow

For users with laptop docking stations:

```bash
# Create a docked configuration
cp ~/.config/sway/config.d/10-monitors.conf ~/.config/sway/config.d/10-monitors-docked.conf
cp ~/.config/sway/config.d/20-workspaces.conf ~/.config/sway/config.d/20-workspaces-docked.conf

# Create an undocked configuration
cp ~/.config/sway/config.d/10-monitors.conf ~/.config/sway/config.d/10-monitors-mobile.conf
cp ~/.config/sway/config.d/20-workspaces.conf ~/.config/sway/config.d/20-workspaces-mobile.conf

# Switch between them as needed (example script):
# ln -sf ~/.config/sway/config.d/10-monitors-docked.conf ~/.config/sway/config.d/10-monitors.conf
# swaymsg reload
```

## Performance Considerations

### Multiple 4K Monitors

For systems with multiple 4K displays:

- **Enable adaptive sync** for smoother rendering
- **Consider fractional scaling** (1.5x or 2x) to reduce GPU load
- **Disable animations** in applications (BunkerOS already has minimal effects)

```bash
# 10-monitors.conf
output DP-1 resolution 3840x2160 scale 1.5 adaptive_sync on
output DP-2 resolution 3840x2160 scale 1.5 adaptive_sync on
```

### Mixed Refresh Rates

If monitors have different refresh rates:

```bash
# Specify refresh rate explicitly
output DP-1 mode 2560x1440@144Hz
output HDMI-A-1 mode 1920x1080@60Hz
```

## Integration with BunkerOS Features

### Theme System

BunkerOS themes apply across all monitors automatically. Wallpapers are duplicated on each display.

### Auto-Scaling Service

The auto-scaling service (`scripts/auto-scaling-service.sh`) works with multi-monitor setups, applying optimal scaling per display.

### Waybar

Waybar can show different bars on each monitor. See `waybar/config` for multi-monitor bar configuration.

## Best Practices

1. **Use predictable workspace assignments** - Stick to the default 1-5, 6-10, 11-15 distribution
2. **Name your monitors** - Add comments in config files to remember which is which
3. **Test after changes** - Always run `swaymsg reload` to test configuration changes
4. **Keep backups** - Copy working configurations before making major changes
5. **Document custom layouts** - Add comments explaining your specific setup

## Migration from Single Monitor

If you're upgrading from a single monitor setup:

1. Your existing workspace habits (1-5) remain the same on your primary monitor
2. New workspaces (6-10) become available on the second monitor
3. No keybinding muscle memory is lost
4. Applications stay where they are

## Script Reference

### detect-monitors.sh

```bash
# Show all connected monitors with details
bash ~/Projects/bunkeros/scripts/detect-monitors.sh

# Get JSON output for scripting
bash ~/Projects/bunkeros/scripts/detect-monitors.sh --json

# Get primary monitor name
bash ~/Projects/bunkeros/scripts/detect-monitors.sh --primary

# Count monitors
bash ~/Projects/bunkeros/scripts/detect-monitors.sh --count
```

### setup-monitors.sh

```bash
# Interactive setup with prompts
bash ~/Projects/bunkeros/scripts/setup-monitors.sh

# Automatic configuration
bash ~/Projects/bunkeros/scripts/setup-monitors.sh --auto

# Help
bash ~/Projects/bunkeros/scripts/setup-monitors.sh --help
```

## See Also

- `man 5 sway-output` - Sway output configuration reference
- `ARCHITECTURE.md` - BunkerOS architecture overview
- `QUICKREF.md` - Quick reference for keybindings
- [Sway Wiki - Multihead](https://github.com/swaywm/sway/wiki#multihead-multiple-monitor-support)

## Philosophy

Multi-monitor support in BunkerOS follows the same principles as the rest of the system:

- **Performance First** - Zero overhead for single monitor users
- **Configuration Compatibility** - Works consistently across all hardware
- **Operational Efficiency** - Predictable, muscle-memory-friendly workspace distribution
- **Simplicity** - Easy to understand, easy to customize

Your monitors should serve your workflow, not complicate it.
