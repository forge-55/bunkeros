#!/usr/bin/env bash

# BunkerOS Complete Package List
# This is the definitive list of all packages required for BunkerOS

echo "=== BunkerOS Complete Package Requirements ==="
echo ""

# Core Sway environment packages
CORE_PACKAGES=(
    sway                     # Vanilla Sway Wayland compositor
    autotiling-rs            # Intelligent automatic window tiling
    waybar                   # Status bar
    wofi                     # Application launcher and menus
    mako                     # Notification daemon
    foot                     # Terminal emulator
    swaylock                 # Screen locker
    swayidle                 # Idle management
    swaybg                   # Wallpaper manager
)

# System utilities
SYSTEM_PACKAGES=(
    brightnessctl            # Brightness control for laptops
    playerctl               # Media player control
    wl-clipboard            # Wayland clipboard utilities
    grim                    # Screenshot capture
    slurp                   # Area selection for screenshots
    wlsunset                # Night mode (color temperature adjustment)
    network-manager-applet  # Network management GUI
    blueman                 # Bluetooth management
    pavucontrol            # Audio control GUI
    zenity                 # Dialog boxes for scripts
)

# Applications
APP_PACKAGES=(
    nautilus               # GNOME file manager
    sushi                  # File preview for Nautilus (spacebar preview)
    eog                    # Eye of GNOME image viewer
    evince                 # PDF and document viewer
    lite-xl                # Lightweight text editor for notes
    btop                   # System monitor
    mate-calc              # Calculator
)

# Audio/Video system
MEDIA_PACKAGES=(
    pipewire               # Modern audio system
    pipewire-pulse         # PulseAudio replacement
    pipewire-alsa          # ALSA compatibility
    pipewire-jack          # JACK compatibility
    wireplumber            # PipeWire session manager
    v4l-utils              # Video4Linux utilities (webcam support)
)

# Display manager and theming
DM_PACKAGES=(
    sddm                   # Display manager
    qt5-declarative        # Qt QML support for SDDM theme
    qt5-quickcontrols2     # Qt Quick Controls for SDDM theme
)

# Fonts
FONT_PACKAGES=(
    ttf-meslo-nerd         # Nerd Font for icons in Waybar/Wofi
    ttf-dejavu             # Fallback font used in all theme templates
    noto-fonts             # Unicode coverage for international text
    noto-fonts-emoji       # Color emoji support
    cantarell-fonts        # Default GNOME font for GTK applications
)

# Desktop integration
DESKTOP_PACKAGES=(
    xdg-desktop-portal     # Desktop portal base
    xdg-desktop-portal-wlr # Wayland desktop portal (screen sharing)
    xdg-desktop-portal-gtk # GTK file picker integration
    python-pipx            # Python package installer
)

# AUR packages (require yay/paru)
AUR_PACKAGES=(
    swayosd-git            # On-screen display for volume/brightness
)

# Python packages (installed via pipx)
PYTHON_PACKAGES=(
    terminaltexteffects    # Terminal text effects for screensaver
)

# Combine all official packages
ALL_OFFICIAL_PACKAGES=(
    "${CORE_PACKAGES[@]}"
    "${SYSTEM_PACKAGES[@]}"
    "${APP_PACKAGES[@]}"
    "${MEDIA_PACKAGES[@]}"
    "${FONT_PACKAGES[@]}"
    "${DM_PACKAGES[@]}"
    "${DESKTOP_PACKAGES[@]}"
)

echo "Core Sway Environment (${#CORE_PACKAGES[@]} packages):"
printf '  • %s\n' "${CORE_PACKAGES[@]}"
echo ""

echo "System Utilities (${#SYSTEM_PACKAGES[@]} packages):"
printf '  • %s\n' "${SYSTEM_PACKAGES[@]}"
echo ""

echo "Applications (${#APP_PACKAGES[@]} packages):"
printf '  • %s\n' "${APP_PACKAGES[@]}"
echo ""

echo "Audio/Video System (${#MEDIA_PACKAGES[@]} packages):"
printf '  • %s\n' "${MEDIA_PACKAGES[@]}"
echo ""

echo "Font Packages (${#FONT_PACKAGES[@]} packages):"
printf '  • %s\n' "${FONT_PACKAGES[@]}"
echo ""

echo "Display Manager & Theming (${#DM_PACKAGES[@]} packages):"
printf '  • %s\n' "${DM_PACKAGES[@]}"
echo ""

echo "Desktop Integration (${#DESKTOP_PACKAGES[@]} packages):"
printf '  • %s\n' "${DESKTOP_PACKAGES[@]}"
echo ""

echo "AUR Packages (${#AUR_PACKAGES[@]} packages):"
printf '  • %s\n' "${AUR_PACKAGES[@]}"
echo ""

echo "Python Packages (${#PYTHON_PACKAGES[@]} packages):"
printf '  • %s\n' "${PYTHON_PACKAGES[@]}"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Total Official Packages: ${#ALL_OFFICIAL_PACKAGES[@]}"
echo "Total AUR Packages: ${#AUR_PACKAGES[@]}"
echo "Total Python Packages: ${#PYTHON_PACKAGES[@]}"
echo ""

echo "Installation Commands:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "# Install all official packages:"
echo "sudo pacman -S --needed \\"
printf '    %s \\\n' "${ALL_OFFICIAL_PACKAGES[@]}" | sed '$s/ \\//'
echo ""
echo "# Install AUR packages:"
echo "yay -S --needed \\"
printf '    %s \\\n' "${AUR_PACKAGES[@]}" | sed '$s/ \\//'
echo ""
echo "# Install Python packages:"
printf 'pipx install %s\n' "${PYTHON_PACKAGES[@]}"
echo ""

# Check current installation status if requested
if [ "$1" = "--check" ]; then
    echo ""
    echo "Checking current installation status..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    missing_official=()
    missing_aur=()
    
    for pkg in "${ALL_OFFICIAL_PACKAGES[@]}"; do
        if ! pacman -Q "$pkg" &>/dev/null; then
            missing_official+=("$pkg")
        fi
    done
    
    for pkg in "${AUR_PACKAGES[@]}"; do
        if ! pacman -Q "$pkg" &>/dev/null; then
            missing_aur+=("$pkg")
        fi
    done
    
    if [ ${#missing_official[@]} -eq 0 ] && [ ${#missing_aur[@]} -eq 0 ]; then
        echo "✅ All packages are installed!"
    else
        if [ ${#missing_official[@]} -gt 0 ]; then
            echo "❌ Missing official packages:"
            printf '  • %s\n' "${missing_official[@]}"
            echo ""
            echo "Install with:"
            echo "sudo pacman -S --needed ${missing_official[*]}"
            echo ""
        fi
        
        if [ ${#missing_aur[@]} -gt 0 ]; then
            echo "❌ Missing AUR packages:"
            printf '  • %s\n' "${missing_aur[@]}"
            echo ""
            echo "Install with:"
            echo "yay -S --needed ${missing_aur[*]}"
            echo ""
        fi
    fi
fi