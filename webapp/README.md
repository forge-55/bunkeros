# Web App Manager

A browser-agnostic web app installation system for Sway, inspired by Omarchy. Install any website as a containerized desktop application with custom icons in just a few steps.

## Features

- **Browser Detection** - Automatically uses your default browser (Chrome, Chromium, Brave, Firefox)
- **Seamless Login Experience** - Uses your main browser's login sessions (like Omarchy)
- **Instant Access** - Already signed in if you're signed in to your main browser
- **Custom Icons** - Download icons from dashboardicons.com or use local files
- **App Mode** - Clean, chrome-less windows that integrate perfectly with Sway
- **Wofi Integration** - Consistent with the tactical theme and quick menu system
- **Easy Management** - Install, remove, and list web apps through simple menus

## Usage

### Install a Web App

1. Open Quick Menu: `Super+Alt+Space`
2. Select **📱 Web Apps** → **󰐖 Install Web App**
3. Enter app details when prompted:
   - **App Name**: GitHub
   - **URL**: https://github.com
   - **Icon**: Paste URL from dashboardicons.com or local path

The app will appear in your Wofi launcher immediately!

### Remove a Web App

1. Open Quick Menu: `Super+Alt+Space`
2. Select **📱 Web Apps** → **󰆴 Remove Web App**
3. Choose the app to remove from the list

### List Installed Web Apps

1. Open Quick Menu: `Super+Alt+Space`
2. Select **📱 Web Apps** → **󰋗 List Web Apps**

## Supported Browsers

The tool automatically detects and uses your default browser:

- **Google Chrome** - Full support with main profile
- **Chromium** - Full support with main profile
- **Brave** - Full support with main profile
- **Firefox** - Supported with new-window mode

## Directory Structure

**In Git repo (setup files only):**
```
webapp/
├── bin/
│   ├── webapp-install      # Installation script
│   ├── webapp-remove       # Removal script
│   └── webapp-list         # List installed apps
└── README.md                # Documentation
```

**User data (outside Git):**
```
~/.local/share/sway-webapp/
├── icons/                   # Your installed app icons
└── data/                    # Reserved for custom profiles
```

This separation keeps your personal web app data private while allowing the setup files to be version controlled.

## Technical Details

### Browser Detection

The tool uses `xdg-settings` to detect your default browser and falls back to checking for installed browsers in this order:
1. Google Chrome
2. Chromium
3. Brave
4. Firefox

### Desktop Integration

Each web app creates a `.desktop` file in `~/.local/share/applications/` following FreeDesktop standards. These files include:

- Custom app name and icon
- Browser launch command with app mode flags
- Uses main browser profile for seamless login
- WebApp category for organization

### Browser-Specific Flags

**Chromium-based browsers:**
```bash
--app="URL" --class=WebApp
```
Uses your main browser's default profile for seamless login experience.

**Firefox:**
```bash
--new-window --class="WebApp" "URL"
```

## Examples

### Common Web Apps

**GitHub:**
- Name: GitHub
- URL: https://github.com
- Icon: https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/github.png

**Gmail:**
- Name: Gmail
- URL: https://mail.google.com
- Icon: https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/gmail.png

**Calendar:**
- Name: Calendar
- URL: https://calendar.google.com
- Icon: https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/google-calendar.png

**Slack:**
- Name: Slack
- URL: https://app.slack.com
- Icon: https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/slack.png

### Finding Icons

Visit [Dashboard Icons](https://github.com/walkxcode/dashboard-icons) to browse thousands of high-quality app icons. Right-click any icon and copy the image URL.

## Command-Line Usage

You can also use the scripts directly:

```bash
# Install a web app
~/.config/sway-config/webapp/bin/webapp-install

# Remove a web app
~/.config/sway-config/webapp/bin/webapp-remove

# List installed web apps
~/.config/sway-config/webapp/bin/webapp-list
```

## Packaging

This module is designed to be packaged independently. The entire `webapp/` directory is self-contained and can be distributed as a standalone tool for any Wayland compositor.

## Security & Isolation

Web apps run with:
- **Main browser profile** - Uses your default browser profile for instant access
- **Browser sandbox** - Standard browser security features apply  
- **No system containers** - Uses browser-native app mode, not Docker
- **Same security** - Identical security posture as opening the site in your main browser

This approach provides maximum convenience (instant login) while maintaining browser-level security.

### Why Main Profile?

Following Omarchy's design, web apps use your main browser profile because:
1. **Instant access** - Already signed in to all your accounts
2. **No friction** - Zero re-authentication needed
3. **Realistic use case** - If you're signed into GitHub/Gmail in your browser, you want to be signed in everywhere
4. **Consistency** - Bookmarks, extensions, and settings work across web apps and browser

If you need per-app isolation, you can manually edit the `.desktop` files to add `--user-data-dir=/custom/path` flags.

