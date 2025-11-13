#!/bin/bash
# BunkerOS swayidle launcher with battery-aware timeouts
# Automatically suspends and locks the screen after idle timeout

# Kill any existing swayidle instance
killall swayidle 2>/dev/null
sleep 0.3

# Check if we're on battery or AC power
# Different timeouts for different power states (best practice)
on_battery() {
    # Check if we have a battery
    if [ ! -d /sys/class/power_supply/BAT* ] 2>/dev/null; then
        return 1  # No battery (desktop)
    fi
    
    # Check power supply status
    for battery in /sys/class/power_supply/BAT*; do
        if [ -f "$battery/status" ]; then
            status=$(cat "$battery/status")
            if [ "$status" = "Discharging" ]; then
                return 0  # On battery
            fi
        fi
    done
    return 1  # Plugged in or unknown
}

# Set timeouts based on power state
if on_battery; then
    # On battery: Shorter timeout to save power
    LOCK_TIMEOUT=180   # 3 minutes
    SUSPEND_TIMEOUT=185  # 5 seconds after lock
else
    # Plugged in: Longer timeout for convenience
    LOCK_TIMEOUT=300   # 5 minutes
    SUSPEND_TIMEOUT=305  # 5 seconds after lock
fi

# Start swayidle with the configured timeouts
# This handles:
# 1. Automatic lock after idle timeout
# 2. Automatic suspend shortly after lock
# 3. Lock before any system sleep (lid close, manual suspend, etc.)
exec swayidle -w \
    timeout $LOCK_TIMEOUT "$HOME/.local/bin/bunkeros-lock" \
    timeout $SUSPEND_TIMEOUT 'systemctl suspend' \
    before-sleep "$HOME/.local/bin/bunkeros-lock"
