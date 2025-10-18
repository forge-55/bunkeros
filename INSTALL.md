# BunkerOS Installation Guide

Complete step-by-step installation instructions for BunkerOS on Arch Linux.

## Prerequisites

### System Requirements

**Standard Edition (Sway)**:
- RAM: 4GB minimum, 8GB recommended
- GPU: Any (Intel integrated graphics work excellently)
- Disk: 10GB free space

**Enhanced Edition (SwayFX)**:
- RAM: 8GB minimum, 16GB recommended
- GPU: Intel HD 620 or newer, AMD GCN 1.0+, NVIDIA GTX 600+
- Disk: 10GB free space

### Base System

This guide assumes you have:
- Arch Linux installed and updated
- Internet connection configured
- A user account with sudo privileges

## Installation Steps

### 1. Install Base Packages

```bash
# Update system
sudo pacman -Syu

# Install SwayFX compositor (provides both Standard and Enhanced editions)
sudo pacman -S swayfx

# Install autotiling for intelligent window placement (COSMIC-like behavior)
sudo pacman -S autotiling-rs

# Install essential utilities
sudo pacman -S waybar wofi mako foot nautilus btop \
               grim slurp wl-clipboard brightnessctl \
               playerctl pavucontrol network-manager-applet \
               blueman mate-calc

# Install file manager ecosystem (preview, image viewer, PDF viewer)
sudo pacman -S sushi eog evince

# Install display manager
sudo pacman -S sddm qt5-declarative qt5-quickcontrols2

# Install SwayOSD (from AUR)
yay -S swayosd-git
```

### 2. Clone BunkerOS Repository

```bash
cd ~/Projects
git clone https://github.com/forge-55/bunkeros.git
cd bunkeros
```

### 3. Install Configuration Files

```bash
# Create config directories
mkdir -p ~/.config/{sway/config.d,waybar,wofi,mako,foot,btop,swayosd}

# Copy configuration files
cp -r sway/* ~/.config/sway/
cp -r waybar/* ~/.config/waybar/
cp -r wofi/* ~/.config/wofi/
cp -r mako/* ~/.config/mako/
cp -r foot/* ~/.config/foot/
cp -r btop/* ~/.config/btop/
cp -r swayosd/* ~/.config/swayosd/

# Make scripts executable
chmod +x ~/.config/waybar/scripts/*.sh
```

### 4. Install GTK Themes

```bash
cd ~/Projects/bunkeros

# Install GTK 3.0 theme
cd gtk-3.0
./install.sh
cd ..

# Install GTK 4.0 theme
cd gtk-4.0
./install.sh
cd ..
```

### 5. Install SDDM Theme and Sessions

```bash
cd ~/Projects/bunkeros/sddm
sudo ./install-theme.sh
```

This script will:
- Install the BunkerOS SDDM theme
- Copy session files for Standard and Enhanced editions
- Configure SDDM to use the BunkerOS theme

### 6. Install Theme System

```bash
cd ~/Projects/bunkeros

# Copy themes
mkdir -p ~/.config/themes
cp -r themes/* ~/.config/themes/

# Install theme switcher
mkdir -p ~/.local/bin
cp scripts/theme-switcher.sh ~/.local/bin/
chmod +x ~/.local/bin/theme-switcher.sh

# Apply default BunkerOS theme
~/.local/bin/theme-switcher.sh tactical
```

### 7. Install Web App Manager

```bash
cd ~/Projects/bunkeros

# Copy webapp utilities
cp -r webapp/bin/* ~/.local/bin/
chmod +x ~/.local/bin/webapp-*
```

### 8. Configure Shell

```bash
cd ~/Projects/bunkeros

# Append BunkerOS bashrc config
cat bashrc >> ~/.bashrc

# Install dircolors
cp dircolors ~/.dircolors

# Reload shell config
source ~/.bashrc
```

### 9. Enable SDDM

```bash
# Disable other display managers (if any)
sudo systemctl disable ly.service 2>/dev/null
sudo systemctl disable gdm.service 2>/dev/null
sudo systemctl disable lightdm.service 2>/dev/null

# Enable SDDM
sudo systemctl enable sddm.service

# Optional: Start SDDM now (will log you out)
# sudo systemctl start sddm.service
```

### 10. Reboot

```bash
sudo reboot
```

## Post-Installation

### Selecting Your Edition

At the SDDM login screen:
1. Enter your username and password
2. Click the session selector (usually top-right corner)
3. Choose:
   - **BunkerOS (Standard)** - SwayFX with effects disabled (maximum performance)
   - **BunkerOS (Enhanced)** - SwayFX with visual effects enabled

Your selection is remembered for future logins. Both use the same SwayFX compositor.

### First Launch Configuration

After logging in to BunkerOS:

1. **Set your wallpaper**:
   ```bash
   killall swaybg
   swaybg -i ~/Pictures/your-wallpaper.jpg -m fill &
   ```

2. **Configure displays** (if multiple monitors):
   ```bash
   swaymsg -t get_outputs  # List outputs
   ```
   
   Edit `~/.config/sway/config` and add:
   ```
   output HDMI-A-1 resolution 1920x1080 position 1920,0
   ```

3. **Test all keybindings**:
   - `Super+Return` - Open terminal
   - `Super+d` - Application launcher
   - `Super+m` - Quick actions menu
   - `Super+w` - Workspace overview
   - See README.md for full keybinding list

4. **Explore themes**:
   - `Super+m` → Change Theme
   - Try Gruvbox, Nord, Tokyo Night, Everforest

### Optional: Configure Auto-start Applications

Edit `~/.config/sway/config` and add:

```bash
# Example: Start Thunderbird on workspace 4
exec --no-startup-id thunderbird
for_window [class="Thunderbird"] move to workspace 4
```

## Troubleshooting

### SDDM Theme Not Showing

```bash
# Check SDDM status
systemctl status sddm

# Check logs
journalctl -u sddm -b

# Verify theme installation
ls -la /usr/share/sddm/themes/tactical

# Verify session files
ls -la /usr/share/wayland-sessions/bunkeros-*
```

### SwayFX Not Available at Login

```bash
# Verify SwayFX is installed
which swayfx

# If not installed:
sudo pacman -S swayfx

# Reinstall session files
cd ~/Projects/bunkeros/sddm
sudo ./install-theme.sh
```

### Waybar Not Showing

```bash
# Check if Waybar is running
pgrep waybar

# Manually start Waybar
killall waybar
waybar &

# Check for errors
waybar 2>&1 | grep -i error
```

### Theme Switching Not Working

```bash
# Verify theme switcher is in PATH
which theme-switcher.sh

# If not, add to PATH:
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Test theme switcher
theme-switcher.sh list
```

### Missing Nerd Font Icons

```bash
# Install Nerd Fonts
yay -S ttf-meslo-nerd-font-powerlevel10k

# Or any Nerd Font:
sudo pacman -S ttf-jetbrains-mono-nerd

# Reload font cache
fc-cache -fv
```

## Uninstallation

To remove BunkerOS:

```bash
# Disable SDDM
sudo systemctl disable sddm.service

# Remove config files
rm -rf ~/.config/{sway,waybar,wofi,mako,foot,btop,swayosd}

# Remove GTK themes
rm -rf ~/.config/{gtk-3.0,gtk-4.0}/gtk.css

# Remove SDDM theme
sudo rm -rf /usr/share/sddm/themes/tactical
sudo rm /usr/share/wayland-sessions/bunkeros-*

# Remove scripts
rm -rf ~/.local/bin/{theme-switcher.sh,webapp-*}

# Remove theme directory
rm -rf ~/.config/themes

# Restore original bashrc (manual - remove BunkerOS section)
# Edit ~/.bashrc and remove added lines
```

## Getting Help

- GitHub Issues: https://github.com/forge-55/bunkeros/issues
- Documentation: See README.md
- Architecture: See ARCHITECTURE.md

## Next Steps

After installation:
1. Read the full README.md for feature overview
2. Learn keybindings (Super+m → Quick Actions)
3. Explore the theme system
4. Install web apps (Super+m → Web Apps)
5. Customize colors and layouts to your preference

