#!/bin/bash
# Toggle auto-cpufreq power profiles
# Cycles through: auto -> power -> balanced -> performance -> auto

# Check if auto-cpufreq is installed
if ! command -v auto-cpufreq &>/dev/null; then
    notify-send "Power Profile" "auto-cpufreq is not installed" --icon=battery-missing
    exit 1
fi

# Get current profile from state file
if [ -f /tmp/auto-cpufreq-mode ]; then
    current_mode=$(cat /tmp/auto-cpufreq-mode 2>/dev/null || echo "auto")
else
    current_mode="auto"
fi

# Determine next mode in cycle
case "$current_mode" in
    "auto")
        next_mode="power"
        label="Power Saver"
        ;;
    "power")
        next_mode="balanced"
        label="Balanced"
        ;;
    "balanced")
        next_mode="performance"
        label="Performance"
        ;;
    "performance")
        next_mode="auto"
        label="Auto"
        ;;
    *)
        next_mode="auto"
        label="Auto"
        ;;
esac

# Apply the profile change
if sudo auto-cpufreq --force "$next_mode" &>/dev/null; then
    # Update state file
    echo "$next_mode" > /tmp/auto-cpufreq-mode
    
    # Notify user
    notify-send "Power Profile" "Switched to: $label" --icon=battery-profile-power
    
    # Signal waybar to update (signal 8)
    sleep 0.2
    killall -SIGUSR2 waybar 2>/dev/null || true
else
    notify-send "Power Profile" "Failed to switch mode" --icon=dialog-error --urgency=critical
    exit 1
fi
