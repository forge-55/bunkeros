# BunkerOS Wallpapers

This directory contains the official wallpapers for each BunkerOS theme.

## Included Wallpapers

- **tactical.jpg** - Default BunkerOS (Tactical) theme wallpaper
- **gruvbox.jpg** - Gruvbox Dark theme wallpaper
- **nord.jpg** - Nord theme wallpaper
- **everforest.jpg** - Everforest theme wallpaper
- **tokyo-night.jpg** - Tokyo Night theme wallpaper

## Installation

Wallpapers are automatically installed during BunkerOS setup:

```bash
cd ~/Projects/bunkeros
./setup.sh
```

The setup script creates a symlink from `~/.local/share/bunkeros/wallpapers/` to this directory.

## How It Works

Each theme's `theme.conf` file specifies its wallpaper:

```bash
WALLPAPER="$HOME/.local/share/bunkeros/wallpapers/tactical.jpg"
```

When you switch themes (Super+m → Theme → Change Theme), the theme switcher automatically:
1. Reads the WALLPAPER path from the theme's config
2. Kills the existing swaybg process
3. Launches swaybg with the new wallpaper

## Adding Custom Wallpapers

To use a custom wallpaper for a theme:

1. Add your image to this directory
2. Edit the theme's `theme.conf` file
3. Update the WALLPAPER line:
   ```bash
   WALLPAPER="$HOME/.local/share/bunkeros/wallpapers/your-image.jpg"
   ```

The theme switcher supports any image format that swaybg supports (JPG, PNG, etc.).

## Directory Structure

```
bunkeros/
├── wallpapers/                    # This directory (in git repo)
│   ├── tactical.jpg
│   ├── gruvbox.jpg
│   ├── nord.jpg
│   ├── everforest.jpg
│   └── tokyo-night.jpg
└── themes/
    ├── tactical/theme.conf        # Contains: WALLPAPER="$HOME/.local/share/bunkeros/wallpapers/tactical.jpg"
    ├── gruvbox/theme.conf
    └── ...

# After setup:
~/.local/share/bunkeros/
└── wallpapers/                    # Symlink → /home/user/Projects/bunkeros/wallpapers/
```

## Why This Structure?

1. **Follows XDG Standards**: Uses `~/.local/share/` for user data
2. **Always In Sync**: Symlink means wallpapers auto-update with git pulls
3. **Easy Distribution**: Wallpapers ship with BunkerOS repository
4. **User Customizable**: Users can replace/add images in the repo directory
5. **No Manual Management**: Automatic installation and theme switching

## File Sizes

The wallpapers total approximately 20MB. They are stored in the git repository to ensure they're always available with BunkerOS installations.

