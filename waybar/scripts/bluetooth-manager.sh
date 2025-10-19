#!/bin/bash

# Bluetooth Manager with wofi - User-friendly Bluetooth management

# Show loading notification
notify-send "Bluetooth" "Loading devices..." --icon=bluetooth --urgency=low --expire-time=0 &

# Check if Bluetooth is available
if ! command -v bluetoothctl &> /dev/null; then
    notify-send "Bluetooth" "Bluetooth tools not installed" --icon=bluetooth-disabled
    exit 1
fi

# Get Bluetooth power status
bt_power=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

# If Bluetooth is off, offer to enable it
if [ "$bt_power" != "yes" ]; then
    makoctl dismiss --all 2>/dev/null
    action=$(echo -e "󰂯 Enable Bluetooth\n⚙️  Settings\n❌ Cancel" | wofi --dmenu --prompt "Bluetooth is OFF" --width 250 --height 150)
    case "$action" in
        "󰂯 Enable Bluetooth")
            bluetoothctl power on
            notify-send "Bluetooth" "Bluetooth enabled" --icon=bluetooth
            sleep 1
            exec "$0"  # Restart script
            ;;
        "⚙️  Settings")
            foot -e bluetoothctl
            ;;
    esac
    exit 0
fi

# Bluetooth is on - get paired and available devices
header="Bluetooth Enabled\n━━━━━━━━━━━━━━━━━━━━━━━━━"

# Get paired devices
paired_devices=""
while IFS= read -r line; do
    if [[ $line =~ Device\ ([0-9A-F:]+)\ (.+) ]]; then
        mac="${BASH_REMATCH[1]}"
        name="${BASH_REMATCH[2]}"
        
        # Check if connected
        connected=$(bluetoothctl info "$mac" 2>/dev/null | grep "Connected:" | awk '{print $2}')
        trusted=$(bluetoothctl info "$mac" 2>/dev/null | grep "Trusted:" | awk '{print $2}')
        
        if [ "$connected" = "yes" ]; then
            icon="✓"
            status="Connected"
        elif [ "$trusted" = "yes" ]; then
            icon="󰂯"
            status="Paired"
        else
            icon="󰂲"
            status="Paired"
        fi
        
        # Get device type/icon
        device_type=$(bluetoothctl info "$mac" 2>/dev/null | grep "Icon:" | awk '{print $2}')
        case "$device_type" in
            *"audio"*|*"headset"*|*"headphone"*)
                type_icon="󰋋"
                ;;
            *"input"*|*"keyboard"*)
                type_icon="󰌌"
                ;;
            *"mouse"*)
                type_icon="󰍽"
                ;;
            *"phone"*)
                type_icon="󰄜"
                ;;
            *)
                type_icon="󰂯"
                ;;
        esac
        
        paired_devices+="$icon $type_icon $(printf "%-25s" "$name") [$status]|$mac|$connected\n"
    fi
done < <(bluetoothctl devices Paired 2>/dev/null)

# Start scan in background for available devices
bluetoothctl --timeout 5 scan on >/dev/null 2>&1 &
scan_pid=$!

# Get available (non-paired) devices
sleep 0.5  # Brief wait for scan to find devices
available_devices=""
while IFS= read -r line; do
    if [[ $line =~ Device\ ([0-9A-F:]+)\ (.+) ]]; then
        mac="${BASH_REMATCH[1]}"
        name="${BASH_REMATCH[2]}"
        
        # Skip if already paired
        if echo -e "$paired_devices" | grep -q "$mac"; then
            continue
        fi
        
        available_devices+="󰂲 󰂯 $(printf "%-25s" "$name") [Available]|$mac|no\n"
    fi
done < <(bluetoothctl devices 2>/dev/null)

# Build menu
if [ -n "$paired_devices" ]; then
    devices_section="━━ Paired Devices ━━\n$paired_devices"
else
    devices_section="━━ No Paired Devices ━━\n"
fi

if [ -n "$available_devices" ]; then
    devices_section+="\n━━ Available Devices ━━\n$available_devices"
fi

menu="$header
$devices_section
━━━━━━━━━━━━━━━━━━━━━━━━━
󰂲 Scan for Devices
󰂭 Disable Bluetooth
⚙️  Advanced Settings"

# Dismiss loading notification
makoctl dismiss --all 2>/dev/null

# Stop background scan
kill $scan_pid 2>/dev/null

# Show menu
choice=$(echo -e "$menu" | wofi --dmenu --prompt "Bluetooth" --width 450 --height 500)

# Handle selection
if [ -z "$choice" ]; then
    bluetoothctl scan off 2>/dev/null
    exit 0
fi

case "$choice" in
    *"Bluetooth Enabled"*|"━"*)
        # Header/separator - ignore
        exit 0
        ;;
        
    "󰂭 Disable Bluetooth")
        bluetoothctl power off
        notify-send "Bluetooth" "Bluetooth disabled" --icon=bluetooth-disabled
        ;;
        
    "⚙️  Advanced Settings")
        foot -e bluetoothctl
        ;;
        
    "󰂲 Scan for Devices")
        notify-send "Bluetooth" "Scanning for devices..." --icon=bluetooth --expire-time=5000
        bluetoothctl --timeout 10 scan on >/dev/null 2>&1
        exec "$0"  # Restart to show new devices
        ;;
        
    *)
        # Device selection
        mac=$(echo "$choice" | awk -F'|' '{print $2}')
        connected=$(echo "$choice" | awk -F'|' '{print $3}')
        device_name=$(echo "$choice" | awk -F'|' '{print $1}' | sed 's/^[^ ]* [^ ]* //' | sed 's/ *\[.*\]//')
        
        if [ -n "$mac" ]; then
            if [ "$connected" = "yes" ]; then
                # Already connected - show options
                action=$(echo -e "🔌 Disconnect\n🗑️  Remove Device\n❌ Cancel" | wofi --dmenu --prompt "$device_name" --width 300 --height 150)
                case "$action" in
                    "🔌 Disconnect")
                        if bluetoothctl disconnect "$mac" 2>/dev/null; then
                            notify-send "Bluetooth" "Disconnected from $device_name" --icon=bluetooth-disabled
                        else
                            notify-send "Bluetooth" "Failed to disconnect" --icon=bluetooth-disabled
                        fi
                        ;;
                    "🗑️  Remove Device")
                        if bluetoothctl remove "$mac" 2>/dev/null; then
                            notify-send "Bluetooth" "Removed $device_name" --icon=bluetooth
                        else
                            notify-send "Bluetooth" "Failed to remove device" --icon=bluetooth-disabled
                        fi
                        ;;
                esac
            elif echo "$choice" | grep -q "\[Paired\]"; then
                # Paired but not connected
                notify-send "Bluetooth" "Connecting to $device_name..." --icon=bluetooth
                if bluetoothctl connect "$mac" 2>/dev/null; then
                    notify-send "Bluetooth" "Connected to $device_name" --icon=bluetooth
                else
                    notify-send "Bluetooth" "Failed to connect to $device_name" --icon=bluetooth-disabled
                fi
            else
                # Not paired - pair and connect
                notify-send "Bluetooth" "Pairing with $device_name..." --icon=bluetooth
                (
                    echo "pair $mac"
                    sleep 2
                    echo "trust $mac"
                    sleep 1
                    echo "connect $mac"
                    sleep 2
                    echo "exit"
                ) | bluetoothctl >/dev/null 2>&1
                
                # Check if successful
                sleep 1
                if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
                    notify-send "Bluetooth" "Connected to $device_name" --icon=bluetooth
                else
                    notify-send "Bluetooth" "Failed to pair with $device_name" --icon=bluetooth-disabled
                fi
            fi
        fi
        ;;
esac

# Clean up
bluetoothctl scan off 2>/dev/null
