#!/bin/bash
# Display current auto-cpufreq power profile status for waybar

# Check if auto-cpufreq is installed
if ! command -v auto-cpufreq &>/dev/null; then
    battery_path="/sys/class/power_supply/BAT0"
    [ ! -d "$battery_path" ] && battery_path="/sys/class/power_supply/BAT1"
    
    if [ -d "$battery_path" ]; then
        capacity=$(cat "$battery_path/capacity" 2>/dev/null || echo "0")
        echo "{\"text\": \"󰂑 ${capacity}%\", \"tooltip\": \"auto-cpufreq not installed\", \"class\": \"missing\"}"
    else
        echo '{"text": "󰂑", "tooltip": "No battery or auto-cpufreq", "class": "missing"}'
    fi
    exit 0
fi

# Get battery status
battery_path="/sys/class/power_supply/BAT0"
[ ! -d "$battery_path" ] && battery_path="/sys/class/power_supply/BAT1"

if [ -d "$battery_path" ]; then
    capacity=$(cat "$battery_path/capacity" 2>/dev/null || echo "0")
    status=$(cat "$battery_path/status" 2>/dev/null || echo "Unknown")
else
    capacity="0"
    status="No Battery"
fi

# Get current profile from state file
if [ -f /tmp/auto-cpufreq-mode ]; then
    mode=$(cat /tmp/auto-cpufreq-mode 2>/dev/null || echo "auto")
else
    mode="auto"
fi

# Set labels and icons based on mode
case "$mode" in
    "auto") mode_label="Auto"; profile_icon="󱐌" ;;
    "power") mode_label="Power Saver"; profile_icon="󱈏" ;;
    "balanced") mode_label="Balanced"; profile_icon="󰾅" ;;
    "performance") mode_label="Performance"; profile_icon="󱐋" ;;
    *) mode_label="Auto"; profile_icon="󱐌"; mode="auto" ;;
esac

# Determine battery icon based on status and capacity
if [ "$status" = "Charging" ]; then
    battery_icon="󰂄"
    status_class="charging"
elif [ "$status" = "Full" ] || [ "$status" = "Not charging" ]; then
    battery_icon="󰚥"
    status_class="plugged"
else
    if [ "$capacity" -ge 90 ]; then battery_icon="󰁹"
    elif [ "$capacity" -ge 80 ]; then battery_icon="󰂂"
    elif [ "$capacity" -ge 70 ]; then battery_icon="󰂁"
    elif [ "$capacity" -ge 60 ]; then battery_icon="󰂀"
    elif [ "$capacity" -ge 50 ]; then battery_icon="󰁿"
    elif [ "$capacity" -ge 40 ]; then battery_icon="󰁾"
    elif [ "$capacity" -ge 30 ]; then battery_icon="󰁽"
    elif [ "$capacity" -ge 20 ]; then battery_icon="󰁼"
    elif [ "$capacity" -ge 10 ]; then battery_icon="󰁻"
    else battery_icon="󰁺"
    fi
    
    if [ "$capacity" -le 15 ]; then status_class="critical"
    elif [ "$capacity" -le 30 ]; then status_class="warning"
    else status_class="good"
    fi
fi

tooltip="Battery: ${capacity}%\\nStatus: ${status}\\nProfile: ${mode_label}\\n\\nClick to select profile"

# Output JSON for waybar
# In power saver mode, only show the profile icon for minimal visual clutter
if [ "$mode" = "power" ]; then
    echo "{\"text\": \"${profile_icon}\", \"tooltip\": \"${tooltip}\", \"class\": \"${mode} ${status_class}\"}"
else
    echo "{\"text\": \"${battery_icon} ${profile_icon}\", \"tooltip\": \"${tooltip}\", \"class\": \"${mode} ${status_class}\"}"
fi
