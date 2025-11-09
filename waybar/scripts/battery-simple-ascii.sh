#!/bin/bash
# Temporary dual battery script with ASCII characters (no font dependencies)

# Get battery information directly
bat0_capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "0")
bat1_capacity=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || echo "0")
bat0_energy_now=$(cat /sys/class/power_supply/BAT0/energy_now 2>/dev/null || echo "0")
bat0_energy_full=$(cat /sys/class/power_supply/BAT0/energy_full 2>/dev/null || echo "1")
bat1_energy_now=$(cat /sys/class/power_supply/BAT1/energy_now 2>/dev/null || echo "0")
bat1_energy_full=$(cat /sys/class/power_supply/BAT1/energy_full 2>/dev/null || echo "1")

# Calculate combined battery
total_energy_now=$((bat0_energy_now + bat1_energy_now))
total_energy_full=$((bat0_energy_full + bat1_energy_full))
combined_capacity=$((total_energy_now * 100 / total_energy_full))

# Get status
bat1_status=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null || echo "Unknown")

# Determine icon (ASCII-based)
if [ "$combined_capacity" -ge 90 ]; then battery_icon="[████]"
elif [ "$combined_capacity" -ge 75 ]; then battery_icon="[███▒]"
elif [ "$combined_capacity" -ge 60 ]; then battery_icon="[██▒▒]"
elif [ "$combined_capacity" -ge 45 ]; then battery_icon="[█▒▒▒]"
elif [ "$combined_capacity" -ge 30 ]; then battery_icon="[█▒▒▒]"
elif [ "$combined_capacity" -ge 15 ]; then battery_icon="[▒▒▒▒]"
else battery_icon="[░░░░]"
fi

# Handle charging
if [ "$bat1_status" = "Charging" ]; then
    battery_icon="[+CHG]"
fi

# Output for waybar
echo "{\"text\": \"${battery_icon} [A]\", \"tooltip\": \"Combined: ${combined_capacity}% (Int:${bat0_capacity}% Ext:${bat1_capacity}%)\", \"class\": \"dual-battery\"}"