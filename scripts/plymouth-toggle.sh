#!/bin/bash
# BunkerOS Plymouth Toggle Script
# Easily enable or disable Plymouth boot splash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log() { echo -e "${GREEN}[PLYMOUTH]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   error "This script should not be run as root. Run as your user with sudo access."
   exit 1
fi

# Check current Plymouth status
check_plymouth_status() {
    local status="disabled"
    local theme="none"
    
    # Check if Plymouth is installed
    if ! pacman -Q plymouth &>/dev/null; then
        echo "not_installed"
        return
    fi
    
    # Check if splash is in boot entries
    local has_splash=false
    for entry in /boot/loader/entries/*.conf; do
        if [[ -f "$entry" ]] && grep -q "splash" "$entry"; then
            has_splash=true
            break
        fi
    done
    
    # Get current theme
    if command -v plymouth-set-default-theme &>/dev/null; then
        theme=$(plymouth-set-default-theme 2>/dev/null || echo "none")
    fi
    
    if $has_splash && [[ "$theme" != "none" ]]; then
        status="enabled"
    fi
    
    echo "${status}:${theme}"
}

# Show current status
show_status() {
    local status_info
    status_info=$(check_plymouth_status)
    
    local status="${status_info%:*}"
    local theme="${status_info#*:}"
    
    echo
    info "Plymouth Boot Splash Status"
    echo "=========================="
    
    case "$status" in
        "not_installed")
            echo "Status: Not installed"
            echo "Theme:  N/A"
            ;;
        "enabled")
            echo "Status: ✅ Enabled"
            echo "Theme:  $theme"
            ;;
        "disabled")
            echo "Status: ❌ Disabled"
            echo "Theme:  $theme (not active)"
            ;;
    esac
    echo
}

# Enable Plymouth
enable_plymouth() {
    log "Enabling Plymouth boot splash..."
    
    # Check if Plymouth is installed
    if ! pacman -Q plymouth &>/dev/null; then
        error "Plymouth is not installed. Please install it first:"
        echo "sudo pacman -S plymouth"
        echo "yay -S plymouth-theme-arch-charge"
        return 1
    fi
    
    # Check if theme is available
    if ! pacman -Q plymouth-theme-arch-charge &>/dev/null; then
        warn "arch-charge theme not found. Installing it..."
        if command -v yay &>/dev/null; then
            yay -S --needed plymouth-theme-arch-charge
        else
            error "yay not found. Please install plymouth-theme-arch-charge manually"
            return 1
        fi
    fi
    
    # Set the theme
    info "Setting Plymouth theme to arch-charge..."
    sudo plymouth-set-default-theme arch-charge
    
    # Regenerate initramfs
    info "Regenerating initramfs..."
    sudo mkinitcpio -p linux
    
    # Handle LTS kernel if present
    if pacman -Q linux-lts &>/dev/null; then
        info "Regenerating LTS initramfs..."
        sudo mkinitcpio -p linux-lts
    fi
    
    # Add splash to boot entries
    info "Adding splash parameter to boot entries..."
    local entries_updated=0
    
    for entry in /boot/loader/entries/*.conf; do
        if [[ -f "$entry" ]]; then
            if ! grep -q "splash" "$entry"; then
                sudo sed -i 's/options /options splash /' "$entry"
                info "Added splash to $(basename "$entry")"
                ((entries_updated++))
            fi
        fi
    done
    
    if [[ $entries_updated -gt 0 ]]; then
        success "Updated $entries_updated boot entries"
    else
        info "Boot entries already configured"
    fi
    
    log "Plymouth boot splash enabled successfully!"
    info "Reboot to see the Arch Linux logo during boot"
}

# Disable Plymouth
disable_plymouth() {
    log "Disabling Plymouth boot splash..."
    
    # Remove splash from boot entries
    info "Removing splash parameter from boot entries..."
    local entries_updated=0
    
    for entry in /boot/loader/entries/*.conf; do
        if [[ -f "$entry" ]] && grep -q "splash" "$entry"; then
            sudo sed -i 's/splash //g' "$entry"
            info "Removed splash from $(basename "$entry")"
            ((entries_updated++))
        fi
    done
    
    if [[ $entries_updated -gt 0 ]]; then
        success "Updated $entries_updated boot entries"
    else
        info "Boot entries already configured without splash"
    fi
    
    log "Plymouth boot splash disabled!"
    info "Reboot to see text-only boot messages"
}

# Install Plymouth (if not installed)
install_plymouth() {
    log "Installing Plymouth boot splash..."
    
    # Install Plymouth
    info "Installing Plymouth package..."
    sudo pacman -S --needed plymouth
    
    # Install theme
    info "Installing arch-charge theme..."
    if command -v yay &>/dev/null; then
        yay -S --needed plymouth-theme-arch-charge
    else
        error "yay not found. Please install yay first or install plymouth-theme-arch-charge manually"
        return 1
    fi
    
    log "Plymouth installation complete!"
    info "Run '$0 enable' to activate the boot splash"
}

# Remove Plymouth completely
remove_plymouth() {
    log "Removing Plymouth boot splash..."
    
    # Disable first
    disable_plymouth
    
    # Remove packages
    info "Removing Plymouth packages..."
    if pacman -Q plymouth-theme-arch-charge &>/dev/null; then
        yay -Rns plymouth-theme-arch-charge
    fi
    
    if pacman -Q plymouth &>/dev/null; then
        sudo pacman -Rns plymouth
    fi
    
    # Regenerate initramfs
    info "Regenerating initramfs..."
    sudo mkinitcpio -p linux
    
    if pacman -Q linux-lts &>/dev/null; then
        info "Regenerating LTS initramfs..."
        sudo mkinitcpio -p linux-lts
    fi
    
    log "Plymouth completely removed!"
}

# Show help
show_help() {
    cat << EOF
BunkerOS Plymouth Toggle Script

USAGE:
    $0 [COMMAND]

COMMANDS:
    status      Show current Plymouth status
    enable      Enable Plymouth boot splash with Arch Linux logo
    disable     Disable Plymouth boot splash (keep installed)
    install     Install Plymouth and theme (if not installed)
    remove      Completely remove Plymouth
    help        Show this help message

EXAMPLES:
    $0 status       # Check current status
    $0 enable       # Enable boot splash
    $0 disable      # Disable boot splash (faster boot)
    $0 remove       # Completely remove Plymouth

NOTES:
    • Plymouth shows the official Arch Linux logo during boot
    • Adds ~1-2 seconds to boot time when enabled
    • Works with LUKS encryption password prompts
    • Changes require a reboot to take effect
    • BunkerOS installs Plymouth by default (can be disabled)

EOF
}

success() { echo -e "${GREEN}✓${NC} $1"; }

# Main logic
case "${1:-status}" in
    "status")
        show_status
        ;;
    "enable")
        enable_plymouth
        ;;
    "disable") 
        disable_plymouth
        ;;
    "install")
        install_plymouth
        ;;
    "remove")
        read -p "Remove Plymouth completely? This cannot be easily undone. (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            remove_plymouth
        else
            info "Removal cancelled"
        fi
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        error "Unknown command: $1"
        echo
        show_help
        exit 1
        ;;
esac