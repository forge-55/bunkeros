#!/bin/bash
# BunkerOS Screensaver - Linux is Freedom

# Hide cursor and setup cleanup
tput civis
trap 'tput cnorm; clear; exit' EXIT INT TERM

# Colors
YELLOW=$(tput bold; tput setaf 3)
CYAN=$(tput bold; tput setaf 6)
WHITE=$(tput bold; tput setaf 7)
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)

# Get terminal size
COLS=$(tput cols)
LINES=$(tput lines)

# Center text function
center_text() {
    local text="$1"
    local color="$2"
    
    clear
    
    # Calculate vertical centering
    local text_lines=$(echo -e "$text" | wc -l)
    local start_line=$(( (LINES - text_lines) / 2 ))
    
    # Add vertical spacing
    for ((i=0; i<start_line; i++)); do
        echo ""
    done
    
    # Print each line centered
    while IFS= read -r line; do
        local line_length=${#line}
        local spaces=$(( (COLS - line_length) / 2 ))
        printf "%*s" $spaces ""
        echo "${color}${line}${RESET}"
    done <<< "$text"
}

# Big ASCII art
BIG_ART="
        ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
        ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
        ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ 
        ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ 
        ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
        ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
        
            ██╗███████╗    ███████╗██████╗ ███████╗███████╗██████╗  ██████╗ ███╗   ███╗
            ██║██╔════╝    ██╔════╝██╔══██╗██╔════╝██╔════╝██╔══██╗██╔═══██╗████╗ ████║
            ██║███████╗    █████╗  ██████╔╝█████╗  █████╗  ██║  ██║██║   ██║██╔████╔██║
            ██║╚════██║    ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██║  ██║██║   ██║██║╚██╔╝██║
            ██║███████║    ██║     ██║  ██║███████╗███████╗██████╔╝╚██████╔╝██║ ╚═╝ ██║
            ╚═╝╚══════╝    ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚═════╝  ╚═════╝ ╚═╝     ╚═╝
"

BOXED_ART="
        ┌─────────────────────────────────────────────────────────────────────────────┐
        │                             LINUX IS FREEDOM                               │
        │                                                                             │
        │                    'Think Different. Code Different. Be Free.'             │
        │                                                                             │
        │              Open Source • Open Minds • Open Possibilities                 │
        └─────────────────────────────────────────────────────────────────────────────┘
"

QUOTE_ART="
        'The only way to deal with an unfree world
         is to become so absolutely free that your
         very existence is an act of rebellion.'
        
                                        - Albert Camus
        
                              LINUX IS FREEDOM
"

# Main loop
while true; do
    # Digital rain effect
    clear
    for frame in {1..15}; do
        for ((col=1; col<=COLS; col+=4)); do
            if (( RANDOM % 20 == 0 )); then
                row=$((RANDOM % LINES + 1))
                tput cup $row $col
                echo -n "${GREEN}$((RANDOM % 2))${RESET}"
            fi
        done
        sleep 0.1
    done
    
    # Show big text
    center_text "$BIG_ART" "$YELLOW"
    sleep 4
    
    # Show boxed text
    center_text "$BOXED_ART" "$CYAN"
    sleep 4
    
    # Show quote
    center_text "$QUOTE_ART" "$WHITE"
    sleep 4
done
