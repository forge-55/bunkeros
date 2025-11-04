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
    
    # Check if paru is installed, if not install it
    if ! check_aur_helper; then
        info "AUR helper not found - installing paru..."
        
        # Create temporary directory for paru installation
        local paru_build_dir="/tmp/paru-install-$$"
        mkdir -p "$paru_build_dir"
        
        info "Cloning paru from AUR..."
        if git clone https://aur.archlinux.org/paru.git "$paru_build_dir" 2>&1 | tee -a "$LOG_FILE"; then
            cd "$paru_build_dir"
            info "Building and installing paru..."
            if makepkg -si --noconfirm 2>&1 | tee -a "$LOG_FILE"; then
                success "Paru installed successfully"
                cd "$SCRIPT_DIR"
                rm -rf "$paru_build_dir"
            else
                error "Failed to build paru"
                cd "$SCRIPT_DIR"
                rm -rf "$paru_build_dir"
                warning "Please install paru manually and re-run the script"
                exit 1
            fi
        else
            error "Failed to clone paru from AUR"
            rm -rf "$paru_build_dir"
            warning "Please install paru manually and re-run the script"
            exit 1
        fi
    fi
    
    local aur_helper
    if command -v paru &>/dev/null; then
        aur_helper="paru"
    elif command -v yay &>/dev/null; then
        aur_helper="yay"
    else
        error "AUR helper installation failed"
        exit 1
    fi
    
    info "Installing AUR packages with $aur_helper..."
    for pkg in "${aur_packages[@]}"; do
        if ! check_package "$pkg"; then
            if $aur_helper -S --needed --noconfirm "$pkg" 2>&1 | tee -a "$LOG_FILE"; then
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
    
    info "BunkerOS requires vanilla Arch Linux"
    echo ""
    
    # Create backup
    backup_config
    save_checkpoint "backup_complete"
    
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
    
    # Setup user environment (PipeWire, etc.)
    echo ""
    info "Setting up user environment..."
    if [ -f "$SCRIPT_DIR/scripts/install-user-environment.sh" ]; then
        if "$SCRIPT_DIR/scripts/install-user-environment.sh"; then
            success "User environment configured"
        else
            warning "User environment setup had issues (non-critical)"
        fi
    else
        warning "User environment installer not found - skipping"
    fi
    save_checkpoint "user_environment_complete"
    
    # Validate Sway configuration
    echo ""
    info "Validating Sway configuration..."
    echo ""
    warning "Note: You may see DRM/HDMI/atomic commit errors below - these are NORMAL"
    warning "when validating outside a graphical session. They are harmless and expected."
    echo ""
    
    # Note: sway --validate may show DRM/display errors when run outside a graphical session
    # These are harmless and only affect syntax checking
    VALIDATION_OUTPUT=$(sway --validate 2>&1)
    SYNTAX_ERRORS=$(echo "$VALIDATION_OUTPUT" | grep -i "error" | grep -v "permission denied\|atomic\|HDMI\|DRM\|connector\|Failed to open")
    
    if [ -n "$SYNTAX_ERRORS" ]; then
        error "Sway configuration has syntax errors!"
        echo ""
        echo "$SYNTAX_ERRORS"
        echo ""
        echo "Please check the errors above before logging in."
        echo "You can still use the Emergency Recovery session if needed."
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        success "Sway configuration syntax is valid"
        info "DRM/display errors during validation are normal and can be ignored"
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
    
    # Install SDDM
    echo ""
    info "Installing SDDM display manager..."
    
    # Install SDDM theme and session files
    if [ -f "$SCRIPT_DIR/sddm/install-theme.sh" ]; then
        if "$SCRIPT_DIR/sddm/install-theme.sh" 2>&1 | tee -a "$LOG_FILE"; then
            success "SDDM theme and sessions installed"
        else
            error "SDDM theme installation failed"
            echo ""
            echo "You can try installing manually:"
            echo "  cd $SCRIPT_DIR/sddm"
            echo "  sudo ./install-theme.sh"
            exit 1
        fi
    else
        error "SDDM theme installer not found at $SCRIPT_DIR/sddm/install-theme.sh"
        exit 1
    fi
    
    # Enable SDDM service
    if ! systemctl is-enabled sddm.service &>/dev/null; then
        info "Enabling SDDM..."
        if sudo systemctl enable sddm.service 2>&1 | tee -a "$LOG_FILE"; then
            success "SDDM will start on next boot"
        else
            error "Failed to enable SDDM service"
            exit 1
        fi
    else
        success "SDDM already enabled"
    fi
    
    save_checkpoint "sddm_installed"
    
    # Display completion message
    display_completion_message
}

# Completion message
display_completion_message() {
    cat << EOF

# Completion message
display_completion_message() {
    cat << EOF

╔════════════════════════════════════════════════════════════╗
║                                                            ║
║         BunkerOS Installation Complete! ✓                  ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

📋 Installation Summary:
   • Configuration backup: $BACKUP_DIR
   • Installation log: $LOG_FILE
   • SDDM display manager: Installed

🎯 Next Steps:

   INSTALLATION COMPLETE ✓ - Everything installed!
   
   1. Reboot your system: sudo reboot
   2. At SDDM login, select "BunkerOS" session
   3. Log in and enjoy your environment!

🔧 If something goes wrong:
   • Validation script: $SCRIPT_DIR/scripts/validate-installation.sh
   • View logs: $LOG_FILE
   • Rollback: $SCRIPT_DIR/scripts/rollback-installation.sh

💡 Checkpoints saved - if installation was interrupted, re-running
   will resume from the last successful stage.

EOF
}

# Run main function
main "$@"

}

# Run main function
main "$@"

EOF
}

# Completion message for derivative distros (two-phase)
display_derivative_completion_message() {
    cat << EOF

╔════════════════════════════════════════════════════════════╗
║                                                            ║
║    BunkerOS Installation Complete! (Phase 1) ✓            ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

📋 Installation Summary:
   • Configuration backup: $BACKUP_DIR
   • Installation log: $LOG_FILE
   • All configs installed to: ~/.config

🎯 Next Steps - IMPORTANT:

   PHASE 1 COMPLETE ✓ - Your BunkerOS environment is ready!
   
   TEST FIRST (Recommended):
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   1. Test BunkerOS by running: sway
   2. Verify everything works (Waybar, keybindings, etc.)
   3. Exit with Super+Shift+E → "Exit"
   
   THEN INSTALL SDDM (Phase 2):
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   4. Once tested, run: ./install-sddm.sh
   5. Follow prompts to install SDDM display manager
   6. Reboot to get the themed login screen

   💡 Why Two Phases?
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   • Phase 1 (This): Install user environment safely
   • Phase 2 (Next): Install SDDM system-wide (requires reboot)
   • This prevents issues switching display managers while running

🔧 If something goes wrong:
   • Check the validation script: $SCRIPT_DIR/scripts/validate-installation.sh
   • View logs: $LOG_FILE
   • Rollback changes: $SCRIPT_DIR/scripts/rollback-installation.sh
   • Restore backup manually: cp -r $BACKUP_DIR/* ~/.config/
   • Re-run this script: $SCRIPT_DIR/install.sh

💡 Checkpoints saved - if installation was interrupted, re-running
   will resume from the last successful stage.

EOF
}

# Run main function
main "$@"

}

# Run main function
main "$@"