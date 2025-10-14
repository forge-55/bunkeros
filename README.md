# Sway Configuration

A clean, minimal Sway setup with a tactical color palette inspired by military aesthetics. Features muted olive and tan tones with a focus on functionality and visual clarity.

## Features

- **Waybar** status bar with enhanced depth effects and tactical styling
- **Wofi** application launcher with command center aesthetic
- **Dynamic wallpaper** management via swaybg
- **Window gaps** for a modern tiled layout
- **Subtle transparency** on windows (95% opacity)
- **Custom color scheme** with olive drab, tactical gray, and tan accents
- **CSS box shadows** for visual depth without GPU compositor effects
- **Zero performance overhead** - all effects are pure CSS

## Color Palette

The configuration uses a carefully crafted military-inspired palette that balances functionality with aesthetics:

- **Primary (Khaki/Tan)** `#C3B091` - Focus indicators, highlights, active workspace markers
- **Secondary (Olive)** `#4A5240` - Accents, borders, workspace hover states
- **Tertiary (Muted Olive)** `#3C4A2F` - Subtle borders and secondary accents
- **Background (Charcoal)** `#1C1C1C` - Primary dark background
- **Surface (Tactical Gray)** `#2B2D2E` - Window backgrounds, input fields
- **Alert (Amber)** `#CC7832` - Warnings, critical states, mode indicators
- **Text (Off-White)** `#D4D4D4` - Primary text color

### Design Philosophy

The palette prioritizes readability and focus while maintaining a cohesive tactical aesthetic. Box shadows and border accents create visual hierarchy without requiring GPU-intensive compositor effects, making it ideal for older hardware like the ThinkPad T480.

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
gaps inner 8    # Space between windows
gaps outer 8    # Space around edges
default_border pixel 3    # Border thickness
```

### Visual Effects

All depth effects are achieved through CSS box shadows, which are GPU-accelerated and have zero CPU overhead. This approach provides visual polish without the performance cost of compositor-level effects like blur or animations.

**Waybar enhancements:**
- Drop shadow for panel separation
- Inset shadows on modules for recessed tactical display
- Left border accents (stencil effect)
- Enhanced focus states on workspaces

**Wofi enhancements:**
- Command center aesthetic with strong window shadow
- Dual-tone border treatment
- Inset shadows on input fields
- Left accent bar on selections

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

## Performance Notes

This configuration is optimized for lightweight performance on older hardware. All visual enhancements use CSS-based effects rather than compositor-level features, resulting in:

- Minimal RAM usage (~50-80MB for Sway)
- No GPU-intensive blur or animation effects
- Zero CPU overhead from visual styling
- Tested and optimized for ThinkPad T480 (Intel UHD 620)

## Credits

Built with inspiration from popular tiling window manager configurations including Hyprland and COSMIC. Visual polish achieved through smart CSS styling rather than compositor effects.

