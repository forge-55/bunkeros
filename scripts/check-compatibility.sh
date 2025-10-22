#!/usr/bin/env bash

# BunkerOS Pre-Installation Compatibility Checker
# Checks system compatibility before installation

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║              BunkerOS Compatibility Check                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

PASS="✅"
FAIL="❌"
WARN="⚠️ "
INFO="ℹ️ "

# Track issues
CRITICAL_ISSUES=0
WARNINGS=0

# Function to check and report
check() {
    local description="$1"
    local command="$2"
    local is_critical="${3:-true}"
    
    echo -n "Checking $description... "
    
    if eval "$command" &>/dev/null; then
        echo "$PASS"
        return 0
    else
        if [ "$is_critical" = "true" ]; then
            echo "$FAIL"
            ((CRITICAL_ISSUES++))
        else
            echo "$WARN"
            ((WARNINGS++))
        fi
        return 1
    fi
}

echo "System Compatibility:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

check "Arch-based system (pacman)" "command -v pacman"
check "Systemd" "command -v systemctl"
check "Wayland support" "[ -n \"\$WAYLAND_DISPLAY\" ] || command -v weston"
check "User in wheel group" "groups | grep -q wheel" "false"

echo ""
echo "Network and Package Management:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

check "Internet connectivity" "ping -c 1 archlinux.org"
check "Package database updated" "[ -f /var/lib/pacman/sync/core.db ]" "false"
check "AUR helper (yay/paru)" "command -v yay || command -v paru" "false"

echo ""
echo "Display and Audio:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

check "Graphics drivers" "ls /dev/dri/card* 2>/dev/null | head -1" "false"
check "Audio system" "ls /dev/snd/ 2>/dev/null | grep -q ." "false"

echo ""
echo "Existing Configuration:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -d "$HOME/.config/sway" ]; then
    echo "${WARN} Existing Sway configuration found"
    ((WARNINGS++))
fi

if systemctl is-enabled gdm.service &>/dev/null; then
    echo "${INFO} Current display manager: GDM"
elif systemctl is-enabled sddm.service &>/dev/null; then
    echo "${INFO} Current display manager: SDDM (compatible)"
elif systemctl is-enabled lightdm.service &>/dev/null; then
    echo "${INFO} Current display manager: LightDM"
elif systemctl is-enabled ly.service &>/dev/null; then
    echo "${INFO} Current display manager: ly"
else
    echo "${INFO} No display manager detected"
fi

echo ""
echo "Disk Space:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

HOME_SPACE=$(df -h "$HOME" | awk 'NR==2 {print $4}')
ROOT_SPACE=$(df -h / | awk 'NR==2 {print $4}')

echo "${INFO} Home directory free space: $HOME_SPACE"
echo "${INFO} Root filesystem free space: $ROOT_SPACE"

# Check minimum space requirements
HOME_SPACE_MB=$(df "$HOME" | awk 'NR==2 {print $4}')
if [ "$HOME_SPACE_MB" -lt 1048576 ]; then  # 1GB in KB
    echo "${WARN} Less than 1GB free in home directory"
    ((WARNINGS++))
fi

echo ""
echo "Summary:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $CRITICAL_ISSUES -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "${PASS} System is fully compatible with BunkerOS!"
    echo ""
    echo "Ready to install! Run:"
    echo "  ./install-robust.sh"
    exit 0
elif [ $CRITICAL_ISSUES -eq 0 ]; then
    echo "${WARN} System is compatible with $WARNINGS warning(s)"
    echo ""
    echo "You can proceed with installation, but address warnings if possible."
    echo ""
    echo "Ready to install! Run:"
    echo "  ./install-robust.sh"
    exit 0
else
    echo "${FAIL} $CRITICAL_ISSUES critical issue(s) found"
    if [ $WARNINGS -gt 0 ]; then
        echo "${WARN} $WARNINGS warning(s) found"
    fi
    echo ""
    echo "Please fix critical issues before installing BunkerOS."
    echo ""
    echo "Common fixes:"
    echo "  • Update package database: sudo pacman -Sy"
    echo "  • Install AUR helper: git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si"
    echo "  • Check internet connection"
    exit 1
fi