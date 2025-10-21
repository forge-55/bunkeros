#!/bin/bash
# BunkerOS Screensaver - Linux is Freedom with starfield background

# Hide cursor and setup cleanup
tput civis
trap 'tput cnorm; clear; exit' EXIT INT TERM

# Colors
YELLOW=$(tput bold; tput setaf 3)
WHITE=$(tput bold; tput setaf 7)
GREEN=$(tput setaf 2)
BRIGHT_GREEN=$(tput bold; tput setaf 2)
BLUE=$(tput bold; tput setaf 4)
BRIGHT_BLUE=$(tput bold; tput setaf 6)
BRIGHT_CYAN=$(tput bold; tput setaf 6)
BRIGHT_YELLOW=$(tput bold; tput setaf 11)
DIM=$(tput dim)
RESET=$(tput sgr0)

# Get current year dynamically
CURRENT_YEAR=$(date +%Y)

# Global star positions that persist across transitions
declare -a GLOBAL_STAR_ROWS
declare -a GLOBAL_STAR_COLS
STARS_INITIALIZED=0

# Initialize persistent stars once at startup
init_stars() {
    if [[ $STARS_INITIALIZED -eq 0 ]]; then
        cols=$(tput cols)
        lines=$(tput lines)
        for ((i=0; i<50; i++)); do
            GLOBAL_STAR_ROWS[$i]=$((RANDOM % lines + 1))
            GLOBAL_STAR_COLS[$i]=$((RANDOM % cols + 1))
        done
        STARS_INITIALIZED=1
    fi
}

# Smooth, subtle transition - just a brief clear, stars stay in same positions
fade_transition() {
    sleep 0.4
    clear
    sleep 0.1
}

# Display "Linux is Freedom" with starfield
show_linux_freedom() {
    clear
    cols=$(tput cols)
    lines=$(tput lines)
    
    # Define the ASCII art lines
    declare -a art_lines=(
        "██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗"
        "██║     ██║████╗  ██║██║   ██║╚██╗██╔╝"
        "██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ "
        "██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ "
        "███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗"
        "╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝"
        ""
        "    ██╗███████╗    ███████╗██████╗ ███████╗███████╗██████╗  ██████╗ ███╗   ███╗"
        "    ██║██╔════╝    ██╔════╝██╔══██╗██╔════╝██╔════╝██╔══██╗██╔═══██╗████╗ ████║"
        "    ██║███████╗    █████╗  ██████╔╝█████╗  █████╗  ██║  ██║██║   ██║██╔████╔██║"
        "    ██║╚════██║    ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██║  ██║██║   ██║██║╚██╔╝██║"
        "    ██║███████║    ██║     ██║  ██║███████╗███████╗██████╔╝╚██████╔╝██║ ╚═╝ ██║"
        "    ╚═╝╚══════╝    ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚═════╝  ╚═════╝ ╚═╝     ╚═╝"
    )
    
    # Calculate content boundaries
    content_height=${#art_lines[@]}
    start_row=$(( (lines - content_height) / 2 ))
    end_row=$((start_row + content_height))
    
    max_length=0
    for line in "${art_lines[@]}"; do
        length=${#line}
        if [[ $length -gt $max_length ]]; then
            max_length=$length
        fi
    done
    content_left=$(( (cols - max_length) / 2 ))
    content_right=$((content_left + max_length))
    
    # Use global persistent stars (initialize if needed)
    init_stars
    
    # Animation loop: 10 seconds with blinking stars
    for ((frame=0; frame<50; frame++)); do
        # Draw/update stars at their persistent positions (blink effect)
        for ((i=0; i<50; i++)); do
            row=${GLOBAL_STAR_ROWS[$i]}
            col=${GLOBAL_STAR_COLS[$i]}
            # Only draw star if outside content area
            if [[ $row -lt $start_row || $row -gt $end_row || 
                  $col -lt $content_left || $col -gt $content_right ]]; then
                tput cup $row $col
                if (( (frame + i) % 3 == 0 )); then
                    echo -n "${BRIGHT_GREEN}*${RESET}"
                elif (( (frame + i) % 3 == 1 )); then
                    echo -n "${GREEN}.${RESET}"
                else
                    echo -n " "
                fi
            fi
        done
        
        # Redraw content to ensure it stays on top
        current_row=$start_row
        for line in "${art_lines[@]}"; do
            tput cup $current_row 0
            line_length=${#line}
            spaces=$(( (cols - line_length) / 2 ))
            if [[ $spaces -gt 0 ]]; then
                printf "%*s" $spaces ""
            fi
            printf "%s%s%s" "$BRIGHT_YELLOW" "$line" "$RESET"
            ((current_row++))
        done
        
        sleep 0.2
    done
}

# Display quote with starfield
show_quote() {
    clear
    cols=$(tput cols)
    lines=$(tput lines)
    
    declare -a quote_lines=(
        ""
        "'In real open source, you have the right"
        " to control your own destiny.'"
        ""
        "                                    - Linus Torvalds"
    )
    
    content_height=${#quote_lines[@]}
    start_row=$(( (lines - content_height) / 2 ))
    end_row=$((start_row + content_height))
    
    max_length=0
    for line in "${quote_lines[@]}"; do
        length=${#line}
        if [[ $length -gt $max_length ]]; then
            max_length=$length
        fi
    done
    content_left=$(( (cols - max_length) / 2 ))
    content_right=$((content_left + max_length))
    
    # Use global persistent stars
    init_stars
    
    # Animation loop
    for ((frame=0; frame<50; frame++)); do
        # Draw/update stars at their persistent positions
        for ((i=0; i<50; i++)); do
            row=${GLOBAL_STAR_ROWS[$i]}
            col=${GLOBAL_STAR_COLS[$i]}
            # Only draw star if outside content area
            if [[ $row -lt $start_row || $row -gt $end_row || 
                  $col -lt $content_left || $col -gt $content_right ]]; then
                tput cup $row $col
                if (( (frame + i) % 3 == 0 )); then
                    echo -n "${BRIGHT_GREEN}*${RESET}"
                elif (( (frame + i) % 3 == 1 )); then
                    echo -n "${GREEN}.${RESET}"
                else
                    echo -n " "
                fi
            fi
        done
        
        # Redraw content
        current_row=$start_row
        for line in "${quote_lines[@]}"; do
            tput cup $current_row 0
            line_length=${#line}
            spaces=$(( (cols - line_length) / 2 ))
            if [[ $spaces -gt 0 ]]; then
                printf "%*s" $spaces ""
            fi
            printf "%s%s%s" "$WHITE" "$line" "$RESET"
            ((current_row++))
        done
        
        sleep 0.2
    done
}

# Display Tux with starfield
show_tux() {
    clear
    cols=$(tput cols)
    lines=$(tput lines)
    
    declare -a tux_lines=(
        '    .--.'
        '   |o_o |'
        '   |:_/ |'
        '  //   \ \'
        ' (|     | )'
        '/'"'"'\_   _/`\'
        '\___)=(___/'
    )
    
    content_height=$((${#tux_lines[@]} + 6))
    start_row=$(( (lines - content_height) / 2 ))
    end_row=$((start_row + content_height))
    
    max_length=40
    content_left=$(( (cols - max_length) / 2 ))
    content_right=$((content_left + max_length))
    
    # Use global persistent stars
    init_stars
    
    # Animation loop
    for ((frame=0; frame<50; frame++)); do
        # Draw/update stars at their persistent positions
        for ((i=0; i<50; i++)); do
            row=${GLOBAL_STAR_ROWS[$i]}
            col=${GLOBAL_STAR_COLS[$i]}
            # Only draw star if outside content area
            if [[ $row -lt $start_row || $row -gt $end_row || 
                  $col -lt $content_left || $col -gt $content_right ]]; then
                tput cup $row $col
                if (( (frame + i) % 3 == 0 )); then
                    echo -n "${BRIGHT_GREEN}*${RESET}"
                elif (( (frame + i) % 3 == 1 )); then
                    echo -n "${GREEN}.${RESET}"
                else
                    echo -n " "
                fi
            fi
        done
        
        # Redraw content
        current_row=$start_row
        for line in "${tux_lines[@]}"; do
            tput cup $current_row 0
            line_length=${#line}
            spaces=$(( (cols - line_length) / 2 ))
            if [[ $spaces -gt 0 ]]; then
                printf "%*s" $spaces ""
            fi
            printf "%s%s%s" "$BRIGHT_CYAN" "$line" "$RESET"
            ((current_row++))
        done
        
        current_row=$((current_row + 2))
        timeline="LINUX: 1991 - $CURRENT_YEAR"
        timeline_length=${#timeline}
        spaces=$(( (cols - timeline_length) / 2 ))
        tput cup $current_row 0
        if [[ $spaces -gt 0 ]]; then
            printf "%*s" $spaces ""
        fi
        printf "%s%s%s" "$BRIGHT_GREEN" "$timeline" "$RESET"
        
        ((current_row++))
        tagline="Powering Freedom for Over 30 Years"
        tagline_length=${#tagline}
        spaces=$(( (cols - tagline_length) / 2 ))
        tput cup $current_row 0
        if [[ $spaces -gt 0 ]]; then
            printf "%*s" $spaces ""
        fi
        printf "%s%s%s" "$WHITE" "$tagline" "$RESET"
        
        sleep 0.2
    done
}

# Main loop
while true; do
    show_linux_freedom
    fade_transition
    show_quote
    fade_transition
    show_tux
    fade_transition
done
