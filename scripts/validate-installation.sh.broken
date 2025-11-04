#!/usr/bin/env bash#!/usr/bin/env bash

# BunkerOS Installation Validation Script# BunkerOS Installation Validation Script

##

# This script checks if BunkerOS is properly installed and configured.# This script checks if BunkerOS is properly installed and configured.

# Run this after installation to verify everything is working correctly.# Run this after installation to verify everything is working correctly.



echo "╔════════════════════════════════════════════════════════════╗"set -e

echo "║                                                            ║"

echo "║          BunkerOS Installation Validator                   ║"echo "╔════════════════════════════════════════════════════════════╗"

echo "║                                                            ║"echo "║                                                            ║"

echo "╚════════════════════════════════════════════════════════════╝"echo "║          BunkerOS Installation Validator                   ║"

echo ""echo "║                                                            ║"

echo "╚════════════════════════════════════════════════════════════╝"

PASS="✅"echo ""

FAIL="❌"

WARN="⚠️ "PASS="✅"

FAIL="❌"

# Track issuesWARN="⚠️ "

ERRORS=0INFO="ℹ️ "

WARNINGS=0

FIXES=()# Track issues

ISSUES=0

# Function to check and reportWARNINGS=0

check() {

    local description="$1"# Function to check and report

    local command="$2"check() {

    local fix_command="${3:-}"    local description="$1"

    local is_warning="${4:-false}"    local command="$2"

        local is_warning="${3:-false}"

    echo -n "Checking $description... "    

        echo -n "Checking $description... "

    if eval "$command" &>/dev/null; then    

        echo "$PASS"    if eval "$command" &>/dev/null; then

        return 0        echo "$PASS"

    else        return 0

        if [ "$is_warning" = "true" ]; then    else

            echo "$WARN"        if [ "$is_warning" = "true" ]; then

            ((WARNINGS++))            echo "$WARN"

        else            ((WARNINGS++))

            echo "$FAIL"        else

            ((ERRORS++))            echo "$FAIL"

        fi            ((ISSUES++))

                fi

        if [ -n "$fix_command" ]; then        return 1

            FIXES+=("$description|$fix_command")    fi

        fi}

        return 1

    fiecho "═══════════════════════════════════════════════════════════════"

}echo "1. Core Packages"

echo "═══════════════════════════════════════════════════════════════"

echo "═══════════════════════════════════════════════════════════════"echo ""

echo "1. Core Packages"

echo "═══════════════════════════════════════════════════════════════"check "Sway installed" "command -v sway"

echo ""check "Waybar installed" "command -v waybar"

check "Wofi installed" "command -v wofi"

check "Sway" "pacman -Q sway" "sudo pacman -S sway"check "Foot terminal installed" "command -v foot"

check "Waybar" "pacman -Q waybar" "sudo pacman -S waybar"check "SDDM installed" "command -v sddm"

check "Wofi" "pacman -Q wofi" "sudo pacman -S wofi"

check "Mako" "pacman -Q mako" "sudo pacman -S mako"echo ""

check "Foot terminal" "pacman -Q foot" "sudo pacman -S foot"echo "═══════════════════════════════════════════════════════════════"

check "SwayLock" "pacman -Q swaylock" "sudo pacman -S swaylock"echo "2. Desktop Portal Support"

check "SwayIdle" "pacman -Q swayidle" "sudo pacman -S swayidle"echo "═══════════════════════════════════════════════════════════════"

check "Autotiling" "pacman -Q autotiling-rs" "sudo pacman -S autotiling-rs"echo ""

check "SDDM" "pacman -Q sddm" "sudo pacman -S sddm qt5-declarative qt5-quickcontrols2"

check "SwayOSD" "pacman -Q swayosd-git" "yay -S swayosd-git" "true"check "xdg-desktop-portal" "pacman -Q xdg-desktop-portal"

check "xdg-desktop-portal-wlr" "pacman -Q xdg-desktop-portal-wlr"

echo ""check "xdg-desktop-portal-gtk" "pacman -Q xdg-desktop-portal-gtk"

echo "═══════════════════════════════════════════════════════════════"

echo "2. Audio/Video (PipeWire)"echo ""

echo "═══════════════════════════════════════════════════════════════"echo "═══════════════════════════════════════════════════════════════"

echo ""echo "3. Configuration Files"

echo "═══════════════════════════════════════════════════════════════"

check "PipeWire" "pacman -Q pipewire" "sudo pacman -S pipewire"echo ""

check "PipeWire Pulse" "pacman -Q pipewire-pulse" "sudo pacman -S pipewire-pulse"

check "WirePlumber" "pacman -Q wireplumber" "sudo pacman -S wireplumber"check "Sway config exists" "test -f ~/.config/sway/config"

check "v4l-utils" "pacman -Q v4l-utils" "sudo pacman -S v4l-utils"check "Waybar config exists" "test -f ~/.config/waybar/config"

check "Wofi config exists" "test -f ~/.config/wofi/config"

echo ""check "Foot config exists" "test -f ~/.config/foot/foot.ini"

echo "═══════════════════════════════════════════════════════════════"check "Environment.d config exists" "test -f ~/.config/environment.d/10-bunkeros-wayland.conf"

echo "3. Desktop Portal Support"check "Desktop portal config exists" "test -f ~/.config/xdg-desktop-portal/portals.conf"

echo "═══════════════════════════════════════════════════════════════"

echo ""echo ""

echo "═══════════════════════════════════════════════════════════════"

check "xdg-desktop-portal" "pacman -Q xdg-desktop-portal" "sudo pacman -S xdg-desktop-portal"echo "4. SDDM Configuration"

check "xdg-desktop-portal-wlr" "pacman -Q xdg-desktop-portal-wlr" "sudo pacman -S xdg-desktop-portal-wlr"echo "═══════════════════════════════════════════════════════════════"

check "xdg-desktop-portal-gtk" "pacman -Q xdg-desktop-portal-gtk" "sudo pacman -S xdg-desktop-portal-gtk"echo ""



echo ""check "SDDM service enabled" "systemctl is-enabled sddm.service"

echo "═══════════════════════════════════════════════════════════════"check "BunkerOS session file" "test -f /usr/share/wayland-sessions/bunkeros.desktop"

echo "4. Configuration Files"check "Launch script in /usr/local/bin" "test -f /usr/local/bin/launch-bunkeros.sh"

echo "═══════════════════════════════════════════════════════════════"check "Launch script is executable" "test -x /usr/local/bin/launch-bunkeros.sh"

echo ""

echo ""

check "Sway config" "test -f ~/.config/sway/config" "cd ~/Projects/bunkeros && ./setup.sh"echo "═══════════════════════════════════════════════════════════════"

check "Waybar config" "test -f ~/.config/waybar/config" "cd ~/Projects/bunkeros && ./setup.sh"echo "5. Environment Variables (if in Sway session)"

check "Wofi config" "test -f ~/.config/wofi/config" "cd ~/Projects/bunkeros && ./setup.sh"echo "═══════════════════════════════════════════════════════════════"

check "Mako config" "test -f ~/.config/mako/config" "cd ~/Projects/bunkeros && ./setup.sh"echo ""

check "Foot config" "test -f ~/.config/foot/foot.ini" "cd ~/Projects/bunkeros && ./setup.sh"

check "Environment.d config" "test -f ~/.config/environment.d/10-bunkeros-wayland.conf" "cd ~/Projects/bunkeros && ./setup.sh"if [ -n "$WAYLAND_DISPLAY" ]; then

check "Desktop portal config" "test -f ~/.config/xdg-desktop-portal/portals.conf" "cd ~/Projects/bunkeros/xdg-desktop-portal && ./install.sh"    check "WAYLAND_DISPLAY set" "test -n \"$WAYLAND_DISPLAY\""

check "BunkerOS defaults.conf" "test -f ~/.config/bunkeros/defaults.conf" "cd ~/Projects/bunkeros && ./setup.sh"    check "XDG_CURRENT_DESKTOP set" "test -n \"$XDG_CURRENT_DESKTOP\""

    check "XDG_SESSION_TYPE is wayland" "[ \"$XDG_SESSION_TYPE\" = \"wayland\" ]"

echo ""    check "ELECTRON_OZONE_PLATFORM_HINT set" "test -n \"$ELECTRON_OZONE_PLATFORM_HINT\"" "true"

echo "═══════════════════════════════════════════════════════════════"    

echo "5. Environment.d File Validation"    echo ""

echo "═══════════════════════════════════════════════════════════════"    echo "${INFO}Current environment:"

echo ""    echo "  WAYLAND_DISPLAY: $WAYLAND_DISPLAY"

    echo "  XDG_CURRENT_DESKTOP: $XDG_CURRENT_DESKTOP"

check "Environment.d is regular file (not symlink)" "test -f ~/.config/environment.d/10-bunkeros-wayland.conf && ! test -L ~/.config/environment.d/10-bunkeros-wayland.conf" "cp ~/Projects/bunkeros/environment.d/10-bunkeros-wayland.conf ~/.config/environment.d/10-bunkeros-wayland.conf"    echo "  XDG_SESSION_TYPE: $XDG_SESSION_TYPE"

    echo "  ELECTRON_OZONE_PLATFORM_HINT: $ELECTRON_OZONE_PLATFORM_HINT"

echo ""else

echo "═══════════════════════════════════════════════════════════════"    echo "${INFO}Not running in Wayland session - environment checks skipped"

echo "6. SDDM & Session Configuration"    echo "   (This is normal if you're in TTY or X11)"

echo "═══════════════════════════════════════════════════════════════"fi

echo ""

echo ""

check "SDDM service enabled" "systemctl is-enabled sddm.service" "sudo systemctl enable sddm.service"echo "═══════════════════════════════════════════════════════════════"

check "BunkerOS session file" "test -f /usr/share/wayland-sessions/bunkeros.desktop" "cd ~/Projects/bunkeros/sddm && sudo ./install-theme.sh"echo "6. Audio System"

check "Emergency session file" "test -f /usr/share/wayland-sessions/bunkeros-recovery.desktop" "cd ~/Projects/bunkeros/sddm && sudo ./install-theme.sh"echo "═══════════════════════════════════════════════════════════════"

check "Launch script exists" "test -f /usr/local/bin/launch-bunkeros.sh" "cd ~/Projects/bunkeros/sddm && sudo ./install-theme.sh"echo ""

check "Launch script executable" "test -x /usr/local/bin/launch-bunkeros.sh" "sudo chmod +x /usr/local/bin/launch-bunkeros.sh"

check "Emergency script exists" "test -f /usr/local/bin/launch-bunkeros-emergency.sh" "cd ~/Projects/bunkeros/sddm && sudo ./install-theme.sh"check "PipeWire installed" "pacman -Q pipewire"

check "Emergency script executable" "test -x /usr/local/bin/launch-bunkeros-emergency.sh" "sudo chmod +x /usr/local/bin/launch-bunkeros-emergency.sh"check "PipeWire-Pulse installed" "pacman -Q pipewire-pulse"

check "WirePlumber installed" "pacman -Q wireplumber"

echo ""

echo "═══════════════════════════════════════════════════════════════"if [ -n "$WAYLAND_DISPLAY" ]; then

echo "7. Sway Configuration Validation"    check "PipeWire service running" "systemctl --user is-active pipewire" "true"

echo "═══════════════════════════════════════════════════════════════"    check "PipeWire-Pulse service running" "systemctl --user is-active pipewire-pulse" "true"

echo ""    check "WirePlumber service running" "systemctl --user is-active wireplumber" "true"

fi

if [ -f ~/.config/sway/config ]; then

    echo -n "Validating Sway config syntax... "echo ""

    if sway --validate 2>&1 | grep -q "Configuration OK"; thenecho "═══════════════════════════════════════════════════════════════"

        echo "$PASS"echo "7. BunkerOS Project"

    elseecho "═══════════════════════════════════════════════════════════════"

        echo "$FAIL"echo ""

        echo ""

        echo "Sway config has errors:"# Try to find BunkerOS directory

        sway --validate 2>&1 | head -20BUNKEROS_DIR=""

        ((ERRORS++))if [ -d "$HOME/Projects/bunkeros" ]; then

        FIXES+=("Sway config syntax|Check ~/.config/sway/config for errors")    BUNKEROS_DIR="$HOME/Projects/bunkeros"

    fielif [ -d "$HOME/bunkeros" ]; then

else    BUNKEROS_DIR="$HOME/bunkeros"

    echo "$FAIL Sway config missing"elif [ -d "/opt/bunkeros" ]; then

    ((ERRORS++))    BUNKEROS_DIR="/opt/bunkeros"

fifi



echo ""if [ -n "$BUNKEROS_DIR" ]; then

echo "═══════════════════════════════════════════════════════════════"    echo "${PASS} BunkerOS directory found: $BUNKEROS_DIR"

echo "8. User Services"    check "BunkerOS git repo" "test -d \"$BUNKEROS_DIR/.git\""

echo "═══════════════════════════════════════════════════════════════"else

echo ""    echo "${WARN} BunkerOS directory not found in standard locations"

    echo "   Searched: ~/Projects/bunkeros, ~/bunkeros, /opt/bunkeros"

check "PipeWire service enabled" "systemctl --user is-enabled pipewire.service" "systemctl --user enable pipewire.service" "true"    ((WARNINGS++))

check "PipeWire Pulse enabled" "systemctl --user is-enabled pipewire-pulse.service" "systemctl --user enable pipewire-pulse.service" "true"fi

check "WirePlumber enabled" "systemctl --user is-enabled wireplumber.service" "systemctl --user enable wireplumber.service" "true"

echo ""

echo ""echo "═══════════════════════════════════════════════════════════════"

echo "═══════════════════════════════════════════════════════════════"echo "8. Optional: Electron Apps"

echo "9. Applications"echo "═══════════════════════════════════════════════════════════════"

echo "═══════════════════════════════════════════════════════════════"echo ""

echo ""

check "VS Code installed" "command -v code" "true"

check "Nautilus file manager" "pacman -Q nautilus" "sudo pacman -S nautilus"check "Cursor installed" "command -v cursor" "true"

check "Eye of GNOME (image viewer)" "pacman -Q eog" "sudo pacman -S eog"check "Discord installed" "command -v discord" "true"

check "Evince (PDF viewer)" "pacman -Q evince" "sudo pacman -S evince"

check "Lite-XL (code editor)" "pacman -Q lite-xl" "sudo pacman -S lite-xl"echo ""

check "btop (system monitor)" "pacman -Q btop" "sudo pacman -S btop"echo "╔════════════════════════════════════════════════════════════╗"

check "Nerd Font" "pacman -Q ttf-meslo-nerd" "sudo pacman -S ttf-meslo-nerd" "true"echo "║                    Validation Summary                      ║"

echo "╚════════════════════════════════════════════════════════════╝"

echo ""echo ""

echo "═══════════════════════════════════════════════════════════════"

echo "10. Utilities"if [ $ISSUES -eq 0 ] && [ $WARNINGS -eq 0 ]; then

echo "═══════════════════════════════════════════════════════════════"    echo "${PASS} All checks passed! BunkerOS is properly installed."

echo ""    echo ""

    echo "Next steps:"

check "grim (screenshot)" "pacman -Q grim" "sudo pacman -S grim"    echo "  1. Reboot: sudo reboot"

check "slurp (area selection)" "pacman -Q slurp" "sudo pacman -S slurp"    echo "  2. At login screen, select a BunkerOS session"

check "wl-clipboard" "pacman -Q wl-clipboard" "sudo pacman -S wl-clipboard"    echo "  3. Enjoy your productivity environment!"

check "brightnessctl" "pacman -Q brightnessctl" "sudo pacman -S brightnessctl"    exit 0

check "playerctl" "pacman -Q playerctl" "sudo pacman -S playerctl"elif [ $ISSUES -eq 0 ]; then

check "network-manager-applet" "pacman -Q network-manager-applet" "sudo pacman -S network-manager-applet"    echo "${WARN} $WARNINGS warning(s) found, but installation looks good."

    echo ""

echo ""    echo "The warnings are typically for optional components."

echo "═══════════════════════════════════════════════════════════════"    echo "You can proceed with using BunkerOS."

echo "VALIDATION SUMMARY"    exit 0

echo "═══════════════════════════════════════════════════════════════"else

echo ""    echo "${FAIL} $ISSUES critical issue(s) found!"

    if [ $WARNINGS -gt 0 ]; then

if [ ${#FIXES[@]} -gt 0 ]; then        echo "${WARN} $WARNINGS warning(s) found."

    echo "Issues found that need fixing:"    fi

    echo ""    echo ""

    for fix in "${FIXES[@]}"; do    echo "Recommended actions:"

        IFS='|' read -r desc cmd <<< "$fix"    echo "  1. Review the failed checks above"

        echo "  • $desc"    echo "  2. Re-run: cd ~/Projects/bunkeros && ./install.sh"

        echo "    Fix: $cmd"    echo "  3. Check TROUBLESHOOTING.md for specific issues"

        echo ""    echo "  4. Run this validation script again"

    done    exit 1

fifi


echo "Summary:"
echo "  Errors: $ERRORS"
echo "  Warnings: $WARNINGS"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo "$PASS Installation appears valid!"
    echo ""
    echo "Next steps:"
    echo "  1. Log out of your current session"
    echo "  2. At the login screen, select 'BunkerOS' session"
    echo "  3. Log in with your credentials"
    echo ""
    echo "If you encounter issues:"
    echo "  • Use 'BunkerOS Emergency' session for recovery"
    echo "  • Check logs: journalctl --user -b"
    echo "  • Re-run this validator: ~/Projects/bunkeros/scripts/validate-installation.sh"
    exit 0
else
    echo "$FAIL Installation has errors that need fixing"
    echo ""
    echo "Please fix the errors above and run this script again:"
    echo "  ~/Projects/bunkeros/scripts/validate-installation.sh"
    echo ""
    exit 1
fi
