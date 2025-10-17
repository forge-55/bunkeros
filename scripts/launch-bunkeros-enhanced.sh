#!/usr/bin/env bash

EFFECTS_SOURCE="$HOME/Projects/bunkeros/sway/config.d/swayfx-effects"
EFFECTS_FILE="$HOME/.config/sway/config.d/swayfx-effects.conf"

rm -f "$EFFECTS_FILE"

ln -sf "$EFFECTS_SOURCE" "$EFFECTS_FILE"

if command -v sway &> /dev/null; then
    exec sway "$@"
else
    echo "Error: sway/swayfx not found in PATH"
    exit 1
fi

