#!/usr/bin/env bash

# BunkerOS Session Test Script
# Test BunkerOS launch scripts without logging out

echo "=== BunkerOS Session Test ==="
echo ""

echo "Testing BunkerOS launch scripts..."
echo ""

# Test Standard Edition script
echo "1. Testing Standard Edition launcher:"
if [ -f "/usr/local/bin/launch-bunkeros-standard.sh" ]; then
    echo "   ✓ Script exists: /usr/local/bin/launch-bunkeros-standard.sh"
    if [ -x "/usr/local/bin/launch-bunkeros-standard.sh" ]; then
        echo "   ✓ Script is executable"
        
        # Test script syntax without executing
        if bash -n /usr/local/bin/launch-bunkeros-standard.sh; then
            echo "   ✓ Script syntax is valid"
        else
            echo "   ❌ Script has syntax errors"
        fi
    else
        echo "   ❌ Script is not executable"
    fi
else
    echo "   ❌ Script not found"
fi

echo ""

# Test Enhanced Edition script
echo "2. Testing Enhanced Edition launcher:"
if [ -f "/usr/local/bin/launch-bunkeros-enhanced.sh" ]; then
    echo "   ✓ Script exists: /usr/local/bin/launch-bunkeros-enhanced.sh"
    if [ -x "/usr/local/bin/launch-bunkeros-enhanced.sh" ]; then
        echo "   ✓ Script is executable"
        
        # Test script syntax without executing
        if bash -n /usr/local/bin/launch-bunkeros-enhanced.sh; then
            echo "   ✓ Script syntax is valid"
        else
            echo "   ❌ Script has syntax errors"
        fi
    else
        echo "   ❌ Script is not executable"
    fi
else
    echo "   ❌ Script not found"
fi

echo ""

# Test Sway availability
echo "3. Testing Sway installation:"
if command -v sway &> /dev/null; then
    echo "   ✓ sway command found in PATH"
    sway_version=$(sway --version 2>/dev/null || echo "unknown")
    echo "   Version: $sway_version"
else
    echo "   ❌ sway not found in PATH"
    echo "   Install with: sudo pacman -S sway"
fi

echo ""

# Test session files
echo "4. Testing SDDM session files:"
for session in standard enhanced; do
    session_file="/usr/share/wayland-sessions/bunkeros-${session}.desktop"
    if [ -f "$session_file" ]; then
        echo "   ✓ Session file exists: bunkeros-${session}.desktop"
        # Check if it points to the right script
        if grep -q "/usr/local/bin/launch-bunkeros-${session}.sh" "$session_file"; then
            echo "   ✓ Points to correct launch script"
        else
            echo "   ⚠️  May point to wrong script path"
        fi
    else
        echo "   ❌ Session file missing: bunkeros-${session}.desktop"
    fi
done

echo ""

# Test BunkerOS directory detection
echo "5. Testing BunkerOS directory detection:"
if [ -d "$HOME/Projects/bunkeros" ]; then
    echo "   ✓ Found BunkerOS directory: $HOME/Projects/bunkeros"
    if [ -f "$HOME/Projects/bunkeros/sway/config" ]; then
        echo "   ✓ Sway config file exists"
    else
        echo "   ⚠️  Sway config file missing"
    fi
else
    echo "   ⚠️  BunkerOS directory not found in $HOME/Projects/bunkeros"
fi

echo ""
echo "=== Test Complete ==="
echo ""

# Check for any previous launch errors
if [ -f "/tmp/bunkeros-launch-error.log" ]; then
    echo "Previous launch error log found:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    cat /tmp/bunkeros-launch-error.log
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "You may want to remove this log: rm /tmp/bunkeros-launch-error.log"
fi

echo "If all tests pass, BunkerOS sessions should work correctly."
echo "You can now safely log out and select a BunkerOS session."