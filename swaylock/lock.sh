#!/bin/bash
# BunkerOS Lock Screen Wrapper
# Creates secure lock screen with BunkerOS theming

LOCK_IMG="/tmp/bunkeros-lockscreen.png"

# Check if ImageMagick is available for custom background
if command -v convert &> /dev/null; then
    # Create a custom tactical background with text
    # This prevents any screen content from being visible
    convert -size 1920x1080 xc:'#1C1C1C' \
        -font "Liberation-Mono" -pointsize 20 -fill '#8B4545' -gravity North -annotate +0+150 '[ CLASSIFIED ]' \
        -font "Liberation-Mono" -pointsize 72 -fill '#C3B091' -gravity North -annotate +0+200 'BUNKEROS' \
        -font "Liberation-Mono" -pointsize 24 -fill '#E5D5C5' -gravity North -annotate +0+290 'Authentication Required' \
        "$LOCK_IMG" 2>/dev/null
    
    # Launch swaylock with custom image if created successfully
    if [ -f "$LOCK_IMG" ]; then
        swaylock -f --image "$LOCK_IMG" --scaling fill "$@"
        rm -f "$LOCK_IMG"
        exit 0
    fi
fi

# Fallback: Use solid color with swaylock config (no ImageMagick required)
# The swaylock config provides the tactical theming
swaylock -f --color 1C1C1C "$@"
