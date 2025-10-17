#!/usr/bin/env bash

EFFECTS_SOURCE="$HOME/Projects/bunkeros/sway/config.d/swayfx-effects"
EFFECTS_FILE="$HOME/.config/sway/config.d/swayfx-effects.conf"

rm -f "$EFFECTS_FILE"

ln -sf "$EFFECTS_SOURCE" "$EFFECTS_FILE"

exec swayfx "$@"

