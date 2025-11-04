#!/usr/bin/env bash
# BunkerOS - Monitor Detection Script
# Detects connected monitors and provides configuration recommendations
# Part of the multi-monitor support system

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get list of connected outputs
get_outputs() {
    swaymsg -t get_outputs | jq -r '.[] | select(.active == true) | "\(.name)|\(.make)|\(.model)|\(.current_mode.width)x\(.current_mode.height)|\(.scale)|\(.transform)"'
}

# Detect primary output (usually laptop screen or first connected)
detect_primary() {
    # Try to find laptop screen first
    local laptop_screen=$(swaymsg -t get_outputs | jq -r '.[] | select(.active == true) | select(.name | test("eDP|LVDS")) | .name' | head -n1)
    
    if [ -n "$laptop_screen" ]; then
        echo "$laptop_screen"
        return
    fi
    
    # Fall back to first active output
    swaymsg -t get_outputs | jq -r '.[] | select(.active == true) | .name' | head -n1
}

# Print monitor information in human-readable format
print_monitor_info() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  ${GREEN}BunkerOS Multi-Monitor Detection${NC}                          ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    local count=0
    local outputs=$(get_outputs)
    
    if [ -z "$outputs" ]; then
        echo -e "${YELLOW}No active displays detected${NC}"
        return 1
    fi
    
    local primary=$(detect_primary)
    
    while IFS='|' read -r name make model resolution scale transform; do
        count=$((count + 1))
        
        local label="Monitor $count"
        if [ "$name" = "$primary" ]; then
            label="$label (Primary)"
        fi
        
        echo -e "${GREEN}$label${NC}"
        echo "  Name:       $name"
        echo "  Make:       $make"
        echo "  Model:      $model"
        echo "  Resolution: $resolution"
        echo "  Scale:      $scale"
        
        if [ "$transform" != "normal" ] && [ -n "$transform" ]; then
            echo "  Transform:  $transform"
        fi
        
        echo ""
    done <<< "$outputs"
    
    echo -e "${BLUE}Total active displays: $count${NC}"
    echo ""
    
    return 0
}

# Generate suggested configuration
generate_config_suggestion() {
    local output_count=$(get_outputs | wc -l)
    local primary=$(detect_primary)
    
    echo -e "${BLUE}Suggested Configuration:${NC}"
    echo ""
    
    case $output_count in
        1)
            echo "Single monitor setup detected"
            echo "• No additional configuration needed"
            echo "• All workspaces (1-10) available on main display"
            ;;
        2)
            echo "Dual monitor setup detected"
            echo "• Primary: $primary (Workspaces 1-5)"
            
            local secondary=$(swaymsg -t get_outputs | jq -r ".[] | select(.active == true) | select(.name != \"$primary\") | .name" | head -n1)
            echo "• Secondary: $secondary (Workspaces 6-10)"
            echo ""
            echo "Run 'setup-monitors.sh' to configure"
            ;;
        *)
            echo "Multi-monitor setup detected ($output_count displays)"
            echo "• Primary: $primary (Workspaces 1-5)"
            
            local secondary=$(swaymsg -t get_outputs | jq -r ".[] | select(.active == true) | select(.name != \"$primary\") | .name" | head -n1)
            if [ -n "$secondary" ]; then
                echo "• Secondary: $secondary (Workspaces 6-10)"
            fi
            
            local tertiary=$(swaymsg -t get_outputs | jq -r ".[] | select(.active == true) | select(.name != \"$primary\") | select(.name != \"$secondary\") | .name" | head -n1)
            if [ -n "$tertiary" ]; then
                echo "• Tertiary: $tertiary (Workspaces 11-15)"
            fi
            
            echo ""
            echo "Run 'setup-monitors.sh' to configure"
            ;;
    esac
}

# Generate output for machine-readable consumption
print_json() {
    swaymsg -t get_outputs | jq '[.[] | select(.active == true) | {name: .name, make: .make, model: .model, width: .current_mode.width, height: .current_mode.height, scale: .scale, transform: .transform, x: .rect.x, y: .rect.y}]'
}

# Main execution
main() {
    case "${1:-}" in
        --json)
            print_json
            ;;
        --primary)
            detect_primary
            ;;
        --count)
            get_outputs | wc -l
            ;;
        --help|-h)
            echo "BunkerOS Monitor Detection Script"
            echo ""
            echo "Usage: detect-monitors.sh [option]"
            echo ""
            echo "Options:"
            echo "  (none)      Show detailed monitor information and suggestions"
            echo "  --json      Output raw JSON data"
            echo "  --primary   Show primary monitor name only"
            echo "  --count     Show number of active monitors"
            echo "  --help, -h  Show this help message"
            ;;
        *)
            if ! print_monitor_info; then
                exit 1
            fi
            generate_config_suggestion
            ;;
    esac
}

main "$@"
