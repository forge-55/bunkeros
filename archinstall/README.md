# BunkerOS archinstall Profile

This directory contains configuration files for installing BunkerOS using archinstall, the official Arch Linux installer.

## Overview

The archinstall profile provides a streamlined way to install BunkerOS. It automates the Arch Linux base installation and BunkerOS configuration setup in one process.

**For those who prefer manual installation:** The traditional approach of installing Arch Linux manually and then adding BunkerOS is still fully supported and offers a deeper learning experience. See [INSTALL.md](../INSTALL.md) for that approach.

## What This Does

The archinstall profile will:

1. Install a minimal Arch Linux base system
2. Install all BunkerOS dependencies (Sway, Waybar, applications, etc.)
3. Clone the BunkerOS repository to `~/.local/share/bunkeros`
4. Set up all BunkerOS configurations with symlinks
5. Install and configure SDDM display manager
6. Configure Plymouth boot splash with official Arch Linux logo
7. Enable necessary system and user services

## Files

- **bunkeros-config.json** - archinstall configuration template
- **post-install.sh** - Script that runs after base installation to set up BunkerOS
- **user-config.json** - User credentials template (create this yourself)

## Installation Methods

### Method 1: Interactive archinstall (Recommended)

This method uses archinstall's guided interface while pre-installing BunkerOS packages:

```bash
# Boot the Arch Linux ISO

# Download the BunkerOS package list
curl -O https://raw.githubusercontent.com/forge-55/bunkeros/main/archinstall/bunkeros-config.json

# Run archinstall with the profile
archinstall --config bunkeros-config.json

# During archinstall:
# - Choose your disk partitioning
# - Set timezone and locale
# - Create your user account
# - Set passwords
# - Review package list (BunkerOS packages pre-selected)

# After installation completes, run the post-install script:
arch-chroot /mnt /bin/bash -c "
  curl -O https://raw.githubusercontent.com/forge-55/bunkeros/main/archinstall/post-install.sh
  chmod +x post-install.sh
  ./post-install.sh /mnt YOUR_USERNAME
"

# Unmount and reboot
umount -R /mnt
reboot
```

### Method 2: Fully Automated (Advanced)

Create a complete configuration file including user credentials:

**Create user-config.json:**
```json
{
  "!users": [
    {
      "!password": "your_password_here",
      "sudo": true,
      "username": "your_username"
    }
  ]
}
```

**Run automated installation:**
```bash
# Download both configs
curl -O https://raw.githubusercontent.com/forge-55/bunkeros/main/archinstall/bunkeros-config.json
curl -O https://raw.githubusercontent.com/forge-55/bunkeros/main/archinstall/user-config.json

# Edit user-config.json with your credentials

# Merge configs and run
jq -s '.[0] * .[1]' bunkeros-config.json user-config.json > final-config.json
archinstall --config final-config.json --silent

# Run post-install
arch-chroot /mnt /bin/bash -c "
  curl -O https://raw.githubusercontent.com/forge-55/bunkeros/main/archinstall/post-install.sh
  chmod +x post-install.sh
  ./post-install.sh /mnt your_username
"
```

### Method 3: Manual Installation (Deeper Learning)

If you want to understand how Arch Linux and BunkerOS work at a deeper level, manual installation is available:

1. Install vanilla Arch Linux following the [Arch Wiki](https://wiki.archlinux.org/title/Installation_guide)
2. Boot into your new Arch system
3. Clone this repository: `git clone https://github.com/forge-55/bunkeros.git`
4. Run the installer: `cd bunkeros && ./install.sh`

This approach helps you learn:
- How Arch Linux works
- What BunkerOS installs and configures
- How to troubleshoot and customize your system

See [INSTALL.md](../INSTALL.md) for detailed manual installation instructions.

## Configuration Options

The `bunkeros-config.json` file can be customized before installation:

**Timezone:**
```json
"timezone": "America/New_York"  // Change to your timezone
```

**Keyboard Layout:**
```json
"locale_config": {
  "kb_layout": "us",  // Change to your layout (de, fr, etc.)
  "sys_enc": "UTF-8",
  "sys_lang": "en_US"  // Change to your language
}
```

**Kernel:**
```json
"kernels": [
  "linux"  // Or: "linux-lts", "linux-zen", "linux-hardened"
]
```

**Additional Packages:**
Add any packages you want to the `"packages"` array.

## Post-Installation

After installation and first boot:

1. Log in at SDDM (select "BunkerOS" session)
2. Optional: Install AUR packages
   ```bash
   cd ~/.local/share/bunkeros
   ./scripts/install-aur-packages.sh
   ```
3. Optional: Configure power management
   ```bash
   ~/.local/share/bunkeros/scripts/install-power-management.sh
   ```
4. Customize your setup (see [QUICKREF.md](../QUICKREF.md))

## Troubleshooting

**archinstall not found:**
```bash
# Update and install archinstall
pacman -Sy archinstall
```

**Network connection issues:**
```bash
# WiFi connection
iwctl
> station wlan0 connect "YOUR_NETWORK"
> quit

# Or use ethernet
dhcpcd
```

**Post-install script fails:**
Run the BunkerOS installer manually after booting:
```bash
git clone https://github.com/forge-55/bunkeros.git
cd bunkeros
./install.sh
```

## Why archinstall?

archinstall is the **official Arch Linux installer**, maintained by the Arch team. It:

- Provides a guided installation process
- Uses standard Arch repositories and tools
- Offers both interactive and automated modes
- Maintains Arch's transparency and flexibility
- Is well-documented in the [Arch Wiki](https://wiki.archlinux.org/title/Archinstall)

Using archinstall for BunkerOS aligns with our philosophy:
- **Transparent:** All packages and configs visible
- **Standard tools:** No custom installers or proprietary methods
- **Educational:** Users can see what gets installed
- **Flexible:** Fully customizable before installation

## Philosophy

BunkerOS is a **configuration layer** for Arch Linux, not a standalone distribution. The archinstall profile simply automates:

1. Installing vanilla Arch Linux (using official tools)
2. Installing BunkerOS packages (from standard repos)
3. Setting up BunkerOS configurations (symlinked from git)

You maintain full control and transparency at every step.

## Learn More

- [BunkerOS Installation Guide](../INSTALL.md) - Manual installation process
- [BunkerOS Architecture](../docs/development/architecture.md) - How BunkerOS works
- [BunkerOS Architecture](../docs/development/architecture.md) - Our design approach
- [Arch Wiki: archinstall](https://wiki.archlinux.org/title/Archinstall) - Official documentation
