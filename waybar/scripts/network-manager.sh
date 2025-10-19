#!/bin/bash

# Network Manager with wofi - User-friendly WiFi management

# Show persistent loading notification (will be dismissed when menu opens)
notify-send "WiFi" "Loading networks..." --icon=network-wireless --urgency=low --expire-time=0 &

# Check if NetworkManager is running
if ! systemctl is-active --quiet NetworkManager; then
    notify-send "Network Manager" "NetworkManager service is not running" --icon=network-error
    exit 1
fi

# Get current status quickly
wifi_status=$(nmcli radio wifi)
current_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

# If WiFi is off, offer to enable it
if [ "$wifi_status" = "disabled" ]; then
    action=$(echo -e "󰖩 Enable WiFi\n⚙️  Settings\n❌ Cancel" | wofi --dmenu --prompt "WiFi is OFF" --width 250 --height 150)
    case "$action" in
        "󰖩 Enable WiFi")
            nmcli radio wifi on
            notify-send "Network Manager" "WiFi enabled" --icon=network-wireless
            sleep 1
            exec "$0"  # Restart script
            ;;
        "⚙️  Settings")
            foot nmtui
            ;;
    esac
    exit 0
fi

# WiFi is enabled - show quick connect menu
# NOTE: We use cached results for speed. User can manually rescan if needed.

# Build header with current connection
if [ -n "$current_ssid" ]; then
    header="✓ Connected: $current_ssid\n━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    header="Not connected\n━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# Get WiFi networks - sorted by signal strength (uses cached scan results for speed)
# Deduplicates networks - shows strongest signal when same SSID appears multiple times
wifi_networks=$(nmcli -t -f SSID,SECURITY,SIGNAL,BARS dev wifi list 2>/dev/null | \
    awk -F: '
    {
        ssid = $1
        security = $2
        signal = $3
        bars = $4
        
        # Skip empty/hidden SSIDs
        if (ssid == "" || ssid == "--") next
        
        # Store the strongest signal for each SSID (deduplication)
        if (!(ssid in max_signal) || signal+0 > max_signal[ssid]+0) {
            max_signal[ssid] = signal
            ssid_security[ssid] = security
            ssid_bars[ssid] = bars
        }
    }
    END {
        # Output deduplicated networks
        for (ssid in max_signal) {
            icon = "󰖩"
            lock = (ssid_security[ssid] != "" && ssid_security[ssid] != "--") ? " 🔒" : ""
            printf "%s %-32s %3s%% %s%s\n", icon, ssid, max_signal[ssid], ssid_bars[ssid], lock
        }
    }' | sort -t '%' -k1 -rn)

# Add management options
menu="$header
$wifi_networks
━━━━━━━━━━━━━━━━━━━━━━━━━
󰖪 Disable WiFi
⚙️  Advanced Settings
🔄 Rescan Networks"

# Dismiss all notifications before showing menu (works with mako)
makoctl dismiss --all 2>/dev/null

# Start background rescan for next time (non-blocking)
(sleep 0.5 && nmcli device wifi rescan 2>/dev/null) &

# Show menu
choice=$(echo -e "$menu" | wofi --dmenu --prompt "WiFi Networks" --width 420 --height 450)

# Handle selection
if [ -z "$choice" ]; then
    exit 0
fi

case "$choice" in
    *"Connected:"*|*"Not connected"*|"━"*)
        # Header lines - ignore
        exit 0
        ;;
        
    "󰖪 Disable WiFi")
        nmcli radio wifi off
        notify-send "Network Manager" "WiFi disabled" --icon=network-wireless-disabled
        ;;
        
    "⚙️  Advanced Settings")
        foot nmtui
        ;;
        
    "🔄 Rescan Networks")
        notify-send "Network Manager" "Scanning for networks..." --icon=network-wireless
        nmcli device wifi rescan
        sleep 2
        exec "$0"  # Restart script
        ;;
        
    "󰖩 "*)
        # Network selection - extract SSID
        ssid=$(echo "$choice" | sed 's/󰖩 \(.*\)  *[0-9]*% .*/\1/' | sed 's/ *$//')
        
        # Check if already connected
        if [ "$ssid" = "$current_ssid" ]; then
            action=$(echo -e "✓ Already connected\n🔌 Disconnect\n❌ Cancel" | wofi --dmenu --prompt "$ssid" --width 300 --height 150)
            if [ "$action" = "🔌 Disconnect" ]; then
                nmcli connection down "$ssid" 2>/dev/null
                notify-send "Network Manager" "Disconnected from $ssid" --icon=network-wireless-disconnected
            fi
            exit 0
        fi
        
        # Check if we have a saved connection
        if nmcli -t -f NAME connection show | grep -qF "$ssid"; then
            # Try to connect with saved credentials
            if nmcli connection up "$ssid" 2>/dev/null; then
                notify-send "Network Manager" "Connected to $ssid" --icon=network-wireless
                exit 0
            fi
        fi
        
        # Check if network needs password
        security=$(nmcli -f SSID,SECURITY dev wifi list | grep -F "$ssid" | awk '{for(i=2;i<=NF;i++) printf "%s ", $i; print ""}' | xargs)
        
        if [ "$security" = "--" ] || [ -z "$security" ]; then
            # Open network - no password needed
            if nmcli device wifi connect "$ssid" 2>/dev/null; then
                notify-send "Network Manager" "Connected to $ssid" --icon=network-wireless
            else
                notify-send "Network Manager" "Failed to connect to $ssid" --icon=network-error
            fi
        else
            # Secured network - prompt for password
            password=$(echo "" | wofi --dmenu --password --prompt "Password for: $ssid" --width 350)
            
            if [ -n "$password" ]; then
                if nmcli device wifi connect "$ssid" password "$password" 2>/dev/null; then
                    notify-send "Network Manager" "Connected to $ssid" --icon=network-wireless
                else
                    # Connection failed - offer troubleshooting
                    action=$(echo -e "❌ Connection Failed\n🔄 Try Again\n⚙️  Advanced Settings\n📋 Show Details" | \
                        wofi --dmenu --prompt "Failed: $ssid" --width 300 --height 180)
                    
                    case "$action" in
                        "🔄 Try Again")
                            exec "$0"
                            ;;
                        "⚙️  Advanced Settings")
                            foot nmtui
                            ;;
                        "📋 Show Details")
                            details=$(nmcli device wifi list | grep -F "$ssid")
                            notify-send "Network Details" "$details" --icon=network-wireless
                            ;;
                    esac
                fi
            fi
        fi
        ;;
esac

