#!/bin/bash

# Get battery information
battery_path="/sys/class/power_supply/BAT0"
if [ ! -d "$battery_path" ]; then
    battery_path="/sys/class/power_supply/BAT1"
fi

if [ ! -d "$battery_path" ]; then
    notify-send "Battery" "No battery detected"
    exit 1
fi

capacity=$(cat "$battery_path/capacity" 2>/dev/null || echo "N/A")
status=$(cat "$battery_path/status" 2>/dev/null || echo "Unknown")

# Format the status message
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

notify-send "Battery" "${message}" --icon=battery
