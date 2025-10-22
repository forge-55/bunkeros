#!/bin/bash
# BunkerOS Autotiling Toggle
# Allows users to enable/disable autotiling-rs on demand

if pgrep -x autotiling-rs > /dev/null; then
    # Autotiling is running, disable it
    killall autotiling-rs
    notify-send "BunkerOS" "Autotiling disabled\nManual tiling enabled" -u normal
else
    # Autotiling is not running, enable it
    autotiling-rs &
    notify-send "BunkerOS" "Autotiling enabled\nAutomatic split direction" -u normal
fi
