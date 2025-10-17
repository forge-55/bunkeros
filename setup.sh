#!/usr/bin/env bash

set -e

PROJECT_DIR="/home/ryan/Projects/bunkeros"
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

echo "Step 11: Setting up shell configuration..."
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

echo "=== BunkerOS Setup Complete! ==="
echo ""
echo "Next steps:"
echo ""
echo "1. Ensure all required packages are installed:"
echo "   sudo pacman -S sway swayfx waybar wofi mako foot thunar btop \\"
echo "                  grim slurp wl-clipboard brightnessctl playerctl \\"
echo "                  pavucontrol network-manager-applet blueman \\"
echo "                  mate-calc sddm wlsunset swaylock"
echo ""
echo "2. Install SwayOSD from AUR:"
echo "   yay -S swayosd-git"
echo ""
echo "3. Install a Nerd Font for icons:"
echo "   sudo pacman -S ttf-meslo-nerd"
echo ""
echo "4. Log out and select 'BunkerOS (Standard)' or 'BunkerOS (Enhanced)'"
echo "   from your display manager session selector"
echo ""
echo "5. If using SDDM, enable it:"
echo "   sudo systemctl enable sddm.service"
echo ""
echo "All configuration files are now symlinked. Any changes you make in"
echo "$PROJECT_DIR will be reflected immediately!"
echo ""

