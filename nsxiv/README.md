# nsxiv Configuration

**nsxiv** (Neo Simple X Image Viewer) is the visual wallpaper browser for BunkerOS. It provides a fast, keyboard-driven interface for selecting wallpapers with thumbnail previews.

## Features

- **Dark theme** matching BunkerOS tactical aesthetic
- **Fast thumbnail browsing** with keyboard navigation
- **Mark and select** workflow for choosing wallpapers
- **Minimal dependencies** - lightweight C-based image viewer

## Installation

The `colors` file is automatically symlinked during BunkerOS setup:

```bash
ln -sf ~/Projects/bunkeros/nsxiv/colors ~/.config/nsxiv/colors
xrdb -merge ~/.config/nsxiv/colors
```

## Usage in BunkerOS

### Wallpaper Browser

1. Open: `Super+m` → **🖼️ Wallpaper** → **🖼️ Browse & Select Wallpaper**
2. **Browse**: Click any thumbnail to preview it
3. **Mark**: Press `m` to mark image with gold checkmark
4. **Apply**: Press `q` to quit and apply marked image
5. **Cancel**: Press `Escape` to cancel without changes

### Keyboard Shortcuts (Thumbnail Mode)

| Key | Action |
|-----|--------|
| `Arrow keys` / `h/j/k/l` | Navigate thumbnails |
| `Enter` / `Space` | View selected image (full size) |
| `m` | Mark/unmark image (for selection) |
| `q` | Quit and output marked files |
| `Escape` | Cancel and quit |
| `g` / `G` | Go to first/last thumbnail |
| `+` / `-` | Zoom in/out thumbnails |

### Keyboard Shortcuts (Image View)

| Key | Action |
|-----|--------|
| `q` | Return to thumbnail grid |
| `n` / `Space` | Next image |
| `p` / `Backspace` | Previous image |
| `+` / `=` | Zoom in |
| `-` | Zoom out |
| `w` | Fit to window |
| `m` | Mark/unmark current image |

## Color Scheme

The BunkerOS tactical theme uses:

- **Background**: `#1C1C1C` (dark charcoal)
- **Bar**: `#2B2D2E` (sidebar gray)
- **Text**: `#E0E0E0` (light gray)
- **Accent/Mark**: `#C3B091` (tactical gold)

## Troubleshooting

### White background still showing

Ensure X resources are loaded:
```bash
xrdb -merge ~/.config/nsxiv/colors
```

Then relaunch nsxiv. You may need to restart Sway if colors aren't applying.

### Colors not loading

Verify the config file exists:
```bash
ls -l ~/.config/nsxiv/colors
```

Check if it's properly symlinked to the repository.

### Thumbnails not generating

nsxiv creates a cache in `~/.cache/nsxiv/`. If thumbnails aren't showing:
```bash
rm -rf ~/.cache/nsxiv/
```

Then relaunch nsxiv to regenerate thumbnails.

## Philosophy

nsxiv fits BunkerOS's design principles:
- **Lightweight**: < 1 MB binary, minimal dependencies
- **Fast**: Hardware-accelerated rendering, instant startup
- **Keyboard-first**: Vim-inspired navigation
- **Unix philosophy**: Does one thing well (image viewing)
- **Themeable**: X resources for consistent visual integration

Unlike heavy GUI tools like GNOME Image Viewer or complex alternatives like feh, nsxiv provides the perfect balance of visual polish and tactical efficiency.

