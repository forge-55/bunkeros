#!/bin/bash
# BunkerOS GPU Power Management Configuration
# Automatically detects and configures GPU power management for Intel, AMD, and Nvidia

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="/etc/bunkeros"
GPU_CONFIG="$CONFIG_DIR/gpu-power.conf"

# Colors and formatting
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info() { echo -e "${BLUE}ℹ️  ${NC}$1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠️  ${NC}$1"; }
error() { echo -e "${RED}✗${NC} $1"; }

echo "╔════════════════════════════════════════════════════════════╗"
echo "║         BunkerOS GPU Power Management Setup                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Create config directory if needed
if [ ! -d "$CONFIG_DIR" ]; then
    info "Creating BunkerOS config directory..."
    sudo mkdir -p "$CONFIG_DIR"
fi

# Detect GPU vendor and model
detect_gpu() {
    local gpu_info=""
    local vendor=""
    local model=""
    
    # Try to get GPU info from lspci
    if command -v lspci &>/dev/null; then
        gpu_info=$(lspci | grep -i 'vga\|3d\|display' | head -1)
        
        if echo "$gpu_info" | grep -qi "intel"; then
            vendor="intel"
            model=$(echo "$gpu_info" | grep -oP '(?<=Intel Corporation ).*' | sed 's/\[.*\]//' | xargs)
        elif echo "$gpu_info" | grep -qi "amd\|radeon"; then
            vendor="amd"
            model=$(echo "$gpu_info" | grep -oP '(?<=AMD/ATI ).*|(?<=Advanced Micro Devices ).*' | sed 's/\[.*\]//' | xargs)
        elif echo "$gpu_info" | grep -qi "nvidia"; then
            vendor="nvidia"
            model=$(echo "$gpu_info" | grep -oP '(?<=NVIDIA Corporation ).*' | sed 's/\[.*\]//' | xargs)
        else
            vendor="unknown"
            model="Unknown GPU"
        fi
    else
        vendor="unknown"
        model="lspci not available"
    fi
    
    echo "$vendor|$model|$gpu_info"
}

# Configure Intel GPU power management
configure_intel_gpu() {
    local model="$1"
    
    info "Configuring Intel GPU power management..."
    echo ""
    
    # Find the Intel GPU card (could be card0, card1, etc.)
    local intel_card=""
    for card in /sys/class/drm/card*/device; do
        if [ -d "$card" ] && [ -f "$card/vendor" ]; then
            local vendor=$(cat "$card/vendor" 2>/dev/null)
            if [ "$vendor" = "0x8086" ]; then
                intel_card="$card"
                break
            fi
        fi
    done
    
    if [ -z "$intel_card" ]; then
        warn "Intel GPU device not found in /sys/class/drm/, skipping configuration"
        return 1
    fi
    
    info "Found Intel GPU at: $intel_card"
    
    # Create kernel parameter file for i915
    local kernel_params_file="/etc/modprobe.d/i915-power.conf"
    
    info "Creating i915 kernel module configuration..."
    sudo tee "$kernel_params_file" > /dev/null << 'EOF'
# BunkerOS Intel GPU Power Management
# Enable aggressive power saving for i915 driver

# Enable RC6 sleep states (reduces power when GPU is idle)
options i915 enable_rc6=1

# Enable frame buffer compression (saves memory bandwidth)
options i915 enable_fbc=1

# Enable PSR (Panel Self Refresh) for eDP displays
options i915 enable_psr=1

# GuC/HuC firmware for better power management (Gen9+)
options i915 enable_guc=3
EOF
    
    success "Intel i915 power management configured"
    success "Created: $kernel_params_file"
    echo ""
    
    # Enable runtime PM for Intel GPU
    info "Enabling runtime power management..."
    
    # Create udev rule for automatic runtime PM
    local udev_rule="/etc/udev/rules.d/50-intel-gpu-pm.rules"
    sudo tee "$udev_rule" > /dev/null << 'EOF'
# BunkerOS Intel GPU Runtime Power Management
# Automatically enable runtime PM for Intel GPUs

ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{class}=="0x03*", ATTR{power/control}="auto"
EOF
    success "Created udev rule: $udev_rule"
    
    # Apply immediately to all Intel GPU devices
    for card_power in /sys/class/drm/card*/device/power/control; do
        if [ -f "$card_power" ]; then
            local card_vendor=$(cat "$(dirname $(dirname $card_power))/vendor" 2>/dev/null)
            if [ "$card_vendor" = "0x8086" ]; then
                echo "auto" | sudo tee "$card_power" > /dev/null 2>&1 && \
                    success "Enabled runtime PM for $(basename $(dirname $(dirname $card_power)))"
            fi
        fi
    done
    
    echo ""
    info "Intel GPU power management configured successfully"
    info "Reboot required for full effect"
    
    return 0
}

# Configure AMD GPU power management
configure_amd_gpu() {
    local model="$1"
    
    info "Configuring AMD GPU power management..."
    echo ""
    
    # Find the AMD GPU card
    local amd_card=""
    for card in /sys/class/drm/card*/device; do
        if [ -d "$card" ] && [ -f "$card/vendor" ]; then
            local vendor=$(cat "$card/vendor" 2>/dev/null)
            if [ "$vendor" = "0x1002" ]; then
                amd_card="$card"
                break
            fi
        fi
    done
    
    if [ -z "$amd_card" ]; then
        warn "AMD GPU device not found in /sys/class/drm/, skipping configuration"
        return 1
    fi
    
    info "Found AMD GPU at: $amd_card"
    
    # Create kernel parameter file for amdgpu
    local kernel_params_file="/etc/modprobe.d/amdgpu-power.conf"
    
    info "Creating amdgpu kernel module configuration..."
    sudo tee "$kernel_params_file" > /dev/null << 'EOF'
# BunkerOS AMD GPU Power Management
# Enable power management features for amdgpu driver

# Enable dynamic power management
options amdgpu dpm=1

# Set power profile to auto (balanced)
options amdgpu ppfeaturemask=0xffffffff

# Enable audio power management
options amdgpu audio=1
EOF
    
    success "AMD amdgpu power management configured"
    success "Created: $kernel_params_file"
    echo ""
    
    # Enable runtime PM and dynamic power management
    info "Enabling runtime power management..."
    local udev_rule="/etc/udev/rules.d/50-amd-gpu-pm.rules"
    sudo tee "$udev_rule" > /dev/null << 'EOF'
# BunkerOS AMD GPU Runtime Power Management
# Automatically enable runtime PM and DPM for AMD GPUs

ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1002", ATTR{class}=="0x03*", ATTR{power/control}="auto"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1002", ATTR{class}=="0x03*", ATTR{device/power_dpm_state}="balanced"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1002", ATTR{class}=="0x03*", ATTR{device/power_dpm_force_performance_level}="auto"
EOF
    success "Created udev rule: $udev_rule"
    
    # Apply immediately to all AMD GPU devices
    for card_power in /sys/class/drm/card*/device/power/control; do
        if [ -f "$card_power" ]; then
            local card_vendor=$(cat "$(dirname $(dirname $card_power))/vendor" 2>/dev/null)
            if [ "$card_vendor" = "0x1002" ]; then
                echo "auto" | sudo tee "$card_power" > /dev/null 2>&1 && \
                    success "Enabled runtime PM for $(basename $(dirname $(dirname $card_power)))"
                
                # Set DPM state if available
                local card_dir=$(dirname $(dirname $card_power))
                if [ -f "$card_dir/power_dpm_state" ]; then
                    echo "balanced" | sudo tee "$card_dir/power_dpm_state" > /dev/null 2>&1
                fi
                if [ -f "$card_dir/power_dpm_force_performance_level" ]; then
                    echo "auto" | sudo tee "$card_dir/power_dpm_force_performance_level" > /dev/null 2>&1
                fi
            fi
        fi
    done
    
    success "Runtime PM and DPM enabled for current session"
    echo ""
    info "AMD GPU power management configured successfully"
    info "Reboot required for full effect"
    
    return 0
}

# Configure Nvidia GPU power management
configure_nvidia_gpu() {
    local model="$1"
    
    info "Configuring Nvidia GPU power management..."
    echo ""
    
    # Check if Nvidia driver is installed
    if ! command -v nvidia-smi &>/dev/null; then
        warn "Nvidia driver not detected"
        warn "GPU power management requires proprietary Nvidia driver"
        echo ""
        info "If you're using Nvidia GPU, install driver with:"
        info "  sudo pacman -S nvidia nvidia-utils"
        echo ""
        warn "Skipping Nvidia GPU configuration"
        return 1
    fi
    
    # Create Nvidia power management configuration
    local nvidia_config="/etc/modprobe.d/nvidia-power.conf"
    
    info "Creating Nvidia kernel module configuration..."
    sudo tee "$nvidia_config" > /dev/null << 'EOF'
# BunkerOS Nvidia GPU Power Management
# Enable power management for proprietary Nvidia driver

# Enable runtime power management (requires driver >= 465)
options nvidia NVreg_DynamicPowerManagement=0x02

# Preserve video memory allocations during suspend
options nvidia NVreg_PreserveVideoMemoryAllocations=1

# Enable GSP firmware (for newer GPUs)
options nvidia NVreg_EnableGpuFirmware=1
EOF
    
    success "Nvidia power management configured"
    success "Created: $nvidia_config"
    echo ""
    
    # Enable nvidia runtime PM services
    info "Enabling Nvidia suspend/resume services..."
    
    if systemctl list-unit-files | grep -q "nvidia-suspend.service"; then
        sudo systemctl enable nvidia-suspend.service
        sudo systemctl enable nvidia-hibernate.service
        sudo systemctl enable nvidia-resume.service
        success "Nvidia power services enabled"
    else
        warn "Nvidia suspend services not found (may need newer driver)"
    fi
    
    echo ""
    
    # Create udev rule for runtime PM
    local udev_rule="/etc/udev/rules.d/50-nvidia-gpu-pm.rules"
    sudo tee "$udev_rule" > /dev/null << 'EOF'
# BunkerOS Nvidia GPU Runtime Power Management
# Enable runtime PM for Nvidia GPUs (requires driver >= 465)

ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03*", ATTR{power/control}="auto"
EOF
    success "Created udev rule: $udev_rule"
    
    echo ""
    info "Nvidia GPU power management configured successfully"
    info "Reboot required for full effect"
    
    return 0
}

# Profile-aware power limits (future enhancement)
apply_power_profile() {
    local profile="${1:-auto}"
    
    # This function can be called by auto-cpufreq profile switcher
    # to apply GPU-specific power limits per profile
    
    case "$profile" in
        "powersave")
            # Apply aggressive GPU power saving
            info "Applying power-save GPU settings..."
            ;;
        "performance")
            # Allow maximum GPU performance
            info "Applying performance GPU settings..."
            ;;
        *)
            # Balanced/auto mode
            info "Applying balanced GPU settings..."
            ;;
    esac
}

# Main execution
main() {
    info "Detecting GPU hardware..."
    echo ""
    
    IFS='|' read -r vendor model gpu_info <<< "$(detect_gpu)"
    
    if [ "$vendor" = "unknown" ]; then
        error "Could not detect GPU"
        echo "GPU Info: $gpu_info"
        echo ""
        warn "GPU power management will not be configured"
        exit 1
    fi
    
    echo -e "${BOLD}Detected GPU:${NC}"
    echo "  Vendor: $vendor"
    echo "  Model:  $model"
    echo ""
    
    # Save GPU info to config
    info "Saving GPU configuration..."
    sudo tee "$GPU_CONFIG" > /dev/null << EOF
# BunkerOS GPU Configuration
# Auto-generated by configure-gpu-power.sh
# $(date)

GPU_VENDOR="$vendor"
GPU_MODEL="$model"
GPU_INFO="$gpu_info"
CONFIGURED_DATE="$(date -Iseconds)"
EOF
    success "Configuration saved to: $GPU_CONFIG"
    echo ""
    
    # Configure based on vendor
    case "$vendor" in
        intel)
            configure_intel_gpu "$model"
            ;;
        amd)
            configure_amd_gpu "$model"
            ;;
        nvidia)
            configure_nvidia_gpu "$model"
            ;;
        *)
            error "Unknown GPU vendor: $vendor"
            exit 1
            ;;
    esac
    
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                   Configuration Complete                   ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    success "GPU power management configured for: $vendor $model"
    echo ""
    warn "Reboot required for all changes to take effect"
    echo ""
    info "After reboot, verify with:"
    case "$vendor" in
        intel)
            echo "  cat /sys/class/drm/card*/device/power/control  # Should show 'auto' for Intel GPU"
            echo "  cat /sys/module/i915/parameters/enable_rc6     # Should show '1'"
            ;;
        amd)
            echo "  cat /sys/class/drm/card*/device/power/control  # Should show 'auto' for AMD GPU"
            echo "  cat /sys/class/drm/card*/device/power_dpm_state # Should show 'balanced'"
            ;;
        nvidia)
            echo "  nvidia-smi -q -d POWER  # Check power management mode"
            echo "  systemctl status nvidia-suspend.service"
            ;;
    esac
    echo ""
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
