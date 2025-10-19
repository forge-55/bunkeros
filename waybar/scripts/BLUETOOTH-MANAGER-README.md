# Bluetooth Manager for BunkerOS

## Overview

A user-friendly Bluetooth management interface for BunkerOS using wofi, designed to match the WiFi manager experience.

## Features

### 🎧 Device Management
- **View paired devices** with connection status
- **View available devices** from scan results
- **One-click connect** to paired devices
- **One-click disconnect** from connected devices
- **Device icons** (headphones, keyboards, mice, phones)
- **Battery levels** for supported devices (shown in tooltip)

### 🔍 Device Discovery
- **Automatic scanning** on menu open
- **Manual scan** option for fresh results
- **Device type detection** with appropriate icons
- **Real-time status updates**

### ⚡ Quick Actions
- **Enable/Disable Bluetooth** radio
- **Scan for new devices**
- **Access advanced settings** (bluetoothctl)
- **Remove paired devices**

### 🎨 User Experience
- **Loading notification** while gathering device info
- **Status indicators**: ✓ Connected, 󰂯 Paired, 󰂲 Available
- **Device type icons**: 󰋋 Audio, 󰌌 Keyboard, 󰍽 Mouse, 󰄜 Phone
- **Clean, organized layout** with sections
- **Consistent with WiFi manager** design

## Waybar Integration

### Icon States
- **󰂯** - Bluetooth enabled, no devices connected
- **󰂱** - Bluetooth enabled, device(s) connected
- **󰂲** - Bluetooth disabled

### Tooltip Information
- Shows connection status
- Lists connected devices
- Shows battery percentage for supported devices

## Usage

### From Waybar
Click the Bluetooth icon (󰂯) in waybar to open the manager.

### From Command Line
```bash
~/.config/waybar/scripts/bluetooth-manager.sh
```

## Workflow Examples

### Connecting to a New Device

1. Click Bluetooth icon
2. If Bluetooth is off, select "Enable Bluetooth"
3. Device appears in "Available Devices"
4. Click device to pair and connect
5. Get notification when connected

### Connecting to Paired Device

1. Click Bluetooth icon
2. See device in "Paired Devices" section
3. Click device name
4. Automatically connects
5. Status updates to "Connected"

### Disconnecting a Device

1. Click Bluetooth icon
2. Click connected device (marked with ✓)
3. Select "🔌 Disconnect"
4. Device disconnects but remains paired

### Removing a Device

1. Click connected device
2. Select "🗑️ Remove Device"
3. Device is unpaired and removed
4. Must re-pair to reconnect later

### Manual Scanning

1. Click "󰂲 Scan for Devices"
2. 10-second scan runs
3. Menu refreshes with new devices
4. New devices appear in "Available Devices"

### Bluetooth is Disabled

1. Click Bluetooth icon
2. Menu shows "Bluetooth is OFF"
3. Options: Enable Bluetooth, Settings, or Cancel
4. Select "Enable Bluetooth"
5. Bluetooth turns on, menu reloads

## Device Information Displayed

For each device, the menu shows:
- **Status icon**: ✓ (connected), 󰂯 (paired), 󰂲 (available)
- **Device type icon**: Based on device class
- **Device name**: Up to 25 characters
- **Status**: Connected, Paired, or Available
- **MAC address**: Hidden in UI, used for commands

## Technical Details

### Dependencies
- `bluetoothctl` (BlueZ utilities)
- `wofi` (menu interface)
- `mako` (notifications)
- `bash` 4.0+

### Bluetooth Commands Used
```bash
bluetoothctl show          # Get adapter status
bluetoothctl devices       # List all devices
bluetoothctl devices Paired # List paired devices
bluetoothctl scan on       # Start scanning
bluetoothctl pair <MAC>    # Pair with device
bluetoothctl trust <MAC>   # Trust device
bluetoothctl connect <MAC> # Connect to device
bluetoothctl disconnect <MAC> # Disconnect from device
bluetoothctl remove <MAC>  # Unpair/remove device
bluetoothctl power on/off  # Enable/disable Bluetooth
```

### Device Type Detection

The script detects device types based on the "Icon" field from `bluetoothctl info`:
- **Audio devices** (headphones, speakers): 󰋋
- **Input devices** (keyboards): 󰌌
- **Mice**: 󰍽
- **Phones**: 󰄜
- **Default**: 󰂯

### Performance

- **Initial load**: < 1 second with cached results
- **Scan time**: 5-10 seconds for discovering new devices
- **Connection time**: 1-3 seconds typical
- **Pairing time**: 2-5 seconds typical

### Background Scanning

When the menu opens:
1. Starts a 5-second background scan
2. Displays menu immediately with known devices
3. New devices appear after brief delay
4. Scan stops when menu closes

## Troubleshooting

### Bluetooth Won't Enable
```bash
# Check Bluetooth service
systemctl status bluetooth

# Start if not running
sudo systemctl start bluetooth
```

### Devices Not Appearing
1. Use "🔄 Scan for Devices" option
2. Make sure device is in pairing mode
3. Try "⚙️ Advanced Settings" → `scan on`

### Connection Fails
1. Remove device and re-pair
2. Check device battery
3. Move closer to computer
4. Try from advanced settings

### Script Issues
```bash
# Test script manually
~/.config/waybar/scripts/bluetooth-manager.sh

# Check bluetoothctl
bluetoothctl show
bluetoothctl devices
```

## Integration with System Menu

The Bluetooth option in the system menu has been updated to use the new manager:
```bash
# Old: foot -e bluetoothctl
# New: ~/.config/waybar/scripts/bluetooth-manager.sh
```

## Comparison with WiFi Manager

| Feature | WiFi Manager | Bluetooth Manager |
|---------|-------------|-------------------|
| Enable/Disable Radio | ✅ | ✅ |
| List Available | ✅ | ✅ |
| One-Click Connect | ✅ | ✅ |
| Show Status | ✅ | ✅ |
| Disconnect | ✅ | ✅ |
| Remove/Forget | ❌ | ✅ |
| Signal Strength | ✅ | ❌ |
| Battery Level | ❌ | ✅ (tooltip) |
| Device Icons | ✅ | ✅ |
| Loading Indicator | ✅ | ✅ |

## Future Enhancements

Potential improvements:
- Show device battery in main menu (not just tooltip)
- Display signal strength (RSSI)
- Audio device quick controls
- Multi-device audio switching
- Device renaming
- Auto-connect preferences

## Notes

- Pairing may require confirmation on the device
- Some devices need to be in "pairing mode"
- Audio devices may need PulseAudio profile switching
- Keyboard/mouse connections are instant after pairing
- Battery information requires device support

Perfect Bluetooth management for BunkerOS! 🎯
