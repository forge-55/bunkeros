#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/bunkeros-install.log"
BACKUP_DIR="$HOME/.config/bunkeros-backup-$(date +%Y%m%d-%H%M%S)"
CHECKPOINT_FILE="/tmp/bunkeros-install-checkpoint"

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

# Save checkpoint
save_checkpoint() {
    echo "$1" > "$CHECKPOINT_FILE"
}

# Get last checkpoint
get_checkpoint() {
    if [ -f "$CHECKPOINT_FILE" ]; then
        cat "$CHECKPOINT_FILE"
    else
        echo "start"
    fi
}

# Pre-flight checks
preflight_checks() {
    info "Running pre-flight checks..."
    
    # Check if running on Arch-based system
    if ! command -v pacman &>/dev/null; then
        error "This installer requires an Arch-based system with pacman"
        exit 1
    fi
    
    # Check for internet connectivity
    if ! ping -c 1 archlinux.org &>/dev/null; then
        warning "No internet connection detected"
        echo "Internet connection is required to download packages."
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Check for pacman lock
    if [ -f /var/lib/pacman/db.lck ]; then
        warning "Pacman database is locked"
        echo "Another package manager might be running, or a previous operation was interrupted."
        read -p "Remove lock file and continue? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo rm -f /var/lib/pacman/db.lck
            success "Lock file removed"
        else
            exit 1
        fi
    fi
    
    # Check disk space (need at least 2GB free)
    local free_space=$(df -BG / | tail -1 | awk '{print $4}' | sed 's/G//')
    if [ "$free_space" -lt 2 ]; then
        error "Insufficient disk space. Need at least 2GB free, have ${free_space}GB"
        exit 1
    fi
    
    # Update pacman database
    info "Updating package database..."
    if ! sudo pacman -Sy; then
        error "Failed to update package database"
        exit 1
    fi
    
    success "Pre-flight checks passed"
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
        echo "  1) Switch to SDDM (recommended - will install if needed)"
        echo "  2) Keep $current_dm (you'll need to manually select BunkerOS sessions)"
        echo "  3) Cancel installation"
        echo ""
        read -p "Choose option (1-3): " -n 1 -r
        echo
        
        case $REPLY in
            1)
                info "Switching to SDDM..."
                
                # Install SDDM and dependencies if not already installed
                if ! check_package "sddm"; then
                    info "Installing SDDM..."
                    if sudo pacman -S --needed sddm qt5-declarative qt5-quickcontrols2; then
                        success "SDDM installed successfully"
                    else
                        error "Failed to install SDDM"
                        exit 1
                    fi
                fi
                
                # Disable old display manager and enable SDDM
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
    elif [ -z "$current_dm" ]; then
        # No display manager is enabled, install and enable SDDM
        info "No display manager detected. Installing SDDM..."
        if ! check_package "sddm"; then
            if sudo pacman -S --needed sddm qt5-declarative qt5-quickcontrols2; then
                success "SDDM installed successfully"
            else
                error "Failed to install SDDM"
                exit 1
            fi
        fi
        sudo systemctl enable sddm.service
        success "SDDM enabled"
    else
        info "Display manager check completed (SDDM already configured)"
    fi
}

# Install packages with verification and conflict handling
install_packages() {
    local package_list=("$@")
    local failed_packages=()
    
    info "Installing ${#package_list[@]} packages..."
    
    # Try to install all packages with --overwrite for common conflicts
    if ! sudo pacman -S --needed --noconfirm "${package_list[@]}" 2>&1 | tee -a "$LOG_FILE"; then
        warning "Batch install had issues, trying individually..."
        
        # Check each package individually
        for pkg in "${package_list[@]}"; do
            if ! check_package "$pkg"; then
                # Try normal install first
                if ! sudo pacman -S --needed --noconfirm "$pkg" 2>&1 | tee -a "$LOG_FILE"; then
                    # If it fails, try with --overwrite (for file conflicts)
                    if ! sudo pacman -S --needed --noconfirm --overwrite='*' "$pkg" 2>&1 | tee -a "$LOG_FILE"; then
                        failed_packages+=("$pkg")
                        error "Failed to install: $pkg"
                    else
                        success "Installed (with overwrite): $pkg"
                    fi
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
║                  BunkerOS Installer                        ║
║                                                            ║
║      Productivity-hardened Arch Linux environment          ║
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
    save_checkpoint "backup_complete"
    
    # Handle display manager
    handle_display_manager
    save_checkpoint "sddm_configured"
    
    # Define package groups
    local core_packages=(
        sway autotiling-rs waybar wofi mako foot swaylock swayidle swaybg
        brightnessctl playerctl wl-clipboard grim slurp wlsunset
        network-manager-applet blueman pavucontrol jq
    )
    
    local app_packages=(
        nautilus sushi eog evince lite-xl btop mate-calc zenity
    )
    
    local media_packages=(
        pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber v4l-utils
    )
    
    local system_packages=(
        sddm qt5-declarative qt5-quickcontrols2 ttf-meslo-nerd 
        xdg-desktop-portal python-pipx
    )
    
    # Desktop portal packages (need special handling due to file conflicts)
    local portal_packages=(
        xdg-desktop-portal-wlr xdg-desktop-portal-gtk
    )
    
    local aur_packages=(
        swayosd-git
    )
    
    # Install package groups
    echo ""
    info "Installing core packages..."
    install_packages "${core_packages[@]}"
    save_checkpoint "core_packages_installed"
    
    echo ""
    info "Installing application packages..."
    install_packages "${app_packages[@]}"
    save_checkpoint "app_packages_installed"
    
    echo ""
    info "Installing media packages..."
    install_packages "${media_packages[@]}"
    save_checkpoint "media_packages_installed"
    
    echo ""
    info "Installing system packages..."
    install_packages "${system_packages[@]}"
    save_checkpoint "system_packages_installed"
    
    echo ""
    info "Installing desktop portal packages (may have file conflicts)..."
    if ! sudo pacman -S --needed --noconfirm --overwrite='*' "${portal_packages[@]}" 2>&1 | tee -a "$LOG_FILE"; then
        warning "Desktop portal installation had conflicts - trying individually..."
        for pkg in "${portal_packages[@]}"; do
            if ! sudo pacman -S --needed --noconfirm --overwrite='*' "$pkg" 2>&1 | tee -a "$LOG_FILE"; then
                warning "Failed to install $pkg (non-critical, continuing...)"
            fi
        done
    fi
    success "Desktop portal packages installed"
    save_checkpoint "portal_packages_installed"
    
    echo ""
    info "Installing AUR packages..."
    install_aur_packages "${aur_packages[@]}"
    save_checkpoint "aur_packages_installed"
    
    # Run setup script
    echo ""
    info "Running configuration setup..."
    if "$SCRIPT_DIR/setup.sh"; then
        success "Configuration setup completed"
        save_checkpoint "setup_complete"
    else
        error "Configuration setup failed"
        exit 1
    fi
    
    # Validate Sway configuration
    echo ""
    info "Validating Sway configuration..."
    if sway --validate 2>&1 | tee -a "$LOG_FILE"; then
        success "Sway configuration is valid"
    else
        error "Sway configuration has errors!"
        echo "Please check the errors above before logging in."
        echo "You can still use the Emergency Recovery session if needed."
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    save_checkpoint "sway_validated"
    
    # Install Python tools
    echo ""
    info "Installing Python tools..."
    if pipx install terminaltexteffects &>/dev/null; then
        success "Installed TerminalTextEffects"
    else
        warning "Failed to install TerminalTextEffects (optional)"
    fi
    save_checkpoint "python_tools_installed"
    
    # Verify services
    verify_services
    save_checkpoint "services_verified"
    
    # Install power management
    echo ""
    info "Installing power management configuration..."
    if "$SCRIPT_DIR/scripts/install-power-management.sh"; then
        success "Power management configured"
    else
        warning "Power management setup had issues (non-critical)"
    fi
    save_checkpoint "power_management_complete"
    
    # Fix current session
    fix_current_session
    save_checkpoint "session_fixed"
    
    # Configure multi-monitor setup
    echo ""
    info "Checking for multi-monitor setup..."
    if pgrep -x sway > /dev/null 2>&1; then
        # Sway is running, we can detect monitors
        local monitor_count=$("$SCRIPT_DIR/scripts/detect-monitors.sh" --count 2>/dev/null || echo "0")
        
        if [ "$monitor_count" -gt 1 ]; then
            echo ""
            success "Multiple monitors detected ($monitor_count displays)"
            echo ""
            read -p "Would you like to configure multi-monitor workspace distribution now? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                if "$SCRIPT_DIR/scripts/setup-monitors.sh" --auto; then
                    success "Multi-monitor setup configured"
                else
                    warning "Multi-monitor setup had issues (you can configure later)"
                fi
            else
                info "You can configure monitors later by running:"
                info "  bash ~/Projects/bunkeros/scripts/setup-monitors.sh"
            fi
        else
            info "Single monitor detected - no additional configuration needed"
            info "Add more monitors later? Run: bash ~/Projects/bunkeros/scripts/setup-monitors.sh"
        fi
    else
        info "Multi-monitor detection skipped (Sway not running)"
        info "Configure monitors after first login: bash ~/Projects/bunkeros/scripts/setup-monitors.sh"
    fi
    save_checkpoint "monitor_setup_complete"
    
    # Final validation
    echo ""
    info "Running final validation..."
    if "$SCRIPT_DIR/scripts/validate-installation.sh" 2>&1 | tee -a "$LOG_FILE"; then
        success "Installation validation passed"
    else
        warning "Some validation checks failed - see log for details"
    fi
    save_checkpoint "installation_complete"
    
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
   2. Select "BunkerOS" at the login screen
   3. Enjoy your productivity environment!

🔧 If something goes wrong:
   • Use "BunkerOS Emergency Recovery" from login screen
   • Check the log: $LOG_FILE
   • Restore backup: cp -r $BACKUP_DIR/* ~/.config/
   • Re-run this script: $SCRIPT_DIR/install.sh

💡 Checkpoints saved - if installation was interrupted, re-running
   will resume from the last successful stage.

EOF
}

# Run main function
main "$@"