#!/bin/bash#!/bin/bash

# Toggle auto-cpufreq power profiles# Toggle auto-cpufreq power profiles

# Cycles through: auto -> power -> balanced -> performance -> auto# Cycles through: auto -> power -> balanced -> performance -> auto



# Check if auto-cpufreq is installed# Check if auto-cpufreq is installed

if ! command -v auto-cpufreq &>/dev/null; thenif ! command -v auto-cpufreq &>/dev/null; then

    notify-send "Power Profile" "auto-cpufreq is not installed" --icon=battery-missing    notify-send "Power Profile" "auto-cpufreq is not installed" --icon=battery-missing

    exit 1    exit 1

fifi



# Get current profile from auto-cpufreq stats# Get current profile from auto-cpufreq stats

# The stats output shows which governor/mode is active# The stats output shows which governor/mode is active

current_stats=$(sudo auto-cpufreq --stats 2>/dev/null)# Use -n flag to prevent password prompts and timeout

current_stats=$(timeout 2s sudo -n auto-cpufreq --stats 2>/dev/null)

# Determine current mode by checking the stats output

if echo "$current_stats" | grep -q "mode: default"; then# Determine current mode by checking the stats output

    current_mode="auto"if echo "$current_stats" | grep -q "mode: default"; then

elif echo "$current_stats" | grep -q "mode: powersave"; then    current_mode="auto"

    current_mode="power"elif echo "$current_stats" | grep -q "mode: powersave"; then

elif echo "$current_stats" | grep -q "mode: balanced"; then    current_mode="power"

    current_mode="balanced"elif echo "$current_stats" | grep -q "mode: balanced"; then

elif echo "$current_stats" | grep -q "mode: performance"; then    current_mode="balanced"

    current_mode="performance"elif echo "$current_stats" | grep -q "mode: performance"; then

else    current_mode="performance"

    # Default to auto if we can't determineelse

    current_mode="auto"    # Default to auto if we can't determine

fi    current_mode="auto"

fi

# Determine next mode in the cycle

case "$current_mode" in# Determine next mode in the cycle

    "auto")case "$current_mode" in

        next_mode="power"    "auto")

        next_label="Power Saver"        next_mode="power"

        next_icon="󱈏"        next_label="Power Saver"

        ;;        next_icon="󱈏"

    "power")        ;;

        next_mode="balanced"    "power")

        next_label="Balanced"        next_mode="balanced"

        next_icon="󰾅"        next_label="Balanced"

        ;;        next_icon="󰾅"

    "balanced")        ;;

        next_mode="performance"    "balanced")

        next_label="Performance"        next_mode="performance"

        next_icon="󱐋"        next_label="Performance"

        ;;        next_icon="󱐋"

    "performance")        ;;

        next_mode="auto"    "performance")

        next_label="Auto"        next_mode="auto"

        next_icon="󱐌"        next_label="Auto"

        ;;        next_icon="󱐌"

    *)        ;;

        next_mode="auto"    *)

        next_label="Auto"        next_mode="auto"

        next_icon="󱐌"        next_label="Auto"

        ;;        next_icon="󱐌"

esac        ;;

esac

# Apply the new mode

if sudo auto-cpufreq --force "$next_mode" &>/dev/null; then# Apply the new mode

    notify-send "Power Profile" "Switched to: $next_label" --icon=battery-profile-powerif timeout 5s sudo -n auto-cpufreq --force "$next_mode" &>/dev/null; then

        notify-send "Power Profile" "Switched to: $next_label" --icon=battery-profile-power

    # Trigger waybar refresh if using custom battery module    

    pkill -RTMIN+8 waybar 2>/dev/null || true    # Trigger waybar refresh if using custom battery module

else    pkill -RTMIN+8 waybar 2>/dev/null || true

    notify-send "Power Profile" "Failed to switch mode" --icon=dialog-error --urgency=criticalelse

    exit 1    # Check if it's a permission issue

fi    if ! sudo -n true 2>/dev/null; then

        notify-send "Power Profile" "Permission denied - install polkit rule first\nRun: sudo cp systemd/polkit-rules/50-auto-cpufreq.rules /etc/polkit-1/rules.d/" --icon=dialog-error --urgency=critical
    else
        notify-send "Power Profile" "Failed to switch mode" --icon=dialog-error --urgency=critical
    fi
    exit 1
fi
