# Desktop Portal Configuration

BunkerOS uses **xdg-desktop-portal-wlr** for Wayland/Sway integration. The GTK file chooser is automatically themed with BunkerOS tactical colors.

## What This Does

When you open or save files in applications like **Cursor**, **VS Code**, **GIMP**, or other Electron/GTK apps, you'll see the **GTK file chooser** themed with BunkerOS tactical colors.

### Why Not GNOME Portal?

While `xdg-desktop-portal-gnome` provides a Nautilus-based file picker, it requires **GNOME Shell dependencies** which would:
- Add ~50+ MB of unnecessary packages
- Pull in GNOME-specific services
- Conflict with the lightweight Sway philosophy

**The wlr portal is sufficient** - the GTK file chooser works well and is fully themed.

## How It Works

### Desktop Portals

Desktop portals are a **Wayland/Flatpak technology** that allows applications to request system services (like file picking, screen sharing, notifications) in a desktop-agnostic way.

BunkerOS uses two portals:
1. **xdg-desktop-portal-gnome**: Provides GNOME/Nautilus components (file picker, etc.)
2. **xdg-desktop-portal-wlr**: Provides Wayland-specific features (screen sharing, etc.)

### Configuration

**File**: `portals.conf`
```ini
[preferred]
default=wlr
```

This tells the portal system to use **xdg-desktop-portal-wlr** for all portal features, including:
- File picker (GTK-based, themed with BunkerOS colors)
- Screenshot capability
- Screen sharing
- Remote desktop access

## Installation

The portal configuration is installed automatically by `setup.sh` (Step 11.6).

Manual installation:
```bash
cd ~/Projects/bunkeros/xdg-desktop-portal
./install.sh
```

## Required Package

```bash
sudo pacman -S xdg-desktop-portal-wlr
```

This package is **already installed** as part of BunkerOS base requirements. It provides:
- GTK file picker (themed)
- Screenshot capability
- Screen sharing (Wayland-native)
- Remote desktop access

## How to Verify

1. **Check configuration**:
   ```bash
   cat ~/.config/xdg-desktop-portal/portals.conf
   ```
   Should show `org.freedesktop.impl.portal.FileChooser=gnome`

2. **Check installed portals**:
   ```bash
   pacman -Qq | grep xdg-desktop-portal
   ```
   Should show:
   - `xdg-desktop-portal`
   - `xdg-desktop-portal-gnome`
   - `xdg-desktop-portal-wlr`

3. **Test it**:
   - Open Cursor or any Electron app
   - Try to open a file (`Ctrl+O`)
   - You should see a modern file picker with thumbnails and recent files

## Troubleshooting

### File picker still looks basic
**Solution**: Restart the portal service and the application:
```bash
pkill -f xdg-desktop-portal
# Close and reopen your application (e.g., Cursor)
```

### Portal service not starting
**Solution**: Check the service status:
```bash
systemctl --user status xdg-desktop-portal.service
```

Restart it manually:
```bash
systemctl --user restart xdg-desktop-portal.service
```

### GNOME portal conflicts with wlr
**Solution**: The configuration explicitly sets priority. GNOME is preferred, wlr is fallback. This is intentional and correct.

### File picker doesn't match BunkerOS theme
**Solution**: Verify GTK4 theme is installed:
```bash
ls -la ~/.config/gtk-4.0/
# Should show symlinks to BunkerOS gtk-4.0/
```

The GNOME portal inherits the GTK4 theme, so it should automatically use the BunkerOS tactical theme.

## Comparison

| Feature | GTK File Chooser (Basic) | GNOME Portal (Nautilus) |
|---------|------------------------|------------------------|
| **Design** | Basic, dated | Modern, polished |
| **Thumbnails** | ✗ | ✓ |
| **Recent Files** | Basic | Full integration |
| **Bookmarks** | Limited | Nautilus bookmarks |
| **Search** | Basic | Advanced |
| **Preview Pane** | ✗ | ✓ |
| **Theme Support** | GTK3/4 only | Full Nautilus theming |

## Alternative: Reverting to Basic GTK

If you prefer the basic GTK file chooser, edit `~/.config/xdg-desktop-portal/portals.conf`:

```ini
[preferred]
default=wlr
# Comment out or remove the FileChooser line:
# org.freedesktop.impl.portal.FileChooser=gnome
```

Then restart:
```bash
pkill -f xdg-desktop-portal
```

**Note**: The basic GTK file chooser is less feature-rich and less polished, but it's lighter weight.

## Technical Details

### Portal Interfaces

xdg-desktop-portal provides these interfaces:
- `org.freedesktop.impl.portal.FileChooser` - File picker dialog
- `org.freedesktop.impl.portal.Screenshot` - Screenshot capability
- `org.freedesktop.impl.portal.ScreenCast` - Screen recording/sharing
- `org.freedesktop.impl.portal.RemoteDesktop` - Remote desktop access
- `org.freedesktop.impl.portal.Notification` - Notification sending
- `org.freedesktop.impl.portal.Settings` - Desktop settings access

BunkerOS uses:
- **GNOME portal**: FileChooser, Settings, Notification
- **wlr portal**: Screenshot, ScreenCast, RemoteDesktop (Wayland-specific)

### Why Not Just wlr?

xdg-desktop-portal-wlr is **excellent for Wayland features** (screen sharing, etc.) but provides only a **basic GTK file chooser**. For a polished desktop experience, GNOME's Nautilus-based picker is superior.

By using both portals, BunkerOS gets:
- Best-in-class file picker (GNOME/Nautilus)
- Full Wayland support (wlr for screen sharing, etc.)
- No compromises

## Screen Sharing & Video Conferencing

The wlr portal provides full screen sharing support for video conferencing applications.

### Testing Screen Sharing

1. **Quick test** (no account needed):
   ```bash
   xdg-open https://meet.jit.si/test-$(date +%s)
   ```

2. Click "Share screen" button

3. You should see a screen picker showing:
   - Individual windows
   - Entire screen/output
   - Specific workspaces

### Supported Applications

- **Web-based**: Google Meet, Zoom (web), Microsoft Teams, Slack, Discord
- **Native**: Zoom, Discord, Slack Desktop, OBS Studio
- **Browsers**: Chromium, Chrome, Brave, Edge (auto-configured by setup.sh)

### Browser Requirements

Chromium-based browsers need specific Wayland flags. BunkerOS automatically configures these via the setup script:

```bash
~/Projects/bunkeros/scripts/configure-browser-wayland.sh
```

**Flags added:**
- `--enable-features=WebRTCPipeWireCapturer` - PipeWire screen capture
- `--ozone-platform-hint=auto` - Native Wayland rendering

### Troubleshooting Screen Sharing

**Screen sharing button does nothing:**
```bash
# Restart desktop portal
pkill -f xdg-desktop-portal

# Verify PipeWire is running
systemctl --user status pipewire
```

**Screen picker shows no screens:**
```bash
# Verify wlr portal is installed
pacman -Q xdg-desktop-portal-wlr

# Check config
cat ~/.config/xdg-desktop-portal/portals.conf
# Should show: default=wlr
```

**For detailed video conferencing setup, see:** [`VIDEOCONFERENCING.md`](../VIDEOCONFERENCING.md)

## Resources

- [xdg-desktop-portal Documentation](https://github.com/flatpak/xdg-desktop-portal)
- [xdg-desktop-portal-gnome](https://gitlab.gnome.org/GNOME/xdg-desktop-portal-gnome)
- [xdg-desktop-portal-wlr](https://github.com/emersion/xdg-desktop-portal-wlr)
- [Arch Wiki: XDG Desktop Portal](https://wiki.archlinux.org/title/XDG_Desktop_Portal)

---

**Quick Reference**:
- Config: `~/.config/xdg-desktop-portal/portals.conf`
- Package: `xdg-desktop-portal-gnome`
- Restart: `pkill -f xdg-desktop-portal`
- Install: `cd ~/Projects/bunkeros/xdg-desktop-portal && ./install.sh`


