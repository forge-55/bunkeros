# BunkerOS

**A productivity-hardened Sway-based Linux environment built for mission-focused computing.**

BunkerOS is a carefully crafted Sway environment for Arch Linux that delivers a distraction-free, tactical computing experience. Built on vanilla Sway Wayland compositor, BunkerOS provides a clean, minimal desktop optimized for productivity.

## Philosophy

BunkerOS is designed around operational discipline and efficiency:
- **Distraction-free interface** focused on productivity and work excellence
- **Performance-first architecture** - Vanilla Sway for maximum speed and stability
- **Minimal, functional design** over flashy animations
- **Keyboard-driven workflow** for maximum efficiency
- **Tactical color palette** inspired by professional field gear
- **Smart engineering** - Building on the solid Arch foundation with targeted enhancements
- **Productivity-hardened security** - professional-grade protection that works invisibly in the background

## Technical Foundation

**Vanilla Arch Linux required**:
- **Base Layer**: Clean Arch Linux installation with rolling release model
- **Experience Layer**: BunkerOS delivers unique Sway-based environment, productivity automation, and tactical theming
- **Compositor**: Vanilla Sway - stable, fast, and reliable Wayland compositor
- **Installation**: Simple single-phase installation process
- **Ecosystem Access**: Full Arch ecosystem (AUR, rolling release, extensive documentation)

This architecture allows BunkerOS to focus on delivering the best Sway-based productivity experience with a clean, predictable foundation.

## Design Philosophy

BunkerOS uses **vanilla Sway** with no visual effects or animations. This approach delivers:

- **Maximum performance** - No GPU overhead from effects
- **Zero visual artifacts** - No flicker, blur, or shadows during workspace switching
- **Rock-solid stability** - Sway's production-ready reliability
- **Universal compatibility** - Works excellently on all hardware from 2012+
- **Clean, professional aesthetic** - Function over decoration

The tactical color palette and flat design provide a modern, professional look without any performance cost.

## Features

- **Intelligent autotiling** - COSMIC-like smart window placement that automatically balances layouts
- **Multi-monitor support** - Automatic detection and configuration for 1-5 displays with predictable workspace distribution
- **Automatic display scaling** - Auto-detects your screen resolution and applies optimal font sizes on first login
- **Interactive keybinding manager** - View, search, edit, and add keybindings via GUI (Super+m → Keybindings)
- **Multi-theme system** - Switch between 5 curated themes instantly (Tactical, Gruvbox, Nord, Everforest, Tokyo Night)
- **Smart wallpaper manager** - Graphical wallpaper selector with theme/custom modes, upload support
- **Automatic wallpaper switching** - Each theme has its own wallpaper that changes automatically
- **Minimal, intuitive keybindings** - Essential bindings that work across major tiling WMs
- **Custom SDDM login theme** - BunkerOS-styled login screen with centered design and emergency recovery session
- **GTK theming** - Custom dark theme with tactical colors for all GTK applications
- **Waybar** status bar with flat, tactical styling
- **Numbered workspace indicators** (1-7) with ArchCraft-inspired design and refined box styling
- **Workspace overview** - See all workspaces and windows at a glance (Super+W)
- **Wofi** application launcher with minimal design aesthetic
- **Quick Actions Menu** - Hierarchical icon-based menu for power, theme, and system controls
- **Web App Manager** - Install any website as a containerized desktop app (Omarchy-style)
- **Video conferencing ready** - Full PipeWire audio, screen sharing, and webcam support for Zoom, Meet, Teams, Discord
- **Nautilus file manager** - Modern, polished GNOME file manager with GTK4 and libadwaita
- **Lite XL note-taking** - Lightweight, modern text editor with tactical theme for quick notes (Super+n)
- **MATE Calculator** - Simple, GTK3-based calculator with full tactical theming
- **Custom terminal** with tactical prompt design and color scheme
- **btop** system monitor with custom tactical theme
- **Mako** notification daemon with themed notifications
- **Interactive screenshot system** with GNOME/COSMIC-style workflow
- **Night mode toggle** with one-click color temperature adjustment
- **SwayOSD** on-screen display for volume and brightness with elegant overlays
- **Smart power management** - Auto-suspend with optional CPU frequency scaling (auto-cpufreq/TLP)
- **Dynamic wallpaper** management via swaybg
- **Window gaps** for a modern tiled layout
- **Custom color scheme** with olive drab, tactical gray, and tan accents
- **Flat design philosophy** - function over decoration
- **Performance-optimized** - ~280 MB RAM at idle

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

The palette prioritizes readability and focus while maintaining a cohesive tactical aesthetic. The design follows a flat, understated approach with minimal shadows and clean borders - emphasizing function over decoration, perfect for performance-conscious setups from ThinkPads to modern workstations.

## Theme System

This setup includes a powerful theme system that lets you switch between multiple curated color schemes instantly. All themes maintain the tactical aesthetic while offering different moods and color temperatures.

### Available Themes

1. **BunkerOS** (Default) - Khaki/olive/charcoal desert operations aesthetic
2. **Gruvbox Dark** - Warm browns and earthy tones, vintage field gear
3. **Nord** - Cool grays and arctic blues, naval/tech operations *(coming soon)*
4. **Everforest** - Muted greens and forest tones, woodland camo *(coming soon)*
5. **Tokyo Night** - Deep blues and purples, night operations *(coming soon)*

### What Gets Themed

When you switch themes, the following components update automatically:
- Waybar (status bar colors and styling)
- Wofi (application launcher)
- Sway (window borders and focus indicators)
- Bash prompt (terminal colors)
- btop (system monitor)
- Mako (notifications)
- SwayOSD (volume/brightness overlays)
- Foot terminal (colors and cursor)
- File listing colors (dircolors)
- GTK applications (via custom CSS)

### Switching Themes

**Via Quick Menu:**
1. Press `Super+m` to open Quick Actions Menu
2. Select "Theme" option
3. Choose "Change Theme"
4. Select your desired theme from the list

**Via Script:**
```bash
# Show theme menu
~/.config/sway-config/scripts/theme-switcher.sh menu

# Switch directly to a theme
~/.config/sway-config/scripts/theme-switcher.sh gruvbox

# List available themes
~/.config/sway-config/scripts/theme-switcher.sh list

# Show current theme
~/.config/sway-config/scripts/theme-switcher.sh current
```

**What Happens:**
1. Theme files are copied to active config locations
2. Sway configuration is updated with new colors
3. Waybar, Mako, and SwayOSD are restarted
4. Bash prompt colors are updated (reload terminal to see changes)
5. Your theme preference is saved

### Theme Structure

Each theme is self-contained in `themes/THEME_NAME/` with all necessary config files:
```
themes/tactical/
├── theme.conf          # Metadata and color palette
├── waybar-style.css    # Waybar styling
├── wofi-style.css      # Wofi launcher styling
├── sway-colors.conf    # Window border colors
├── bashrc-colors       # Terminal prompt colors
├── btop.theme          # System monitor theme
├── mako-config         # Notification styling
├── swayosd-style.css   # OSD overlay styling
├── foot.ini            # Terminal colors
└── dircolors           # File listing colors
```

### Creating Custom Themes

To create your own theme:
1. Copy an existing theme directory: `cp -r themes/tactical themes/mytheme`
2. Edit `themes/mytheme/theme.conf` with your metadata
3. Update all CSS and config files with your color palette
4. Test it: `~/.config/sway-config/scripts/theme-switcher.sh mytheme`
5. Submit a PR to share with the community!

**Contributing Themes:**
We welcome community-contributed themes! Please ensure your theme:
- Maintains the tactical aesthetic
- Provides good contrast for readability
- Includes all required config files
- Has complete metadata in theme.conf

## Keybindings

This configuration uses minimal, intuitive keybindings that are consistent across major tiling window managers. The philosophy is to provide only the essential bindings, leaving room for users to customize with their favorite applications and scripts.

### Design Philosophy

- **Minimal by default** - Only essential keybindings included
- **Mnemonic system** - Keys match their function (a=apps, b=browser, e=editor, f=files, m=menu, t=terminal)
- **Alternative bindings** - Common actions have alternatives for users from different WMs (Super+Space, Super+Enter)
- **No Shift modifiers** - Essential actions use single keys for speed
- **User-configurable** - Default apps set via variables at top of config
- **Customization-friendly** - Clear space for users to add personal bindings

### Essential Keybindings

**Basic Actions:**
- `Super+a` or `Super+Space` - Application launcher (Wofi)
- `Super+b` - Open default web browser
- `Super+e` - Text editor
- `Super+Escape` - Lock screen
- `Super+f` - File manager
- `Super+m` or `Super+Alt+Space` - Quick actions menu
- `Super+q` - Close window
- `Super+t` or `Super+Enter` - Launch terminal
- `Super+c` - Launch calculator (MATE Calculator)
- `Super+w` - Workspace overview (see all workspaces and windows)
- `Super+Shift+w` - Reorder workspaces (reorganize workspace positions)
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
- `Super+v` - Toggle split layout
- `F11` - Fullscreen
- `Super+r` - Enter resize mode (use h/j/k/l or arrows, then Esc)

**System Controls:**
- `Print` - Interactive screenshot (select area, then choose copy/save)
- `Shift+Print` - Screenshot entire screen (save)
- `Ctrl+Print` - Screenshot area (copy to clipboard)
- `Ctrl+Shift+Print` - Screenshot active window (save)
- `Super+n` - Toggle night mode
- `Fn+F1-F6` - Volume/brightness controls (hardware keys with OSD)


### Keybinding Manager

BunkerOS includes an **interactive keybinding manager** that makes discovering and customizing keybindings easy, even for users new to tiling window managers.

**Access**: `Super+m` → **Keybindings**

**Features**:
- **View All Keybindings** - Browse every keybinding in a searchable list
- **Search Keybindings** - Find specific keybindings by key combo or action
- **Add New Keybindings** - Create custom keybindings via GUI (no config editing needed)
- **Edit Keybindings** - Select a keybinding to open the config at that exact line
- **Keybinding Cheatsheet** - Quick reference of essential keybindings organized by category
- **Backup Keybindings** - Save your current keybindings to a timestamped file
- **Open Config File** - Direct access to the Sway config for advanced editing

The keybinding manager uses Wofi for all interactions, maintaining the keyboard-first workflow while making customization accessible to everyone. All custom keybindings are added to a dedicated section at the end of the config file, keeping your customizations organized and separate from the defaults.

### Manual Customization

You can also edit keybindings directly in the config. There's a dedicated customization section at the end of the keybindings area:

```
# Examples:
bindsym $mod+Shift+d exec Discord
bindsym $mod+s exec spotify
bindsym $mod+d exec steam
```

**Configuring Default Applications:**

Edit the variables section at the top of `sway/config`:
```bash
set $editor cursor        # Change to: code, micro, vim, etc.
set $filemanager nautilus   # Modern GNOME file manager
set $term foot            # Change to: alacritty, kitty, etc.
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

## Workspace Overview

Get a birds-eye view of all your workspaces and open windows with a single keypress. This feature provides a quick way to see what's running across all workspaces and jump directly to any window or workspace.

### Usage

Press `Super+W` to open the workspace overview.

The overview displays:
- **󰝥 Current workspace** - The workspace you're currently on
- **󰍺 Visible workspaces** - Workspaces visible on other monitors (multi-monitor setups)
- **󰖲 Active workspaces** - Workspaces with open windows
- **Window list** - All open windows under each workspace with their titles
- **󰣐 Window icons** - Each window prefixed with an icon for easy scanning

### Navigation

- **Type to filter** - Start typing to narrow down workspaces or windows
- **Click or Enter** - Select a workspace to switch to it
- **Esc** - Close the overview without switching

### Reordering Workspaces

Want to reorganize your workspaces? Use the dedicated reorder mode:

**Quick Access:** Press `Super+Shift+W` to enter reorder mode directly

**How it works:**
1. Press `Super+Shift+W` (reorder mode opens immediately)
2. Select the workspace you want to move
3. Type the destination position number (1-9)
4. Done! The workspaces swap positions instantly

**Example:** If you have development work on workspace 7 but want it on workspace 2:
- Press `Super+Shift+W`
- Select workspace 7
- Type `2`
- Workspace 7 and 2 swap - you're now on your dev workspace at position 2!

**Why this is useful:**
- Quick reorganization when you have many workspaces open
- Group related work together (all communication apps on 3-4)
- Move important work to easier-to-reach positions (1-3)
- Much faster than manually moving windows between workspaces

### When to Use

The workspace overview is most useful when:
- You have multiple workspaces with various applications
- You can't remember which workspace has a specific window
- You want to quickly scan what's open without cycling through workspaces
- You need to jump to a specific window across workspaces

This is **much faster** than manually cycling through workspaces (`PgUp/PgDn` or `Super+1-9`) when you're looking for something specific.

### Implementation

The overview is implemented as a custom script (`workspace-windows.sh`) that:
1. Queries Sway's IPC for all workspaces and their windows
2. Formats the data with icons and clear labeling
3. Displays in Wofi with tactical theme styling
4. Handles workspace switching, window focusing, and workspace reordering
5. Uses Sway's native `rename workspace` command for seamless reordering

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

## Login Screen (SDDM)

This configuration includes a custom SDDM theme that matches the tactical aesthetic. The login screen features a minimal, centered design with the same color palette as the rest of the setup.

### Features

- **Tactical color scheme** - Uses the same khaki/tan, olive, and charcoal palette
- **Minimal design** - Centered login box with clean fields for username and password
- **Session selector** - Choose between available desktop sessions (Sway, X11, etc.)
- **Power controls** - Shutdown, reboot, and suspend buttons
- **Date and time display** - Shows current date/time in the bottom left
- **Monospace typography** - Consistent with terminal and Waybar styling
- **Smooth animations** - Subtle hover effects and focus indicators

### Installation

The SDDM theme files are located in `sddm/tactical/` and need to be installed to the system:

```bash
cd /home/ryan/Projects/bunkeros/sddm
./install-theme.sh
```

This script will:
1. Copy the theme to `/usr/share/sddm/themes/tactical`
2. Configure SDDM to use the tactical theme in `/etc/sddm.conf`

To enable SDDM as your display manager:

```bash
sudo systemctl enable sddm.service
```

To test the theme without logging out:

```bash
sddm-greeter --test-mode --theme /usr/share/sddm/themes/tactical
```

### Theme Files

- `Main.qml` - Main theme interface (QML markup)
- `theme.conf` - Theme configuration
- `metadata.desktop` - Theme metadata
- `install-theme.sh` - Installation script

The theme uses Qt Quick/QML for rendering and follows SDDM's theme API 2.0. All UI elements are styled to match the tactical aesthetic with proper focus indicators and hover states.

## GTK Theme (Dark Mode & Application Styling)

This configuration includes custom GTK 3.0 and GTK 4.0 themes that apply the tactical color scheme to all GTK applications, system dialogs, and most desktop applications.

### Features

- **Dark mode by default** - All GTK apps use dark theme
- **Tactical color palette** - Matches the rest of the setup (khaki/tan, olive, charcoal)
- **Custom styling** - Overrides for buttons, inputs, sidebars, headers, menus
- **Consistent experience** - All applications blend seamlessly with the theme
- **Focus indicators** - Clear visual feedback using tactical tan (#C3B091)
- **Smooth transitions** - Subtle hover and active states

### Installation

The GTK theme files are in `gtk-3.0/` and `gtk-4.0/` directories. Install them:

```bash
cd /home/ryan/Projects/bunkeros/gtk-3.0
./install.sh

cd /home/ryan/Projects/bunkeros/gtk-4.0
./install.sh
```

This will:
1. Create backups of existing GTK configs (if any)
2. Symlink the tactical theme files to `~/.config/gtk-3.0/` and `~/.config/gtk-4.0/`

### What Gets Styled

- **File Manager (Nautilus)** - File browser, thumbnails, search, and network locations
- **System Dialogs** - File pickers, color pickers, print dialogs
- **Applications** - Any GTK-based app (GIMP, Inkscape, etc.)
- **UI Elements** - Buttons, inputs, menus, scrollbars, tooltips, tabs

### Files

**GTK 3.0:**
- `settings.ini` - Enables dark theme and sets preferences
- `gtk.css` - Custom CSS with tactical color overrides

**GTK 4.0:**
- `settings.ini` - Enables dark theme for newer apps
- `gtk.css` - Custom CSS for GTK 4 applications

### Applying Changes

After installation, restart any running GTK applications:

```bash
pkill nautilus
nautilus &
```

Or simply log out and back in for system-wide changes.

### Customization

To adjust colors, edit `gtk-3.0/gtk.css` or `gtk-4.0/gtk.css`. The main colors used:

- **Background**: `#1C1C1C` (Charcoal)
- **Surface**: `#2B2D2E` (Tactical Gray)
- **Primary**: `#C3B091` (Tactical Tan)
- **Secondary**: `#6B7A54` (Olive)
- **Tertiary**: `#3C4A2F` (Muted Olive)
- **Text**: `#D4D4D4` (Off-White)

After making changes, the updates apply immediately to newly opened applications (existing apps need restart).

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
- **󰍃 File Manager** - Open Nautilus file manager
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

## Lite XL Note-Taking

BunkerOS includes **Lite XL**, a lightweight, modern text editor perfect for quick note-taking and text editing. Lite XL provides a clean, tactical-themed interface that matches the BunkerOS aesthetic.

### Quick Start
- **Super+n**: Open Lite XL with your Notes directory (quick access!)
- **Super+m → Notes**: Launch from Quick Menu
- **Super+e**: Open Lite XL as general text editor

### Features
- **Instant startup**: <0.5 second launch time, ~10 MB RAM footprint
- **BunkerOS Tactical Theme**: Dark interface with tactical gold accents matching Waybar and Nautilus
- **Markdown support**: Built-in syntax highlighting for structured notes
- **Multi-cursor editing**: Power-user features when you need them
- **Fuzzy file finder**: Quick navigation with Ctrl+p
- **Tab interface**: Work on multiple notes simultaneously
- **Auto-save**: Never lose your thoughts

### Keybindings
| Shortcut | Action |
|----------|--------|
| `Ctrl+Shift+f` | Find in all files |
| `Ctrl+f` | Find in current file |
| `Ctrl+p` | Quick file open (fuzzy) |
| `Ctrl+n` | New file |
| `Ctrl+s` | Save |
| `Ctrl+w` | Close tab |
| `Ctrl+Tab` | Next tab |

### Notes Organization
Notes are stored in `~/Documents/Notes/` and created automatically. A Welcome note explains Lite XL features.

**Full documentation**: See `lite-xl/README.md` for advanced configuration, plugins, and theming.

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

### Core Packages (Required)

Install all required packages:

```bash
sudo pacman -S sway waybar wofi foot swaybg brightnessctl sway-contrib grim slurp wl-clipboard mako wlsunset swayosd xdg-utils swaylock nautilus sushi eog evince btop pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber v4l-utils
```

**What each package does:**
- `sway` - Tiling window manager (Wayland compositor)
- `waybar` - Status bar with tactical theme
- `wofi` - Application launcher and menu system
- `foot` - Terminal emulator
- `swaybg` - Wallpaper manager
- `brightnessctl` - Brightness control for laptops
- `sway-contrib` - Includes grimshot for screenshots
- `grim` + `slurp` - Screenshot tools (capture + area selection)
- `wl-clipboard` - Clipboard utilities for Wayland
- `mako` - Notification daemon
- `wlsunset` - Night mode (color temperature adjustment)
- `swayosd` - On-screen display for volume/brightness
- `xdg-utils` - Desktop integration (needed for web apps)
- `swaylock` - Screen locker (Super+Escape)
- `nautilus` - GNOME file manager with modern UI (Super+f)
- `sushi` - Spacebar file preview for Nautilus
- `eog` - Eye of GNOME image viewer
- `evince` - PDF and document viewer
- `btop` - System monitor (accessible from System menu)
- `pipewire` + `pipewire-pulse` - Modern audio system (required for video conferencing)
- `pipewire-alsa` + `pipewire-jack` - Audio compatibility layers
- `wireplumber` - PipeWire session manager
- `v4l-utils` - Webcam utilities (video conferencing)

### Video Conferencing

BunkerOS includes full support for video conferencing with screen sharing, audio, and webcam support. The setup script automatically configures browsers for optimal Wayland screen sharing.

**Supported platforms:**
- Google Meet, Zoom, Microsoft Teams (web and native)
- Discord, Slack, Jitsi Meet
- Any WebRTC-based conferencing tool

**See the complete guide:** [`VIDEOCONFERENCING.md`](VIDEOCONFERENCING.md)

### User-Configurable Applications

You'll also need to install your preferred applications for the keybindings:

**Web Browser** (Super+b):
```bash
# Default: Brave (privacy-focused, built-in ad blocking, seamless web apps)
yay -S brave-bin

# Alternative: Firefox (also included, independent engine)
sudo pacman -S firefox

# Optional: Other browsers
yay -S ungoogled-chromium  # Community-driven, no Google services
yay -S google-chrome       # Official Google browser
```
Set your default browser: `xdg-settings set default-web-browser brave-browser.desktop`

**Note**: BunkerOS defaults to Brave for optimal containerized web app functionality while providing built-in privacy protection. Firefox is also installed for users who prefer it, though containerized web apps will have limited isolation. See `DEFAULT-APPS.md` for details.

**Text Editor** (Super+e):
```bash
# Choose one based on your preference:
sudo pacman -S code           # VS Code
# or cursor from AUR
# or: micro, vim, neovim, etc.
```
Update the variable in `sway/config`: `set $editor cursor`

**Calculator** (Super+c):
```bash
sudo pacman -S mate-calc
```
MATE Calculator is a simple, GTK3-based calculator that integrates perfectly with the tactical theme. It provides essential calculation features without the complexity of scientific calculators, and fully supports custom CSS theming.

### Login Manager (Optional)

For a themed login screen that matches the tactical aesthetic:

```bash
sudo pacman -S sddm qt6-svg qt6-declarative
```

After installing, run the installation script:
```bash
cd /home/ryan/Projects/bunkeros/sddm
./install-theme.sh
```

Then enable SDDM:
```bash
sudo systemctl enable sddm.service
```

See the [Login Screen (SDDM)](#login-screen-sddm) section for details.

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

BunkerOS requires **vanilla Arch Linux** with no desktop environment or window manager pre-installed.

### Quick Start (For Existing Arch Users)

If you already have vanilla Arch Linux installed:

```bash
# Clone BunkerOS
cd ~
git clone https://github.com/forge-55/bunkeros.git
cd bunkeros

# Run installer
./install.sh

# Reboot when prompted
```

That's it! Select "BunkerOS" at the SDDM login screen.

### Fresh Installation (No Arch Yet)

If you're starting from scratch:

1. **Install Vanilla Arch Linux** - Follow [ARCH-INSTALL.md](ARCH-INSTALL.md)
   - Essential packages: `base linux linux-firmware git sudo networkmanager base-devel grub efibootmgr`
   - Create user account and enable sudo
   - **DO NOT** install any desktop environment, window manager, or display manager

2. **Install BunkerOS** - Run the commands above

**See [FRESH-INSTALL-CHECKLIST.md](FRESH-INSTALL-CHECKLIST.md) for detailed checklist**

### Installation Time

- Fresh Arch install: ~15 minutes
- BunkerOS install: ~10-15 minutes  
- **Total: ~30 minutes from blank drive to working BunkerOS**

### What Gets Installed

The `install.sh` script automatically:
- ✅ Installs all required packages (Sway, Waybar, apps, fonts, etc.)
- ✅ Builds and installs `yay` AUR helper
- ✅ Installs AUR packages (swayosd-git)
- ✅ Copies all configuration files
- ✅ Enables user services (PipeWire audio)
- ✅ Installs and enables SDDM display manager
- ✅ Sets up themed login screen

**No manual configuration needed** - just install and reboot!

### Documentation

- 📘 [ARCH-INSTALL.md](ARCH-INSTALL.md) - Complete Arch installation guide
- 📘 [FRESH-INSTALL-CHECKLIST.md](FRESH-INSTALL-CHECKLIST.md) - Installation checklist
- 📘 [INSTALL.md](INSTALL.md) - Detailed installation guide and troubleshooting
- 📘 [QUICKREF.md](QUICKREF.md) - Quick reference for using BunkerOS


This approach prevents session interruption and allows you to verify BunkerOS works before switching display managers.

### Alternative: Manual Setup

If you prefer the original setup process:

```bash
# Install dependencies manually first
sudo pacman -S sway autotiling-rs waybar wofi mako foot nautilus \
               sushi eog evince lite-xl btop grim slurp wl-clipboard \
               brightnessctl playerctl pavucontrol network-manager-applet \
               blueman sddm qt5-declarative qt5-quickcontrols2 mate-calc \
               ttf-meslo-nerd xdg-desktop-portal xdg-desktop-portal-wlr \
               xdg-desktop-portal-gtk pipewire pipewire-pulse pipewire-alsa \
               pipewire-jack wireplumber v4l-utils python-pipx zenity \
               wlsunset swaylock swayidle swaybg jq

# Install SwayOSD for volume/brightness overlays
yay -S swayosd-git

# Install TerminalTextEffects
pipx install terminaltexteffects

# Run user configuration
./setup.sh

# Install SDDM separately
./install-sddm.sh
```

**For detailed installation instructions, see [INSTALL.md](INSTALL.md)**

## Project Structure

All configuration files are stored in this repository and copied to their appropriate locations:

```
bunkeros/
├── sway/
│   ├── config                    → ~/.config/sway/config
│   └── config.d/
├── themes/                       (Theme system - all themes stored here)
│   ├── tactical/                 (Default tactical theme)
│   │   ├── theme.conf            (Theme metadata and color palette)
│   │   ├── waybar-style.css      (Waybar colors)
│   │   ├── wofi-style.css        (Wofi launcher colors)
│   │   ├── sway-colors.conf      (Window border colors)
│   │   ├── bashrc-colors         (Terminal prompt colors)
│   │   ├── btop.theme            (System monitor theme)
│   │   ├── mako-config           (Notification styling)
│   │   ├── swayosd-style.css     (OSD styling)
│   │   ├── foot.ini              (Terminal colors)
│   │   └── dircolors             (File listing colors)
│   ├── gruvbox/                  (Gruvbox Dark theme)
│   ├── nord/                     (Nord theme - coming soon)
│   ├── everforest/               (Everforest theme - coming soon)
│   └── tokyo-night/              (Tokyo Night theme - coming soon)
├── scripts/
│   └── theme-switcher.sh         (Theme switching utility)
├── waybar/
│   ├── config                    → ~/.config/waybar/config
│   ├── style.css                 → ~/.config/waybar/style.css
│   └── scripts/                  → ~/.config/waybar/scripts/
│       ├── power-menu.sh         (Power menu for Waybar)
│       ├── quick-menu.sh         (Main quick actions menu)
│       ├── theme-menu.sh         (Theme controls sub-menu)
│       ├── system-menu.sh        (System settings sub-menu)
│       ├── webapp-menu.sh        (Web app manager sub-menu)
│       ├── workspace-windows.sh  (Workspace overview with window list)
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
├── swayosd/
│   └── style.css                 → ~/.config/swayosd/style.css
├── gtk-3.0/
│   ├── settings.ini              → ~/.config/gtk-3.0/settings.ini
│   ├── gtk.css                   → ~/.config/gtk-3.0/gtk.css
│   └── install.sh                (GTK 3.0 theme installation script)
├── gtk-4.0/
│   ├── settings.ini              → ~/.config/gtk-4.0/settings.ini
│   ├── gtk.css                   → ~/.config/gtk-4.0/gtk.css
│   └── install.sh                (GTK 4.0 theme installation script)
├── sddm/
│   ├── tactical/
│   │   ├── Main.qml              (BunkerOS SDDM theme interface)
│   │   ├── theme.conf            (Theme configuration)
│   │   └── metadata.desktop      (Theme metadata)
│   ├── sessions/
│   │   └── bunkeros.desktop          → /usr/share/wayland-sessions/ (BunkerOS session)
│   ├── install-theme.sh          (Theme and session installation script)
│   └── README.md                 (SDDM theme documentation)
├── webapp/
│   ├── bin/
│   │   ├── webapp-install        (Install web apps)
│   │   ├── webapp-remove         (Remove web apps)
│   │   └── webapp-list           (List installed web apps)
│   └── README.md                 (Web app manager documentation)
├── bashrc                        → ~/.bashrc
├── dircolors                     → ~/.dircolors
├── .current-theme                (Tracks active theme - user-specific, not in git)
├── .gitignore
└── README.md
```

**Benefits of this structure:**
- All configs version-controlled in one place
- Easy to backup and restore
- Changes to project files immediately reflect in system
- Simple to share and replicate across machines
- Theme system allows instant visual changes without losing customizations

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

---

## Documentation

### Installation & Setup
- **[INSTALL.md](INSTALL.md)** - Installation guide with robust installer
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Issues and automated troubleshooting tools

### Architecture & Design
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Technical architecture and design decisions
- **[EDITION_STRATEGY.md](EDITION_STRATEGY.md)** - Edition philosophy and hardware guidelines
- **[SECURITY.md](SECURITY.md)** - Security features and best practices

### Features & Usage
- **[MULTI-MONITOR.md](MULTI-MONITOR.md)** - Multi-monitor configuration and workspace distribution
- **[VIDEOCONFERENCING.md](VIDEOCONFERENCING.md)** - Video call setup and screen sharing
- **[FAQ.md](FAQ.md)** - Frequently asked questions
- **Component READMEs** - Individual component directories for detailed guides

### Project Information
- **[ABOUT.md](ABOUT.md)** - Project overview and philosophy

---