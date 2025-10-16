# Sway Configuration

A clean, minimal Sway setup with a tactical color palette. Features muted olive and tan tones with a focus on functionality and visual clarity.

## Features

- **Minimal, intuitive keybindings** - Essential bindings that work across major tiling WMs
- **Waybar** status bar with flat, tactical styling
- **Numbered workspace indicators** (1-7) with ArchCraft-inspired design and refined box styling
- **Wofi** application launcher with minimal design aesthetic
- **Web App Manager** - Install any website as a containerized desktop app (Omarchy-style)
- **Custom terminal** with tactical prompt design and color scheme
- **btop** system monitor with custom tactical theme
- **Mako** notification daemon with themed notifications
- **Interactive screenshot system** with GNOME/COSMIC-style workflow
- **Night mode toggle** with one-click color temperature adjustment
- **SwayOSD** on-screen display for volume and brightness with elegant overlays
- **Dynamic wallpaper** management via swaybg
- **Window gaps** for a modern tiled layout
- **Subtle transparency** on windows (95% opacity)
- **Custom color scheme** with olive drab, tactical gray, and tan accents
- **Flat design philosophy** - function over decoration
- **Zero performance overhead** - pure CSS styling

## Color Palette

The configuration uses a carefully crafted tactical palette that balances functionality with aesthetics:

- **Primary (Khaki/Tan)** `#C3B091` - Focus indicators, highlights, active workspace markers
- **Secondary (Olive)** `#4A5240` - Accents, borders, workspace hover states
- **Tertiary (Muted Olive)** `#3C4A2F` - Subtle borders and secondary accents
- **Background (Charcoal)** `#1C1C1C` - Primary dark background
- **Surface (Tactical Gray)** `#2B2D2E` - Window backgrounds, input fields
- **Alert (Amber)** `#CC7832` - Warnings, critical states, mode indicators
- **Text (Off-White)** `#D4D4D4` - Primary text color

### Design Philosophy

The palette prioritizes readability and focus while maintaining a cohesive tactical aesthetic. The design follows a flat, understated approach with minimal shadows and clean borders - emphasizing function over decoration, perfect for performance-conscious setups like the ThinkPad T480.

## Keybindings

This configuration uses minimal, intuitive keybindings that are consistent across major tiling window managers. The philosophy is to provide only the essential bindings, leaving room for users to customize with their favorite applications and scripts.

### Design Philosophy

- **Minimal by default** - Only essential keybindings included
- **Intuitive across WMs** - Works similarly to i3, Hyprland, and other tiling WMs
- **Easy to remember** - Logical key choices without excessive Shift modifiers
- **Customization-friendly** - Clear space for users to add personal bindings

### Essential Keybindings

**Basic Actions:**
- `Super+Return` - Launch terminal
- `Super+Space` - Application launcher (Wofi)
- `Super+q` - Close window
- `Super+t` - Toggle floating mode
- `Super+Shift+r` - Reload Sway configuration

**Window Focus (Vim-style or Arrow keys):**
- `Super+h/j/k/l` or `Super+←/↓/↑/→` - Move focus between windows

**Window Movement:**
- `Super+Shift+h/j/k/l` or `Super+Shift+←/↓/↑/→` - Move windows

**Workspaces:**
- `Super+1-9` - Switch to workspace 1-9
- `Super+Shift+1-9` - Move window to workspace 1-9
- `PgUp/PgDn` - Cycle to previous/next workspace

**Window Layout:**
- `Super+e` - Toggle split layout
- `Super+f` - Fullscreen
- `Super+r` - Enter resize mode (use h/j/k/l or arrows, then Esc)

**System Controls:**
- `Print` - Interactive screenshot (select area, then choose copy/save)
- `Shift+Print` - Screenshot entire screen (save)
- `Ctrl+Print` - Screenshot area (copy to clipboard)
- `Ctrl+Shift+Print` - Screenshot active window (save)
- `Super+n` - Toggle night mode
- `Fn+F1-F6` - Volume/brightness controls (hardware keys with OSD)

**Quick Actions Menu:**
- `Super+Alt+Space` - Quick actions menu with icon-based navigation

### Customization

The configuration includes a dedicated customization area at the end of the keybindings section. Add your own bindings for favorite applications:

```
# Examples:
bindsym $mod+b exec firefox
bindsym $mod+c exec code
bindsym $mod+m exec spotify
```

## Screenshot System

This configuration features an interactive screenshot system designed to replicate the intuitive GNOME/COSMIC screenshot experience on Sway.

### Design Philosophy

The screenshot workflow prioritizes user choice, clarity, and speed. Rather than immediately saving or copying screenshots, the system presents users with a visual selector followed by a prominent keyboard-driven dialog. Simply press C or S - no Enter key required, no mouse needed. The dialog is impossible to miss and optimized for rapid keyboard workflow.

### Technical Stack

The screenshot system is built using lightweight Wayland-native tools:

- **grim** - Screenshot utility for Wayland compositors (captures pixels)
- **slurp** - Region selection tool for Wayland (provides the visual area picker)
- **wl-clipboard** - Command-line clipboard utilities for Wayland (handles copy operations)
- **grimshot** - Helper script that orchestrates grim, slurp, and wl-copy (used for power shortcuts)
- **foot** - Terminal emulator used to display the keyboard-driven dialog
- **mako** - Notification daemon that confirms screenshot actions

### Workflow

**Primary workflow (Print Screen):**
1. Press Print Screen
2. Visual crosshair selector appears (slurp)
3. Click and drag to select the screenshot area
4. Dialog window appears in center of screen displaying:
   - "Press [C] to Copy to Clipboard"
   - "Press [S] to Save to Pictures"
5. Press **C** or **S** (no Enter required)
6. Dialog closes and confirmation notification appears

**Power user shortcuts:**
- **Shift+Print** - Instantly capture entire screen and save (no prompts)
- **Ctrl+Print** - Select area and copy to clipboard (skips save option)
- **Ctrl+Shift+Print** - Capture active window and save (no prompts)

### Implementation

The screenshot system uses a custom script in `waybar/scripts/`:

- `screenshot-area.sh` - Interactive workflow with visual area selector and floating terminal dialog

The script launches a centered, floating terminal window that captures a single keypress (C or S) without requiring Enter. The dialog uses the Foot terminal configured to float and center automatically via Sway window rules. All confirmations use mako notifications themed to match the tactical aesthetic.

## Night Mode

This configuration includes a GNOME-style night mode toggle accessible directly from the Waybar.

### Overview

Night mode reduces blue light emission by adjusting the color temperature of your display, making it easier on the eyes during evening/night use. The feature is implemented using `wlsunset`, the Wayland equivalent of redshift.

### Usage

Toggle night mode using either method:
- **Click** the moon icon (󰖔) in the Waybar
- **Press** `Mod+N` keyboard shortcut

When toggled:
- **Active**: Icon displays in amber/orange color, screen has warm color temperature
- **Inactive**: Icon displays in muted olive color, screen has normal color temperature
- Hover for tooltip showing current state
- Notification confirms each state change

### Configuration

The night mode uses the following color temperature settings:
- **Day temperature**: 4500K (slightly warm)
- **Night temperature**: 3400K (warm, reduces blue light)

These values can be adjusted in `waybar/scripts/night-mode-toggle.sh` by modifying the `-T` (day) and `-t` (night) parameters for `wlsunset`.

### Implementation

Two custom scripts work together:
- `night-mode-toggle.sh` - Starts/stops wlsunset and updates state
- `night-mode-status.sh` - Reports current state to Waybar (icon and tooltip)

The state persists across Waybar restarts using a cache file at `~/.cache/night-mode-state`.

## On-Screen Display (OSD)

This configuration includes SwayOSD for elegant visual feedback when adjusting volume and brightness levels.

### Overview

SwayOSD provides centered, beautiful overlays that appear when volume or brightness is changed. This replicates the native OSD experience found in GNOME, KDE, and other desktop environments, providing visual confirmation of the current level.

### Features

- **Centered display** - OSD appears in the middle of the screen for maximum visibility
- **Tactical styling** - Matches the tactical color palette with khaki/tan accents
- **Auto-dismiss** - Fades after 2 seconds of inactivity
- **Smooth animations** - Clean transitions and progress bar updates
- **Automatic icons** - Shows appropriate icons for volume (speaker/mute) and brightness
- **Progress bars** - Visual representation of current level (0-100%)

### Usage

SwayOSD activates automatically when using volume or brightness controls:

**Volume controls:**
- **Volume Up** - XF86AudioRaiseVolume (usually Fn+F3 on ThinkPad)
- **Volume Down** - XF86AudioLowerVolume (usually Fn+F2 on ThinkPad)
- **Mute** - XF86AudioMute (usually Fn+F1 on ThinkPad)
- **Mic Mute** - XF86AudioMicMute (usually Fn+F4 on ThinkPad)

**Brightness controls:**
- **Brightness Up** - XF86MonBrightnessUp (usually Fn+F6 on ThinkPad)
- **Brightness Down** - XF86MonBrightnessDown (usually Fn+F5 on ThinkPad)

### Styling

The OSD appearance is configured in `swayosd/style.css` with:
- **Background**: Charcoal (`#1C1C1C`) with transparency
- **Border**: Tactical tan (`#C3B091`) with 4px width and 12px rounded corners
- **Progress bar**: Tactical tan fill on tactical gray (`#2B2D2E`) background with 24px height
- **Text**: Tactical tan (`#C3B091`) in monospace font
- **Icons**: Tactical tan colored icons
- **Position**: Perfectly centered on screen (top-margin: 0.5)

### Implementation

SwayOSD consists of two components:
- **swayosd-server** - Background daemon that displays the OSD (auto-started by Sway)
- **swayosd-client** - Command-line tool that triggers OSD displays

All volume and brightness keybindings in the Sway config use `swayosd-client` instead of direct `pactl` or `brightnessctl` commands, ensuring every adjustment shows visual feedback.

## Quick Actions Menu

This configuration includes an Omarchy-style quick actions menu accessible via `Super+Alt+Space`. The menu provides centralized access to power options, theme controls, and system settings through a hierarchical, icon-based interface.

### Overview

The quick actions menu follows a modular architecture with a main menu that navigates to specialized sub-menus. All menus use Wofi with the tactical theme styling for visual consistency.

### Main Menu Categories

Press `Super+Alt+Space` to access:

- **󰐥 Power** - System power options (shutdown, reboot, suspend, logout)
- **󰃟 Theme** - Appearance and styling controls
- **󰒓 System** - System settings and utilities
- **󰖔 Night Mode** - Toggle night mode on/off
- **󰄀 Screenshot** - Launch interactive screenshot tool
- **󰍃 File Manager** - Open file browser (Thunar)
- **󰊶 Terminal** - Launch new terminal window

### Sub-Menus

**Power Menu (󰐥):**
- **󰐥 Shutdown** - Power off the system
- **󰜉 Reboot** - Restart the system
- **󰒲 Suspend** - Suspend to RAM
- **󰍃 Logout** - Exit Sway session

**Theme Menu (󰃟):**
- **󰹑 Toggle Gaps** - Enable/disable window gaps
- **󰙵 Increase Gaps** - Expand gap size by 2px
- **󰙴 Decrease Gaps** - Reduce gap size by 2px
- **󰂚 Increase Opacity** - Make windows more opaque
- **󰂙 Decrease Opacity** - Make windows more transparent
- **󰸉 Wallpaper** - Select new wallpaper from Pictures folder
- **󰆊 Reload Config** - Reload Sway configuration

**System Menu (󰒓):**
- **󰖩 Network Settings** - Configure WiFi/Ethernet (nmtui)
- **󰂯 Bluetooth** - Manage Bluetooth connections
- **󰕾 Audio Settings** - Audio device configuration (pulsemixer)
- **󰍹 Display Settings** - Monitor configuration (wdisplays)
- **󰍛 System Monitor** - Launch btop resource monitor
- **󰘘 Processes** - View running processes (htop)

### Architecture

The menu system uses a modular script architecture:

```
waybar/scripts/
├── quick-menu.sh       # Main menu entry point
├── power-menu.sh       # Power options sub-menu
├── theme-menu.sh       # Theme/styling sub-menu
└── system-menu.sh      # System controls sub-menu
```

Each menu:
- Uses Wofi with tactical styling
- Displays Nerd Font icons for visual clarity
- Provides instant feedback via mako notifications
- Supports keyboard navigation

### Customization

Add custom menu options by editing the respective script files. For example, to add a new option to the main menu:

```bash
# In quick-menu.sh
options="󰐥 Power\n󰃟 Theme\n󰒓 System\n 󰌽 Your Custom Option"

case $selected in
    " 󰌽 Your Custom Option")
        your-custom-command
        ;;
esac
```

The modular design makes it easy to extend with additional sub-menus or modify existing options to match your workflow.

## Web App Manager

This configuration includes a powerful web app installation system inspired by Omarchy. Install any website as a containerized desktop application with custom icons in just a few steps.

### Overview

The Web App Manager automatically detects your default browser (Chrome, Chromium, Brave, or Firefox) and creates isolated app instances with custom icons. Each app runs in its own browser profile, providing full data isolation while integrating seamlessly with Sway's tiling system.

### Quick Start

1. Open Quick Menu: `Super+Alt+Space`
2. Select **📱 Web Apps** → **󰐖 Install Web App**
3. Enter app details:
   - **App Name**: e.g., "GitHub"
   - **URL**: e.g., "https://github.com"
   - **Icon**: Paste URL from [Dashboard Icons](https://github.com/walkxcode/dashboard-icons) or use local path

The app appears in your Wofi launcher immediately and can be launched like any native application!

### Features

- **Browser-Agnostic** - Works with Chrome, Chromium, Brave, and Firefox
- **Seamless Logins** - Uses your main browser's sessions (Omarchy-style)
- **Instant Access** - Already signed in if you're signed in to your browser
- **Custom Icons** - Use icons from dashboardicons.com or local files
- **App Mode** - Chrome-less windows that tile perfectly in Sway
- **Easy Management** - Install, remove, and list apps through the quick menu
- **Wofi Integration** - Consistent tactical theme styling

### Common Web Apps

**GitHub:**
- URL: `https://github.com`
- Icon: `https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/github.png`

**Gmail:**
- URL: `https://mail.google.com`
- Icon: `https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/gmail.png`

**Calendar:**
- URL: `https://calendar.google.com`
- Icon: `https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/google-calendar.png`

**Slack:**
- URL: `https://app.slack.com`
- Icon: `https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/slack.png`

### Technical Details

Each web app:
- Creates a `.desktop` file in `~/.local/share/applications/`
- Uses browser's app mode (`--app` flag for Chromium-based, `--new-window` for Firefox)
- Uses your main browser's profile for seamless login sharing
- Downloads/stores icon in `~/.local/share/sway-webapp/icons/`

**Login Behavior:**
- Already signed in if you're logged into your main browser
- All web apps share the same login sessions as your main browser
- No need to re-authenticate - instant access to your accounts!

For detailed documentation, see [`webapp/README.md`](webapp/README.md).

## Requirements

```bash
sudo pacman -S sway waybar wofi foot swaybg brightnessctl sway-contrib grim slurp wl-clipboard mako wlsunset swayosd xdg-utils
```

- `sway-contrib` includes grimshot for screenshots
- `grim` and `slurp` are the underlying screenshot tools
- `wl-clipboard` enables copying screenshots to clipboard
- `foot` is the terminal emulator used for the screenshot dialog and general use
- `mako` is the notification daemon for screenshot confirmations and other alerts
- `wlsunset` provides color temperature adjustment for night mode
- `swayosd` provides on-screen display overlays for volume and brightness

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

The configuration uses MesloLGL Nerd Font by default. This can be changed in `waybar/style.css` to use a different Nerd Font if desired.

## Installation

Clone this repo and symlink the configs:

```bash
git clone https://github.com/forge-55/sway.git
cd sway

# Backup existing configs (if any)
mkdir -p ~/.config/backup
cp -r ~/.config/sway ~/.config/backup/ 2>/dev/null || true
cp -r ~/.config/waybar ~/.config/backup/ 2>/dev/null || true
cp -r ~/.config/wofi ~/.config/backup/ 2>/dev/null || true

# Create config directories
mkdir -p ~/.config/sway ~/.config/waybar ~/.config/wofi ~/.config/foot ~/.config/btop/themes ~/.config/mako ~/.config/swayosd

# Symlink configs
ln -sf $(pwd)/sway/config ~/.config/sway/config
ln -sf $(pwd)/waybar/config ~/.config/waybar/config
ln -sf $(pwd)/waybar/style.css ~/.config/waybar/style.css
ln -sf $(pwd)/waybar/scripts ~/.config/waybar/scripts
ln -sf $(pwd)/wofi/config ~/.config/wofi/config
ln -sf $(pwd)/wofi/style.css ~/.config/wofi/style.css
ln -sf $(pwd)/foot/foot.ini ~/.config/foot/foot.ini
ln -sf $(pwd)/mako/config ~/.config/mako/config
ln -sf $(pwd)/btop/btop.conf ~/.config/btop/btop.conf
ln -sf $(pwd)/btop/themes/tactical.theme ~/.config/btop/themes/tactical.theme
ln -sf $(pwd)/swayosd/style.css ~/.config/swayosd/style.css
ln -sf $(pwd)/bashrc ~/.bashrc
ln -sf $(pwd)/dircolors ~/.dircolors

# Make scripts executable (screenshot tools, power menu, etc.)
chmod +x waybar/scripts/*.sh

# Reload Sway
swaymsg reload
```

## Project Structure

All configuration files are stored in this repository and symlinked to their appropriate locations:

```
sway-config/
├── sway/
│   └── config                    → ~/.config/sway/config
├── waybar/
│   ├── config                    → ~/.config/waybar/config
│   ├── style.css                 → ~/.config/waybar/style.css
│   └── scripts/                  → ~/.config/waybar/scripts/
│       ├── power-menu.sh         (Power menu for Waybar)
│       ├── screenshot-area.sh    (Interactive screenshot with keyboard dialog)
│       ├── night-mode-toggle.sh  (Toggle night mode on/off)
│       └── night-mode-status.sh  (Report night mode state to Waybar)
├── wofi/
│   ├── config                    → ~/.config/wofi/config
│   └── style.css                 → ~/.config/wofi/style.css
├── foot/
│   └── foot.ini                  → ~/.config/foot/foot.ini
├── mako/
│   └── config                    → ~/.config/mako/config
├── btop/
│   ├── btop.conf                 → ~/.config/btop/btop.conf
│   └── themes/
│       └── tactical.theme        → ~/.config/btop/themes/tactical.theme
├── bashrc                        → ~/.bashrc
├── dircolors                     → ~/.dircolors
└── README.md
```

**Benefits of this structure:**
- All configs version-controlled in one place
- Easy to backup and restore
- Changes to project files immediately reflect in system
- Simple to share and replicate across machines

## Customization

### Wallpaper

Edit `sway/config` line 34 to set a custom wallpaper:

```
exec_always "killall swaybg 2>/dev/null; swaybg -i ~/Pictures/wallpaper.jpg -m fill"
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
- Night mode toggle with color temperature adjustment (GNOME-style)
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
- Tactical color palette throughout
- Beam cursor with blink
- Custom color scheme for man pages and less
- Font size optimized for 1920x1080 displays
- Custom directory colors for better visibility

**btop system monitor:**
- Custom tactical theme with color gradients
- Khaki highlights and olive accents
- Charcoal background matching overall aesthetic
- Gradient meters transitioning from olive to khaki to amber
- Minimal borders and clean presentation

### Colors

All color values are clearly labeled in each config file. The Sway window colors are in `sway/config` starting at line 47.

## Workspaces

The configuration features 7 persistent numbered workspaces with subtle, non-distracting design:

**Visual states:**
- **Inactive**: Minimal styling with muted olive text
- **Active**: Bold khaki text with subtle olive background and defined border
- **Hover**: Light olive tint with khaki text
- **Urgent**: Amber background with pulsing animation

Numbered workspaces provide clear identification while staying unobtrusive during focused work. The design works naturally with Waybar's capabilities and fits the tactical aesthetic. Workspaces are flexible and not assigned to specific applications.

## Key Bindings

Uses standard Sway bindings with Mod4 (Super/Windows key):

- **Mod+Return** - Open terminal
- **Mod+d** - Launch Wofi
- **Mod+Shift+q** - Close window
- **Mod+h/j/k/l** - Navigate windows (vim keys)
- **Mod+1-7** - Switch workspaces
- **Mod+Shift+1-7** - Move window to workspace
- **Mod+r** - Resize mode

**Screenshots:**
- **Print** - Interactive area selector, then choose Copy or Save
- **Shift+Print** - Quick capture full screen and save
- **Ctrl+Print** - Quick capture area and copy to clipboard
- **Ctrl+Shift+Print** - Quick capture active window and save

See the [Screenshot System](#screenshot-system) section above for detailed workflow and technical implementation.

**Utilities:**
- **Mod+N** - Toggle night mode (color temperature adjustment)
- **Page Up** - Switch to previous workspace
- **Page Down** - Switch to next workspace

**Additional Keybindings:**

See `sway/config` for complete keybinding reference.

## Performance Notes

This configuration is optimized for lightweight performance on older hardware. All visual enhancements use CSS-based effects rather than compositor-level features, resulting in:

- Minimal RAM usage (~50-80MB for Sway)
- No GPU-intensive blur or animation effects
- Zero CPU overhead from visual styling
- Tested and optimized for ThinkPad T480 (Intel UHD 620)

## Credits & Acknowledgments

This configuration draws inspiration from excellent projects in the Linux desktop ecosystem:

### Major Influences

**[Omarchy](https://github.com/basecamp/omarchy)** by Basecamp
- Web App Manager - The entire web app installation system, including browser-agnostic installation, seamless login sharing, and interactive workflow design
- Quick Actions Menu - The Super+Alt+Space hierarchical menu system
- Design philosophy - Balancing power-user features with approachable UX

**[Omakub](https://github.com/basecamp/omakub)** by Basecamp  
- Keybinding convention - The Super+Space (launcher) and Super+Alt+Space (actions) pattern
- Minimalist aesthetic principles

### Components & Tools

**[Dashboard Icons](https://github.com/walkxcode/dashboard-icons)** by @walkxcode
- High-quality, consistent icon library for web apps

**Sway Community**
- Tiling window manager best practices and configuration patterns

### Design Philosophy

This configuration combines power-user efficiency with modern desktop polish:
- **Minimal by default** - Only essential features, room for customization
- **Zero performance overhead** - Pure CSS styling, no compositor effects
- **Web-first approach** - Seamless integration of web apps as native applications
- **Tactical aesthetics** - Muted, functional color palette with excellent readability

