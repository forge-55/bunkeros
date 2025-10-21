#!/usr/bin/env bash

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== BunkerOS System Services Installation ==="
echo ""

# SDDM theme and sessions
echo "Installing SDDM theme and session files..."
echo ""
read -p "Install SDDM theme? (requires sudo) (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd "$PROJECT_DIR/sddm"
    ./install-theme.sh
    echo ""
    echo "✓ SDDM theme and sessions installed"
    echo ""
    echo "To enable SDDM as your display manager:"
    echo "  sudo systemctl enable sddm.service"
    echo "  sudo systemctl start sddm.service"
else
    echo "⚠ Skipping SDDM installation"
    echo ""
    echo "You can install it later with:"
    echo "  cd $PROJECT_DIR/sddm"
    echo "  ./install-theme.sh"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ System services installation complete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
