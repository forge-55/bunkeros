#!/bin/bash
# BunkerOS Screensaver - Linux is Freedom with starfield background
# Multi-monitor safe: Each instance gets unique random seed

# Debug logging
LOGFILE="/tmp/screensaver-debug-$$.log"
echo "$(date): Screensaver starting, PID=$$" >> "$LOGFILE"

# Get a unique seed based on the terminal window ID or PID
# This ensures each monitor gets different star positions
RANDOM_SEED=$$
RANDOM=$RANDOM_SEED

# Save our PID for the input monitor
MAIN_PID=$$

# Hide cursor and setup cleanup
tput civis  # Hide terminal cursor
printf '\033[?25l'  # Extra cursor hide escape sequence
trap 'echo "$(date): EXIT trap triggered" >> "$LOGFILE"; tput cnorm; printf "\033[?25h"; clear; stty sane 2>/dev/null; exit' EXIT INT TERM

# Set up terminal for input detection
# -echo: don't echo input
# -icanon: read character by character  
# Only set if we have a TTY
if [ -t 0 ]; then
    stty -echo -icanon 2>/dev/null || true
    echo "$(date): TTY detected, stty configured" >> "$LOGFILE"
else
    echo "$(date): No TTY on stdin!" >> "$LOGFILE"
fi

# Give the terminal a moment to fully initialize before monitoring input
# This prevents the window opening event from triggering exit
echo "$(date): Sleeping 1.5s..." >> "$LOGFILE"
sleep 1.5

# Clear any buffered input that might have accumulated during launch
echo "$(date): Clearing buffered input..." >> "$LOGFILE"
while read -r -t 0.01 -n 1; do echo "$(date): Cleared a buffered char" >> "$LOGFILE"; done 2>/dev/null

# Start input monitor using /dev/tty directly to avoid stdin issues
echo "$(date): Starting input monitor on /dev/tty" >> "$LOGFILE"
(
    echo "$(date): Input monitor waiting for input..." >> "$LOGFILE"
    # Read directly from /dev/tty to avoid stdin being closed
    if read -r -n 1 < /dev/tty 2>/dev/null; then
        echo "$(date): Input received! Killing $MAIN_PID" >> "$LOGFILE"
        kill -TERM $MAIN_PID 2>/dev/null
    else
        echo "$(date): Read from /dev/tty failed" >> "$LOGFILE"
    fi
) &
INPUT_MONITOR_PID=$!
echo "$(date): Input monitor PID=$INPUT_MONITOR_PID" >> "$LOGFILE"

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

# Display Arch Linux logo with starfield
show_arch_tribute() {
    clear
    cols=$(tput cols)
    lines=$(tput lines)
    
    declare -a arch_lines=(
        '                  -`                  '
        '                 .o+`                 '
        '                `ooo/                 '
        '               `+oooo:                '
        '              `+oooooo:               '
        '              -+oooooo+:              '
        '            `/:-:++oooo+:             '
        '           `/++++/+++++++:            '
        '          `/++++++++++++++:           '
        '         `/+++ooooooooooooo/`         '
        '        ./ooosssso++osssssso+`        '
        '       .oossssso-````/ossssss+`       '
        '      -osssssso.      :ssssssso.      '
        '     :osssssss/        osssso+++.     '
        '    /ossssssss/        +ssssooo/-     '
        '  `/ossssso+/:-        -:/+osssso+-   '
        ' `+sso+:-`                 `.-/+oso:  '
        '`++:.                           `-/+/ '
        '.`                                 `/ '
    )
    
    content_height=$((${#arch_lines[@]} + 6))
    start_row=$(( (lines - content_height) / 2 ))
    end_row=$((start_row + content_height))
    
    max_length=50
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
        
        # Redraw content - Arch logo in Arch blue
        current_row=$start_row
        for line in "${arch_lines[@]}"; do
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
        timeline="ARCH LINUX: 2002 - $CURRENT_YEAR"
        timeline_length=${#timeline}
        spaces=$(( (cols - timeline_length) / 2 ))
        tput cup $current_row 0
        if [[ $spaces -gt 0 ]]; then
            printf "%*s" $spaces ""
        fi
        printf "%s%s%s" "$BRIGHT_CYAN" "$timeline" "$RESET"
        
        ((current_row++))
        tagline="Built by Users, For Users"
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

# Main loop - input monitor will kill us on any keypress
while true; do
    show_linux_freedom
    fade_transition
    show_quote
    fade_transition
    show_arch_tribute
    fade_transition
done
