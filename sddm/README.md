# Tactical SDDM Theme

A custom SDDM login theme designed to match the tactical aesthetic of this Sway configuration. Features a minimal, centered design with khaki/tan, olive, and charcoal colors.

## Features

- **Tactical color palette** - Matches the rest of the Sway setup
- **Minimal centered design** - Clean login box with no distractions
- **Session selector** - Choose between Sway, X11, or other sessions
- **Power controls** - Shutdown, reboot, and suspend buttons
- **Date/time display** - Shows current date and time
- **Monospace typography** - Consistent with terminal aesthetic
- **Keyboard-friendly** - Tab navigation and Enter to login
- **Focus indicators** - Clear visual feedback for active fields
- **Smooth animations** - Subtle hover and press effects

## Installation

### 1. Install SDDM and dependencies

```bash
sudo pacman -S sddm qt6-svg qt6-declarative
```

### 2. Install the theme

```bash
cd /home/ryan/Projects/bunkeros/sddm
./install-theme.sh
```

This will:
- Copy the theme to `/usr/share/sddm/themes/tactical`
- Configure SDDM to use the tactical theme in `/etc/sddm.conf`

### 3. Enable SDDM

```bash
sudo systemctl enable sddm.service
```

To start SDDM immediately (will log you out):
```bash
sudo systemctl start sddm.service
```

## Testing

Test the theme without logging out:

```bash
sddm-greeter --test-mode --theme /usr/share/sddm/themes/tactical
```

This opens a test window where you can preview the theme.

## File Structure

```
tactical/
├── Main.qml          # Main theme interface (QML)
├── theme.conf        # Theme configuration
└── metadata.desktop  # Theme metadata
```

## Customization

### Colors

Edit `Main.qml` to change colors:

```qml
property color tacticalbg: "#1C1C1C"      // Background
property color tacticaltan: "#C3B091"     // Primary (borders, buttons)
property color tacticalolive: "#6B7A54"   // Secondary (hover states)
property color tacticalgray: "#2B2D2E"    // Inactive elements
property color textcolor: "#E5D5C5"       // Text
```

### Layout

To adjust the login box size or position, edit the `loginBox` Rectangle in `Main.qml`:

```qml
Rectangle {
    id: loginBox
    width: 450          // Login box width
    height: 520         // Login box height
    anchors.centerIn: parent
    ...
}
```

### Background

To add a custom background image:

1. Place your image in the theme directory (e.g., `background.jpg`)
2. In `Main.qml`, find the Image component and set `visible: true`:

```qml
Image {
    anchors.fill: parent
    source: "background.jpg"
    fillMode: Image.PreserveAspectCrop
    visible: true              // Change from false to true
}
```

## Updating the Theme

After making changes to the theme files in this project directory:

```bash
./install-theme.sh
```

This will copy the updated files to the system theme directory.

## Troubleshooting

**Theme doesn't load:**
- Check `/etc/sddm.conf` has `Current=tactical` under `[Theme]`
- Verify files are in `/usr/share/sddm/themes/tactical/`
- Check SDDM logs: `journalctl -u sddm`

**Qt errors:**
- Ensure `qt6-svg` and `qt6-declarative` are installed
- Theme uses Qt Quick 2.15 and Qt Quick Controls 2.15

**Permission errors:**
- Theme installation requires sudo (run with `./install-theme.sh`)
- Theme files must be readable by the `sddm` user

## Technical Details

- **Language**: QML (Qt Meta Language)
- **Qt Version**: Qt 6
- **SDDM API**: 2.0
- **Resolution**: Responsive design (tested at 1920x1080)
- **Dependencies**: qt6-svg, qt6-declarative

## Credits

Inspired by ArchCraft's SDDM theme design, adapted for the tactical aesthetic of this Sway configuration.

