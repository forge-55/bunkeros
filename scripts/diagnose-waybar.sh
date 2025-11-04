#!/usr/bin/env bash

# BunkerOS Waybar Diagnostic and Fix Script

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║     BunkerOS Waybar Diagnostic                             ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if Waybar is installed
echo "1. Checking if Waybar is installed..."
if command -v waybar &>/dev/null; then
    echo "  ✓ Waybar is installed: $(which waybar)"
else
    echo "  ✗ Waybar is NOT installed"
    echo ""
    echo "  Fix: sudo pacman -S waybar"
    exit 1
fi
echo ""

# Check if Waybar config exists
echo "2. Checking Waybar configuration..."
if [ -f "$HOME/.config/waybar/config" ]; then
    echo "  ✓ Waybar config exists: ~/.config/waybar/config"
else
    echo "  ✗ Waybar config is MISSING"
    echo ""
    echo "  Fix: Re-run setup"
    echo "    cd ~/Projects/bunkeros"
    echo "    ./setup.sh"
    exit 1
fi
echo ""

# Check if Waybar style exists
echo "3. Checking Waybar style..."
if [ -f "$HOME/.config/waybar/style.css" ]; then
    echo "  ✓ Waybar style exists: ~/.config/waybar/style.css"
else
    echo "  ✗ Waybar style is MISSING"
    echo ""
    echo "  Fix: Re-run setup"
    echo "    cd ~/Projects/bunkeros"
    echo "    ./setup.sh"
    exit 1
fi
echo ""

# Check if Waybar is running
echo "4. Checking if Waybar is running..."
if pgrep -x waybar >/dev/null; then
    echo "  ✓ Waybar is running (PID: $(pgrep -x waybar))"
    echo ""
    echo "  Checking for errors..."
    journalctl --user -u waybar -n 20 --no-pager 2>/dev/null || echo "  (No systemd service logs)"
else
    echo "  ✗ Waybar is NOT running"
    echo ""
    echo "  Trying to start Waybar..."
    if waybar &>/dev/null & then
        sleep 1
        if pgrep -x waybar >/dev/null; then
            echo "  ✓ Waybar started successfully!"
        else
            echo "  ✗ Waybar failed to start"
            echo ""
            echo "  Check errors:"
            waybar 2>&1 | head -20
            exit 1
        fi
    fi
fi
echo ""

# Check Sway config for Waybar launch
echo "5. Checking Sway config for Waybar..."
if grep -q "exec.*waybar" "$HOME/.config/sway/config"; then
    echo "  ✓ Sway config launches Waybar"
else
    echo "  ✗ Sway config does NOT launch Waybar"
    echo ""
    echo "  Fix: Waybar should be launched by Sway config"
    echo "  Add to ~/.config/sway/config:"
    echo '    exec_always "killall -9 waybar 2>/dev/null; sleep 0.5; waybar -b bar-0 >/dev/null 2>&1 &"'
    exit 1
fi
echo ""

# Check if Waybar scripts exist
echo "6. Checking Waybar scripts..."
SCRIPT_COUNT=$(find "$HOME/.config/waybar/scripts" -name "*.sh" 2>/dev/null | wc -l)
if [ "$SCRIPT_COUNT" -gt 0 ]; then
    echo "  ✓ Found $SCRIPT_COUNT Waybar scripts"
else
    echo "  ⚠ No Waybar scripts found (might be normal)"
fi
echo ""

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║     Waybar Diagnostic Complete                             ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "✓ All checks passed! Waybar should be working."
echo ""
echo "If Waybar is still not visible:"
echo "  1. Reload Sway: Super+Shift+R"
echo "  2. Restart Waybar: killall waybar && waybar &"
echo "  3. Check display scaling (might be off-screen)"
echo ""
