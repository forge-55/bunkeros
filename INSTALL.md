# BunkerOS Installation Guide

Complete installation instructions for BunkerOS with robust error handling and compatibility checking.

## System Requirements

**Standard Edition (Effects Disabled)**:
- RAM: 4GB minimum, 8GB recommended
- GPU: Any (Intel integrated graphics work excellently)
- CPU: x86-64 compatible (modern processors recommended)
- Disk: 20GB free space

**Enhanced Edition (Effects Enabled)**:
- RAM: 8GB minimum, 16GB recommended
- GPU: Intel HD 620 or newer, AMD GCN 1.0+, NVIDIA GTX 600+
- CPU: x86-64 compatible
- Disk: 20GB free space

## Quick Installation (Recommended)

For most users, this is the easiest method:

```bash
# Clone repository
cd ~/Projects
git clone https://github.com/forge-55/bunkeros.git
cd bunkeros

# Check system compatibility (recommended)
./scripts/check-compatibility.sh

# Install with robust error handling
./install-robust.sh
```

The robust installer will:
- Check for existing display managers and handle conflicts
- Install all required packages with verification
- Create automatic backups of existing configs
- Set up all BunkerOS configurations with symlinks
- Enable proper services and environment variables
- Provide clear error messages and recovery instructions

## Manual Installation

If you prefer step-by-step control or need to troubleshoot:

### Step 1: Arch Linux Base

BunkerOS requires an Arch-based system. If installing from scratch:

1. **Download Arch ISO** from [archlinux.org](https://archlinux.org/download/)
2. **Follow standard Arch installation** (see [Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide))
3. **Boot into your Arch system**

### Step 2: Install Dependencies

```bash
# Update system
sudo pacman -Syu

# Install system packages
sudo pacman -S --needed swayfx autotiling-rs waybar wofi mako foot \
                        swaylock swayidle swaybg brightnessctl playerctl \
                        wl-clipboard grim slurp wlsunset network-manager-applet \
                        blueman pavucontrol nautilus sushi eog evince lite-xl \
                        btop mate-calc zenity pipewire pipewire-pulse \
                        pipewire-alsa pipewire-jack wireplumber v4l-utils \
                        sddm qt5-declarative qt5-quickcontrols2 ttf-meslo-nerd \
                        xdg-desktop-portal xdg-desktop-portal-wlr \
                        xdg-desktop-portal-gtk python-pipx

# Install AUR packages (requires yay or paru)
yay -S swayosd-git

# Install Python tools
pipx install terminaltexteffects
```

### Step 3: Configure BunkerOS

```bash
# Clone repository if not done already
cd ~/Projects
git clone https://github.com/forge-55/bunkeros.git
cd bunkeros

# Run configuration setup
./setup.sh

# Fix environment for current session (optional)
./scripts/fix-environment.sh
```

### Step 4: Verify Installation

```bash
# Check all packages and configurations
./scripts/validate-installation.sh

# Fix any missing packages
./scripts/verify-packages.sh
```

## Manual Installation (Advanced)

If you prefer manual installation or already have an Arch base system, you can install BunkerOS components individually:

### 1. Update System

```bash
sudo pacman -Syu
```

### 2. Install Base Packages

```bash
# Install SwayFX compositor (provides both Standard and Enhanced editions)
sudo pacman -S swayfx

# Install autotiling for intelligent window placement (COSMIC-like behavior)
sudo pacman -S autotiling-rs

# Install essential utilities
sudo pacman -S waybar wofi mako foot nautilus btop \
               grim slurp wl-clipboard brightnessctl \
               playerctl pavucontrol network-manager-applet \
               blueman mate-calc zenity file-roller

# Install file manager ecosystem (preview, image viewer, PDF viewer)
sudo pacman -S sushi eog evince

# Install note-taking app
sudo pacman -S lite-xl

# Install display manager
sudo pacman -S sddm qt5-declarative qt5-quickcontrols2

# Install SwayOSD (from AUR)
yay -S swayosd-git
```

### 3. Clone BunkerOS Repository

```bash
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/forge-55/bunkeros.git
cd bunkeros
```

### 4. Run Setup Script

**Recommended**: Use the automated setup script:
```bash
bash setup.sh
```

The setup script handles:
- Configuration file installation
- GTK theme installation
- SDDM theme setup
- MIME type configuration
- Default application setup
- Session file installation
- PipeWire audio service enablement
- Browser Wayland screen sharing configuration

**Alternative**: Manual installation (see below)

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

## Post-Installation

### Themed Login Screen

After installation, you should see the BunkerOS tactical-themed SDDM login screen. If you see the default SDDM theme instead:

```bash
# Ensure Qt QML packages are installed (should be automatic with robust installer)
sudo pacman -S qt5-declarative qt5-quickcontrols2

# Restart SDDM to load the theme
sudo systemctl restart sddm.service
# OR reboot
sudo reboot
```

### Selecting Your Edition

At the SDDM login screen:
1. Enter your username and password
2. Click the session selector (usually top-right corner)
3. Choose:
   - **BunkerOS (Standard)** - SwayFX with effects disabled (maximum performance)
   - **BunkerOS (Enhanced)** - SwayFX with visual effects enabled

Your selection is remembered for future logins. Both use the same SwayFX compositor.

### First Launch

After logging in for the first time:

1. **Auto-Scaling**: BunkerOS automatically detects your display resolution and applies optimal font sizes
   - This happens on first login only - your manual font changes are preserved
   - To disable: `touch ~/.config/bunkeros/scaling-disabled`
   - To reset to auto-detected settings: `rm ~/.config/bunkeros/user-preferences.conf`
   - See [AUTO-SCALING.md](AUTO-SCALING.md) for details

2. **Test key features**:
   - `Super+Return` - Open terminal
   - `Super+d` - Application launcher
   - `Super+m` - Quick actions menu
   - `Super+w` - Workspace overview

### Theme Switching
- `Super+m` → Change Theme
- Try: Tactical (default), Gruvbox, Nord, Tokyo Night, Everforest

**For detailed feature documentation, see [README.md](README.md)**

**For security configuration, see [SECURITY.md](SECURITY.md)**

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

### Kernel Issues

If you encounter issues with the kernel:

```bash
# Check kernel version
uname -r

# Switch between kernels if needed
sudo pacman -S linux linux-headers        # Standard kernel
sudo pacman -S linux-lts linux-lts-headers # LTS kernel

# Update bootloader after kernel changes
sudo grub-mkconfig -o /boot/grub/grub.cfg  # For GRUB
```

For Arch-specific issues (kernel, packages, system configuration), consult:
- Arch Wiki: https://wiki.archlinux.org/
- Arch Forums: https://bbs.archlinux.org/

For BunkerOS environment issues (Sway, themes, configuration), use:
- BunkerOS GitHub Issues: https://github.com/forge-55/bunkeros/issues

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

