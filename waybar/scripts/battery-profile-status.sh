#!/bin/bash#!/bin/bash

# Display current auto-cpufreq power profile status for waybar# Display current auto-cpufreq power profile status for waybar



# Check if auto-cpufreq is installed# Check if auto-cpufreq is installed

if ! command -v auto-cpufreq &>/dev/null; thenif ! command -v auto-cpufreq &>/dev/null; then

    # Still show battery even if auto-cpufreq not installed    # Still show battery even if auto-cpufreq not installed

    battery_path="/sys/class/power_supply/BAT0"    battery_path="/sys/class/power_supply/BAT0"

    [ ! -d "$battery_path" ] && battery_path="/sys/class/power_supply/BAT1"    [ ! -d "$battery_path" ] && battery_path="/sys/class/power_supply/BAT1"

        

    if [ -d "$battery_path" ]; then    if [ -d "$battery_path" ]; then

        capacity=$(cat "$battery_path/capacity" 2>/dev/null || echo "0")        capacity=$(cat "$battery_path/capacity" 2>/dev/null || echo "0")

        echo "{\"text\": \"󰂑 ${capacity}%\", \"tooltip\": \"auto-cpufreq not installed\", \"class\": \"missing\"}"        echo "{\"text\": \"󰂑 ${capacity}%\", \"tooltip\": \"auto-cpufreq not installed\", \"class\": \"missing\"}"

    else    else

        echo '{"text": "󰂑", "tooltip": "No battery or auto-cpufreq", "class": "missing"}'        echo '{"text": "󰂑", "tooltip": "No battery or auto-cpufreq", "class": "missing"}'

    fi    fi

    exit 0    exit 0

fifi



# Get battery status# Get battery status

battery_path="/sys/class/power_supply/BAT0"battery_path="/sys/class/power_supply/BAT0"

if [ ! -d "$battery_path" ]; thenif [ ! -d "$battery_path" ]; then

    battery_path="/sys/class/power_supply/BAT1"    battery_path="/sys/class/power_supply/BAT1"

fifi



# Get battery info# Get battery info

if [ -d "$battery_path" ]; thenif [ -d "$battery_path" ]; then

    capacity=$(cat "$battery_path/capacity" 2>/dev/null || echo "0")    capacity=$(cat "$battery_path/capacity" 2>/dev/null || echo "0")

    status=$(cat "$battery_path/status" 2>/dev/null || echo "Unknown")    status=$(cat "$battery_path/status" 2>/dev/null || echo "Unknown")

elseelse

    capacity="0"    capacity="0"

    status="No Battery"    status="No Battery"

fifi



# Get current profile - read from state file (fast) instead of running --stats (slow)# Get current profile - read from state file (fast) instead of running --stats (slow)

if [ -f /tmp/auto-cpufreq-mode ]; thenif [ -f /tmp/auto-cpufreq-mode ]; then

    mode=$(cat /tmp/auto-cpufreq-mode 2>/dev/null || echo "auto")    mode=$(cat /tmp/auto-cpufreq-mode 2>/dev/null || echo "auto")

elseelse

    mode="auto"    mode="auto"

fifi



# Set labels and icons based on mode# Set labels and icons based on mode

case "$mode" incase "$mode" in

    "auto")    "auto")

        mode_label="Auto"        mode_label="Auto"

        profile_icon="󱐌"        profile_icon="󱐌"

        ;;        ;;

    "power")    "power")

        mode_label="Power Saver"        mode_label="Power Saver"

        profile_icon="󱈏"        profile_icon="󱈏"

        ;;        ;;

    "balanced")    "balanced")

        mode_label="Balanced"        mode_label="Balanced"

        profile_icon="󰾅"        profile_icon="󰾅"

        ;;        ;;

    "performance")    "performance")

        mode_label="Performance"        mode_label="Performance"

        profile_icon="󱐋"        profile_icon="󱐋"

        ;;        ;;

    *)    *)

        mode_label="Auto"        mode_label="Auto"

        profile_icon="󱐌"        profile_icon="󱐌"

        mode="auto"        mode="auto"

        ;;        ;;

esacesac



# Determine battery icon based on status and capacity# Determine battery icon based on status and capacity

if [ "$status" = "Charging" ]; thenif [ "$status" = "Charging" ]; then

    battery_icon="󰂄"    battery_icon="󰂄"

    status_class="charging"    status_class="charging"

elif [ "$status" = "Full" ] || [ "$status" = "Not charging" ]; thenelif [ "$status" = "Full" ] || [ "$status" = "Not charging" ]; then

    battery_icon="󰚥"    battery_icon="󰚥"

    status_class="plugged"    status_class="plugged"

elseelse

    # Discharging - select icon based on capacity    # Discharging - select icon based on capacity

    if [ "$capacity" -ge 90 ]; then    if [ "$capacity" -ge 90 ]; then

        battery_icon="󰁹"        battery_icon="󰁹"

    elif [ "$capacity" -ge 80 ]; then    elif [ "$capacity" -ge 80 ]; then

        battery_icon="󰂂"        battery_icon="󰂂"

    elif [ "$capacity" -ge 70 ]; then    elif [ "$capacity" -ge 70 ]; then

        battery_icon="󰂁"        battery_icon="󰂁"

    elif [ "$capacity" -ge 60 ]; then    elif [ "$capacity" -ge 60 ]; then

        battery_icon="󰂀"        battery_icon="󰂀"

    elif [ "$capacity" -ge 50 ]; then    elif [ "$capacity" -ge 50 ]; then

        battery_icon="󰁿"        battery_icon="󰁿"

    elif [ "$capacity" -ge 40 ]; then    elif [ "$capacity" -ge 40 ]; then

        battery_icon="󰁾"        battery_icon="󰁾"

    elif [ "$capacity" -ge 30 ]; then    elif [ "$capacity" -ge 30 ]; then

        battery_icon="󰁽"        battery_icon="󰁽"

    elif [ "$capacity" -ge 20 ]; then    elif [ "$capacity" -ge 20 ]; then

        battery_icon="󰁼"        battery_icon="󰁼"

    elif [ "$capacity" -ge 10 ]; then    elif [ "$capacity" -ge 10 ]; then

        battery_icon="󰁻"        battery_icon="󰁻"

    else    else

        battery_icon="󰁺"        battery_icon="󰁺"

    fi    fi

        

    if [ "$capacity" -le 15 ]; then    if [ "$capacity" -le 15 ]; then

        status_class="critical"        status_class="critical"

    elif [ "$capacity" -le 30 ]; then    elif [ "$capacity" -le 30 ]; then

        status_class="warning"        status_class="warning"

    else    else

        status_class="good"        status_class="good"

    fi    fi

fifi



# Build tooltip# Build tooltip

tooltip="Battery: ${capacity}%\\nStatus: ${status}\\nProfile: ${mode_label}\\n\\nClick to select profile"tooltip="Battery: ${capacity}%\\nStatus: ${status}\\nProfile: ${mode_label}\\n\\nClick to select profile"



# Output JSON for waybar# Output JSON for waybar

# For power saver mode, show only the profile icon to avoid duplicate battery icons# For power saver mode, show only the profile icon to avoid duplicate battery icons

if [ "$mode" = "power" ]; thenif [ "$mode" = "power" ]; then

    echo "{\"text\": \"${profile_icon}\", \"tooltip\": \"${tooltip}\", \"class\": \"${mode} ${status_class}\"}"    echo "{\"text\": \"${profile_icon}\", \"tooltip\": \"${tooltip}\", \"class\": \"${mode} ${status_class}\"}"

elseelse

    echo "{\"text\": \"${battery_icon} ${profile_icon}\", \"tooltip\": \"${tooltip}\", \"class\": \"${mode} ${status_class}\"}"    echo "{\"text\": \"${battery_icon} ${profile_icon}\", \"tooltip\": \"${tooltip}\", \"class\": \"${mode} ${status_class}\"}"

fifi

