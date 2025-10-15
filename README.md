# Sway Configuration

A clean, minimal Sway setup with a tactical color palette inspired by military aesthetics. Features muted olive and tan tones with a focus on functionality and visual clarity.

## Features

- **Waybar** status bar with flat, tactical styling
- **Numbered workspace indicators** (1-7) with ArchCraft-inspired design and refined box styling
- **Wofi** application launcher with minimal design aesthetic
- **Custom terminal** with military-inspired prompt design and tactical color scheme
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

### Fonts

This configuration requires a **Nerd Font** to display icons properly in Waybar. Nerd Fonts are patched fonts that include thousands of glyphs (icons) from popular icon collections like Font Awesome and Material Design Icons.

**Install MesloLGL Nerd Font (recommended):**
```bash
sudo pacman -S ttf-meslo-nerd
```

**Alternative - Install all Nerd Font symbols:**
```bash
sudo pacman -S ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
```

After installing the font, restart Waybar to see the icons:
```bash
pkill waybar && waybar &
```

The configuration uses MesloLGL Nerd Font by default, but you can change this in `waybar/style.css` if you prefer a different Nerd Font.

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
mkdir -p ~/.config/sway ~/.config/waybar ~/.config/wofi ~/.config/foot

# Symlink configs
ln -sf $(pwd)/sway/config ~/.config/sway/config
ln -sf $(pwd)/waybar/config ~/.config/waybar/config
ln -sf $(pwd)/waybar/style.css ~/.config/waybar/style.css
ln -sf $(pwd)/wofi/config ~/.config/wofi/config
ln -sf $(pwd)/wofi/style.css ~/.config/wofi/style.css
ln -sf $(pwd)/foot/foot.ini ~/.config/foot/foot.ini
ln -sf $(pwd)/bashrc ~/.bashrc

# Make scripts executable
chmod +x waybar/scripts/*.sh

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
- Numbered workspace indicators with refined box styling (ArchCraft-inspired)
- 7 persistent workspaces with tactical spacing
- Minimal borders with rounded corners
- Active workspace: khaki border and text, enhanced padding
- Inactive workspace: subtle olive border with muted text
- Hover workspace: semi-transparent background
- Icon-based status modules with dynamic states
- Power menu, network manager, and battery info on click
- Clean spacing and uniform icon distribution

**Wofi enhancements:**
- Minimal border treatment for clean appearance
- Subtle left accent bar on selections
- Flat input field styling
- Focus on content over decoration

**Terminal styling:**
- Two-line prompt with tactical separators
- Current directory in khaki with git branch integration
- Status indicator (olive for success, amber for errors)
- Military color palette throughout
- Beam cursor with blink
- Custom color scheme for man pages and less
- Font size optimized for 1920x1080 displays

### Colors

All color values are clearly labeled in each config file. The Sway window colors are in `sway/config` starting at line 47.

## Workspaces

The configuration features 7 persistent numbered workspaces with subtle, non-distracting design:

**Visual states:**
- **Inactive**: Minimal styling with muted olive text
- **Active**: Bold khaki text with subtle olive background and defined border
- **Hover**: Light olive tint with khaki text
- **Urgent**: Amber background with pulsing animation

Numbered workspaces provide clear identification while staying unobtrusive during focused work. The design works naturally with Waybar's capabilities and fits the military tactical aesthetic. Workspaces are flexible and not assigned to specific applications.

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

