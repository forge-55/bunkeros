#!/bin/bash
# Power profile selection menu using wofi

if pgrep -x wofi > /dev/null 2>&1; then
    pkill -x wofi
    exit 0
fi

if ! command -v auto-cpufreq &>/dev/null; then
    notify-send "Power Profile" "auto-cpufreq is not installed" --icon=battery-missing
    exit 1
fi

if [ -f /tmp/auto-cpufreq-mode ]; then
    current_mode=$(cat /tmp/auto-cpufreq-mode 2>/dev/null || echo "auto")
else
    current_mode="auto"
fi

options=""
[ "$current_mode" = "auto" ] && options+="󱐌  Auto (Current)\n" || options+="󱐌  Auto\n"
[ "$current_mode" = "power" ] && options+="󱈏  Power Saver (Current)\n" || options+="󱈏  Power Saver\n"
[ "$current_mode" = "balanced" ] && options+="󰾅  Balanced (Current)\n" || options+="󰾅  Balanced\n"
[ "$current_mode" = "performance" ] && options+="󱐋  Performance (Current)" || options+="󱐋  Performance"

selected=$(echo -e "$options" | wofi --dmenu \
    --prompt "Power Profile" \
    --width 250 \
    --lines 4 \
    --location top_right \
    --xoffset -10 \
    --yoffset 40 \
    --cache-file=/dev/null)

[ -z "$selected" ] && exit 0

if echo "$selected" | grep -q "Auto"; then
    mode="auto"; label="Auto"; cmd_mode="reset"
elif echo "$selected" | grep -q "Power Saver"; then
    mode="power"; label="Power Saver"; cmd_mode="powersave"
elif echo "$selected" | grep -q "Balanced"; then
    mode="balanced"; label="Balanced"; cmd_mode="powersave"
elif echo "$selected" | grep -q "Performance"; then
    mode="performance"; label="Performance"; cmd_mode="performance"
else
    exit 0
fi

if [ "$mode" = "$current_mode" ]; then
    notify-send "Power Profile" "Already using: $label" --icon=battery-profile-power
    exit 0
fi

if sudo auto-cpufreq --force="$cmd_mode" &>/dev/null; then
    echo "$mode" > /tmp/auto-cpufreq-mode
    notify-send "Power Profile" "Switched to: $label" --icon=battery-profile-power
    sleep 0.2
    pkill -RTMIN+8 waybar 2>/dev/null || true
else
    notify-send "Power Profile" "Failed to switch mode" --icon=dialog-error --urgency=critical
    exit 1
fi
