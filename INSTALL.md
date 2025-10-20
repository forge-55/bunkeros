# BunkerOS Installation Guide

Complete step-by-step installation instructions for BunkerOS.

## About This Guide

BunkerOS is an Arch-based Linux distribution built on CachyOS's performance-optimized foundation. This guide covers the current installation workflow, which uses the CachyOS installer as a foundation before applying BunkerOS's Sway environment and configuration.

## Prerequisites

### System Requirements

**Standard Edition (Effects Disabled)**:
- RAM: 4GB minimum, 8GB recommended
- GPU: Any (Intel integrated graphics work excellently)
- CPU: x86-64-v3 compatible (2015+ recommended for CachyOS optimizations)
- Disk: 20GB free space

**Enhanced Edition (Effects Enabled)**:
- RAM: 8GB minimum, 16GB recommended
- GPU: Intel HD 620 or newer, AMD GCN 1.0+, NVIDIA GTX 600+
- CPU: x86-64-v3 compatible
- Disk: 20GB free space

## Installation Process

### Phase 1: Install CachyOS Base System

BunkerOS currently uses the CachyOS installer to establish the Arch-based foundation with performance optimizations.

1. **Download CachyOS ISO** from [cachyos.org](https://cachyos.org)

2. **Create bootable USB**:
   ```bash
   sudo dd if=cachyos-*.iso of=/dev/sdX bs=4M status=progress
   ```

3. **Boot from USB** and start the CachyOS installer

4. **Installation Options**:
   - **Desktop Environment**: Choose "Minimal" or "None" (we'll install Sway separately)
   - **Partitioning**: Standard layout or custom as needed
   - **Bootloader**: GRUB or systemd-boot
   - **Kernel**: CachyOS optimized kernel (recommended) or Arch standard kernel
   - **Packages**: Install only base system

5. **Complete Installation** and reboot into your new CachyOS system

**What This Provides**:
- Arch Linux base system with rolling releases
- CachyOS performance optimizations (BORE scheduler, optimized packages)
- Hardware drivers and bootloader configuration
- Access to AUR and CachyOS repositories

### Phase 2: Install BunkerOS Environment

After booting into your CachyOS base system:

1. **Update System**:
   ```bash
   sudo pacman -Syu
   ```

2. **Clone BunkerOS Repository**:
   ```bash
   mkdir -p ~/Projects
   cd ~/Projects
   git clone https://github.com/forge-55/bunkeros.git
   cd bunkeros
   ```

3. **Run BunkerOS Setup**:
   ```bash
   bash setup.sh
   ```

   The setup script will:
   - Install SwayFX compositor and dependencies
   - Install Waybar, Wofi, Mako, and other components
   - Configure GTK themes and applications
   - Install SDDM login manager with BunkerOS theme
   - Set up default applications and MIME types
   - Configure themes and wallpapers

4. **Choose Your Edition** (during setup):
   - **Standard Edition**: Optimized for older hardware, minimal effects
   - **Enhanced Edition**: Polished visuals for modern hardware

5. **Reboot**:
   ```bash
   reboot
   ```

6. **Login** at the SDDM screen:
   - Select either "BunkerOS Standard" or "BunkerOS Enhanced" session
   - Enter your credentials

**What This Provides**:
- Complete Sway/SwayFX environment
- BunkerOS theming and customization
- Productivity tools and automation
- Military-inspired aesthetic

### Why This Two-Phase Approach?

**Current State**: Using CachyOS's proven installer allows BunkerOS to focus on the Sway environment rather than building installation infrastructure from scratch.

**Future Direction**: Planned options include:
- Dedicated BunkerOS installer
- BunkerOS installation profile for CachyOS installer
- ISO with pre-configured BunkerOS environment

For now, the CachyOS installer provides:
- Reliable hardware detection
- Performance optimizations
- Partition management
- Bootloader setup

## Manual Installation (Advanced)

If you prefer manual installation or already have an Arch/CachyOS base system, you can install BunkerOS components individually:

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

### CachyOS-Specific Issues

If you encounter issues with the CachyOS foundation:

```bash
# Check CachyOS kernel version
uname -r

# Switch to standard Arch kernel if needed
sudo pacman -S linux linux-headers

# Check CachyOS repository status
pacman -Sl cachyos
```

**Note**: BunkerOS's Sway environment works on both CachyOS-optimized and standard Arch kernels. Performance optimizations are a benefit, not a requirement.

For CachyOS-specific issues (kernel, scheduler, package optimizations), consult:
- CachyOS forums: https://forum.cachyos.org/
- CachyOS Discord: https://discord.gg/cachyos

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

