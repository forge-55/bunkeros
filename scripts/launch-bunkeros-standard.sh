#!/usr/bin/env bash

EFFECTS_FILE="$HOME/.config/sway/config.d/swayfx-effects.conf"

if [ -f "$EFFECTS_FILE" ] || [ -L "$EFFECTS_FILE" ]; then
    rm -f "$EFFECTS_FILE"
fi

touch "$EFFECTS_FILE"

exec sway "$@"

