#!/bin/bash
# BunkerOS Advanced Performance Optimization Installer
# Installs GPU power management, I/O optimization, and kernel tuning

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

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

cat << "EOF"
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║     BunkerOS Advanced Performance Optimization            ║
║     Achieving Pop!_OS Parity and Beyond                   ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
EOF

echo ""
echo "This installer will configure:"
echo "  1. GPU Power Management (Intel/AMD/Nvidia)"
echo "  2. I/O Scheduler Optimization (NVMe/SSD/HDD)"
echo "  3. Kernel Parameter Tuning (sysctl)"
echo "  4. Network & Memory Optimization"
echo ""
warn "Some optimizations require a reboot to take full effect"
echo ""

read -p "Continue with installation? (Y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  Phase 1: GPU Power Management"
echo "═══════════════════════════════════════════════════════════"
echo ""

if [ -f "$SCRIPT_DIR/configure-gpu-power.sh" ]; then
    bash "$SCRIPT_DIR/configure-gpu-power.sh"
    GPU_STATUS=$?
else
    error "GPU configuration script not found"
    GPU_STATUS=1
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  Phase 2: I/O Scheduler Optimization"
echo "═══════════════════════════════════════════════════════════"
echo ""

if [ -f "$SCRIPT_DIR/configure-io-scheduler.sh" ]; then
    bash "$SCRIPT_DIR/configure-io-scheduler.sh"
    IO_STATUS=$?
else
    error "I/O scheduler script not found"
    IO_STATUS=1
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  Phase 3: Kernel Parameter Tuning"
echo "═══════════════════════════════════════════════════════════"
echo ""

info "Installing system-wide kernel optimizations..."
echo ""

# Install sysctl configuration
SYSCTL_SRC="$PROJECT_DIR/systemd/sysctl.d/99-bunkeros-performance.conf"
SYSCTL_DST="/etc/sysctl.d/99-bunkeros-performance.conf"

if [ -f "$SYSCTL_SRC" ]; then
    sudo cp "$SYSCTL_SRC" "$SYSCTL_DST"
    sudo chmod 644 "$SYSCTL_DST"
    success "Installed: $SYSCTL_DST"
    
    # Apply immediately
    info "Applying kernel parameters..."
    if sudo sysctl --system > /dev/null 2>&1; then
        success "Kernel parameters applied"
        SYSCTL_STATUS=0
    else
        warn "Some kernel parameters may require reboot"
        SYSCTL_STATUS=1
    fi
else
    error "sysctl configuration file not found: $SYSCTL_SRC"
    SYSCTL_STATUS=1
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  Phase 4: Network Optimization"
echo "═══════════════════════════════════════════════════════════"
echo ""

info "Enabling TCP BBR congestion control..."

# Check if BBR module is available
if modinfo tcp_bbr > /dev/null 2>&1; then
    # Load module now
    sudo modprobe tcp_bbr 2>/dev/null || true
    
    # Add to modules-load for persistence
    if [ ! -f /etc/modules-load.d/bunkeros-network.conf ]; then
        echo "tcp_bbr" | sudo tee /etc/modules-load.d/bunkeros-network.conf > /dev/null
        success "TCP BBR enabled (persistent across reboots)"
    else
        success "TCP BBR already configured"
    fi
    NET_STATUS=0
else
    warn "TCP BBR module not available in kernel"
    info "Your kernel may not support BBR (requires Linux 4.9+)"
    NET_STATUS=1
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  Installation Summary"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Summary table
printf "%-30s %s\n" "Component" "Status"
printf "%-30s %s\n" "─────────────────────────────" "──────"

if [ $GPU_STATUS -eq 0 ]; then
    printf "%-30s ${GREEN}✓ Configured${NC}\n" "GPU Power Management"
else
    printf "%-30s ${YELLOW}⚠ Skipped${NC}\n" "GPU Power Management"
fi

if [ $IO_STATUS -eq 0 ]; then
    printf "%-30s ${GREEN}✓ Configured${NC}\n" "I/O Scheduler"
else
    printf "%-30s ${YELLOW}⚠ Skipped${NC}\n" "I/O Scheduler"
fi

if [ $SYSCTL_STATUS -eq 0 ]; then
    printf "%-30s ${GREEN}✓ Applied${NC}\n" "Kernel Parameters"
else
    printf "%-30s ${YELLOW}⚠ Partial${NC}\n" "Kernel Parameters"
fi

if [ $NET_STATUS -eq 0 ]; then
    printf "%-30s ${GREEN}✓ Enabled${NC}\n" "Network Optimization"
else
    printf "%-30s ${YELLOW}⚠ Unavailable${NC}\n" "Network Optimization"
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  Next Steps"
echo "═══════════════════════════════════════════════════════════"
echo ""

warn "REBOOT REQUIRED for full optimization"
echo ""
info "After reboot, verify optimizations:"
echo ""
echo "  1. Check GPU power management:"
echo "     cat /sys/class/drm/card0/device/power/control"
echo ""
echo "  2. Check I/O schedulers:"
echo "     cat /sys/block/*/queue/scheduler"
echo ""
echo "  3. Verify kernel parameters:"
echo "     sysctl vm.swappiness"
echo "     sysctl net.ipv4.tcp_congestion_control"
echo ""
echo "  4. Monitor power usage:"
echo "     sudo auto-cpufreq --stats"
echo "     sudo powertop  # Install with: sudo pacman -S powertop"
echo ""

info "For detailed performance analysis, see:"
info "  $PROJECT_DIR/docs/development/performance-optimization-plan.md"

echo ""

# Offer to reboot
read -p "Reboot now to apply all changes? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    info "Rebooting in 5 seconds... (Ctrl+C to cancel)"
    sleep 5
    sudo reboot
else
    echo ""
    success "Installation complete!"
    warn "Remember to reboot when convenient"
fi
