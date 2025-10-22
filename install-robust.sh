#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/bunkeros-install.log"
BACKUP_DIR="$HOME/.config/bunkeros-backup-$(date +%Y%m%d-%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}ERROR: $1${NC}" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}WARNING: $1${NC}" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}SUCCESS: $1${NC}" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}INFO: $1${NC}" | tee -a "$LOG_FILE"
}

# Check if package is installed
check_package() {
    pacman -Q "$1" &>/dev/null
}

# Check if AUR helper is available
check_aur_helper() {
    command -v yay &>/dev/null || command -v paru &>/dev/null
}

# Backup existing configuration
backup_config() {
    info "Creating backup of existing configurations..."
    mkdir -p "$BACKUP_DIR"
    
    for config_dir in sway waybar wofi mako foot btop swayosd gtk-3.0 gtk-4.0; do
        if [ -d "$HOME/.config/$config_dir" ]; then
            cp -r "$HOME/.config/$config_dir" "$BACKUP_DIR/" 2>/dev/null || true
            log "Backed up ~/.config/$config_dir"
        fi
    done
    
    if [ -f "$HOME/.bashrc" ]; then
        cp "$HOME/.bashrc" "$BACKUP_DIR/bashrc.bak"
        log "Backed up ~/.bashrc"
    fi
    
    success "Backup created at: $BACKUP_DIR"
}

# Detect and handle existing display manager
handle_display_manager() {
    info "Checking for existing display managers..."
    
    local current_dm=""
    if systemctl is-enabled gdm.service &>/dev/null; then
        current_dm="gdm"
    elif systemctl is-enabled sddm.service &>/dev/null; then
        current_dm="sddm"
    elif systemctl is-enabled lightdm.service &>/dev/null; then
        current_dm="lightdm"
    elif systemctl is-enabled ly.service &>/dev/null; then
        current_dm="ly"
    fi
    
    if [ -n "$current_dm" ] && [ "$current_dm" != "sddm" ]; then
        warning "Current display manager: $current_dm"
        echo ""
        echo "BunkerOS works best with SDDM for the themed login experience."
        echo "Options:"
        echo "  1) Switch to SDDM (recommended)"
        echo "  2) Keep $current_dm (you'll need to manually select BunkerOS sessions)"
        echo "  3) Cancel installation"
        echo ""
        read -p "Choose option (1-3): " -n 1 -r
        echo
        
        case $REPLY in
            1)
                info "Switching to SDDM..."
                sudo systemctl disable "$current_dm.service" || true
                sudo systemctl enable sddm.service
                success "Switched to SDDM"
                ;;
            2)
                warning "Keeping $current_dm - you'll need to manually select BunkerOS sessions"
                ;;
            3)
                error "Installation cancelled by user"
                exit 1
                ;;
            *)
                error "Invalid option"
                exit 1
                ;;
        esac
    else
        info "Display manager check completed"
    fi
}

# Install packages with verification
install_packages() {
    local package_list=("$@")
    local failed_packages=()
    
    info "Installing ${#package_list[@]} packages..."
    
    # Try to install all packages
    if ! sudo pacman -S --needed "${package_list[@]}"; then
        warning "Some packages failed to install, checking individually..."
        
        # Check each package individually
        for pkg in "${package_list[@]}"; do
            if ! check_package "$pkg"; then
                if ! sudo pacman -S --needed "$pkg"; then
                    failed_packages+=("$pkg")
                    error "Failed to install: $pkg"
                else
                    success "Installed: $pkg"
                fi
            else
                info "Already installed: $pkg"
            fi
        done
    else
        success "All packages installed successfully"
    fi
    
    # Report failed packages
    if [ ${#failed_packages[@]} -gt 0 ]; then
        error "Failed to install packages: ${failed_packages[*]}"
        echo ""
        echo "You can try installing these manually later:"
        printf '  sudo pacman -S %s\n' "${failed_packages[@]}"
        echo ""
        read -p "Continue installation anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Install AUR packages
install_aur_packages() {
    local aur_packages=("$@")
    
    if ! check_aur_helper; then
        warning "No AUR helper found (yay/paru)"
        echo ""
        echo "AUR packages needed: ${aur_packages[*]}"
        echo ""
        echo "Please install an AUR helper first:"
        echo "  git clone https://aur.archlinux.org/yay.git"
        echo "  cd yay && makepkg -si"
        echo ""
        read -p "Skip AUR packages for now? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
        return
    fi
    
    local aur_helper
    if command -v yay &>/dev/null; then
        aur_helper="yay"
    else
        aur_helper="paru"
    fi
    
    info "Installing AUR packages with $aur_helper..."
    for pkg in "${aur_packages[@]}"; do
        if ! check_package "$pkg"; then
            if $aur_helper -S --needed "$pkg"; then
                success "Installed AUR package: $pkg"
            else
                error "Failed to install AUR package: $pkg"
            fi
        else
            info "AUR package already installed: $pkg"
        fi
    done
}

# Verify critical services
verify_services() {
    info "Verifying critical services..."
    
    local services=(
        "pipewire.service"
        "pipewire-pulse.service"
        "wireplumber.service"
    )
    
    for service in "${services[@]}"; do
        if systemctl --user is-enabled "$service" &>/dev/null; then
            success "Service enabled: $service"
        else
            warning "Service not enabled: $service"
            if systemctl --user enable --now "$service" &>/dev/null; then
                success "Enabled service: $service"
            else
                error "Failed to enable service: $service"
            fi
        fi
    done
}

# Fix environment variables for current session
fix_current_session() {
    info "Applying environment fixes to current session..."
    
    export ELECTRON_OZONE_PLATFORM_HINT=auto
    export QT_QPA_PLATFORM=wayland
    export MOZ_ENABLE_WAYLAND=1
    
    # Restart key processes with new environment
    if pgrep -x waybar >/dev/null; then
        killall waybar
        waybar &>/dev/null &
        success "Restarted Waybar"
    fi
    
    if pgrep -x mako >/dev/null; then
        killall mako
        mako &>/dev/null &
        success "Restarted Mako"
    fi
    
    # Start autotiling if not running
    if ! pgrep -f autotiling-rs >/dev/null; then
        autotiling-rs &>/dev/null &
        success "Started autotiling"
    fi
    
    # Start network manager applet if not running
    if ! pgrep -f nm-applet >/dev/null; then
        nm-applet &>/dev/null &
        success "Started network manager applet"
    fi
}

# Main installation function
main() {
    cat << "EOF"
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║             BunkerOS Robust Installer v2.0                ║
║                                                            ║
║      Improved error handling and recovery options          ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
EOF

    echo ""
    info "Starting BunkerOS installation..."
    info "Log file: $LOG_FILE"
    echo ""
    
    # Check if we're on Arch-based system
    if ! command -v pacman &>/dev/null; then
        error "This installer requires an Arch-based system with pacman"
        exit 1
    fi
    
    # Create backup
    backup_config
    
    # Handle display manager
    handle_display_manager
    
    # Define package groups
    local core_packages=(
        swayfx autotiling-rs waybar wofi mako foot swaylock swayidle swaybg
        brightnessctl playerctl wl-clipboard grim slurp wlsunset
        network-manager-applet blueman pavucontrol
    )
    
    local app_packages=(
        nautilus sushi eog evince lite-xl btop mate-calc zenity
    )
    
    local media_packages=(
        pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber v4l-utils
    )
    
    local system_packages=(
        sddm qt5-declarative qt5-quickcontrols2 ttf-meslo-nerd 
        xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk 
        python-pipx
    )
    
    local aur_packages=(
        swayosd-git
    )
    
    # Install package groups
    echo ""
    info "Installing core packages..."
    install_packages "${core_packages[@]}"
    
    echo ""
    info "Installing application packages..."
    install_packages "${app_packages[@]}"
    
    echo ""
    info "Installing media packages..."
    install_packages "${media_packages[@]}"
    
    echo ""
    info "Installing system packages..."
    install_packages "${system_packages[@]}"
    
    echo ""
    info "Installing AUR packages..."
    install_aur_packages "${aur_packages[@]}"
    
    # Run setup script
    echo ""
    info "Running configuration setup..."
    if "$SCRIPT_DIR/setup.sh"; then
        success "Configuration setup completed"
    else
        error "Configuration setup failed"
        exit 1
    fi
    
    # Install Python tools
    echo ""
    info "Installing Python tools..."
    if pipx install terminaltexteffects &>/dev/null; then
        success "Installed TerminalTextEffects"
    else
        warning "Failed to install TerminalTextEffects (optional)"
    fi
    
    # Verify services
    verify_services
    
    # Fix current session
    fix_current_session
    
    # Final validation
    echo ""
    info "Running final validation..."
    if "$SCRIPT_DIR/scripts/validate-installation.sh" &>/dev/null; then
        success "Installation validation passed"
    else
        warning "Some validation checks failed - see log for details"
    fi
    
    cat << EOF

╔════════════════════════════════════════════════════════════╗
║                                                            ║
║           BunkerOS Installation Complete! ✓                ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

📋 Installation Summary:
   • Configuration backup: $BACKUP_DIR
   • Installation log: $LOG_FILE
   • All configs symlinked to: $SCRIPT_DIR

🎯 Next Steps:
   1. Log out and log back in to get full environment
   2. Select "BunkerOS (Standard)" or "BunkerOS (Enhanced)" at login
   3. Enjoy your productivity environment!

🔧 If something goes wrong:
   • Check the log: $LOG_FILE
   • Restore backup: cp -r $BACKUP_DIR/* ~/.config/
   • Re-run this script: $SCRIPT_DIR/install-robust.sh

EOF
}

# Run main function
main "$@"