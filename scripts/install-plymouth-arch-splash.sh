#!/bin/bash
# BunkerOS Plymouth Boot Splash Installer
# Adds Arch Linux logo boot splash screen to BunkerOS

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[PLYMOUTH]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   error "This script should not be run as root. Run as your user with sudo access."
   exit 1
fi

# Check if systemd-boot is being used
check_bootloader() {
    if [[ ! -d /boot/loader/entries ]]; then
        error "This script is designed for systemd-boot. GRUB setups may require different configuration."
        info "Detected bootloader configuration may not be systemd-boot."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Install Plymouth and theme
install_plymouth() {
    log "Installing Plymouth and Arch Linux theme..."
    
    # Install plymouth
    sudo pacman -S --needed plymouth
    
    # Install yay if not present (should already be installed by BunkerOS)
    if ! command -v yay &> /dev/null; then
        error "yay not found. Please install yay first."
        exit 1
    fi
    
    # Show theme options
    echo
    info "Available Arch Linux Plymouth themes:"
    echo "1. arch-charge (Most popular - clean animated logo)"
    echo "2. arch-charge-big (Same as above, larger for HiDPI)"  
    echo "3. dark-arch (Dark background with spinner)"
    echo "4. arch-logo (Simple static logo)"
    echo "5. arch-breeze (KDE Breeze inspired)"
    echo
    
    read -p "Choose theme (1-5) [1]: " theme_choice
    theme_choice=${theme_choice:-1}
    
    case $theme_choice in
        1) theme_package="plymouth-theme-arch-charge" ;;
        2) theme_package="plymouth-theme-arch-charge-big" ;;
        3) theme_package="plymouth-theme-dark-arch" ;;
        4) theme_package="plymouth-theme-arch-logo" ;;
        5) theme_package="plymouth-theme-arch-breeze-git" ;;
        *) theme_package="plymouth-theme-arch-charge" ;;
    esac
    
    log "Installing theme: $theme_package"
    yay -S --needed "$theme_package"
}

# Configure Plymouth
configure_plymouth() {
    log "Configuring Plymouth..."
    
    # Get the theme name (remove package prefix/suffix)
    case $theme_package in
        "plymouth-theme-arch-charge") theme_name="arch-charge" ;;
        "plymouth-theme-arch-charge-big") theme_name="arch-charge-big" ;;
        "plymouth-theme-dark-arch") theme_name="dark-arch" ;;
        "plymouth-theme-arch-logo") theme_name="arch-logo" ;;
        "plymouth-theme-arch-breeze-git") theme_name="arch-breeze" ;;
    esac
    
    # Set the theme
    sudo plymouth-set-default-theme "$theme_name"
    
    # Regenerate initramfs
    log "Regenerating initramfs..."
    sudo mkinitcpio -p linux
    
    # Handle LTS kernel if present
    if pacman -Q linux-lts &>/dev/null; then
        log "LTS kernel detected, regenerating LTS initramfs..."
        sudo mkinitcpio -p linux-lts
    fi
}

# Update bootloader configuration
update_boot_config() {
    log "Updating boot configuration..."
    
    # Find all systemd-boot entries
    for entry in /boot/loader/entries/*.conf; do
        if [[ -f "$entry" ]]; then
            # Check if splash is already in options
            if ! grep -q "splash" "$entry"; then
                # Add splash to kernel options
                sudo sed -i 's/options /options splash /' "$entry"
                info "Added 'splash' to $(basename "$entry")"
            else
                info "Splash already configured in $(basename "$entry")"
            fi
        fi
    done
}

# Test Plymouth
test_plymouth() {
    log "Testing Plymouth configuration..."
    
    # Show current theme
    current_theme=$(plymouth-set-default-theme)
    info "Current Plymouth theme: $current_theme"
    
    # Test the theme (if X/Wayland is running)
    if [[ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]]; then
        warn "You can test the theme by running:"
        echo "sudo plymouthd; sudo plymouth --show-splash; sleep 2; sudo plymouth quit"
    fi
}

# Main installation process
main() {
    echo
    info "BunkerOS Plymouth Boot Splash Installer"
    echo "======================================"
    echo
    info "This will install Plymouth boot splash with Arch Linux logo"
    info "for a professional boot experience matching BunkerOS aesthetic."
    echo
    
    read -p "Continue with installation? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        info "Installation cancelled."
        exit 0
    fi
    
    check_bootloader
    install_plymouth
    configure_plymouth  
    update_boot_config
    test_plymouth
    
    echo
    log "Plymouth installation complete!"
    echo
    info "Next steps:"
    echo "1. Reboot your system to see the new boot splash"
    echo "2. The Arch Linux logo will appear during boot process"
    echo "3. The splash will show during encryption password entry"
    echo
    warn "If you experience any boot issues, you can:"
    echo "- Remove 'splash' from kernel options in /boot/loader/entries/*.conf"
    echo "- Or boot with 'systemd.show_status=1' for debugging"
    echo
    
    read -p "Reboot now to test? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log "Rebooting..."
        sudo reboot
    else
        info "Reboot when ready to see the new boot splash!"
    fi
}

# Run main function
main "$@"