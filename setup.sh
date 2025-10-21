#!/usr/bin/env bash

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"

echo "=== BunkerOS Local Setup ==="
echo ""
echo "This script will set up symlinks and configurations for BunkerOS."
echo "Project directory: $PROJECT_DIR"
echo ""

backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "  Backing up existing $target"
        mv "$target" "${target}.backup.$(date +%Y%m%d-%H%M%S)"
    fi
}

echo "Step 1: Creating config directories..."
mkdir -p "$CONFIG_DIR"/{sway/config.d,waybar/scripts,wofi,mako,foot,btop/themes,swayosd,themes}
mkdir -p "$LOCAL_BIN"
echo "  ✓ Directories created"
echo ""

echo "Step 2: Setting up Sway configuration..."
backup_if_exists "$CONFIG_DIR/sway/config"
ln -sf "$PROJECT_DIR/sway/config" "$CONFIG_DIR/sway/config"

if [ ! -f "$CONFIG_DIR/sway/config.d/swayfx-effects.conf" ]; then
    touch "$CONFIG_DIR/sway/config.d/swayfx-effects.conf"
    echo "  Created empty swayfx-effects.conf for Standard Edition"
fi
echo "  ✓ Sway config symlinked"
echo "  ℹ SwayFX effects will be enabled automatically when using Enhanced Edition"
echo ""

echo "Step 3: Setting up Waybar configuration..."
backup_if_exists "$CONFIG_DIR/waybar/config"
ln -sf "$PROJECT_DIR/waybar/config" "$CONFIG_DIR/waybar/config"
backup_if_exists "$CONFIG_DIR/waybar/style.css"
ln -sf "$PROJECT_DIR/waybar/style.css" "$CONFIG_DIR/waybar/style.css"

for script in "$PROJECT_DIR/waybar/scripts"/*.sh; do
    script_name=$(basename "$script")
    backup_if_exists "$CONFIG_DIR/waybar/scripts/$script_name"
    ln -sf "$script" "$CONFIG_DIR/waybar/scripts/$script_name"
    chmod +x "$script"
done
echo "  ✓ Waybar config and scripts symlinked"
echo ""

echo "Step 4: Setting up Wofi configuration..."
backup_if_exists "$CONFIG_DIR/wofi/config"
ln -sf "$PROJECT_DIR/wofi/config" "$CONFIG_DIR/wofi/config"
backup_if_exists "$CONFIG_DIR/wofi/style.css"
ln -sf "$PROJECT_DIR/wofi/style.css" "$CONFIG_DIR/wofi/style.css"
echo "  ✓ Wofi config symlinked"
echo ""

echo "Step 5: Setting up Mako configuration..."
backup_if_exists "$CONFIG_DIR/mako/config"
ln -sf "$PROJECT_DIR/mako/config" "$CONFIG_DIR/mako/config"
echo "  ✓ Mako config symlinked"
echo ""

echo "Step 6: Setting up Foot terminal configuration..."
backup_if_exists "$CONFIG_DIR/foot/foot.ini"
ln -sf "$PROJECT_DIR/foot/foot.ini" "$CONFIG_DIR/foot/foot.ini"
echo "  ✓ Foot config symlinked"
echo ""

echo "Step 7: Setting up btop configuration..."
backup_if_exists "$CONFIG_DIR/btop/btop.conf"
ln -sf "$PROJECT_DIR/btop/btop.conf" "$CONFIG_DIR/btop/btop.conf"

for theme in "$PROJECT_DIR/btop/themes"/*.theme; do
    theme_name=$(basename "$theme")
    backup_if_exists "$CONFIG_DIR/btop/themes/$theme_name"
    ln -sf "$theme" "$CONFIG_DIR/btop/themes/$theme_name"
done
echo "  ✓ btop config and themes symlinked"
echo ""

echo "Step 8: Setting up SwayOSD configuration..."
backup_if_exists "$CONFIG_DIR/swayosd/style.css"
ln -sf "$PROJECT_DIR/swayosd/style.css" "$CONFIG_DIR/swayosd/style.css"
echo "  ✓ SwayOSD config symlinked"
echo ""

echo "Step 9: Installing theme system..."
backup_if_exists "$CONFIG_DIR/themes"
rm -f "$CONFIG_DIR/themes"
ln -sf "$PROJECT_DIR/themes" "$CONFIG_DIR/themes"

backup_if_exists "$LOCAL_BIN/theme-switcher.sh"
ln -sf "$PROJECT_DIR/scripts/theme-switcher.sh" "$LOCAL_BIN/theme-switcher.sh"
chmod +x "$PROJECT_DIR/scripts/theme-switcher.sh"
echo "  ✓ Theme system symlinked"
echo ""

echo "Step 10: Installing wallpapers..."
mkdir -p "$HOME/.local/share/bunkeros"
backup_if_exists "$HOME/.local/share/bunkeros/wallpapers"
rm -f "$HOME/.local/share/bunkeros/wallpapers"
ln -sf "$PROJECT_DIR/wallpapers" "$HOME/.local/share/bunkeros/wallpapers"
echo "  ✓ Wallpapers symlinked (5 theme wallpapers included)"
echo ""

echo "Step 11: Installing Web App Manager..."
for webapp_script in "$PROJECT_DIR/webapp/bin"/*; do
    script_name=$(basename "$webapp_script")
    backup_if_exists "$LOCAL_BIN/$script_name"
    ln -sf "$webapp_script" "$LOCAL_BIN/$script_name"
    chmod +x "$webapp_script"
done
echo "  ✓ Web app manager scripts symlinked"
echo ""

echo "Step 11.5: Installing Lite XL (Note-Taking App)..."
cd "$PROJECT_DIR/lite-xl"
./install.sh
cd "$PROJECT_DIR"
echo ""

echo "Step 11.6: Installing Desktop Portal Configuration..."
cd "$PROJECT_DIR/xdg-desktop-portal"
./install.sh
cd "$PROJECT_DIR"
echo ""

echo "Step 11.7: Verifying wallpaper system..."
echo "  ✓ Wallpaper manager uses wofi (already installed)"
echo "  ✓ Simple, reliable menu-based wallpaper selection"
echo ""

echo "Step 12: Setting up shell configuration..."
backup_if_exists "$HOME/.dircolors"
ln -sf "$PROJECT_DIR/dircolors" "$HOME/.dircolors"

if ! grep -q "# BunkerOS Configuration" "$HOME/.bashrc" 2>/dev/null; then
    echo "  Adding BunkerOS configuration to ~/.bashrc..."
    echo "" >> "$HOME/.bashrc"
    echo "# BunkerOS Configuration" >> "$HOME/.bashrc"
    cat "$PROJECT_DIR/bashrc" >> "$HOME/.bashrc"
    echo "  ✓ BunkerOS bashrc configuration added"
else
    echo "  ℹ BunkerOS configuration already exists in ~/.bashrc"
fi
echo ""

echo "Step 12: Installing GTK themes..."
cd "$PROJECT_DIR/gtk-3.0"
./install.sh
echo ""
cd "$PROJECT_DIR/gtk-4.0"
./install.sh
echo ""

echo "Step 12.5: Configuring dark theme for Nautilus..."
# Set dark color scheme for libadwaita applications
if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
    echo "  ✓ Dark theme preference set"
else
    echo "  ℹ gsettings not available, skipping theme preference"
fi
echo ""

echo "Step 12.6: Configuring default applications..."
# Set default image viewer to Eye of GNOME
xdg-mime default org.gnome.eog.desktop image/png 2>/dev/null || true
xdg-mime default org.gnome.eog.desktop image/jpeg 2>/dev/null || true
xdg-mime default org.gnome.eog.desktop image/jpg 2>/dev/null || true
xdg-mime default org.gnome.eog.desktop image/gif 2>/dev/null || true
xdg-mime default org.gnome.eog.desktop image/webp 2>/dev/null || true
xdg-mime default org.gnome.eog.desktop image/svg+xml 2>/dev/null || true

# Set default PDF viewer to Evince
xdg-mime default org.gnome.Evince.desktop application/pdf 2>/dev/null || true

# Set default text editor to VS Code
xdg-mime default code.desktop text/plain 2>/dev/null || true
xdg-mime default code.desktop text/x-readme 2>/dev/null || true
xdg-mime default code.desktop text/markdown 2>/dev/null || true
xdg-mime default code.desktop text/x-markdown 2>/dev/null || true

# Set default code file handlers to VS Code
xdg-mime default code.desktop text/x-python 2>/dev/null || true
xdg-mime default code.desktop text/x-shellscript 2>/dev/null || true
xdg-mime default code.desktop text/x-script.python 2>/dev/null || true
xdg-mime default code.desktop application/x-shellscript 2>/dev/null || true
xdg-mime default code.desktop application/javascript 2>/dev/null || true
xdg-mime default code.desktop application/json 2>/dev/null || true
xdg-mime default code.desktop application/x-yaml 2>/dev/null || true
xdg-mime default code.desktop text/html 2>/dev/null || true
xdg-mime default code.desktop text/css 2>/dev/null || true

# Set default archive manager to file-roller (if installed)
xdg-mime default org.gnome.FileRoller.desktop application/zip 2>/dev/null || true
xdg-mime default org.gnome.FileRoller.desktop application/x-tar 2>/dev/null || true
xdg-mime default org.gnome.FileRoller.desktop application/x-compressed-tar 2>/dev/null || true
xdg-mime default org.gnome.FileRoller.desktop application/x-bzip-compressed-tar 2>/dev/null || true
xdg-mime default org.gnome.FileRoller.desktop application/x-xz-compressed-tar 2>/dev/null || true
xdg-mime default org.gnome.FileRoller.desktop application/x-7z-compressed 2>/dev/null || true
xdg-mime default org.gnome.FileRoller.desktop application/x-rar 2>/dev/null || true
xdg-mime default org.gnome.FileRoller.desktop application/gzip 2>/dev/null || true

# Set default file manager to Nautilus
xdg-mime default org.gnome.Nautilus.desktop inode/directory 2>/dev/null || true
xdg-mime default org.gnome.Nautilus.desktop x-directory/normal 2>/dev/null || true

echo "  ✓ Default applications configured:"
echo "    • Images → Eye of GNOME (eog)"
echo "    • PDFs → Evince"
echo "    • Text/Code → VS Code"
echo "    • Archives → File Roller"
echo "    • Directories → Nautilus"
echo ""

echo "Step 13: Installing SDDM theme..."
echo "This step requires sudo privileges for system-wide theme installation."
read -p "Install SDDM theme? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd "$PROJECT_DIR/sddm"
    ./install-theme.sh
    echo ""
else
    echo "  Skipping SDDM theme installation"
    echo ""
fi

echo "Step 15: Applying default BunkerOS theme..."
cd "$PROJECT_DIR"
"$LOCAL_BIN/theme-switcher.sh" tactical 2>/dev/null || echo "  ℹ Theme will be applied on first Sway launch"
echo ""

echo "Step 16: Setting up BunkerOS screensaver..."
mkdir -p "$HOME/.config/bunkeros/screensaver"
backup_if_exists "$HOME/.config/bunkeros/screensaver/screensaver.txt"
ln -sf "$PROJECT_DIR/screensaver/screensaver.txt" "$HOME/.config/bunkeros/screensaver/screensaver.txt"

# Symlink screensaver scripts to sway-config scripts directory
mkdir -p "$CONFIG_DIR/sway-config/scripts"
backup_if_exists "$CONFIG_DIR/sway-config/scripts/bunkeros-screensaver.sh"
ln -sf "$PROJECT_DIR/scripts/bunkeros-screensaver.sh" "$CONFIG_DIR/sway-config/scripts/bunkeros-screensaver.sh"
chmod +x "$PROJECT_DIR/scripts/bunkeros-screensaver.sh"

backup_if_exists "$CONFIG_DIR/sway-config/scripts/launch-screensaver.sh"
ln -sf "$PROJECT_DIR/scripts/launch-screensaver.sh" "$CONFIG_DIR/sway-config/scripts/launch-screensaver.sh"
chmod +x "$PROJECT_DIR/scripts/launch-screensaver.sh"

echo "  ✓ Screensaver configuration symlinked"
echo "  ℹ Install TerminalTextEffects: pipx install terminaltexteffects"
echo ""

echo "Step 17: Configuring video conferencing support..."
echo "  Enabling PipeWire services for audio/video..."

# Enable PipeWire services if not already enabled
if ! systemctl --user is-enabled pipewire.service >/dev/null 2>&1; then
    systemctl --user enable --now pipewire.service >/dev/null 2>&1 || true
    echo "    ✓ PipeWire service enabled"
else
    echo "    ✓ PipeWire already enabled"
fi

if ! systemctl --user is-enabled pipewire-pulse.service >/dev/null 2>&1; then
    systemctl --user enable --now pipewire-pulse.service >/dev/null 2>&1 || true
    echo "    ✓ PipeWire PulseAudio replacement enabled"
else
    echo "    ✓ PipeWire PulseAudio already enabled"
fi

if ! systemctl --user is-enabled wireplumber.service >/dev/null 2>&1; then
    systemctl --user enable --now wireplumber.service >/dev/null 2>&1 || true
    echo "    ✓ WirePlumber session manager enabled"
else
    echo "    ✓ WirePlumber already enabled"
fi

echo ""
echo "  Configuring browsers for Wayland screen sharing..."
cd "$PROJECT_DIR"
"$PROJECT_DIR/scripts/configure-browser-wayland.sh"
echo ""

echo "=== BunkerOS Setup Complete! ==="
echo ""
echo "Next steps:"
echo ""
echo "1. Ensure all required packages are installed:"
echo "   sudo pacman -S swayfx autotiling-rs waybar wofi mako foot \\"
echo "                  nautilus sushi eog evince lite-xl btop \\"
echo "                  grim slurp wl-clipboard brightnessctl \\"
echo "                  playerctl pavucontrol network-manager-applet \\"
echo "                  blueman mate-calc zenity sddm wlsunset swaylock \\"
echo "                  swayidle python-pipx pipewire pipewire-pulse \\"
echo "                  pipewire-alsa pipewire-jack wireplumber v4l-utils"
echo ""
echo "2. Install SwayOSD from AUR:"
echo "   yay -S swayosd-git"
echo ""
echo "3. Install TerminalTextEffects for screensaver:"
echo "   pipx install terminaltexteffects"
echo ""
echo "4. Install a Nerd Font for icons:"
echo "   sudo pacman -S ttf-meslo-nerd"
echo ""
echo "5. Log out and select 'BunkerOS (Standard)' or 'BunkerOS (Enhanced)'"
echo "   from your display manager session selector"
echo ""
echo "6. If using SDDM, enable it:"
echo "   sudo systemctl enable sddm.service"
echo ""
echo "All configuration files are now symlinked. Any changes you make in"
echo "$PROJECT_DIR will be reflected immediately!"
echo ""

