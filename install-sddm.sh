#!/usr/bin/env bash

# BunkerOS SDDM Installation (Phase 2)
# This script installs SDDM and sets it as the system display manager.
# Run this AFTER install.sh and after verifying BunkerOS works with 'sway' command.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/bunkeros-sddm-install.log"

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
    pacman -Qi "$1" &>/dev/null
}

# Detect and handle existing display manager
handle_display_manager() {
    info "Checking for existing display managers..."
    
    local current_dm=""
    local dm_service=""
    
    # Check which display manager is enabled
    for dm in gdm sddm lightdm ly lxdm; do
        if systemctl is-enabled "${dm}.service" &>/dev/null; then
            current_dm="$dm"
            dm_service="${dm}.service"
            break
        fi
    done
    
    if [ -n "$current_dm" ] && [ "$current_dm" != "sddm" ]; then
        warning "Current display manager: $current_dm"
        echo ""
        echo "BunkerOS works best with SDDM for the themed login experience."
        echo ""
        echo "⚠️  IMPORTANT: Switching display managers requires a reboot."
        echo "    Your current graphical session will NOT be interrupted."
        echo ""
        echo "Options:"
        echo "  1) Switch to SDDM (recommended - will disable $current_dm after reboot)"
        echo "  2) Keep $current_dm (you'll manually select BunkerOS from session menu)"
        echo "  3) Cancel"
        echo ""
        read -p "Choose option (1-3): " -n 1 -r
        echo
        
        case $REPLY in
            1)
                info "Switching to SDDM (will take effect after reboot)..."
                
                # Install SDDM and dependencies if not already installed
                if ! check_package "sddm"; then
                    info "Installing SDDM packages..."
                    if sudo pacman -S --needed --noconfirm sddm qt5-declarative qt5-quickcontrols2 2>&1 | tee -a "$LOG_FILE"; then
                        success "SDDM installed successfully"
                    else
                        error "Failed to install SDDM"
                        echo "You can install it manually later: sudo pacman -S sddm qt5-declarative qt5-quickcontrols2"
                        return 1
                    fi
                fi
                
                # Disable old display manager (don't stop it - that would kill the session)
                info "Disabling $current_dm (will take effect after reboot)..."
                sudo systemctl disable "$dm_service" 2>&1 | tee -a "$LOG_FILE" || true
                
                # Enable SDDM (will start on next boot)
                info "Enabling SDDM (will start after reboot)..."
                if sudo systemctl enable sddm.service 2>&1 | tee -a "$LOG_FILE"; then
                    success "SDDM will be activated on next reboot"
                else
                    error "Failed to enable SDDM service"
                    return 1
                fi
                
                return 0
                ;;
            2)
                warning "Keeping $current_dm"
                info "BunkerOS sessions will be available in your display manager's session menu"
                info "SDDM theme will still be installed (available if you switch to SDDM later)"
                return 0
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
            if sudo pacman -S --needed --noconfirm sddm qt5-declarative qt5-quickcontrols2 2>&1 | tee -a "$LOG_FILE"; then
                success "SDDM installed successfully"
            else
                error "Failed to install SDDM"
                return 1
            fi
        fi
        
        info "Enabling SDDM..."
        if sudo systemctl enable sddm.service 2>&1 | tee -a "$LOG_FILE"; then
            success "SDDM will be activated on next boot"
        else
            error "Failed to enable SDDM service"
            return 1
        fi
    else
        info "SDDM is already your display manager"
    fi
    
    return 0
}

main() {
    cat << "EOF"

╔════════════════════════════════════════════════════════════╗
║                                                            ║
║     BunkerOS SDDM Installation (Phase 2)                   ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

EOF

    log "Starting SDDM installation..."
    log "Log file: $LOG_FILE"
    
    # Verify Phase 1 was completed
    echo ""
    info "Verifying Phase 1 installation..."
    if [ ! -d "$HOME/.config/sway" ]; then
        error "BunkerOS user configuration not found!"
        echo ""
        echo "It looks like Phase 1 (install.sh) hasn't been run yet."
        echo "Please run ./install.sh first, then run this script."
        exit 1
    fi
    success "Phase 1 installation verified"
    
    # Recommend testing first
    echo ""
    info "Before switching display managers, it's recommended to test BunkerOS:"
    echo ""
    echo "  1. Open a terminal (TTY or your current desktop)"
    echo "  2. Run: sway"
    echo "  3. Verify BunkerOS works correctly"
    echo "  4. Exit (Super+Shift+E → Exit)"
    echo ""
    read -p "Have you tested BunkerOS and verified it works? (y/n) " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        warning "Please test BunkerOS first by running 'sway' command"
        echo ""
        echo "Once verified, run this script again:"
        echo "  ./install-sddm.sh"
        exit 0
    fi
    
    # Install SDDM theme and sessions (system-wide)
    echo ""
    info "Installing SDDM theme and session files..."
    if [ -f "$SCRIPT_DIR/sddm/install-theme.sh" ]; then
        if "$SCRIPT_DIR/sddm/install-theme.sh"; then
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
    
    # Handle display manager setup
    echo ""
    if ! handle_display_manager; then
        error "Display manager setup failed"
        exit 1
    fi
    
    # Final instructions
    cat << EOF

╔════════════════════════════════════════════════════════════╗
║                                                            ║
║         SDDM Installation Complete! ✓                      ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

📋 Installation Summary:
   • SDDM theme: Installed
   • BunkerOS sessions: Available
   • Installation log: $LOG_FILE

🎯 Next Steps:
   1. REBOOT your system: sudo reboot
   2. At the SDDM login screen, select "BunkerOS" from the session menu
   3. Enjoy your themed login experience!

🔧 Session Options Available:
   • BunkerOS - Full experience with Waybar
   • BunkerOS (No Waybar) - Minimal UI
   • BunkerOS Emergency Recovery - Safe mode

💡 Troubleshooting:
   • If login fails, use "BunkerOS Emergency Recovery"
   • Check logs: /tmp/bunkeros-launch.log (after login attempt)
   • Switch back to your old DM: sudo systemctl disable sddm && sudo systemctl enable gdm (or lightdm, etc.)
   • View installation log: $LOG_FILE

ℹ️  Your current graphical session is still active and safe.
    Changes will take effect after reboot.

EOF
}

# Run main function
main "$@"
