#!/usr/bin/env bash

# Quick Fix for Broken BunkerOS Installation
# Run this if you accidentally installed SDDM via setup.sh and have SwayOSD errors

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║     BunkerOS Installation Quick Fix                        ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Fix 1: Add user to input group for SwayOSD
echo "Step 1: Adding user to input group..."
if ! groups | grep -q '\binput\b'; then
    sudo usermod -a -G input "$USER"
    echo "  ✓ User added to input group"
    NEEDS_RELOGIN=true
else
    echo "  ✓ Already in input group"
fi
echo ""

# Fix 2: Run proper installer to complete setup
echo "Step 2: Running proper installer to complete setup..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [ -f "./install.sh" ]; then
    ./install.sh
else
    echo "  ✗ install.sh not found - are you in the bunkeros directory?"
    exit 1
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║     Fix Complete!                                          ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

if [ "$NEEDS_RELOGIN" = true ]; then
    echo "⚠️  IMPORTANT: You MUST log out and back in for group changes to take effect!"
    echo ""
    echo "Steps:"
    echo "  1. Log out of your current session"
    echo "  2. Log back in"
    echo "  3. SwayOSD will now work"
    echo ""
    echo "After logging back in, verify with: groups | grep input"
else
    echo "✓ All fixes applied! SwayOSD should work now."
fi
echo ""
