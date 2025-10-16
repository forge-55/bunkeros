#!/bin/bash

STATE_FILE="$HOME/.cache/night-mode-state"

if pgrep -x wlsunset > /dev/null; then
    pkill wlsunset
    echo "off" > "$STATE_FILE"
    notify-send -a "Night Mode" "Night mode disabled"
else
    wlsunset -T 4500 -t 3400 &
    echo "on" > "$STATE_FILE"
    notify-send -a "Night Mode" "Night mode enabled"
fi

