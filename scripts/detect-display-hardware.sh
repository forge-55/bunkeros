#!/usr/bin/env bash

# BunkerOS Display Hardware Detection Script
# Detects display characteristics and recommends scaling settings
# Similar to Pop_OS!/COSMIC adaptive scaling approach

set -e

# Output formatting
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m' # No Color

INFO="ℹ️ "
SUCCESS="✅"
WARN="⚠️ "
ERROR="❌"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║           BunkerOS Display Hardware Detection              ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Function to calculate DPI (using awk instead of bc for better compatibility)
calculate_dpi() {
    local width_px=$1
    local height_px=$2
    local width_mm=$3
    local height_mm=$4
    
    if [ "$width_mm" = "0" ] || [ "$height_mm" = "0" ] || [ -z "$width_mm" ] || [ -z "$height_mm" ]; then
        echo "96"  # Fallback DPI
        return
    fi
    
    # Convert mm to inches and calculate DPI using awk
    local dpi=$(awk "BEGIN { printf \"%.0f\", $width_px / ($width_mm / 25.4) }")
    echo "$dpi"
}

# Function to determine device type based on resolution and physical size
detect_device_type() {
    local width_px=$1
    local height_px=$2
    local width_mm=$3
    local height_mm=$4
    local dpi=$5
    
    # Calculate diagonal in inches using awk
    if [ "$width_mm" != "0" ] && [ "$height_mm" != "0" ] && [ -n "$width_mm" ] && [ -n "$height_mm" ]; then
        local diagonal_inches=$(awk "BEGIN { printf \"%.1f\", sqrt($width_mm^2 + $height_mm^2) / 25.4 }")
    else
        # Estimate based on resolution for unknown physical dimensions
        if [ "$width_px" -ge 3440 ]; then
            diagonal_inches="30.0"  # Estimate for ultrawide
        elif [ "$width_px" -ge 2560 ]; then
            diagonal_inches="24.0"  # Estimate for standard monitor
        elif [ "$width_px" -le 1920 ] && [ "$height_px" -le 1200 ]; then
            diagonal_inches="15.0"  # Estimate for laptop
        else
            diagonal_inches="24.0"  # Default monitor estimate
        fi
    fi
    
    # Determine device type using awk for comparisons
    local is_small=$(awk "BEGIN { print ($diagonal_inches < 14) ? 1 : 0 }")
    local is_medium=$(awk "BEGIN { print ($diagonal_inches >= 14 && $diagonal_inches < 17) ? 1 : 0 }")
    local is_large=$(awk "BEGIN { print ($diagonal_inches >= 21) ? 1 : 0 }")
    local is_high_dpi_small=$(awk "BEGIN { print ($dpi > 150) ? 1 : 0 }")
    local is_high_dpi_medium=$(awk "BEGIN { print ($dpi > 120) ? 1 : 0 }")
    
    if [ "$is_small" = "1" ]; then
        if [ "$is_high_dpi_small" = "1" ]; then
            echo "high-dpi-laptop"
        else
            echo "standard-laptop"
        fi
    elif [ "$is_medium" = "1" ]; then
        if [ "$is_high_dpi_medium" = "1" ]; then
            echo "high-dpi-laptop"
        else
            echo "standard-laptop"
        fi
    elif [ "$is_large" = "1" ]; then
        if [ "$is_high_dpi_medium" = "1" ]; then
            echo "high-dpi-monitor"
        elif [ "$width_px" -ge 3440 ]; then
            echo "ultrawide-monitor"
        else
            echo "standard-monitor"
        fi
    else
        if [ "$width_px" -ge 3440 ]; then
            echo "ultrawide-monitor"
        else
            echo "standard-monitor"
        fi
    fi
}

# Function to get optimal scaling configuration
get_scaling_config() {
    local device_type=$1
    local dpi=$2
    local width_px=$3
    
    case "$device_type" in
        "high-dpi-laptop")
            # High DPI laptops (like modern MacBooks, XPS 13, ThinkPad X1)
            local very_high_dpi_laptop=$(awk "BEGIN { print ($dpi > 200) ? 1 : 0 }")
            if [ "$very_high_dpi_laptop" = "1" ]; then
                echo "scale=2.0 font_size=10 waybar_font=16 wofi_font=16 foot_font=10"
            else
                echo "scale=1.5 font_size=9 waybar_font=14 wofi_font=15 foot_font=9"
            fi
            ;;
        "standard-laptop")
            # Standard laptops (ThinkPad T480, older laptops)
            local low_dpi=$(awk "BEGIN { print ($dpi < 100) ? 1 : 0 }")
            if [ "$low_dpi" = "1" ]; then
                echo "scale=1.0 font_size=11 waybar_font=15 wofi_font=16 foot_font=11"
            else
                echo "scale=1.0 font_size=10 waybar_font=14 wofi_font=15 foot_font=10"
            fi
            ;;
        "ultrawide-monitor")
            # Ultrawide monitors (3440x1440, 3840x1600, etc.)
            local high_dpi_ultrawide=$(awk "BEGIN { print ($dpi > 110) ? 1 : 0 }")
            if [ "$high_dpi_ultrawide" = "1" ]; then
                echo "scale=1.25 font_size=10 waybar_font=15 wofi_font=16 foot_font=10"
            else
                echo "scale=1.0 font_size=12 waybar_font=16 wofi_font=17 foot_font=12"
            fi
            ;;
        "high-dpi-monitor")
            # 4K monitors and high DPI external displays
            local very_high_dpi=$(awk "BEGIN { print ($dpi > 150) ? 1 : 0 }")
            if [ "$very_high_dpi" = "1" ]; then
                echo "scale=1.75 font_size=11 waybar_font=16 wofi_font=17 foot_font=11"
            else
                echo "scale=1.25 font_size=10 waybar_font=15 wofi_font=16 foot_font=10"
            fi
            ;;
        "standard-monitor")
            # Standard 1920x1080, 1680x1050, etc.
            echo "scale=1.0 font_size=10 waybar_font=14 wofi_font=15 foot_font=10"
            ;;
        *)
            # Fallback
            echo "scale=1.0 font_size=10 waybar_font=14 wofi_font=15 foot_font=10"
            ;;
    esac
}

# Function to detect GPU for performance recommendations
detect_gpu() {
    if command -v lspci &>/dev/null; then
        local gpu_info=$(lspci | grep -i vga | head -1)
        echo "$gpu_info"
    else
        echo "Unknown GPU"
    fi
}

# Function to recommend BunkerOS edition based on hardware
recommend_edition() {
    local gpu_info=$1
    local device_type=$2
    
    # Check for modern GPUs
    if echo "$gpu_info" | grep -qiE "(nvidia.*rtx|nvidia.*gtx [12][0-9]|nvidia.*gtx [3-9][0-9]|amd.*(vega|rdna|rx [5-7][0-9]|rx [3-4][0-9][0-9])|intel.*(xe|iris|uhd [6-9]|hd [5-9]))"; then
        echo "enhanced"
    # Check for older but capable GPUs
    elif echo "$gpu_info" | grep -qiE "(nvidia.*gtx [4-9][0-9]|amd.*(r9|rx [2-4])|intel.*(hd [4-5]|uhd [6-7]))"; then
        if [ "$device_type" = "standard-laptop" ]; then
            echo "standard"
        else
            echo "enhanced"
        fi
    # Older or integrated graphics
    else
        echo "standard"
    fi
}

# Main detection
echo "Detecting display hardware..."
echo ""

# Check if we're in a Wayland session and can get display info
if [ -n "$WAYLAND_DISPLAY" ] && command -v swaymsg &>/dev/null; then
    echo "${INFO}Using Sway/Wayland display detection..."
    
    # Get output information from sway
    sway_outputs=$(swaymsg -t get_outputs)
    
    # Parse primary/focused output
    primary_output=$(echo "$sway_outputs" | jq -r '.[] | select(.focused == true or .active == true) | .name' | head -1)
    
    if [ -z "$primary_output" ]; then
        primary_output=$(echo "$sway_outputs" | jq -r '.[0].name')
    fi
    
    echo "${INFO}Primary display: $primary_output"
    
    # Extract display properties from current_mode
    width_px=$(echo "$sway_outputs" | jq -r ".[] | select(.name == \"$primary_output\") | .current_mode.width")
    height_px=$(echo "$sway_outputs" | jq -r ".[] | select(.name == \"$primary_output\") | .current_mode.height")
    
    # Physical dimensions are not available in sway output, so we'll estimate based on common sizes
    # This is similar to how many systems handle unknown physical dimensions
    width_mm=0
    height_mm=0
    
    # For ultrawide 3440x1440, estimate physical size of ~34" monitor
    if [ "$width_px" = "3440" ] && [ "$height_px" = "1440" ]; then
        width_mm=800  # ~31.5 inches wide
        height_mm=335  # ~13.2 inches tall
    elif [ "$width_px" = "2560" ] && [ "$height_px" = "1440" ]; then
        width_mm=597  # ~23.5 inches wide
        height_mm=336  # ~13.2 inches tall
    elif [ "$width_px" = "1920" ] && [ "$height_px" = "1080" ]; then
        width_mm=510  # ~20 inches wide
        height_mm=287  # ~11.3 inches tall
    fi
    
elif command -v xrandr &>/dev/null; then
    echo "${INFO}Using X11/xrandr display detection..."
    
    # Parse xrandr output for primary display
    primary_line=$(xrandr | grep ' connected primary\|^\S.* connected [0-9]' | head -1)
    
    if [ -z "$primary_line" ]; then
        echo "${WARN}Could not detect display information via xrandr"
        primary_line=$(xrandr | grep ' connected' | head -1)
    fi
    
    # Extract resolution
    resolution=$(echo "$primary_line" | grep -oE '[0-9]+x[0-9]+' | head -1)
    width_px=$(echo "$resolution" | cut -d'x' -f1)
    height_px=$(echo "$resolution" | cut -d'x' -f2)
    
    # Try to extract physical dimensions (not always available in xrandr)
    width_mm=$(echo "$primary_line" | grep -oE '[0-9]+mm x [0-9]+mm' | cut -d' ' -f1 | sed 's/mm//')
    height_mm=$(echo "$primary_line" | grep -oE '[0-9]+mm x [0-9]+mm' | cut -d' ' -f3 | sed 's/mm//')
    
    if [ -z "$width_mm" ] || [ -z "$height_mm" ]; then
        width_mm=0
        height_mm=0
    fi
    
else
    echo "${WARN}No display detection method available (swaymsg or xrandr)"
    echo "      Falling back to manual detection..."
    
    # Try to read from /sys if available
    if [ -d "/sys/class/drm" ]; then
        # This is a basic fallback - might not work on all systems
        width_px=1920
        height_px=1080
        width_mm=0
        height_mm=0
    else
        echo "${ERROR}Cannot detect display hardware"
        exit 1
    fi
fi

# Calculate DPI and detect device type
dpi=$(calculate_dpi "$width_px" "$height_px" "$width_mm" "$height_mm")
device_type=$(detect_device_type "$width_px" "$height_px" "$width_mm" "$height_mm" "$dpi")

# Get GPU info and edition recommendation
gpu_info=$(detect_gpu)
recommended_edition=$(recommend_edition "$gpu_info" "$device_type")

# Get optimal scaling configuration
scaling_config=$(get_scaling_config "$device_type" "$dpi" "$width_px")

# Parse scaling config
eval "$scaling_config"

echo "Display Information:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "${INFO}Resolution: ${width_px}x${height_px}"
if [ "$width_mm" != "0" ] && [ "$height_mm" != "0" ] && [ -n "$width_mm" ] && [ -n "$height_mm" ]; then
    diagonal_mm=$(awk "BEGIN { printf \"%.1f\", sqrt($width_mm^2 + $height_mm^2) }")
    diagonal_inches=$(awk "BEGIN { printf \"%.1f\", $diagonal_mm / 25.4 }")
    echo "${INFO}Physical size: ${width_mm}x${height_mm}mm (${diagonal_inches}\" diagonal)"
    echo "${INFO}Calculated DPI: $dpi"
else
    echo "${INFO}Physical size: Unknown (using estimated DPI: $dpi)"
fi
echo "${INFO}Device type: $device_type"
echo "${INFO}GPU: $gpu_info"
echo ""

echo "Recommended Configuration:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "${SUCCESS}Wayland scaling: $scale"
echo "${SUCCESS}Terminal font size: $foot_font"
echo "${SUCCESS}Waybar font size: $waybar_font"
echo "${SUCCESS}Wofi font size: $wofi_font"
echo "${SUCCESS}Recommended BunkerOS edition: $recommended_edition"
echo ""

# Export variables for use by other scripts
if [ "$1" = "--export" ]; then
    echo "# BunkerOS Display Configuration"
    echo "export BUNKEROS_DISPLAY_SCALE=\"$scale\""
    echo "export BUNKEROS_FOOT_FONT_SIZE=\"$foot_font\""
    echo "export BUNKEROS_WAYBAR_FONT_SIZE=\"$waybar_font\""
    echo "export BUNKEROS_WOFI_FONT_SIZE=\"$wofi_font\""
    echo "export BUNKEROS_DEVICE_TYPE=\"$device_type\""
    echo "export BUNKEROS_RECOMMENDED_EDITION=\"$recommended_edition\""
    echo "export BUNKEROS_DISPLAY_DPI=\"$dpi\""
    echo "export BUNKEROS_DISPLAY_WIDTH=\"$width_px\""
    echo "export BUNKEROS_DISPLAY_HEIGHT=\"$height_px\""
elif [ "$1" = "--json" ]; then
    # JSON output for programmatic use
    cat << EOF
{
    "display": {
        "width": $width_px,
        "height": $height_px,
        "dpi": $dpi,
        "device_type": "$device_type"
    },
    "scaling": {
        "wayland_scale": "$scale",
        "foot_font_size": $foot_font,
        "waybar_font_size": $waybar_font,
        "wofi_font_size": $wofi_font
    },
    "hardware": {
        "gpu": "$gpu_info",
        "recommended_edition": "$recommended_edition"
    }
}
EOF
elif [ "$1" = "--config-vars" ]; then
    # Output format suitable for sourcing in other scripts
    echo "DISPLAY_SCALE=$scale"
    echo "FOOT_FONT_SIZE=$foot_font"
    echo "WAYBAR_FONT_SIZE=$waybar_font"
    echo "WOFI_FONT_SIZE=$wofi_font"
    echo "DEVICE_TYPE=$device_type"
    echo "RECOMMENDED_EDITION=$recommended_edition"
    echo "DISPLAY_DPI=$dpi"
    echo "DISPLAY_WIDTH=$width_px"
    echo "DISPLAY_HEIGHT=$height_px"
else
    echo "Usage Tips:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "• Run 'configure-display-scaling.sh' to apply these settings"
    echo "• Use '--export' flag to get shell variables"
    echo "• Use '--json' flag for programmatic integration"
    echo "• Use '--config-vars' flag for script sourcing"
    
    if [ "$device_type" = "high-dpi-laptop" ] || [ "$device_type" = "high-dpi-monitor" ]; then
        echo ""
        echo "${INFO}High DPI display detected:"
        echo "   Consider enabling fractional scaling if text appears too small"
    fi
    
    if [ "$recommended_edition" = "standard" ]; then
        echo ""
        echo "${INFO}Hardware recommendation:"
        echo "   Your hardware is best suited for BunkerOS Standard Edition"
        echo "   This provides optimal performance without visual effects"
    fi
fi