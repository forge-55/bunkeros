#!/bin/bash
# BunkerOS Tmux Theme Generator
# Generates tmux theme configuration based on active BunkerOS theme

CONFIG_DIR="$HOME/.config/bunkeros"
TMUX_THEME_FILE="$CONFIG_DIR/tmux-theme.conf"

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"

# Detect current BunkerOS theme
BUNKEROS_THEME="tactical"  # Default fallback
if [ -f "$CONFIG_DIR/current-theme" ]; then
    BUNKEROS_THEME=$(cat "$CONFIG_DIR/current-theme")
fi

# Theme color definitions (matching BunkerOS themes)
case "$BUNKEROS_THEME" in
    "tactical")
        BG_MAIN="#0A0F0D"
        BG_SECONDARY="#1A2822"
        FG_PRIMARY="#C8D5C7"
        ACCENT_PRIMARY="#E8D5B7"
        ACCENT_SECONDARY="#2D4A3E"
        ACCENT_MUTED="#1E3A2F"
        URGENT="#D4A574"
        ;;
    "night-ops")
        BG_MAIN="#0D0E10"
        BG_SECONDARY="#1C1E21"
        FG_PRIMARY="#E8E6E1"
        ACCENT_PRIMARY="#D4A574"
        ACCENT_SECONDARY="#4A4E52"
        ACCENT_MUTED="#2A2D31"
        URGENT="#E8B775"
        ;;
    "abyss")
        BG_MAIN="#0A1628"
        BG_SECONDARY="#152844"
        FG_PRIMARY="#E8E6DC"
        ACCENT_PRIMARY="#7BA5D4"
        ACCENT_SECONDARY="#1E3A5F"
        ACCENT_MUTED="#1A2F4A"
        URGENT="#D4A574"
        ;;
    "sahara")
        # Add sahara colors when available
        BG_MAIN="#1A1206"
        BG_SECONDARY="#2D2010"
        FG_PRIMARY="#E8D5B7"
        ACCENT_PRIMARY="#D4A574"
        ACCENT_SECONDARY="#8B5A2B"
        ACCENT_MUTED="#5C3A1A"
        URGENT="#FF6B35"
        ;;
    "winter")
        # Add winter colors when available
        BG_MAIN="#0F1419"
        BG_SECONDARY="#1E252B"
        FG_PRIMARY="#D9E2E8"
        ACCENT_PRIMARY="#7BA5D4"
        ACCENT_SECONDARY="#4A6B8A"
        ACCENT_MUTED="#2A3A4A"
        URGENT="#D4A574"
        ;;
    *)
        # Default to tactical
        BG_MAIN="#0A0F0D"
        BG_SECONDARY="#1A2822"
        FG_PRIMARY="#C8D5C7"
        ACCENT_PRIMARY="#E8D5B7"
        ACCENT_SECONDARY="#2D4A3E"
        ACCENT_MUTED="#1E3A2F"
        URGENT="#D4A574"
        ;;
esac

# Generate tmux theme configuration
cat > "$TMUX_THEME_FILE" << EOF
# BunkerOS Tmux Theme Configuration
# Auto-generated for theme: $BUNKEROS_THEME
# Generated: $(date)

# Theme color variables
set -g @bunkeros_bg_main "$BG_MAIN"
set -g @bunkeros_bg_secondary "$BG_SECONDARY"
set -g @bunkeros_fg_primary "$FG_PRIMARY"
set -g @bunkeros_accent_primary "$ACCENT_PRIMARY"
set -g @bunkeros_accent_secondary "$ACCENT_SECONDARY"
set -g @bunkeros_accent_muted "$ACCENT_MUTED"
set -g @bunkeros_urgent "$URGENT"

# Status bar colors
set -g status-bg "$BG_MAIN"
set -g status-fg "$FG_PRIMARY"

# Window status colors
setw -g window-status-style "fg=$ACCENT_MUTED"
setw -g window-status-current-style "bg=$ACCENT_SECONDARY,fg=$FG_PRIMARY,bold"

# Pane borders
set -g pane-border-style "fg=$ACCENT_MUTED"
set -g pane-active-border-style "fg=$ACCENT_SECONDARY"

# Message colors
set -g message-style "bg=$ACCENT_SECONDARY,fg=$FG_PRIMARY,bold"
set -g message-command-style "bg=$BG_SECONDARY,fg=$FG_PRIMARY"

# Copy mode colors
set -g mode-style "bg=$ACCENT_SECONDARY,fg=$FG_PRIMARY"

# Clock color
set -g clock-mode-colour "$ACCENT_PRIMARY"
EOF

echo "Tmux theme configuration generated for '$BUNKEROS_THEME' theme"
echo "File: $TMUX_THEME_FILE"