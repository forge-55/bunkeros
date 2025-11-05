#!/bin/bash
# Install BunkerOS swaylock configuration

CONFIG_DIR="$HOME/.config/swaylock"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing BunkerOS swaylock configuration..."

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Copy configuration
cp "$SCRIPT_DIR/config" "$CONFIG_DIR/config"

# Install lock wrapper script
mkdir -p "$HOME/.local/bin"
cp "$SCRIPT_DIR/lock.sh" "$HOME/.local/bin/bunkeros-lock"
chmod +x "$HOME/.local/bin/bunkeros-lock"

echo "✓ Swaylock configuration installed to $CONFIG_DIR/config"
echo "✓ Lock script installed to $HOME/.local/bin/bunkeros-lock"
echo ""
echo "The lock screen now uses the BunkerOS tactical theme:"
echo "  - Tactical wallpaper background"
echo "  - Tactical tan (#C3B091) ring that lights up when typing"
echo "  - Larger indicator (150px) for better visibility"
echo "  - Clear text feedback (verifying, wrong, caps lock)"
echo ""
echo "Test it with: bunkeros-lock"
echo "Or use standard: swaylock"
