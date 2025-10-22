#!/usr/bin/env bash

# BunkerOS Session Debug Script
# Advanced troubleshooting for session launch issues

echo "=== BunkerOS Session Debug Analysis ==="
echo ""

LOG_FILE="/tmp/bunkeros-debug-$(date +%Y%m%d-%H%M%S).log"
echo "Debug log: $LOG_FILE"
echo ""

# Function to log and display
log_and_echo() {
    echo "$1" | tee -a "$LOG_FILE"
}

log_and_echo "=== System Information ==="
log_and_echo "Date: $(date)"
log_and_echo "User: $(whoami)"
log_and_echo "Current session: $XDG_SESSION_TYPE"
log_and_echo "Display: $WAYLAND_DISPLAY"
log_and_echo ""

log_and_echo "=== Launch Script Analysis ==="

# Test both launch scripts with more detail
for edition in standard enhanced; do
    script_path="/usr/local/bin/launch-bunkeros-${edition}.sh"
    log_and_echo "Testing $edition edition:"
    
    if [ -f "$script_path" ]; then
        log_and_echo "  ✓ Script exists: $script_path"
        
        # Check permissions
        perms=$(ls -l "$script_path" | cut -d' ' -f1)
        log_and_echo "  Permissions: $perms"
        
        # Check for bash syntax errors
        if bash -n "$script_path" 2>/dev/null; then
            log_and_echo "  ✓ Syntax valid"
        else
            log_and_echo "  ❌ Syntax errors:"
            bash -n "$script_path" 2>&1 | tee -a "$LOG_FILE"
        fi
        
        # Test environment variable setting
        log_and_echo "  Testing environment setup..."
        source "$script_path" --help &>/dev/null
        if [ $? -eq 0 ]; then
            log_and_echo "  ✓ Environment setup works"
        else
            log_and_echo "  ❌ Environment setup failed"
        fi
        
    else
        log_and_echo "  ❌ Script missing: $script_path"
    fi
    log_and_echo ""
done

log_and_echo "=== SDDM Session Files ==="
for edition in standard enhanced; do
    session_file="/usr/share/wayland-sessions/bunkeros-${edition}.desktop"
    if [ -f "$session_file" ]; then
        log_and_echo "Session file: bunkeros-${edition}.desktop"
        cat "$session_file" | tee -a "$LOG_FILE"
        log_and_echo ""
    else
        log_and_echo "❌ Missing session file: $session_file"
    fi
done

log_and_echo "=== SwayFX Installation Check ==="
if command -v sway &>/dev/null; then
    sway_path=$(which sway)
    sway_version=$(sway --version 2>/dev/null)
    log_and_echo "✓ Sway found: $sway_path"
    log_and_echo "Version: $sway_version"
    
    # Check if it's actually SwayFX
    if sway --version 2>&1 | grep -q "swayfx"; then
        log_and_echo "✓ SwayFX confirmed"
    else
        log_and_echo "⚠️  This appears to be vanilla Sway, not SwayFX"
    fi
else
    log_and_echo "❌ Sway/SwayFX not found in PATH"
fi
log_and_echo ""

log_and_echo "=== Graphics and Display Check ==="
log_and_echo "GPU devices:"
ls -la /dev/dri/ 2>&1 | tee -a "$LOG_FILE"
log_and_echo ""

log_and_echo "Graphics driver info:"
lspci | grep -i vga | tee -a "$LOG_FILE"
log_and_echo ""

log_and_echo "=== Wayland Compositor Test ==="
log_and_echo "Testing if Sway can start in validation mode..."
if timeout 10s sway -C 2>/dev/null; then
    log_and_echo "✓ Sway validation passed"
else
    log_and_echo "❌ Sway validation failed:"
    timeout 10s sway -C 2>&1 | tee -a "$LOG_FILE"
fi
log_and_echo ""

log_and_echo "=== Recent System Logs ==="
log_and_echo "Checking for recent Sway/Wayland related errors..."
journalctl --user --since "1 hour ago" | grep -i "sway\|wayland\|error" | tail -10 | tee -a "$LOG_FILE"
log_and_echo ""

log_and_echo "=== Environment Variables Test ==="
log_and_echo "Testing environment variables that would be set by launch scripts:"

# Simulate the environment setup
export WAYLAND_DISPLAY=wayland-1
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=sway
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export MOZ_ENABLE_WAYLAND=1
export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland
export ELECTRON_OZONE_PLATFORM_HINT=auto

env | grep -E "(WAYLAND|XDG|QT|MOZ|SDL|CLUTTER|ELECTRON)" | sort | tee -a "$LOG_FILE"
log_and_echo ""

log_and_echo "=== Recommendations ==="
log_and_echo ""

# Check for common issues
if ! sway --version 2>&1 | grep -q "swayfx"; then
    log_and_echo "❌ CRITICAL: You have vanilla Sway instead of SwayFX!"
    log_and_echo "   Solution: sudo pacman -S swayfx"
    log_and_echo ""
fi

if [ ! -f "/usr/local/bin/launch-bunkeros-standard.sh" ] || [ ! -f "/usr/local/bin/launch-bunkeros-enhanced.sh" ]; then
    log_and_echo "❌ CRITICAL: Launch scripts missing!"
    log_and_echo "   Solution: cd ~/Projects/bunkeros/sddm && sudo ./install-theme.sh"
    log_and_echo ""
fi

log_and_echo "=== Manual Test Suggestion ==="
log_and_echo ""
log_and_echo "Try starting Sway manually from TTY to see detailed error messages:"
log_and_echo "1. Switch to TTY: Ctrl+Alt+F2"
log_and_echo "2. Login with your username/password"
log_and_echo "3. Run: sway"
log_and_echo "4. If errors appear, they will show the exact problem"
log_and_echo "5. Exit with: Ctrl+Alt+F1 to return to SDDM"
log_and_echo ""

log_and_echo "Debug analysis complete. Log saved to: $LOG_FILE"