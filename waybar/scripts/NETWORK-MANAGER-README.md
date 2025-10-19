# Network Manager Script

A user-friendly WiFi management interface for BunkerOS using wofi.

## Features

### 🚀 Quick Access
- Click the WiFi icon in waybar to instantly see all available networks
- Networks are sorted by signal strength (strongest first)
- Shows current connection status at the top

### 📡 Network Information
- Signal strength percentage for each network
- Visual signal bars (▂▄▆█)
- Lock icon (🔒) for secured networks
- Clean, easy-to-read layout

### 🔐 Smart Connection
- **Saved networks**: Automatically connects using stored credentials
- **New networks**: Prompts for password when needed
- **Open networks**: Connects immediately without password
- **Already connected**: Shows disconnect option

### 🛠️ Troubleshooting
When a connection fails, you get options to:
- **Try Again**: Reopen the network selector
- **Advanced Settings**: Launch nmtui for detailed configuration
- **Show Details**: View technical network information

### ⚙️ Management Options
- **Disable WiFi**: Quick toggle to turn off WiFi radio
- **Advanced Settings**: Access full NetworkManager TUI
- **Rescan Networks**: Refresh the list of available networks

## Usage

### From Waybar
Simply click the WiFi icon (󰖩) in your waybar.

### From Command Line
```bash
~/.config/waybar/scripts/network-manager.sh
```

## Workflow Examples

### Connecting to a New Network
1. Click WiFi icon
2. Select network from list
3. Enter password if prompted
4. Get notification when connected

### Switching Networks
1. Click WiFi icon
2. See current connection at top
3. Click any other network to switch
4. Confirm disconnect if needed

### WiFi is Disabled
1. Click WiFi icon
2. See "WiFi is OFF" prompt
3. Choose "Enable WiFi"
4. Network list appears automatically

### Connection Issues
1. If password is wrong or connection fails
2. Menu shows troubleshooting options
3. Try again or access advanced settings
4. View network details for debugging

## Technical Details

- Uses `nmcli` (NetworkManager CLI) for all operations
- Wofi for menu interface (matches BunkerOS theme)
- Automatic network scanning in background
- Handles both WPA/WPA2 and open networks
- Supports saved connection profiles
- Clean notification messages via `notify-send`

## Dependencies

- NetworkManager
- nmcli
- wofi
- notify-send (libnotify)
- foot (terminal for advanced settings)
