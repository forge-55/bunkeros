#!/bin/bash

# Get battery information using dual-battery-aware helper
script_dir="$(dirname "$0")"
battery_info=$("$script_dir/dual-battery-helper.sh")

if [ $? -ne 0 ]; then
    notify-send "Battery" "No battery detected"
    exit 1
fi

# Parse the battery info (format: capacity|status|type|bat0_cap|bat1_cap)
IFS='|' read -r capacity status battery_type bat0_cap bat1_cap <<< "$battery_info"

# Format the status message
if [ "$battery_type" != "single" ] && [ "$bat1_cap" != "0" ]; then
    # Dual battery system (like T480 PowerBridge)
    case "$status" in
        "Charging")
            icon="󰂄"
            message="Charging: ${capacity}% (Internal: ${bat0_cap}%, External: ${bat1_cap}%)"
            ;;
        "Discharging")
            icon="󰁹"
            message="Discharging: ${capacity}% (Internal: ${bat0_cap}%, External: ${bat1_cap}%)"
            ;;
        "Full")
            icon="󰁹"
            message="Fully charged: ${capacity}% (Internal: ${bat0_cap}%, External: ${bat1_cap}%)"
            ;;
        "Not charging")
            icon="󰚥"
            message="Plugged in: ${capacity}% (Internal: ${bat0_cap}%, External: ${bat1_cap}%)"
            ;;
        *)
            icon="󰂑"
            message="Status: ${status} - ${capacity}% (Internal: ${bat0_cap}%, External: ${bat1_cap}%)"
            ;;
    esac
else
    # Single battery system
    case "$status" in
        "Charging")
            icon="󰂄"
            message="Charging: ${capacity}%"
            ;;
        "Discharging")
            icon="󰁹"
            message="Discharging: ${capacity}%"
            ;;
        "Full")
            icon="󰁹"
            message="Fully charged: ${capacity}%"
            ;;
        "Not charging")
            icon="󰚥"
            message="Plugged in: ${capacity}%"
            ;;
        *)
            icon="󰂑"
            message="Status: ${status} - ${capacity}%"
            ;;
    esac
fi

notify-send "Battery" "${message}" --icon=battery
