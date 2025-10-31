#!/bin/bash
# Install BunkerOS systemd-logind power management configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Installing BunkerOS Power Management ==="
echo ""

# Create logind config directory if it doesn't exist
if [ ! -d "/etc/systemd/logind.conf.d" ]; then
    echo "Creating /etc/systemd/logind.conf.d directory..."
    sudo mkdir -p /etc/systemd/logind.conf.d
fi

# Install power management configuration
echo "Installing systemd-logind configuration..."
sudo cp "$PROJECT_DIR/systemd/logind.conf.d/bunkeros-power.conf" /etc/systemd/logind.conf.d/

echo "Configuration installed to: /etc/systemd/logind.conf.d/bunkeros-power.conf"
echo ""

# CPU Power Management (for laptops)
echo "=== CPU Power Management (Optional) ==="
echo ""
echo "For laptops, you can install additional CPU power management tools:"
echo ""
echo "Options:"
echo "  1) auto-cpufreq (Recommended) - Automatic CPU speed & power optimizer"
echo "  2) TLP - Advanced laptop power management"
echo "  3) Skip - Use kernel defaults only"
echo ""
echo "Note: Do NOT install both TLP and auto-cpufreq (they conflict)"
echo ""
read -p "Choose option (1-3) [3]: " -n 1 -r
echo ""

case $REPLY in
    1)
        echo ""
        echo "Installing auto-cpufreq..."
        if sudo pacman -S --needed auto-cpufreq; then
            sudo systemctl enable --now auto-cpufreq
            echo "✓ auto-cpufreq installed and enabled"
            echo ""
            echo "View status with: sudo auto-cpufreq --stats"
        else
            echo "✗ Failed to install auto-cpufreq"
        fi
        ;;
    2)
        echo ""
        echo "Installing TLP..."
        if sudo pacman -S --needed tlp tlp-rdw; then
            sudo systemctl enable --now tlp
            echo "✓ TLP installed and enabled"
            echo ""
            echo "View status with: sudo tlp-stat -s"
        else
            echo "✗ Failed to install TLP"
        fi
        ;;
    3|"")
        echo ""
        echo "Skipping CPU power management tools"
        echo "(Using kernel defaults)"
        ;;
    *)
        echo ""
        echo "Invalid option. Skipping CPU power management."
        ;;
esac

echo ""

echo "=== Power Management Settings ==="
echo ""
echo "  Screensaver:  5 minutes (managed by swayidle)"
echo "  Auto-suspend: 10 minutes (managed by systemd-logind)"
echo ""
echo "This means:"
echo "  - After 5 min idle: screensaver activates"
echo "  - After 10 min idle: system suspends automatically"
echo ""

echo "=== Restarting systemd-logind ==="
echo ""
echo "This will log you out. Please save your work first."
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Restarting systemd-logind..."
    sudo systemctl restart systemd-logind.service
    echo ""
    echo "Done! You will be logged out now."
else
    echo ""
    echo "Installation complete, but changes require restart of systemd-logind."
    echo "To activate without logging out, reboot your computer:"
    echo "  sudo reboot"
    echo ""
    echo "Or to apply now (will log you out):"
    echo "  sudo systemctl restart systemd-logind.service"
fi

echo ""
echo "=== Verification ==="
echo ""
echo "After restarting/rebooting, verify with:"
echo "  loginctl show-session \$(loginctl | grep \$(whoami) | awk '{print \$1}') | grep IdleAction"
echo ""
echo "You should see: IdleAction=suspend"
