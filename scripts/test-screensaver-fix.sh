#!/bin/bash
# BunkerOS Screensaver Fix - Quick Test Script
# This script helps you test the screensaver and suspend fixes

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║   BunkerOS Screensaver Fix - Diagnostic & Test Tool           ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test 1: Check for sleep inhibitors
echo -e "${BLUE}[TEST 1]${NC} Checking for sleep inhibitors..."
SLEEP_INHIBITORS=$(systemd-inhibit --list 2>/dev/null | grep -i "sleep.*swayidle" || true)
if [ -z "$SLEEP_INHIBITORS" ]; then
    echo -e "${GREEN}✓ PASS${NC} - No sleep inhibitors from swayidle"
else
    echo -e "${RED}✗ FAIL${NC} - swayidle is creating sleep inhibitors:"
    echo "$SLEEP_INHIBITORS"
    echo -e "${YELLOW}  This will prevent suspend from working!${NC}"
fi
echo

# Test 2: Check swayidle configuration
echo -e "${BLUE}[TEST 2]${NC} Checking swayidle process..."
SWAYIDLE_PROC=$(ps aux | grep "swayidle" | grep -v grep || true)
if [ -n "$SWAYIDLE_PROC" ]; then
    echo -e "${GREEN}✓ PASS${NC} - swayidle is running"
    echo "$SWAYIDLE_PROC"
    
    # Check if it has -w flag (bad!)
    if echo "$SWAYIDLE_PROC" | grep -q "\-w"; then
        echo -e "${RED}✗ WARNING${NC} - swayidle is using -w flag!"
        echo -e "${YELLOW}  This will prevent suspend. Reload sway config!${NC}"
    else
        echo -e "${GREEN}✓ GOOD${NC} - No -w flag detected"
    fi
else
    echo -e "${RED}✗ FAIL${NC} - swayidle is not running"
fi
echo

# Test 3: Count monitors
echo -e "${BLUE}[TEST 3]${NC} Detecting monitors..."
if command -v swaymsg &> /dev/null; then
    MONITOR_COUNT=$(swaymsg -t get_outputs | jq -r '.[].name' | wc -l)
    echo -e "${GREEN}✓ FOUND${NC} - Detected $MONITOR_COUNT monitor(s):"
    swaymsg -t get_outputs | jq -r '.[].name' | while read -r output; do
        echo "  - $output"
    done
else
    echo -e "${YELLOW}⚠ SKIP${NC} - swaymsg not available (not in Sway?)"
fi
echo

# Test 4: Check systemd-logind idle action
echo -e "${BLUE}[TEST 4]${NC} Checking systemd-logind idle configuration..."
SESSION_ID=$(loginctl | grep $(whoami) | awk '{print $1}' | head -1)
if [ -n "$SESSION_ID" ]; then
    IDLE_ACTION=$(loginctl show-session "$SESSION_ID" | grep "^IdleAction=" | cut -d= -f2)
    echo "  Session: $SESSION_ID"
    echo "  IdleAction: $IDLE_ACTION"
    
    if [ "$IDLE_ACTION" = "ignore" ]; then
        echo -e "${GREEN}✓ GOOD${NC} - IdleAction is 'ignore' (swayidle will handle suspend)"
    elif [ "$IDLE_ACTION" = "suspend" ]; then
        echo -e "${YELLOW}⚠ WARNING${NC} - IdleAction is 'suspend' (may conflict with swayidle)"
        echo -e "${YELLOW}  Consider setting IdleAction=ignore in logind.conf${NC}"
    fi
else
    echo -e "${YELLOW}⚠ SKIP${NC} - Could not detect session ID"
fi
echo

# Test 5: Check for dependencies
echo -e "${BLUE}[TEST 5]${NC} Checking dependencies..."
DEPS_OK=true

if command -v jq &> /dev/null; then
    echo -e "${GREEN}✓ FOUND${NC} - jq (required for multi-monitor)"
else
    echo -e "${RED}✗ MISSING${NC} - jq (install with: sudo pacman -S jq)"
    DEPS_OK=false
fi

if command -v foot &> /dev/null; then
    echo -e "${GREEN}✓ FOUND${NC} - foot terminal"
else
    echo -e "${RED}✗ MISSING${NC} - foot terminal"
    DEPS_OK=false
fi

if command -v swayidle &> /dev/null; then
    echo -e "${GREEN}✓ FOUND${NC} - swayidle"
else
    echo -e "${RED}✗ MISSING${NC} - swayidle"
    DEPS_OK=false
fi
echo

# Test 6: Check screensaver script exists
echo -e "${BLUE}[TEST 6]${NC} Checking screensaver scripts..."
SCRIPT_LOCATIONS=(
    "$HOME/.config/sway-config/scripts/bunkeros-screensaver.sh"
    "$HOME/Projects/bunkeros/scripts/bunkeros-screensaver.sh"
)

for SCRIPT in "${SCRIPT_LOCATIONS[@]}"; do
    if [ -f "$SCRIPT" ]; then
        echo -e "${GREEN}✓ FOUND${NC} - $SCRIPT"
    else
        echo -e "${YELLOW}⚠ NOT FOUND${NC} - $SCRIPT"
    fi
done
echo

# Summary
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║   QUICK TEST OPTIONS                                           ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo
echo "To test with SHORT timeouts (30s screensaver, 60s suspend):"
echo -e "${YELLOW}killall swayidle 2>/dev/null"
echo "swayidle \\"
echo "    timeout 30 '\$HOME/.config/sway-config/scripts/launch-screensaver.sh' \\"
echo "    timeout 60 'systemctl suspend' \\"
echo "    resume 'swaymsg \"[app_id=BunkerOS-Screensaver]\" kill' &"
echo -e "${NC}"
echo "Then wait 30 seconds without touching anything."
echo

# Interactive test option
echo -e "${BLUE}Would you like to run a quick test now? (y/N)${NC}"
read -r -n 1 RESPONSE
echo

if [[ "$RESPONSE" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Starting quick test with 30s timeout...${NC}"
    echo "Don't touch anything for 30 seconds!"
    echo
    
    # Kill existing swayidle
    killall swayidle 2>/dev/null || true
    sleep 1
    
    # Start test swayidle
    swayidle \
        timeout 30 "$HOME/.config/sway-config/scripts/launch-screensaver.sh" \
        timeout 60 'echo "Would suspend now (test mode - not suspending)"' \
        resume 'swaymsg "[app_id=BunkerOS-Screensaver]" kill' &
    
    echo -e "${GREEN}Test swayidle started!${NC}"
    echo "Wait 30 seconds to see screensaver..."
    echo "Press Ctrl+C to cancel test"
    echo
    
    # Wait for user
    sleep 30
    echo "Screensaver should be visible now!"
    echo "Press any key in the screensaver to exit test..."
    wait
else
    echo "Test skipped. You can run it manually later."
fi

echo
echo -e "${GREEN}Diagnostic complete!${NC}"
echo "See docs/troubleshooting/SCREENSAVER-FIX.md for full documentation."
