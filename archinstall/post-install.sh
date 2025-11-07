#!/usr/bin/env bash

# BunkerOS Post-Installation Script for archinstall
# This script runs after the base Arch installation is complete
# It clones the BunkerOS repository and sets up the configuration

set -e

# Get the installation root (should be /mnt during archinstall)
INSTALL_ROOT="${1:-/mnt}"
USERNAME="${2:-}"

echo "=== BunkerOS Post-Installation Setup ==="
echo "Installation root: $INSTALL_ROOT"
echo "Target user: $USERNAME"
echo ""

if [ -z "$USERNAME" ]; then
    echo "ERROR: Username not provided"
    echo "Usage: $0 <install_root> <username>"
    exit 1
fi

USER_HOME="$INSTALL_ROOT/home/$USERNAME"
BUNKEROS_DIR="$USER_HOME/.local/share/bunkeros"

# Ensure user home directory exists
if [ ! -d "$USER_HOME" ]; then
    echo "ERROR: User home directory not found: $USER_HOME"
    exit 1
fi

echo "Step 1: Cloning BunkerOS repository..."
# Clone as the target user (using arch-chroot context)
arch-chroot "$INSTALL_ROOT" /bin/bash -c "
    sudo -u $USERNAME mkdir -p /home/$USERNAME/.local/share
    sudo -u $USERNAME git clone https://github.com/forge-55/bunkeros.git /home/$USERNAME/.local/share/bunkeros
"
echo "  ✓ Repository cloned"
echo ""

echo "Step 2: Running BunkerOS setup script..."
# Run setup.sh as the target user
arch-chroot "$INSTALL_ROOT" /bin/bash -c "
    cd /home/$USERNAME/.local/share/bunkeros
    sudo -u $USERNAME ./setup.sh
"
echo "  ✓ BunkerOS configuration installed"
echo ""

echo "Step 3: Installing SDDM theme..."
# Copy SDDM theme
arch-chroot "$INSTALL_ROOT" /bin/bash -c "
    cd /home/$USERNAME/.local/share/bunkeros
    sudo ./sddm/install-theme.sh
"
echo "  ✓ SDDM theme installed"
echo ""

echo "Step 4: Configuring user environment..."
# Set up environment.d
arch-chroot "$INSTALL_ROOT" /bin/bash -c "
    sudo -u $USERNAME mkdir -p /home/$USERNAME/.config/environment.d
    sudo -u $USERNAME cp /home/$USERNAME/.local/share/bunkeros/environment.d/*.conf /home/$USERNAME/.config/environment.d/
"
echo "  ✓ Environment configured"
echo ""

echo "Step 5: Enabling user services..."
# Enable PipeWire and other user services
arch-chroot "$INSTALL_ROOT" /bin/bash -c "
    sudo -u $USERNAME systemctl --user enable pipewire.service
    sudo -u $USERNAME systemctl --user enable pipewire-pulse.service
    sudo -u $USERNAME systemctl --user enable wireplumber.service
"
echo "  ✓ User services enabled"
echo ""

echo "Step 6: Installing Plymouth boot splash..."
# Install Plymouth theme from AUR and configure it
arch-chroot "$INSTALL_ROOT" /bin/bash -c "
    # Install yay if not present
    if ! command -v yay &>/dev/null; then
        cd /tmp
        sudo -u $USERNAME git clone https://aur.archlinux.org/yay.git
        cd yay
        sudo -u $USERNAME makepkg -si --noconfirm
        cd /
        rm -rf /tmp/yay
    fi
    
    # Install Plymouth theme
    sudo -u $USERNAME yay -S --noconfirm plymouth-theme-arch-charge
    
    # Configure Plymouth
    plymouth-set-default-theme arch-charge
    mkinitcpio -p linux
    
    # Handle LTS kernel if present
    if pacman -Q linux-lts &>/dev/null; then
        mkinitcpio -p linux-lts
    fi
    
    # Add splash to boot entries  
    for entry in /boot/loader/entries/*.conf; do
        if [[ -f \"\$entry\" ]] && ! grep -q \"splash\" \"\$entry\"; then
            sed -i 's/options /options splash /' \"\$entry\"
        fi
    done
"
echo "  ✓ Plymouth boot splash configured"
echo ""

echo "=== BunkerOS Installation Complete ==="
echo ""
echo "Next steps:"
echo "  1. Complete the archinstall process"
echo "  2. Reboot your system"
echo "  3. Select 'BunkerOS' at the SDDM login screen"
echo "  4. Enjoy your productivity-focused Sway environment!"
echo ""
echo "Optional post-install tasks:"
echo "  - Install AUR packages: cd ~/.local/share/bunkeros && ./scripts/install-aur-packages.sh"
echo "  - Configure power management: ~/.local/share/bunkeros/scripts/install-power-management.sh"
echo "  - Customize themes: Super+Shift+T"
echo ""
