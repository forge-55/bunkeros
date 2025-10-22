#!/usr/bin/env bash
# BunkerOS SDDM Login Diagnostic Script
# Run this from TTY if you get black screen after login

echo "=== BunkerOS SDDM Login Diagnostic ==="
echo ""
echo "Date: $(date)"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check 1: SwayFX Installation
echo "1. Checking SwayFX Installation..."
if command -v sway &> /dev/null; then
    SWAY_PATH=$(which sway)
    check_pass "sway found at: $SWAY_PATH"
    
    if pacman -Q swayfx &> /dev/null; then
        SWAYFX_VERSION=$(pacman -Q swayfx)
        check_pass "SwayFX installed: $SWAYFX_VERSION"
    else
        check_warn "sway found but swayfx package not detected"
        echo "  You may have vanilla sway instead of swayfx"
    fi
else
    check_fail "sway/swayfx NOT FOUND"
    echo "  FIX: Install SwayFX with: yay -S swayfx"
    NEEDS_SWAYFX=true
fi
echo ""

# Check 2: Launch Scripts
echo "2. Checking Launch Scripts..."
if [ -f /usr/local/bin/launch-bunkeros-standard.sh ]; then
    check_pass "Standard launcher found"
    if [ -x /usr/local/bin/launch-bunkeros-standard.sh ]; then
        check_pass "Standard launcher is executable"
    else
        check_fail "Standard launcher is NOT executable"
        echo "  FIX: sudo chmod +x /usr/local/bin/launch-bunkeros-standard.sh"
    fi
else
    check_fail "Standard launcher NOT FOUND"
    echo "  FIX: sudo cp ~/Projects/bunkeros/scripts/launch-bunkeros-standard.sh /usr/local/bin/"
fi

if [ -f /usr/local/bin/launch-bunkeros-enhanced.sh ]; then
    check_pass "Enhanced launcher found"
    if [ -x /usr/local/bin/launch-bunkeros-enhanced.sh ]; then
        check_pass "Enhanced launcher is executable"
    else
        check_fail "Enhanced launcher is NOT executable"
        echo "  FIX: sudo chmod +x /usr/local/bin/launch-bunkeros-enhanced.sh"
    fi
else
    check_fail "Enhanced launcher NOT FOUND"
    echo "  FIX: sudo cp ~/Projects/bunkeros/scripts/launch-bunkeros-enhanced.sh /usr/local/bin/"
fi
echo ""

# Check 3: Session Files
echo "3. Checking SDDM Session Files..."
if [ -f /usr/share/wayland-sessions/bunkeros-standard.desktop ]; then
    check_pass "Standard session file found"
else
    check_fail "Standard session file NOT FOUND"
    echo "  FIX: sudo cp ~/Projects/bunkeros/sddm/sessions/bunkeros-standard.desktop /usr/share/wayland-sessions/"
fi

if [ -f /usr/share/wayland-sessions/bunkeros-enhanced.desktop ]; then
    check_pass "Enhanced session file found"
else
    check_fail "Enhanced session file NOT FOUND"
    echo "  FIX: sudo cp ~/Projects/bunkeros/sddm/sessions/bunkeros-enhanced.desktop /usr/share/wayland-sessions/"
fi
echo ""

# Check 4: Sway Config
echo "4. Checking Sway Configuration..."
if [ -f ~/.config/sway/config ]; then
    check_pass "Sway config found"
    
    if command -v sway &> /dev/null; then
        if sway --validate 2>&1 | grep -q "Error"; then
            check_fail "Sway config has ERRORS"
            echo "  Run: sway --validate"
            echo "  Check your config at: ~/.config/sway/config"
        else
            check_pass "Sway config is valid"
        fi
    fi
else
    check_fail "Sway config NOT FOUND"
    echo "  FIX: Run ~/Projects/bunkeros/setup.sh"
fi
echo ""

# Check 5: Dependencies
echo "5. Checking Key Dependencies..."
DEPS=(waybar wofi mako foot swaybg swaylock swayidle)
for dep in "${DEPS[@]}"; do
    if command -v $dep &> /dev/null; then
        check_pass "$dep installed"
    else
        check_warn "$dep NOT installed"
        echo "  FIX: bash ~/Projects/bunkeros/scripts/install-dependencies.sh"
    fi
done
echo ""

# Check 6: Graphics
echo "6. Checking Graphics..."
if lspci | grep -i vga &> /dev/null; then
    GPU=$(lspci | grep -i vga | cut -d: -f3)
    echo "  GPU:$GPU"
    
    if lspci | grep -i vga | grep -i intel &> /dev/null; then
        if pacman -Q mesa &> /dev/null; then
            check_pass "Intel GPU with mesa driver"
        else
            check_warn "Intel GPU but mesa not installed"
            echo "  FIX: sudo pacman -S mesa vulkan-intel"
        fi
    elif lspci | grep -i vga | grep -i amd &> /dev/null; then
        if pacman -Q mesa &> /dev/null; then
            check_pass "AMD GPU with mesa driver"
        else
            check_warn "AMD GPU but mesa not installed"
            echo "  FIX: sudo pacman -S mesa vulkan-radeon"
        fi
    elif lspci | grep -i vga | grep -i nvidia &> /dev/null; then
        check_warn "NVIDIA GPU detected"
        echo "  NOTE: Wayland on NVIDIA requires special setup"
        echo "  Consider using nouveau driver or check Arch Wiki for nvidia-wayland setup"
    fi
else
    check_warn "Could not detect GPU"
fi
echo ""

# Check 7: SDDM Service
echo "7. Checking SDDM Service..."
if systemctl is-enabled sddm &> /dev/null; then
    check_pass "SDDM is enabled"
else
    check_warn "SDDM is not enabled"
    echo "  FIX: sudo systemctl enable sddm"
fi

if systemctl is-active sddm &> /dev/null; then
    check_pass "SDDM is running"
else
    check_warn "SDDM is not running"
    echo "  FIX: sudo systemctl start sddm"
fi
echo ""

# Summary and Recommendations
echo "=== SUMMARY ==="
echo ""

if [ "$NEEDS_SWAYFX" = true ]; then
    echo -e "${RED}CRITICAL:${NC} SwayFX is not installed!"
    echo "This is the most likely cause of the black screen."
    echo ""
    echo "FIX NOW:"
    echo "  yay -S swayfx"
    echo "  # or: paru -S swayfx"
    echo ""
fi

echo "To test if Sway works manually:"
echo "  sway"
echo ""
echo "To reinstall all BunkerOS components:"
echo "  cd ~/Projects/bunkeros"
echo "  bash scripts/install-system-services.sh"
echo ""
echo "To view detailed error logs:"
echo "  cat /tmp/bunkeros-launch-error.log"
echo "  sudo journalctl -u sddm -n 50"
echo "  journalctl --user -b | grep -i sway"
echo ""
echo "For full troubleshooting guide, see:"
echo "  ~/Projects/bunkeros/TROUBLESHOOTING.md"
echo ""
