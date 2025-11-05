#!/bin/bash
# Quick test of screensaver and suspend with SHORT timeouts

echo "════════════════════════════════════════════════════════════"
echo "  BunkerOS Screensaver & Suspend - QUICK TEST"
echo "════════════════════════════════════════════════════════════"
echo
echo "This will test the screensaver and suspend with SHORT timeouts:"
echo "  - 30 seconds: Screensaver activates"
echo "  - 60 seconds: System would suspend (we'll use a test command instead)"
echo
echo "Press Ctrl+C to cancel, or Enter to continue..."
read

# Kill existing swayidle
echo "Stopping existing swayidle..."
killall swayidle 2>/dev/null
sleep 1

# Start test swayidle
echo "Starting test swayidle with 30s timeout..."
echo "DON'T TOUCH ANYTHING for 30 seconds!"
echo

swayidle \
    timeout 30 "swaymsg seat seat0 hide_cursor 0; ~/.config/sway-config/scripts/launch-screensaver.sh" \
    timeout 60 "systemctl suspend" \
    resume "swaymsg \"[app_id=^BunkerOS-Screensaver.*]\" kill; swaymsg seat seat0 hide_cursor 3000" \
    before-sleep "swaymsg \"[app_id=^BunkerOS-Screensaver.*]\" kill" &

TEST_PID=$!

echo "Test swayidle started (PID: $TEST_PID)"
echo
echo "Timeline:"
echo "  0s - Now (don't touch anything!)"
echo " 30s - Screensaver should appear on all monitors"
echo " 60s - System will ACTUALLY SUSPEND (wake with power button)"
echo
echo "WARNING: This will actually suspend your system at 60s!"
echo "Press Ctrl+C NOW if you don't want to test suspend"
sleep 3
echo
echo "To test screensaver exit: Press any key while screensaver is active"
echo
echo "Press Ctrl+C to stop the test early"

# Wait for user to interrupt
wait $TEST_PID 2>/dev/null

echo
echo "Test completed or interrupted."
echo
echo "To restore normal operation, reload sway config:"
echo "  swaymsg reload"
