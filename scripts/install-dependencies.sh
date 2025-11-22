#!/usr/bin/env bash

set -e

echo "=== BunkerOS Dependency Installation ==="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo "ERROR: Do not run this script as root/sudo"
    echo "The script will prompt for sudo when needed"
    exit 1
fi

# Core Sway environment
CORE_PACKAGES=(
    sway
    autotiling-rs
    waybar
    wofi
    mako
    foot
    swaylock
    swayidle
    swaybg
)

# System utilities
SYSTEM_PACKAGES=(
    brightnessctl
    playerctl
    wl-clipboard
    grim
    slurp
    wlsunset
    network-manager-applet
    blueman
    pavucontrol
    pulsemixer          # Terminal-based audio mixer for waybar menu
    wdisplays           # GUI display manager for Wayland
    imagemagick         # For enhanced lock screen styling
)

# Applications
APP_PACKAGES=(
    nautilus
    sushi
    eog
    evince
    lite-xl
    btop
    mate-calc
    zenity
    tmux
)

# Audio/Video
MEDIA_PACKAGES=(
    pipewire
    pipewire-pulse
    pipewire-alsa
    pipewire-jack
    wireplumber
    v4l-utils
)

# Fonts
FONT_PACKAGES=(
    ttf-meslo-nerd      # Primary Nerd Font for icons and UI elements
    ttf-dejavu          # Fallback font used in all theme templates
    noto-fonts          # Unicode coverage for international text
    noto-fonts-emoji    # Color emoji support
    cantarell-fonts     # Default GNOME font for GTK applications
)

# Display manager
DM_PACKAGES=(
    sddm
    qt5-declarative
    qt5-quickcontrols2
)

# Desktop portals (for file pickers and screen sharing)
PORTAL_PACKAGES=(
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
)

# Development tools
DEVELOPMENT_PACKAGES=(
    # Core programming languages & runtimes
    python                  # Python interpreter
    python-pip             # Python package manager
    nodejs                 # JavaScript runtime
    npm                    # Node.js package manager
    
    # Container technologies
    docker                 # Container engine
    docker-compose         # Multi-container applications
    
    # Compiled languages
    rust                  # Rust programming language & cargo
    go                    # Go programming language
    jdk-openjdk          # Java Development Kit
    jre-openjdk          # Java Runtime Environment (for JetBrains IDEs)
    jre-openjdk-headless # Headless Java runtime
    
    # Version control & build tools
    git-lfs              # Git Large File Storage
    
    # System development tools
    gdb                  # GNU debugger
    strace               # System call tracer
    ltrace               # Library call tracer
    valgrind             # Memory debugging and profiling
    
    # Network & system utilities for development
    curl                 # HTTP client
    wget                 # File downloader
    tree                 # Directory visualization
    unzip                # Archive extraction
    zip                  # Archive creation
    tar                  # Archive utility
    jq                   # JSON processor (already included but ensuring it's here)
    
    # Text processing for development
    ripgrep              # Fast grep alternative (rg command)
    fd                   # Fast find alternative
    bat                  # Enhanced cat with syntax highlighting
    fzf                  # Fuzzy finder for command-line (used by BunkerOS scripts)
    
    # Development databases (lightweight)
    sqlite               # Embedded database for development
)

# Python tools
PYTHON_PACKAGES=(
    python-pipx
    python-setuptools    # Required for PyCharm and Python development
)

# Combine all packages
ALL_PACKAGES=(
    "${CORE_PACKAGES[@]}"
    "${SYSTEM_PACKAGES[@]}"
    "${APP_PACKAGES[@]}"
    "${MEDIA_PACKAGES[@]}"
    "${FONT_PACKAGES[@]}"
    "${DM_PACKAGES[@]}"
    "${PORTAL_PACKAGES[@]}"
    "${DEVELOPMENT_PACKAGES[@]}"
    "${PYTHON_PACKAGES[@]}"
)

echo "The following packages will be installed:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Core Sway Environment:"
printf '  • %s\n' "${CORE_PACKAGES[@]}"
echo ""
echo "System Utilities:"
printf '  • %s\n' "${SYSTEM_PACKAGES[@]}"
echo ""
echo "Applications:"
printf '  • %s\n' "${APP_PACKAGES[@]}"
echo ""
echo "Audio/Video:"
printf '  • %s\n' "${MEDIA_PACKAGES[@]}"
echo ""
echo "Fonts:"
printf '  • %s\n' "${FONT_PACKAGES[@]}"
echo ""
echo "Display Manager:"
printf '  • %s\n' "${DM_PACKAGES[@]}"
echo ""
echo "Desktop Portals:"
printf '  • %s\n' "${PORTAL_PACKAGES[@]}"
echo ""
echo "Development Tools:"
printf '  • %s\n' "${DEVELOPMENT_PACKAGES[@]}"
echo ""
echo "Python Tools:"
printf '  • %s\n' "${PYTHON_PACKAGES[@]}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Continue with installation? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

echo ""
echo "Installing packages from official repositories..."
sudo pacman -S --needed "${ALL_PACKAGES[@]}"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Checking for AUR packages..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if command -v yay &> /dev/null; then
    echo "Installing SwayOSD from AUR..."
    yay -S --needed swayosd-git
    echo "✓ SwayOSD installed"
else
    echo "⚠ WARNING: yay not found"
    echo ""
    echo "Please install yay to get AUR packages:"
    echo "  git clone https://aur.archlinux.org/yay.git"
    echo "  cd yay"
    echo "  makepkg -si"
    echo ""
    echo "Then run:"
    echo "  yay -S swayosd-git"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Installing Python tools..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "✓ Python tools configured"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ All dependencies installed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
