#!/bin/bash#!/bin/bash

# Power profile selection menu using wofi# Power profile selection menu using wofi



# If wofi is already running, close it instead of opening a new menu# If wofi is already running, close it instead of opening a new menu

if pgrep -x wofi > /dev/null 2>&1; thenif pgrep -x wofi > /dev/null 2>&1; then

    pkill -x wofi    pkill -x wofi

    exit 0    exit 0

fifi



# Check if auto-cpufreq is installed# Check if auto-cpufreq is installed

if ! command -v auto-cpufreq &>/dev/null; thenif ! command -v auto-cpufreq &>/dev/null; then

    notify-send "Power Profile" "auto-cpufreq is not installed" --icon=battery-missing    notify-send "Power Profile" "auto-cpufreq is not installed" --icon=battery-missing

    exit 1    exit 1

fifi



# Get current profile from state file (fast)# Get current profile from state file (fast)

if [ -f /tmp/auto-cpufreq-mode ]; thenif [ -f /tmp/auto-cpufreq-mode ]; then

    current_mode=$(cat /tmp/auto-cpufreq-mode 2>/dev/null || echo "auto")    current_mode=$(cat /tmp/auto-cpufreq-mode 2>/dev/null || echo "auto")

elseelse

    current_mode="auto"    current_mode="auto"

fifi



# Create menu options with current selection marked# Create menu options with current selection marked

options=""options=""

if [ "$current_mode" = "auto" ]; thenif [ "$current_mode" = "auto" ]; then

    options+="󱐌  Auto (Current)\n"    options+="󱐌  Auto (Current)\n"

elseelse

    options+="󱐌  Auto\n"    options+="󱐌  Auto\n"

fifi



if [ "$current_mode" = "power" ]; thenif [ "$current_mode" = "power" ]; then

    options+="󱈏  Power Saver (Current)\n"    options+="󱈏  Power Saver (Current)\n"

elseelse

    options+="󱈏  Power Saver\n"    options+="󱈏  Power Saver\n"

fifi



if [ "$current_mode" = "balanced" ]; thenif [ "$current_mode" = "balanced" ]; then

    options+="󰾅  Balanced (Current)\n"    options+="󰾅  Balanced (Current)\n"

elseelse

    options+="󰾅  Balanced\n"    options+="󰾅  Balanced\n"

fifi



if [ "$current_mode" = "performance" ]; thenif [ "$current_mode" = "performance" ]; then

    options+="󱐋  Performance (Current)"    options+="󱐋  Performance (Current)"

elseelse

    options+="󱐋  Performance"    options+="󱐋  Performance"

fifi



# Show menu positioned under waybar battery icon (top right area)# Show menu positioned under waybar battery icon (top right area)

selected=$(echo -e "$options" | wofi --dmenu \selected=$(echo -e "$options" | wofi --dmenu \

    --prompt "Power Profile" \    --prompt "Power Profile" \

    --width 250 \    --width 250 \

    --lines 4 \    --lines 4 \

    --location top_right \    --location top_right \

    --xoffset -10 \    --xoffset -10 \

    --yoffset 40 \    --yoffset 40 \

    --cache-file=/dev/null)    --cache-file=/dev/null)



# Exit if nothing selected (menu closes automatically)# Exit if nothing selected (menu closes automatically)

if [ -z "$selected" ]; thenif [ -z "$selected" ]; then

    exit 0    exit 0

fifi



# Parse selection and apply# Parse selection and apply

if echo "$selected" | grep -q "Auto"; thenif echo "$selected" | grep -q "Auto"; then

    mode="auto"    mode="auto"

    label="Auto"    label="Auto"

elif echo "$selected" | grep -q "Power Saver"; thenelif echo "$selected" | grep -q "Power Saver"; then

    mode="power"    mode="power"

    label="Power Saver"    label="Power Saver"

elif echo "$selected" | grep -q "Balanced"; thenelif echo "$selected" | grep -q "Balanced"; then

    mode="balanced"    mode="balanced"

    label="Balanced"    label="Balanced"

elif echo "$selected" | grep -q "Performance"; thenelif echo "$selected" | grep -q "Performance"; then

    mode="performance"    mode="performance"

    label="Performance"    label="Performance"

elseelse

    exit 0    exit 0

fifi



# Don't switch if already on this mode# Don't switch if already on this mode

if [ "$mode" = "$current_mode" ]; thenif [ "$mode" = "$current_mode" ]; then

    notify-send "Power Profile" "Already using: $label" --icon=battery-profile-power    notify-send "Power Profile" "Already using: $label" --icon=battery-profile-power

    exit 0    exit 0

fifi



# Apply the new mode# Apply the new mode

if sudo auto-cpufreq --force "$mode" &>/dev/null; thenif sudo auto-cpufreq --force "$mode" &>/dev/null; then

    # Save the mode to a state file for quick status checks    # Save the mode to a state file for quick status checks

    echo "$mode" > /tmp/auto-cpufreq-mode    echo "$mode" > /tmp/auto-cpufreq-mode

        

    notify-send "Power Profile" "Switched to: $label" --icon=battery-profile-power    notify-send "Power Profile" "Switched to: $label" --icon=battery-profile-power

        

    # Force immediate waybar refresh by restarting it    # Force immediate waybar refresh by restarting it

    sleep 0.2    sleep 0.2

    killall -SIGUSR2 waybar 2>/dev/null || true    killall -SIGUSR2 waybar 2>/dev/null || true

elseelse

    notify-send "Power Profile" "Failed to switch mode" --icon=dialog-error --urgency=critical    notify-send "Power Profile" "Failed to switch mode" --icon=dialog-error --urgency=critical

    exit 1    exit 1

fifi

