#!/bin/bash
# BunkerOS Screensaver - Linux is Freedom - Simple & Reliable

# Hide cursor and setup cleanup
tput civis
trap 'tput cnorm; clear; exit' EXIT INT TERM

# Colors
YELLOW=$(tput bold; tput setaf 3)
WHITE=$(tput bold; tput setaf 7)
GREEN=$(tput setaf 2)
BRIGHT_GREEN=$(tput bold; tput setaf 2)
RESET=$(tput sgr0)

# Simple centering that works
center_display() {
    local color="$1"
    shift
    local lines=("$@")
    
    clear
    
    # Get terminal size
    local cols=$(tput cols)
    local term_lines=$(tput lines)
    
    # Calculate starting row
    local content_height=${#lines[@]}
    local start_row=$(( (term_lines - content_height) / 2 ))
    
    # Print each line centered
    local current_row=$start_row
    for line in "${lines[@]}"; do
        tput cup $current_row 0
        local line_length=${#line}
        local spaces=$(( (cols - line_length) / 2 ))
        if [[ $spaces -gt 0 ]]; then
            printf "%*s" $spaces ""
        fi
        printf "%s%s%s" "$color" "$line" "$RESET"
        ((current_row++))
    done
}

# Main loop
while true; do
    # Digital rain
    clear
    cols=$(tput cols)
    lines=$(tput lines)
    
    for frame in {1..15}; do
        for ((col=10; col<cols-10; col+=5)); do
            if (( RANDOM % 20 == 0 )); then
                row=$((RANDOM % (lines-5) + 2))
                tput cup $row $col
                printf "%s%d%s" "$GREEN" $((RANDOM % 2)) "$RESET"
            fi
        done
        sleep 0.1
    done
    
    # Show LINUX IS FREEDOM
    center_display "$YELLOW" \
        "        ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗" \
        "        ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝" \
        "        ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ " \
        "        ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ " \
        "        ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗" \
        "        ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝" \
        "" \
        "            ██╗███████╗    ███████╗██████╗ ███████╗███████╗██████╗  ██████╗ ███╗   ███╗" \
        "            ██║██╔════╝    ██╔════╝██╔══██╗██╔════╝██╔════╝██╔══██╗██╔═══██╗████╗ ████║" \
        "            ██║███████╗    █████╗  ██████╔╝█████╗  █████╗  ██║  ██║██║   ██║██╔████╔██║" \
        "            ██║╚════██║    ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██║  ██║██║   ██║██║╚██╔╝██║" \
        "            ██║███████║    ██║     ██║  ██║███████╗███████╗██████╔╝╚██████╔╝██║ ╚═╝ ██║" \
        "            ╚═╝╚══════╝    ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚═════╝  ╚═════╝ ╚═╝     ╚═╝"
    
    sleep 4
    
    # Show TACTICAL BUNKEROS
    center_display "$BRIGHT_GREEN" \
        "        ████████╗ █████╗  ██████╗████████╗██╗ ██████╗ █████╗ ██╗     " \
        "        ╚══██╔══╝██╔══██╗██╔════╝╚══██╔══╝██║██╔════╝██╔══██╗██║     " \
        "           ██║   ███████║██║        ██║   ██║██║     ███████║██║     " \
        "           ██║   ██╔══██║██║        ██║   ██║██║     ██╔══██║██║     " \
        "           ██║   ██║  ██║╚██████╗   ██║   ██║╚██████╗██║  ██║███████╗" \
        "           ╚═╝   ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝" \
        "" \
        "        ██████╗ ██╗   ██╗███╗   ██╗██╗  ██╗███████╗██████╗  ██████╗ ███████╗" \
        "        ██╔══██╗██║   ██║████╗  ██║██║ ██╔╝██╔════╝██╔══██╗██╔═══██╗██╔════╝" \
        "        ██████╔╝██║   ██║██╔██╗ ██║█████╔╝ █████╗  ██████╔╝██║   ██║███████╗" \
        "        ██╔══██╗██║   ██║██║╚██╗██║██╔═██╗ ██╔══╝  ██╔══██╗██║   ██║╚════██║" \
        "        ██████╔╝╚██████╔╝██║ ╚████║██║  ██╗███████╗██║  ██║╚██████╔╝███████║" \
        "        ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝" \
        "" \
        "        ┌──────────────────────────────────────────────────────────────────────────┐" \
        "        │                       PRIVATE • POWERFUL • CUSTOMIZABLE                │" \
        "        │                                                                          │" \
        "        │                            LINUX IS FREEDOM                             │" \
        "        └──────────────────────────────────────────────────────────────────────────┘"
    
    sleep 4
    
    # Show Quote
    center_display "$WHITE" \
        "'In real open source, you have the right" \
        " to control your own destiny.'" \
        "" \
        "                                        - Linus Torvalds" \
        "" \
        "                              LINUX IS FREEDOM"
    
    sleep 4
done
