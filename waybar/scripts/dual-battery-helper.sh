#!/bin/bash
# Dual Battery Helper for ThinkPad PowerBridge systems (T480, etc.)
# Calculates combined battery status for internal + external battery configurations

# Function to calculate combined battery status
get_dual_battery_info() {
    local bat0_path="/sys/class/power_supply/BAT0"
    local bat1_path="/sys/class/power_supply/BAT1"
    
    # Check if both batteries exist
    if [[ ! -d "$bat0_path" || ! -d "$bat1_path" ]]; then
        return 1  # Not a dual battery system
    fi
    
    # Get battery information
    local bat0_capacity=$(cat "$bat0_path/capacity" 2>/dev/null || echo "0")
    local bat0_status=$(cat "$bat0_path/status" 2>/dev/null || echo "Unknown")
    local bat0_energy_now=$(cat "$bat0_path/energy_now" 2>/dev/null || echo "0")
    local bat0_energy_full=$(cat "$bat0_path/energy_full" 2>/dev/null || echo "1")
    
    local bat1_capacity=$(cat "$bat1_path/capacity" 2>/dev/null || echo "0")
    local bat1_status=$(cat "$bat1_path/status" 2>/dev/null || echo "Unknown")
    local bat1_energy_now=$(cat "$bat1_path/energy_now" 2>/dev/null || echo "0")
    local bat1_energy_full=$(cat "$bat1_path/energy_full" 2>/dev/null || echo "1")
    
    # Calculate combined capacity based on energy levels
    local total_energy_now=$((bat0_energy_now + bat1_energy_now))
    local total_energy_full=$((bat0_energy_full + bat1_energy_full))
    local combined_capacity=$((total_energy_now * 100 / total_energy_full))
    
    # Determine overall status based on PowerBridge logic
    local combined_status="Discharging"
    
    # If either battery is charging, system is charging
    if [[ "$bat0_status" == "Charging" || "$bat1_status" == "Charging" ]]; then
        combined_status="Charging"
    # If both are full, system is full
    elif [[ "$bat0_status" == "Full" && "$bat1_status" == "Full" ]]; then
        combined_status="Full"
    # If plugged in but not charging (typically when at high capacity)
    elif [[ "$bat0_status" == "Not charging" || "$bat1_status" == "Not charging" ]]; then
        # Check if we're actually at high capacity
        if [[ $combined_capacity -ge 95 ]]; then
            combined_status="Full"
        else
            combined_status="Not charging"
        fi
    fi
    
    # Determine which battery is active (PowerBridge drains external first, then internal)
    local active_battery="BAT1"  # External battery is usually primary
    local active_capacity=$bat1_capacity
    
    # If external battery is very low and internal has more charge, switch focus
    if [[ $bat1_capacity -lt 10 && $bat0_capacity -gt $bat1_capacity ]]; then
        active_battery="BAT0"
        active_capacity=$bat0_capacity
    fi
    
    # Output the results (format: combined_capacity|combined_status|active_battery|bat0_capacity|bat1_capacity)
    echo "${combined_capacity}|${combined_status}|${active_battery}|${bat0_capacity}|${bat1_capacity}"
    return 0
}

# Function to get single battery info (fallback for non-dual systems)
get_single_battery_info() {
    local battery_path="/sys/class/power_supply/BAT0"
    [[ ! -d "$battery_path" ]] && battery_path="/sys/class/power_supply/BAT1"
    
    if [[ ! -d "$battery_path" ]]; then
        return 1  # No battery found
    fi
    
    local capacity=$(cat "$battery_path/capacity" 2>/dev/null || echo "0")
    local status=$(cat "$battery_path/status" 2>/dev/null || echo "Unknown")
    
    # Output format: capacity|status|single|capacity|0 (to match dual battery format)
    echo "${capacity}|${status}|single|${capacity}|0"
    return 0
}

# Main function to determine battery type and get appropriate info
get_battery_info() {
    # Try dual battery first
    if get_dual_battery_info; then
        return 0
    fi
    
    # Fall back to single battery
    if get_single_battery_info; then
        return 0
    fi
    
    # No battery detected
    echo "100|AC Power|desktop|100|0"
    return 1
}

# If script is called directly, output battery info
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    get_battery_info
fi