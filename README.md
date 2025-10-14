# Sway Configuration

A clean, minimal Sway setup with a tactical color palette inspired by military aesthetics. Features muted olive and tan tones with a focus on functionality and visual clarity.

## Features

- **Waybar** status bar with a 24-hour clock and system monitoring
- **Wofi** application launcher with matching theme
- **Dynamic wallpaper** management via swaybg
- **Window gaps** for a modern tiled layout
- **Subtle transparency** on windows (95% opacity)
- **Custom color scheme** with olive drab, tactical gray, and tan accents

## Color Palette

- **Tan/Khaki** `#C3B091` - Focused window borders and highlights
- **Olive Drab** `#4A5240` - Secondary accents
- **Tactical Gray** `#2B2D2E` - Window backgrounds
- **Charcoal** `#1C1C1C` - Dark backgrounds
- **Amber** `#CC7832` - Alerts and warnings
- **Off-White** `#D4D4D4` - Primary text

## Requirements

```bash
sudo pacman -S sway waybar wofi swaybg brightnessctl
```

Your system should have a monospace Nerd Font installed for the best experience. The config uses MesloLGL Nerd Font by default.

## Installation

Clone this repo and symlink the configs:

```bash
git clone https://github.com/yourusername/sway-military-config.git
cd sway-military-config

# Backup existing configs if you have any
mkdir -p ~/.config/backup
cp -r ~/.config/sway ~/.config/backup/ 2>/dev/null || true
cp -r ~/.config/waybar ~/.config/backup/ 2>/dev/null || true
cp -r ~/.config/wofi ~/.config/backup/ 2>/dev/null || true

# Create config directories
mkdir -p ~/.config/sway ~/.config/waybar ~/.config/wofi

# Symlink configs
ln -sf $(pwd)/sway/config ~/.config/sway/config
ln -sf $(pwd)/waybar/config ~/.config/waybar/config
ln -sf $(pwd)/waybar/style.css ~/.config/waybar/style.css
ln -sf $(pwd)/wofi/config ~/.config/wofi/config
ln -sf $(pwd)/wofi/style.css ~/.config/wofi/style.css

# Reload Sway
swaymsg reload
```

## Customization

### Wallpaper

Edit `sway/config` line 34 to set your wallpaper:

```
exec_always "killall swaybg 2>/dev/null; swaybg -i ~/Pictures/your-wallpaper.jpg -m fill"
```

### Gaps and Borders

Adjust window spacing in `sway/config`:

```
gaps inner 7    # Space between windows
gaps outer 7    # Space around edges
default_border pixel 3    # Border thickness
```

### Colors

All color values are clearly labeled in each config file. The Sway window colors are in `sway/config` starting at line 47.

## Key Bindings

Uses standard Sway bindings with Mod4 (Super/Windows key):

- **Mod+Return** - Open terminal
- **Mod+d** - Launch Wofi
- **Mod+Shift+q** - Close window
- **Mod+h/j/k/l** - Navigate windows (vim keys)
- **Mod+1-9** - Switch workspaces
- **Mod+r** - Resize mode

See `sway/config` for all keybindings.

## Credits

Built with inspiration from popular tiling window manager configurations including Hyprland and COSMIC.

