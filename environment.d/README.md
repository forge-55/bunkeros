# BunkerOS Environment Configuration

This directory contains environment variable configurations for BunkerOS.

## Files

### `10-bunkeros-wayland.conf`

Sets up essential Wayland environment variables for proper application compatibility.

**Purpose:**
- Ensures Electron apps (VS Code, Cursor, Discord, Slack, etc.) work correctly
- Configures proper Wayland support for Qt, SDL2, and other toolkits
- Sets desktop environment identification for app-specific behavior

**Installed to:** `~/.config/environment.d/10-bunkeros-wayland.conf`

**Key variables set:**
- `WAYLAND_DISPLAY=wayland-1` - Tells apps we're using Wayland
- `XDG_CURRENT_DESKTOP=sway` - Desktop environment identification
- `XDG_SESSION_TYPE=wayland` - Session type for compatibility
- `ELECTRON_OZONE_PLATFORM_HINT=auto` - Critical for Electron apps
- `QT_QPA_PLATFORM=wayland` - Qt Wayland support
- `MOZ_ENABLE_WAYLAND=1` - Firefox Wayland support

## Why This Is Needed

### Electron Apps Issue

Electron apps (VS Code, Cursor, etc.) from AUR may not launch properly without explicit Wayland environment variables. This is because:

1. **SDDM doesn't automatically set all Wayland variables** that apps expect
2. **Electron apps need explicit hints** to use Wayland instead of XWayland
3. **Some toolkits require desktop environment identification** to enable features

### The Problem

When installing apps from AUR (like `visual-studio-code-bin` or `cursor-bin`), they would:
- Show in the application launcher
- But fail to open when clicked
- Or open but with broken functionality (no file dialogs, crashes, etc.)

### The Solution

This environment.d configuration ensures all necessary variables are set **before** the desktop session starts, so apps have proper Wayland context from the beginning.

## Installation

This file is automatically symlinked during `setup.sh` (Step 11.7).

Manual installation:
```bash
mkdir -p ~/.config/environment.d
ln -sf ~/Projects/bunkeros/environment.d/10-bunkeros-wayland.conf ~/.config/environment.d/
```

## Verification

Check if environment variables are set in your session:
```bash
echo $XDG_CURRENT_DESKTOP  # Should output: sway
echo $WAYLAND_DISPLAY      # Should output: wayland-1
echo $ELECTRON_OZONE_PLATFORM_HINT  # Should output: auto
```

## Troubleshooting

### App still won't launch
1. Check if the app is installed: `pacman -Q <package-name>`
2. Try launching from terminal to see error messages
3. Ensure you logged out and back in after installation (env vars load at login)

### App opens in XWayland instead of native Wayland
- Check if the app supports native Wayland
- Some older apps may only support XWayland (this is fine)
- You can check with: `swaymsg -t get_tree | grep -i <app-name>`

## Related Files

- `sddm/sessions/bunkeros-*.desktop` - Session files that launch BunkerOS
- `scripts/launch-bunkeros-*.sh` - Launch scripts that also set environment variables
- `xdg-desktop-portal/portals.conf` - Portal configuration for file pickers

## References

- [Arch Wiki: Wayland](https://wiki.archlinux.org/title/Wayland)
- [Arch Wiki: Environment Variables](https://wiki.archlinux.org/title/Environment_variables)
- [Electron Wayland Support](https://www.electronjs.org/docs/latest/api/command-line-switches)
- [Sway Wiki](https://github.com/swaywm/sway/wiki)
