#!/bin/bash
# BunkerOS Lock Screen Wrapper
# Creates blurred screenshot with tactical/military-style overlay

LOCK_IMG="/tmp/bunkeros-lockscreen.png"

# Take screenshot of current screen
grim "$LOCK_IMG"

# Apply blur and add clean tactical overlay
# Minimal text, maximum impact
convert "$LOCK_IMG" \
    -scale 10% -blur 0x2.5 -resize 1000% \
    -fill '#1C1C1C' -colorize 35% \
    -font "Liberation-Mono" -pointsize 20 -fill '#8B4545' -gravity North -annotate +0+150 '[ CLASSIFIED ]' \
    -font "Liberation-Mono" -pointsize 72 -fill '#C3B091' -gravity North -annotate +0+200 'BUNKEROS' \
    -font "Liberation-Mono" -pointsize 24 -fill '#E5D5C5' -gravity North -annotate +0+290 'Authentication Required' \
    "$LOCK_IMG"

# Launch swaylock with the blurred + labeled screenshot
swaylock --image "$LOCK_IMG" --scaling fill "$@"

# Clean up
rm -f "$LOCK_IMG"
