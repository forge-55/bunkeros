# BunkerOS Wallpapers

This directory contains the default wallpaper for each BunkerOS theme.

## Included Wallpapers

- **tactical.jpg** - Tactical (Default) theme wallpaper
- **abyss.jpg** - Abyss theme wallpaper
- **night-ops.jpg** - Night Ops theme wallpaper
- **sahara.jpg** - Sahara theme wallpaper
- **winter.jpg** - Winter theme wallpaper

## Installation

Wallpapers are automatically installed during BunkerOS setup:

```bash
cd ~/bunkeros
./setup.sh
```

The setup script **copies** the wallpapers to `~/.local/share/bunkeros/wallpapers/`. This means your customizations won't be affected by git pulls or updates.

## How It Works

Each theme's `theme.conf` file specifies its wallpaper:

```bash
WALLPAPER="$HOME/.local/share/bunkeros/wallpapers/tactical.jpg"
```

When you switch themes, the wallpaper automatically changes to match. The theme switcher:
1. Reads the WALLPAPER path from the theme's config
2. Kills the existing swaybg process
3. Launches swaybg with the new wallpaper

## Customizing Wallpapers

To replace a theme's wallpaper with your own image:

1. **Choose which theme to customize** (e.g., `tactical`)
2. **Replace the wallpaper file:**
   ```bash
   cp ~/Downloads/my-wallpaper.jpg ~/.local/share/bunkeros/wallpapers/tactical.jpg
   ```
3. **Switch to that theme** to see your custom wallpaper:
   ```bash
   ~/bunkeros/scripts/theme-switcher.sh tactical
   ```

**Tips:**
- Use high-resolution images (1920x1080 or higher) for best results
- JPG and PNG formats are supported
- Keep the same filename as the original to avoid changing theme configs
- Make a backup of the original wallpaper if you want to restore it later

**Example - Adding a new wallpaper:**
```bash
# Add your custom image
cp ~/Downloads/my-custom-wallpaper.jpg ~/.local/share/bunkeros/wallpapers/my-wallpaper.jpg

# Edit the theme config to use it
nano ~/bunkeros/themes/tactical/theme.conf
# Change: WALLPAPER="$HOME/.local/share/bunkeros/wallpapers/tactical.jpg"
# To:     WALLPAPER="$HOME/.local/share/bunkeros/wallpapers/my-wallpaper.jpg"

# Apply the theme
~/bunkeros/scripts/theme-switcher.sh tactical
```

## Directory Structure

```
bunkeros/
├── wallpapers/                    # This directory (in git repo)
│   ├── tactical.jpg               # Original wallpapers (tracked by git)
│   ├── abyss.jpg
│   ├── night-ops.jpg
│   ├── sahara.jpg
│   └── winter.jpg
└── themes/
    ├── tactical/theme.conf        # Contains: WALLPAPER="$HOME/.local/share/bunkeros/wallpapers/tactical.jpg"
    ├── abyss/theme.conf
    └── ...

# After setup (user's local directory):
~/.local/share/bunkeros/
└── wallpapers/                    # Copied from repo (your customizations here)
    ├── tactical.jpg               # Safe to replace - won't be overwritten by git pull
    ├── abyss.jpg
    ├── night-ops.jpg
    ├── sahara.jpg
    └── winter.jpg
```

## Why This Structure?

1. **Follows XDG Standards**: Uses `~/.local/share/` for user data
2. **Safe Customization**: Your wallpaper changes won't be overwritten by git updates
3. **Easy Distribution**: Default wallpapers ship with BunkerOS repository
4. **Git-Friendly**: Customizations don't show up in `git status`
5. **Automatic Theme Switching**: Each theme automatically loads its wallpaper from your local directory

