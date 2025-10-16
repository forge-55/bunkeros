#!/bin/bash

TEMP_FILE="/tmp/sway-screenshot-$(date +%s).png"

geometry=$(slurp -d)

if [ -z "$geometry" ]; then
    exit 0
fi

grim -g "$geometry" "$TEMP_FILE"

# Show dialog and capture key via temp file
RESPONSE_FILE="/tmp/sway-screenshot-response-$$"
foot --app-id=screenshot-dialog sh -c "
    clear
    echo ''
    echo '  ══════════════════════════════════════════════'
    echo '  Screenshot captured!'
    echo '  ══════════════════════════════════════════════'
    echo ''
    echo '  Press [C] to Copy to Clipboard'
    echo '  Press [S] to Save to Pictures'
    echo ''
    echo '  ══════════════════════════════════════════════'
    echo ''
    read -n 1 -s key
    echo \"\$key\" > '$RESPONSE_FILE'
"

# Wait a moment for file to be written
sleep 0.1

# Read the response
action=$(cat "$RESPONSE_FILE" 2>/dev/null | tr -d '[:space:]')
rm -f "$RESPONSE_FILE"

case "$action" in
    c|C)
        wl-copy < "$TEMP_FILE"
        notify-send -a "Screenshot" "Screenshot copied to clipboard"
        rm "$TEMP_FILE"
        ;;
    s|S)
        PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
        FILENAME="$PICTURES_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        mv "$TEMP_FILE" "$FILENAME"
        notify-send -a "Screenshot" "Screenshot saved" "$FILENAME"
        ;;
    *)
        notify-send -a "Screenshot" "Screenshot cancelled"
        rm "$TEMP_FILE"
        exit 0
        ;;
esac

