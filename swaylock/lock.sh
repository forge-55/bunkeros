#!/bin/bash
# BunkerOS Lock Screen Wrapper
# Creates secure lock screen with solid background (no screen content exposure)

LOCK_IMG="/tmp/bunkeros-lockscreen.png"

# Create a solid tactical background instead of screenshot
# This prevents any screen content from being visible
convert -size 1920x1080 xc:'#1C1C1C' \
    -font "Liberation-Mono" -pointsize 20 -fill '#8B4545' -gravity North -annotate +0+150 '[ CLASSIFIED ]' \
    -font "Liberation-Mono" -pointsize 72 -fill '#C3B091' -gravity North -annotate +0+200 'BUNKEROS' \
    -font "Liberation-Mono" -pointsize 24 -fill '#E5D5C5' -gravity North -annotate +0+290 'Authentication Required' \
    "$LOCK_IMG"

# Launch swaylock with -f to daemonize immediately (shows lock screen ASAP)
swaylock -f --image "$LOCK_IMG" --scaling fill "$@"

# Clean up
rm -f "$LOCK_IMG"
