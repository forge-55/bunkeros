#!/bin/bash
# BunkerOS Tmux Installation Script
# Installs tmux configuration with BunkerOS tactical theme and TPM plugins

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_CONF="$HOME/.tmux.conf"
TPM_DIR="$HOME/.tmux/plugins/tpm"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  BunkerOS Tmux Configuration Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo "❌ ERROR: tmux is not installed"
    echo "   Install it with: sudo pacman -S tmux"
    exit 1
fi

echo "✓ Tmux is installed ($(tmux -V))"

# Backup existing config if it exists
if [ -f "$TMUX_CONF" ]; then
    BACKUP_FILE="${TMUX_CONF}.backup-$(date +%Y%m%d-%H%M%S)"
    echo "→ Backing up existing tmux.conf to: $BACKUP_FILE"
    cp "$TMUX_CONF" "$BACKUP_FILE"
fi

# Install new configuration
echo "→ Installing BunkerOS tmux configuration..."
cp "$SCRIPT_DIR/tmux.conf.default" "$TMUX_CONF"
echo "  ✓ Installed $TMUX_CONF"

# Install TPM (Tmux Plugin Manager)
echo ""
echo "→ Installing Tmux Plugin Manager (TPM)..."
if [ ! -d "$TPM_DIR" ]; then
    echo "  • Cloning TPM repository..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "  ✓ TPM installed: $TPM_DIR"
else
    echo "  ℹ TPM already installed at $TPM_DIR"
fi

# Create tmux directory structure
mkdir -p "$HOME/.tmux/plugins"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Tmux Configuration Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "🎯 BunkerOS tmux features:"
echo "  • Ctrl+a prefix (ergonomic for developers)"
echo "  • Mouse support enabled"
echo "  • Vi-style copy mode and navigation"
echo "  • Intuitive pane splitting (| and -)"
echo "  • BunkerOS theme integration (all 5 themes)"
echo "  • Large scrollback buffer (100,000 lines)"
echo "  • Session persistence and restoration"
echo "  • Battery status for laptops"
echo "  • Plugin ecosystem ready"
echo
echo "⚡ Essential key bindings:"
echo "  tmux              # Start new session"
echo "  tmux new -s work  # Create named session"
echo "  tmux attach -t work # Attach to session"
echo "  Ctrl+a |          # Split vertically"
echo "  Ctrl+a -          # Split horizontally"
echo "  Alt+arrows        # Navigate panes (no prefix!)"
echo "  Shift+arrows      # Switch windows"
echo "  Ctrl+a r          # Reload config"
echo "  Ctrl+a I          # Install plugins (in tmux)"
echo ""
echo "🔧 Next steps:"
echo "  1. Start tmux: tmux"
echo "  2. Install plugins: Press Ctrl+a then I"
echo "  3. Plugins will auto-enable session saving/restore"
echo ""
echo "📚 Full documentation: $SCRIPT_DIR/README.md"