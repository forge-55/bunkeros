#!/usr/bin/env bash

# BunkerOS archinstall Helper Script
# Simplifies the installation process using archinstall

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}"
cat << "EOF"
╔══════════════════════════════════════════════════════════╗
║                                                          ║
║   ██████╗ ██╗   ██╗███╗   ██╗██╗  ██╗███████╗██████╗    ║
║   ██╔══██╗██║   ██║████╗  ██║██║ ██╔╝██╔════╝██╔══██╗   ║
║   ██████╔╝██║   ██║██╔██╗ ██║█████╔╝ █████╗  ██████╔╝   ║
║   ██╔══██╗██║   ██║██║╚██╗██║██╔═██╗ ██╔══╝  ██╔══██╗   ║
║   ██████╔╝╚██████╔╝██║ ╚████║██║  ██╗███████╗██║  ██║   ║
║   ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ║
║                                                          ║
║            archinstall Installation Helper              ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
echo -e "${GREEN}BunkerOS - Productivity-focused Sway environment for Arch Linux${NC}"
echo ""
echo "This script will help you install BunkerOS using archinstall."
echo ""
echo "The archinstall method automates the entire process:"
echo "  - Arch Linux base installation"
echo "  - BunkerOS package installation"
echo "  - Configuration setup"
echo ""
echo "If you prefer to install Arch manually first and then add BunkerOS,"
echo "see: https://github.com/forge-55/bunkeros/blob/main/INSTALL.md"
echo ""

read -p "Continue with archinstall? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    echo ""
    echo "Alternative: Manual installation"
    echo "  1. Install Arch Linux: https://wiki.archlinux.org/title/Installation_guide"
    echo "  2. Clone BunkerOS: git clone https://github.com/forge-55/bunkeros.git"
    echo "  3. Run installer: cd bunkeros && ./install.sh"
    echo ""
    echo "The manual approach offers a deeper understanding of your system."
    exit 0
fi

echo ""
echo "Checking requirements..."

# Check if running from Arch ISO
if [ ! -f /etc/arch-release ]; then
    echo "ERROR: This script must be run from an Arch Linux live environment"
    exit 1
fi

# Check for internet
if ! ping -c 1 archlinux.org &>/dev/null; then
    echo "ERROR: No internet connection detected"
    echo ""
    echo "To connect via WiFi:"
    echo "  iwctl"
    echo "  > station wlan0 connect \"YOUR_NETWORK\""
    echo "  > quit"
    exit 1
fi

# Install archinstall if needed
if ! command -v archinstall &>/dev/null; then
    echo "Installing archinstall..."
    pacman -Sy --noconfirm archinstall
fi

echo "✓ Requirements met"
echo ""

# Download BunkerOS config
echo "Downloading BunkerOS configuration..."
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

if ! curl -fsSL -o bunkeros-config.json https://raw.githubusercontent.com/forge-55/bunkeros/main/archinstall/bunkeros-config.json; then
    echo "ERROR: Failed to download configuration"
    exit 1
fi

echo "✓ Configuration downloaded"
echo ""

echo "=== Installation Options ==="
echo ""
echo "1. Interactive Installation (Recommended)"
echo "   - You will be guided through the installation"
echo "   - Choose disk partitioning, timezone, user, etc."
echo "   - BunkerOS packages pre-selected"
echo ""
echo "2. Review Configuration & Exit"
echo "   - Download config and run archinstall manually"
echo ""

read -p "Choose option (1-2): " -n 1 -r option
echo ""

case $option in
    1)
        echo ""
        echo "Starting interactive installation..."
        echo ""
        echo "You will be asked to configure:"
        echo "  - Disk partitioning"
        echo "  - Timezone and locale"
        echo "  - User account and password"
        echo "  - Network configuration"
        echo ""
        echo "BunkerOS packages are already selected."
        echo ""
        read -p "Press Enter to continue..."
        
        # Run archinstall with BunkerOS config
        archinstall --config bunkeros-config.json
        
        # Get the username that was created
        echo ""
        echo "Base installation complete!"
        echo ""
        read -p "Enter the username you created: " USERNAME
        
        if [ -z "$USERNAME" ]; then
            echo "ERROR: Username required"
            exit 1
        fi
        
        # Download and run post-install script
        echo ""
        echo "Setting up BunkerOS configuration..."
        
        if ! curl -fsSL -o post-install.sh https://raw.githubusercontent.com/forge-55/bunkeros/main/archinstall/post-install.sh; then
            echo "ERROR: Failed to download post-install script"
            echo ""
            echo "You can manually install BunkerOS after rebooting:"
            echo "  git clone https://github.com/forge-55/bunkeros.git"
            echo "  cd bunkeros"
            echo "  ./install.sh"
            exit 1
        fi
        
        chmod +x post-install.sh
        ./post-install.sh /mnt "$USERNAME"
        
        echo ""
        echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║                                                      ║${NC}"
        echo -e "${GREEN}║   BunkerOS Installation Complete!                   ║${NC}"
        echo -e "${GREEN}║                                                      ║${NC}"
        echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo "Next steps:"
        echo "  1. Unmount: umount -R /mnt"
        echo "  2. Reboot: reboot"
        echo "  3. Select 'BunkerOS' at the SDDM login screen"
        echo ""
        echo "Optional post-install tasks:"
        echo "  - Install AUR packages: ~/.local/share/bunkeros/scripts/install-aur-packages.sh"
        echo "  - Power management: ~/.local/share/bunkeros/scripts/install-power-management.sh"
        echo ""
        ;;
        
    2)
        echo ""
        echo "Configuration downloaded to: $TEMP_DIR"
        echo ""
        echo "To install manually:"
        echo "  cd $TEMP_DIR"
        echo "  archinstall --config bunkeros-config.json"
        echo ""
        echo "After archinstall completes, run:"
        echo "  curl -O https://raw.githubusercontent.com/forge-55/bunkeros/main/archinstall/post-install.sh"
        echo "  chmod +x post-install.sh"
        echo "  ./post-install.sh /mnt YOUR_USERNAME"
        echo ""
        ;;
        
    *)
        echo "Invalid option"
        exit 1
        ;;
esac
