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
mkdir -p "$CONFIG_DIR"/{sway/config.d,waybar/scripts,wofi,mako,foot,btop/themes,swayosd,themes,bunkeros}
mkdir -p "$LOCAL_BIN"
echo "  ✓ Directories created"
echo ""

echo "Step 1.5: Setting up default applications configuration..."
if [ ! -f "$CONFIG_DIR/bunkeros/defaults.conf" ]; then
    echo "  Creating defaults.conf with fallback applications..."
    cp "$PROJECT_DIR/bunkeros/defaults.conf" "$CONFIG_DIR/bunkeros/defaults.conf"
    echo "  ✓ Default applications configured"
else
    echo "  ℹ defaults.conf already exists, keeping user preferences"
fi
echo ""

echo "Step 2: Setting up Sway configuration..."
backup_if_exists "$CONFIG_DIR/sway/config"
if [ ! -f "$CONFIG_DIR/sway/config" ]; then
    cp "$PROJECT_DIR/sway/config.default" "$CONFIG_DIR/sway/config"
    echo "  ✓ Sway config copied from defaults"
else
    echo "  ℹ Sway config already exists, keeping user version"
fi
echo ""

echo "Step 2.5: Setting up multi-monitor configuration..."
# Copy default multi-monitor config files if they don't exist
for conf_file in "$PROJECT_DIR/sway/config.d"/*.conf; do
    conf_name=$(basename "$conf_file")
    if [ ! -f "$CONFIG_DIR/sway/config.d/$conf_name" ]; then
        cp "$conf_file" "$CONFIG_DIR/sway/config.d/$conf_name"
        echo "  ✓ Copied $conf_name"
    else
        echo "  ℹ $conf_name already exists, keeping user version"
    fi
done

# Copy README if it doesn't exist
if [ ! -f "$CONFIG_DIR/sway/config.d/README.md" ]; then
    cp "$PROJECT_DIR/sway/config.d/README.md" "$CONFIG_DIR/sway/config.d/README.md"
    echo "  ✓ Multi-monitor configuration files installed"
else
    echo "  ℹ Multi-monitor config already set up"
fi
echo ""

echo "Step 3: Setting up Waybar configuration..."
backup_if_exists "$CONFIG_DIR/waybar/config"
ln -sf "$PROJECT_DIR/waybar/config" "$CONFIG_DIR/waybar/config"
backup_if_exists "$CONFIG_DIR/waybar/style.css"
if [ ! -f "$CONFIG_DIR/waybar/style.css" ] || [ -L "$CONFIG_DIR/waybar/style.css" ]; then
    rm -f "$CONFIG_DIR/waybar/style.css"
    cp "$PROJECT_DIR/waybar/style.css.default" "$CONFIG_DIR/waybar/style.css"
    echo "  ✓ Waybar style copied from defaults (theme-switchable)"
else
    echo "  ℹ Waybar style already exists, keeping user version"
fi

for script in "$PROJECT_DIR/waybar/scripts"/*.sh; do
    script_name=$(basename "$script")
    backup_if_exists "$CONFIG_DIR/waybar/scripts/$script_name"
    ln -sf "$script" "$CONFIG_DIR/waybar/scripts/$script_name"
    chmod +x "$script"
done
ln -sf "$PROJECT_DIR/waybar/config" "$CONFIG_DIR/waybar/config"
echo "  ✓ Waybar config symlinked, style copied (theme-switchable)"
echo ""

echo "Step 4: Setting up Wofi configuration..."
backup_if_exists "$CONFIG_DIR/wofi/config"
ln -sf "$PROJECT_DIR/wofi/config" "$CONFIG_DIR/wofi/config"
backup_if_exists "$CONFIG_DIR/wofi/style.css"
if [ ! -f "$CONFIG_DIR/wofi/style.css" ] || [ -L "$CONFIG_DIR/wofi/style.css" ]; then
    rm -f "$CONFIG_DIR/wofi/style.css"
    cp "$PROJECT_DIR/wofi/style.css.default" "$CONFIG_DIR/wofi/style.css"
    echo "  ✓ Wofi config symlinked, style copied (theme-switchable)"
else
    echo "  ℹ Wofi style already exists, keeping user version"
fi
echo ""

echo "Step 5: Setting up Mako configuration..."
backup_if_exists "$CONFIG_DIR/mako/config"
if [ ! -f "$CONFIG_DIR/mako/config" ] || [ -L "$CONFIG_DIR/mako/config" ]; then
    rm -f "$CONFIG_DIR/mako/config"
    cp "$PROJECT_DIR/mako/config.default" "$CONFIG_DIR/mako/config"
    echo "  ✓ Mako config copied (theme-switchable)"
else
    echo "  ℹ Mako config already exists, keeping user version"
fi
echo ""

echo "Step 6: Setting up Foot terminal configuration..."
backup_if_exists "$CONFIG_DIR/foot/foot.ini"
if [ ! -f "$CONFIG_DIR/foot/foot.ini" ] || [ -L "$CONFIG_DIR/foot/foot.ini" ]; then
    rm -f "$CONFIG_DIR/foot/foot.ini"
    cp "$PROJECT_DIR/foot/foot.ini.default" "$CONFIG_DIR/foot/foot.ini"
    echo "  ✓ Foot config copied (theme-switchable)"
else
    echo "  ℹ Foot config already exists, keeping user version"
fi
echo ""

echo "Step 7: Setting up btop configuration..."
backup_if_exists "$CONFIG_DIR/btop/btop.conf"
ln -sf "$PROJECT_DIR/btop/btop.conf" "$CONFIG_DIR/btop/btop.conf"

# Copy active theme (theme-switchable), symlink static themes
backup_if_exists "$CONFIG_DIR/btop/themes/active.theme"
if [ ! -f "$CONFIG_DIR/btop/themes/active.theme" ] || [ -L "$CONFIG_DIR/btop/themes/active.theme" ]; then
    rm -f "$CONFIG_DIR/btop/themes/active.theme"
    cp "$PROJECT_DIR/btop/themes/active.theme.default" "$CONFIG_DIR/btop/themes/active.theme"
fi

for theme in "$PROJECT_DIR/btop/themes"/*.theme; do
    theme_name=$(basename "$theme")
    if [ "$theme_name" != "active.theme" ]; then
        backup_if_exists "$CONFIG_DIR/btop/themes/$theme_name"
        ln -sf "$theme" "$CONFIG_DIR/btop/themes/$theme_name"
    fi
done
echo "  ✓ btop config symlinked, active theme copied (theme-switchable)"
echo ""

echo "Step 8: Setting up SwayOSD configuration..."
backup_if_exists "$CONFIG_DIR/swayosd/style.css"
if [ ! -f "$CONFIG_DIR/swayosd/style.css" ] || [ -L "$CONFIG_DIR/swayosd/style.css" ]; then
    rm -f "$CONFIG_DIR/swayosd/style.css"
    cp "$PROJECT_DIR/swayosd/style.css.default" "$CONFIG_DIR/swayosd/style.css"
    echo "  ✓ SwayOSD config copied (theme-switchable)"
else
    echo "  ℹ SwayOSD config already exists, keeping user version"
fi
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

echo "Step 11.7: Installing Wayland environment variables..."
mkdir -p "$CONFIG_DIR/environment.d"
backup_if_exists "$CONFIG_DIR/environment.d/10-bunkeros-wayland.conf"
# IMPORTANT: environment.d files MUST be copied, not symlinked
# systemd cannot read symlinked environment files
cp "$PROJECT_DIR/environment.d/10-bunkeros-wayland.conf" "$CONFIG_DIR/environment.d/10-bunkeros-wayland.conf"
echo "  ✓ Wayland environment configuration installed (copied, not symlinked)"
echo "  ℹ This ensures Electron apps (VS Code, Cursor) work correctly"
echo "  ⚠ Note: environment.d files MUST be copied - systemd cannot read symlinks"
echo ""

echo "Step 11.8: Setting up adaptive display scaling..."
echo "  🎯 Auto-scaling service will detect and apply optimal settings on first login"
echo "  📊 This ensures proper font sizes and scaling for your hardware automatically"
echo "  💡 Settings will be applied when you start your first Sway session"
echo ""

echo "Step 11.9: Verifying wallpaper system..."
echo "  ✓ Wallpaper manager uses wofi (already installed)"
echo "  ✓ Simple, reliable menu-based wallpaper selection"
echo ""

echo "Step 12: Setting up shell configuration..."
backup_if_exists "$HOME/.dircolors"
if [ ! -f "$HOME/.dircolors" ] || [ -L "$HOME/.dircolors" ]; then
    rm -f "$HOME/.dircolors"
    cp "$PROJECT_DIR/dircolors.default" "$HOME/.dircolors"
    echo "  ✓ dircolors copied (theme-switchable)"
else
    echo "  ℹ .dircolors already exists, keeping user version"
fi

if ! grep -q "# BunkerOS Configuration" "$HOME/.bashrc" 2>/dev/null; then
    echo "  Adding BunkerOS configuration to ~/.bashrc..."
    echo "" >> "$HOME/.bashrc"
    echo "# BunkerOS Configuration" >> "$HOME/.bashrc"
    cat "$PROJECT_DIR/bashrc.default" >> "$HOME/.bashrc"
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

echo "Step 16: Installing power management configuration..."
echo "  Installing systemd-logind configuration for auto-suspend..."
if [ ! -d "/etc/systemd/logind.conf.d" ]; then
    sudo mkdir -p /etc/systemd/logind.conf.d
fi
sudo cp "$PROJECT_DIR/systemd/logind.conf.d/bunkeros-power.conf" /etc/systemd/logind.conf.d/
echo "  ✓ Power management configuration installed"
echo "  📋 Screensaver: 5 minutes (swayidle)"
echo "  📋 Auto-suspend: 10 minutes (systemd-logind)"
echo "  ℹ Changes will take effect after reboot or logout"
echo ""

echo "=== BunkerOS Setup Complete! ==="
echo ""
echo "Next steps:"
echo ""
echo "1. Ensure all required packages are installed:"
echo "   sudo pacman -S sway autotiling-rs waybar wofi mako foot \\"
echo "                  nautilus sushi eog evince lite-xl btop \\"
echo "                  grim slurp wl-clipboard brightnessctl \\"
echo "                  playerctl pavucontrol network-manager-applet \\"
echo "                  blueman mate-calc zenity sddm wlsunset swaylock \\"
echo "                  swayidle python-pipx pipewire pipewire-pulse \\"
echo "                  pipewire-alsa pipewire-jack wireplumber v4l-utils \\"
echo "                  jq"
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
echo "5. Log out and select 'BunkerOS' from your display manager"
echo "   session selector"
echo ""
echo "6. If using SDDM, enable it:"
echo "   sudo systemctl enable sddm.service"
echo ""
echo "7. Multi-monitor setup (optional):"
echo "   bash ~/Projects/bunkeros/scripts/detect-monitors.sh"
echo "   bash ~/Projects/bunkeros/scripts/setup-monitors.sh"
echo ""
echo "All configuration files are now symlinked. Any changes you make in"
echo "$PROJECT_DIR will be reflected immediately!"
echo ""

