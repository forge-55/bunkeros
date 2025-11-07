#!/bin/bash
# BunkerOS Theme Integration for Tmux
# Called by theme-switcher when themes change

TMUX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Regenerate tmux theme configuration
bash "$TMUX_DIR/generate-theme.sh"

# Reload tmux configuration if tmux is running
if tmux info &>/dev/null; then
    # Reload the theme configuration in all tmux sessions
    tmux source-file ~/.tmux.conf
    echo "Tmux theme updated and reloaded"
fi