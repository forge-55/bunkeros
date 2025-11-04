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
echo "=== CPU Power Management ==="
echo ""
echo "Configuring auto-cpufreq for automatic CPU power optimization..."
echo "(Provides optimal battery life with zero configuration)"
echo ""

# Check if auto-cpufreq is installed
if ! command -v auto-cpufreq &>/dev/null; then
    echo "✗ auto-cpufreq is not installed"
    echo "It should have been installed during the main installation process."
    echo ""
    echo "You can install it manually with:"
    echo "  yay -S auto-cpufreq"
    echo "  sudo systemctl enable --now auto-cpufreq"
    echo "  sudo cp $PROJECT_DIR/systemd/sudoers.d/auto-cpufreq /etc/sudoers.d/"
    echo "  sudo chmod 0440 /etc/sudoers.d/auto-cpufreq"
    exit 1
fi

# Enable and start the service
if sudo systemctl enable --now auto-cpufreq; then
    sudo systemctl enable --now auto-cpufreq
    echo "✓ auto-cpufreq installed and enabled"
    echo ""
    
    # Install sudoers configuration for passwordless profile switching
    echo "Installing sudoers configuration for waybar integration..."
    sudo cp "$PROJECT_DIR/systemd/sudoers.d/auto-cpufreq" /etc/sudoers.d/
    sudo chmod 0440 /etc/sudoers.d/auto-cpufreq
    echo "✓ Sudoers configuration installed"
    echo ""
    
    # Create initial state file
    echo "auto" > /tmp/auto-cpufreq-mode
    echo "✓ Initial power profile set to Auto"
    echo ""
    
    echo "View status with: sudo auto-cpufreq --stats"
else
    echo "✗ Failed to install auto-cpufreq"
    echo ""
    echo "You can install it manually later with:"
    echo "  yay -S auto-cpufreq"
    echo "  sudo systemctl enable --now auto-cpufreq"
    echo "  sudo cp $PROJECT_DIR/systemd/sudoers.d/auto-cpufreq /etc/sudoers.d/"
    echo "  sudo chmod 0440 /etc/sudoers.d/auto-cpufreq"
fi

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
echo "To activate power management, systemd-logind needs to restart."
echo "This will log you out. Please save your work first."
echo ""
read -p "Restart now? (Y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo ""
    echo "Installation complete, but changes require restart of systemd-logind."
    echo "To activate without logging out, reboot your computer:"
    echo "  sudo reboot"
    echo ""
    echo "Or to apply now (will log you out):"
    echo "  sudo systemctl restart systemd-logind.service"
else
    echo "Restarting systemd-logind..."
    sudo systemctl restart systemd-logind.service
    echo ""
    echo "Done! You will be logged out now."
fi

echo ""
echo "=== Verification ==="
echo ""
echo "After restarting/rebooting, verify with:"
echo "  loginctl show-session \$(loginctl | grep \$(whoami) | awk '{print \$1}') | grep IdleAction"
echo ""
echo "You should see: IdleAction=suspend"
