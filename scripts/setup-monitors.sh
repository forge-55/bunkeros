#!/usr/bin/env bash
# BunkerOS - Interactive Monitor Setup Script
# Configures multi-monitor layouts with workspace assignments
# Part of the multi-monitor support system

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/sway/config.d"
MONITORS_CONF="$CONFIG_DIR/10-monitors.conf"
WORKSPACES_CONF="$CONFIG_DIR/20-workspaces.conf"
VARIABLES_CONF="$CONFIG_DIR/00-variables.conf"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"

# Welcome message
welcome() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  ${GREEN}BunkerOS Multi-Monitor Setup${NC}                             ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Detect monitors
detect_monitors() {
    bash "$SCRIPT_DIR/detect-monitors.sh"
    echo ""
}

# Interactive layout configuration
configure_layout() {
    local monitor_count=$1
    
    echo -e "${BLUE}Monitor Layout Configuration${NC}"
    echo ""
    echo "How would you like to arrange your monitors?"
    echo ""
    echo "  1) Side-by-side (horizontal)"
    echo "  2) Stacked (vertical)"
    echo "  3) Custom positions"
    echo "  4) Auto-detect current layout"
    echo ""
    read -p "Choose option [1-4]: " layout_choice
    
    echo "$layout_choice"
}

# Configure workspace assignments
configure_workspaces() {
    local primary=$1
    local secondary=$2
    local tertiary=$3
    
    echo -e "${BLUE}Workspace Assignment${NC}"
    echo ""
    
    if [ -n "$tertiary" ]; then
        echo "Three monitors detected. Workspace distribution:"
        echo "  • Monitor 1 ($primary): Workspaces 1-5"
        echo "  • Monitor 2 ($secondary): Workspaces 6-10"
        echo "  • Monitor 3 ($tertiary): Workspaces 11-15"
    elif [ -n "$secondary" ]; then
        echo "Two monitors detected. Workspace distribution:"
        echo "  • Monitor 1 ($primary): Workspaces 1-5"
        echo "  • Monitor 2 ($secondary): Workspaces 6-10"
    else
        echo "Single monitor. All workspaces (1-10) available."
    fi
    
    echo ""
    read -p "Accept this configuration? [Y/n]: " accept
    
    if [[ ! "$accept" =~ ^[Nn] ]]; then
        return 0
    else
        return 1
    fi
}

# Write configuration files
write_config() {
    local primary=$1
    local secondary=$2
    local tertiary=$3
    
    # Update variables.conf
    if [ -f "$VARIABLES_CONF" ]; then
        # Update existing file
        sed -i "s/^# set \$primary .*/set \$primary $primary/" "$VARIABLES_CONF"
        
        if [ -n "$secondary" ]; then
            sed -i "s/^# set \$secondary .*/set \$secondary $secondary/" "$VARIABLES_CONF"
        fi
        
        if [ -n "$tertiary" ]; then
            sed -i "s/^# set \$tertiary .*/set \$tertiary $tertiary/" "$VARIABLES_CONF"
        fi
    fi
    
    # Update workspaces.conf
    if [ -n "$secondary" ]; then
        # Create workspace assignments for dual monitor
        sed -i '/# Primary monitor workspaces (1-5)/,/# workspace 5 output \$primary/s/^# //' "$WORKSPACES_CONF"
        sed -i '/# Secondary monitor workspaces (6-10)/,/# workspace 10 output \$secondary/s/^# //' "$WORKSPACES_CONF"
    fi
    
    if [ -n "$tertiary" ]; then
        # Create workspace assignments for triple monitor
        sed -i '/# Tertiary monitor workspaces (11-15)/,/# workspace 15 output \$tertiary/s/^# //' "$WORKSPACES_CONF"
        
        # Add workspace 11-15 keybindings to workspaces.conf if not present
        if ! grep -q "bindsym \$mod+F1 workspace number 11" "$WORKSPACES_CONF"; then
            cat >> "$WORKSPACES_CONF" << 'EOF'

### Additional Workspace Keybindings (for 3+ monitors)
# Function keys for workspaces 11-15
bindsym $mod+F1 workspace number 11
bindsym $mod+F2 workspace number 12
bindsym $mod+F3 workspace number 13
bindsym $mod+F4 workspace number 14
bindsym $mod+F5 workspace number 15

# Move containers to workspaces 11-15
bindsym $mod+Shift+F1 move container to workspace number 11
bindsym $mod+Shift+F2 move container to workspace number 12
bindsym $mod+Shift+F3 move container to workspace number 13
bindsym $mod+Shift+F4 move container to workspace number 14
bindsym $mod+Shift+F5 move container to workspace number 15
EOF
        fi
    fi
    
    echo -e "${GREEN}✓${NC} Configuration written successfully"
}

# Apply configuration
apply_config() {
    echo ""
    echo -e "${BLUE}Applying configuration...${NC}"
    
    # Reload Sway config
    swaymsg reload
    
    echo -e "${GREEN}✓${NC} Configuration applied"
    echo ""
    echo "Your multi-monitor setup is now configured!"
    echo ""
    echo "Workspace distribution:"
    
    local primary=$(bash "$SCRIPT_DIR/detect-monitors.sh" --primary)
    local monitor_count=$(bash "$SCRIPT_DIR/detect-monitors.sh" --count)
    
    echo "  • Workspaces 1-5: $primary"
    
    if [ "$monitor_count" -ge 2 ]; then
        local secondary=$(swaymsg -t get_outputs | jq -r ".[] | select(.active == true) | select(.name != \"$primary\") | .name" | head -n1)
        echo "  • Workspaces 6-10: $secondary"
    fi
    
    if [ "$monitor_count" -ge 3 ]; then
        local tertiary=$(swaymsg -t get_outputs | jq -r ".[] | select(.active == true) | select(.name != \"$primary\") | select(.name != \"$secondary\") | .name" | head -n1)
        echo "  • Workspaces 11-15: $tertiary"
    fi
    
    echo ""
    echo "Tip: Press Super+1 through Super+5 for primary monitor workspaces"
    echo "     Press Super+6 through Super+0 for secondary monitor workspaces"
    if [ "$monitor_count" -ge 3 ]; then
        echo "     Press Super+F1 through Super+F5 for tertiary monitor workspaces"
    fi
}

# Main interactive flow
main() {
    welcome
    
    # Check if Sway is running
    if ! pgrep -x sway > /dev/null; then
        echo -e "${RED}Error: Sway is not running${NC}"
        echo "This script must be run within a Sway session"
        exit 1
    fi
    
    # Detect monitors
    echo -e "${BLUE}Detecting monitors...${NC}"
    echo ""
    detect_monitors
    
    # Get monitor information
    local primary=$(bash "$SCRIPT_DIR/detect-monitors.sh" --primary)
    local monitor_count=$(bash "$SCRIPT_DIR/detect-monitors.sh" --count)
    
    if [ "$monitor_count" -eq 0 ]; then
        echo -e "${RED}No monitors detected${NC}"
        exit 1
    fi
    
    local secondary=""
    local tertiary=""
    
    if [ "$monitor_count" -ge 2 ]; then
        secondary=$(swaymsg -t get_outputs | jq -r ".[] | select(.active == true) | select(.name != \"$primary\") | .name" | head -n1)
    fi
    
    if [ "$monitor_count" -ge 3 ]; then
        tertiary=$(swaymsg -t get_outputs | jq -r ".[] | select(.active == true) | select(.name != \"$primary\") | select(.name != \"$secondary\") | .name" | head -n1)
    fi
    
    # Configure workspaces
    if configure_workspaces "$primary" "$secondary" "$tertiary"; then
        write_config "$primary" "$secondary" "$tertiary"
        apply_config
    else
        echo ""
        echo -e "${YELLOW}Setup cancelled${NC}"
        exit 0
    fi
}

# Handle command-line options
case "${1:-}" in
    --help|-h)
        echo "BunkerOS Multi-Monitor Setup Script"
        echo ""
        echo "Usage: setup-monitors.sh [option]"
        echo ""
        echo "Options:"
        echo "  (none)      Run interactive setup"
        echo "  --auto      Automatically configure detected monitors"
        echo "  --help, -h  Show this help message"
        ;;
    --auto)
        # Auto-configuration without prompts
        primary=$(bash "$SCRIPT_DIR/detect-monitors.sh" --primary)
        monitor_count=$(bash "$SCRIPT_DIR/detect-monitors.sh" --count)
        
        secondary=""
        tertiary=""
        
        if [ "$monitor_count" -ge 2 ]; then
            secondary=$(swaymsg -t get_outputs | jq -r ".[] | select(.active == true) | select(.name != \"$primary\") | .name" | head -n1)
        fi
        
        if [ "$monitor_count" -ge 3 ]; then
            tertiary=$(swaymsg -t get_outputs | jq -r ".[] | select(.active == true) | select(.name != \"$primary\") | select(.name != \"$secondary\") | .name" | head -n1)
        fi
        
        write_config "$primary" "$secondary" "$tertiary"
        swaymsg reload
        echo "Multi-monitor setup configured automatically"
        ;;
    *)
        main
        ;;
esac
