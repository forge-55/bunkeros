# Default Applications Configuration

BunkerOS allows you to easily customize which applications launch when you use common keybindings. This gives you the flexibility to use your preferred tools while maintaining consistent, productive workflows.

## Overview

The default applications system lets you configure:

| Keybinding | Application Type | Examples |
|------------|------------------|----------|
| `mod+t` (or `mod+Return`) | Terminal | foot, alacritty, kitty, wezterm |
| `mod+e` | Editor | code, cursor, vim, nvim, lite-xl |
| `mod+f` | File Manager | nautilus, thunar, dolphin, ranger |
| `mod+n` | Notes | lite-xl, obsidian, logseq, joplin |
| `mod+b` | Web Browser | brave, firefox, chrome, ungoogled-chromium |

## Accessing the Menu

1. **Via Main Menu**: Press `Super+m` → `Preferences` → `Default Apps`
2. **Via Keybinding**: Press `Super+m`, then navigate to Preferences

## How to Change Default Apps

1. Open the Default Apps menu (see above)
2. Select the category you want to change (e.g., "Editor (mod+e)")
3. Choose from detected installed applications
4. Your selection is saved automatically
5. Sway configuration reloads instantly
6. Press the keybinding to launch your new default!

## Technical Details

### Configuration File

Default applications are stored in:
```
~/.config/bunkeros/defaults.conf
```

This file contains variables in the format:
```bash
BUNKEROS_TERM=foot
BUNKEROS_EDITOR=code
BUNKEROS_FILEMANAGER=nautilus
BUNKEROS_NOTES=lite-xl
```

### How It Works

1. **Sway Config** sources `~/.config/bunkeros/defaults.conf`
2. Variables like `$BUNKEROS_EDITOR` are set from the config
3. Keybindings use these variables: `bindsym $mod+e exec $editor`
4. When you change a default, the script:
   - Updates `defaults.conf`
   - Reloads Sway config
   - Your new choice takes effect immediately

### Application Detection

The system automatically detects which applications are installed on your system:

- **Terminals**: foot, alacritty, kitty, wezterm, terminator, gnome-terminal, xterm, konsole
- **Editors**: code, cursor, vscodium, lite-xl, gedit, kate, vim, nvim, nano, micro, emacs, geany
- **File Managers**: nautilus, thunar, dolphin, nemo, pcmanfm, ranger, lf
- **Note Apps**: lite-xl, obsidian, notion, logseq, joplin, code, vim, nvim

Only installed applications appear in the selection menu.

## Manual Configuration

If you prefer to edit the config file directly:

```bash
nano ~/.config/bunkeros/defaults.conf
```

After editing, reload Sway:
```bash
swaymsg reload
```

Or press `Super+Shift+r`

## Adding Custom Applications

To add an application not in the default list:

1. Edit `defaults.conf` manually
2. Set the variable to any command you want:
   ```bash
   BUNKEROS_EDITOR=custom-editor --some-flag
   ```
3. Reload Sway configuration

## Troubleshooting

### Application doesn't appear in the menu
- Ensure the application is installed: `which <app-name>`
- Check if it's in your `$PATH`
- Add it manually to `defaults.conf` if needed

### Changes don't take effect
- Verify Sway reloaded: Press `Super+Shift+r`
- Check for syntax errors in `defaults.conf`
- Ensure the command is valid: test in terminal first

### Want to use command-line flags
Edit `defaults.conf` directly to add flags:
```bash
BUNKEROS_TERM=alacritty --config-file ~/.config/alacritry/custom.yml
```

## Web Browser Configuration

BunkerOS provides flexible browser management while optimizing for web app functionality.

### Default Browser

BunkerOS ships with **Brave** as the default browser for `Super+b` and system-wide web links. This choice ensures:

- **Containerized web apps work seamlessly** - Chromium's app mode provides proper window isolation for containerized web apps
- **Privacy by default** - Brave has built-in ad blocking and tracker protection, no Google telemetry
- **No extensions needed** - Ad blocking and privacy features work out of the box
- **Polished experience** - Fast updates, professional UX, actively maintained
- **Wayland optimized** - Excellent screen sharing and compositor integration

### Firefox is Also Included

Firefox is pre-installed as an alternative browser. Users who prefer Firefox can easily switch, understanding they'll lose the containerized web app feature:

1. **Set Firefox as default**:
   ```bash
   xdg-settings set default-web-browser firefox.desktop
   ```

2. **Launch Firefox directly**:
   - Via Wofi launcher: `Super+d` → type "firefox"
   - Add custom keybinding if desired

**Note**: Switching to Firefox means containerized web apps will have limited isolation compared to Chromium-based browsers.

### Why Brave by Default?

The default browser choice prioritizes **productivity features that work seamlessly out of the box**:

| Feature | Chromium-based (Brave) | Firefox |
|---------|----------------|---------|
| Containerized Web App Isolation | ✅ Excellent | ⚠️ Limited |
| PWA Support | ✅ Native | ⚠️ Requires addon |
| Profile Separation | ✅ Complete | ⚠️ Shared context |
| Built-in Ad Blocking | ✅ Yes (Brave) | ⚠️ Extension needed |
| Wayland Integration | ✅ Full support | ✅ Good support |

**However**: Firefox offers advantages like independent engine, Mozilla's privacy focus, and container tabs. Users can easily switch based on their priorities, understanding the trade-off with containerized web apps.

### Changing Your Default Browser

**Via XDG Settings** (recommended):
```bash
# Set Brave (default)
xdg-settings set default-web-browser brave-browser.desktop

# Set Firefox
xdg-settings set default-web-browser firefox.desktop

# Set Ungoogled Chromium (if installed)
xdg-settings set default-web-browser ungoogled-chromium.desktop

# Set Chrome (if installed)
xdg-settings set default-web-browser google-chrome.desktop
```

**Verify current default**:
```bash
xdg-settings get default-web-browser
```

### Installing Additional Browsers

**From Official Repositories**:
```bash
# Firefox
sudo pacman -S firefox

# Firefox Developer Edition
sudo pacman -S firefox-developer-edition
```

**From AUR**:
```bash
# Brave (default)
yay -S brave-bin

# Ungoogled Chromium
yay -S ungoogled-chromium

# Google Chrome
yay -S google-chrome

# Chromium (official, with Google integration)
yay -S chromium

# Vivaldi
yay -S vivaldi
```

### Web App Manager Compatibility

The Web App Manager (Super+Alt+Space → Web Apps) works best with Chromium-based browsers:

- **Excellent**: Brave (default), Chrome, Chromium, Ungoogled Chromium, Vivaldi, Edge
- **Limited**: Firefox (uses new-window mode instead of proper app isolation)

See `webapp/README.md` for detailed web app documentation.

### Browser-Specific Wayland Configuration

BunkerOS automatically configures Chromium-based browsers for optimal Wayland support during installation. To manually configure:

```bash
~/Projects/bunkeros/scripts/configure-browser-wayland.sh
```

This enables:
- Native Wayland rendering
- Screen sharing via PipeWire
- Proper HiDPI support
- Optimal performance

## Philosophy

This feature aligns with BunkerOS's core principles:

- **Flexibility**: Use your preferred tools
- **Simplicity**: Change apps via GUI, no config editing needed
- **Speed**: Changes apply instantly
- **Consistency**: Same keybindings, different apps

The goal is to give you a productive workspace that feels like *yours*.
