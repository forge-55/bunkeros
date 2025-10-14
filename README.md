# Sway Configuration

A clean, minimal Sway setup with a tactical color palette inspired by military aesthetics. Features muted olive and tan tones with a focus on functionality and visual clarity.

## Features

- **Waybar** status bar with flat, tactical styling
- **Numbered workspaces** (1-7) with ArchCraft-inspired circular indicators
- **Wofi** application launcher with minimal design aesthetic
- **Dynamic wallpaper** management via swaybg
- **Window gaps** for a modern tiled layout
- **Subtle transparency** on windows (95% opacity)
- **Custom color scheme** with olive drab, tactical gray, and tan accents
- **Flat design philosophy** - function over decoration
- **Zero performance overhead** - pure CSS styling

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

The palette prioritizes readability and focus while maintaining a cohesive tactical aesthetic. The design follows a flat, understated approach with minimal shadows and clean borders - emphasizing function over decoration, perfect for performance-conscious setups like the ThinkPad T480.

## Requirements

```bash
sudo pacman -S sway waybar wofi swaybg brightnessctl
```

Your system should have a monospace Nerd Font installed for the best experience. The config uses MesloLGL Nerd Font by default.

## Installation

Clone this repo and symlink the configs:

```bash
git clone https://github.com/forge-55/sway.git
cd sway

# Backup existing configs if you have any
mkdir -p ~/.config/backup
cp -r ~/.config/sway ~/.config/backup/ 2>/dev/null || true
cp -r ~/.config/waybar ~/.config/backup/ 2>/dev/null || true
cp -r ~/.config/wofi ~/.config/backup/ 2>/dev/null ￼|| true

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

The design embraces a flat, minimal aesthetic with restrained use of visual effects. All styling is pure CSS with zero performance overhead.

**Waybar enhancements:**
- Circular workspace indicators (ArchCraft-inspired)
- 7 persistent workspaces with clear visual hierarchy
- Active workspace: filled khaki circle
- Inactive workspace: hollow circle with olive border
- Hover workspace: semi-transparent fill
- Urgent workspace: filled amber circle with pulsing glow animation
- Clean module separation through subtle backgrounds

**Wofi enhancements:**
- Minimal border treatment for clean appearance
- Subtle left accent bar on selections
- Flat input field styling
- Focus on content over decoration

### Colors

All color values are clearly labeled in each config file. The Sway window colors are in `sway/config` starting at line 47.

## Workspaces

The configuration features 7 persistent numbered workspaces with ArchCraft-inspired circular indicators:

```
○ ○ ● ○ ○ ○ ○
1 2 3 4 5 6 7
```

**Visual states:**
- **Inactive**: Hollow circle with olive border, muted number
- **Active**: Filled khaki circle with dark text and subtle glow
- **Hover**: Semi-transparent fill with khaki border
- **Urgent**: Filled amber circle with pulsing alert animation

Workspaces are flexible and not assigned to specific applications, allowing you to organize your workflow as needed.

## Key Bindings

Uses standard Sway bindings with Mod4 (Super/Windows key):

- **Mod+Return** - Open terminal
- **Mod+d** - Launch Wofi
- **Mod+Shift+q** - Close window
- **Mod+h/j/k/l** - Navigate windows (vim keys)
- **Mod+1-7** - Switch workspaces
- **Mod+Shift+1-7** - Move window to workspace
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

