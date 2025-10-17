#!/usr/bin/env bash

EFFECTS_FILE="$HOME/.config/sway/config.d/swayfx-effects.conf"

if [ -f "$EFFECTS_FILE" ] || [ -L "$EFFECTS_FILE" ]; then
    rm -f "$EFFECTS_FILE"
fi

touch "$EFFECTS_FILE"

if command -v sway &> /dev/null; then
    exec sway "$@"
else
    echo "Error: sway/swayfx not found in PATH"
    exit 1
fi

