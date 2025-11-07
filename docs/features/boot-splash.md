# BunkerOS Boot Splash Configuration

## Overview

BunkerOS supports adding a professional boot splash screen with the Arch Linux logo during system startup. This provides a polished boot experience that matches BunkerOS's tactical aesthetic.

## Current Boot Process

By default, BunkerOS installations show:
1. **UEFI/BIOS** → **systemd-boot menu** → **Kernel loading** → **Encryption prompt** → **Login screen**
2. No graphical splash screen during kernel loading and initialization

## Adding Arch Linux Boot Splash

### Quick Installation

Run the automated installer:

```bash
cd ~/bunkeros  # Or wherever you have BunkerOS installed
./scripts/install-plymouth-arch-splash.sh
```

This script will:
- Install Plymouth boot splash system
- Install an Arch Linux themed Plymouth theme
- Configure your bootloader to show the splash
- Update your initramfs
- Handle both regular and LTS kernels if present

### Manual Installation

If you prefer to install manually:

#### 1. Install Plymouth

```bash
sudo pacman -S plymouth
```

#### 2. Choose and Install a Theme

**Most Popular Options:**

```bash
# Clean animated Arch logo (recommended)
yay -S plymouth-theme-arch-charge

# Larger version for HiDPI displays  
yay -S plymouth-theme-arch-charge-big

# Dark theme with spinner animation
yay -S plymouth-theme-dark-arch

# KDE Breeze-inspired theme
yay -S plymouth-theme-arch-breeze-git
```

#### 3. Configure the Theme

```bash
# Set the theme (example with arch-charge)
sudo plymouth-set-default-theme arch-charge

# Rebuild initramfs
sudo mkinitcpio -p linux

# If you have LTS kernel installed:
sudo mkinitcpio -p linux-lts
```

#### 4. Update Boot Configuration

Add `splash` to your kernel boot options. For systemd-boot:

```bash
# Edit each boot entry
sudo nano /boot/loader/entries/2025-11-06_23-20-37_linux.conf

# Add 'splash' to the options line:
# Before: options cryptdevice=UUID=... root=/dev/... rw rootfstype=btrfs
# After:  options splash cryptdevice=UUID=... root=/dev/... rw rootfstype=btrfs
```

## Theme Previews

### arch-charge / arch-charge-big
- Clean, professional animation
- Arch Linux logo with subtle charging effect
- Works well with encryption prompts
- Most stable and popular choice

### dark-arch  
- Dark background matching BunkerOS theme
- Animated spinner around Arch logo
- Good for tactical/minimal aesthetic

### arch-breeze
- KDE Breeze-inspired design
- Modern, polished appearance
- Integrates well with desktop environments

## Technical Details

### What Plymouth Does

Plymouth provides:
- **Graphical boot splash** instead of text messages
- **Smooth transitions** between boot stages  
- **Professional appearance** during encryption password entry
- **Consistent branding** throughout boot process

### Boot Process with Plymouth

1. **UEFI/BIOS** → **systemd-boot** → **Plymouth splash starts**
2. **Kernel loading** (with Arch logo animation)
3. **Encryption prompt** (with themed password entry)
4. **System initialization** (with progress indication)
5. **SDDM login screen** (BunkerOS tactical theme)

### Compatibility

✅ **Systemd-boot** (BunkerOS default) - Fully supported  
✅ **LUKS encryption** - Enhanced experience with themed password prompts  
✅ **Multiple kernels** - Handles both linux and linux-lts  
⚠️ **GRUB** - May require different configuration

## Testing

### Preview Theme
```bash
# Test current theme
sudo plymouthd; sudo plymouth --show-splash; sleep 3; sudo plymouth quit
```

### Check Configuration
```bash
# View current theme
plymouth-set-default-theme

# List available themes  
plymouth-set-default-theme --list

# View boot entries
ls /boot/loader/entries/
cat /boot/loader/entries/*.conf | grep options
```

## Troubleshooting

### Boot Issues

If Plymouth causes boot problems:

1. **Remove splash parameter:**
   ```bash
   # Edit boot entry and remove 'splash' from options line
   sudo nano /boot/loader/entries/*.conf
   ```

2. **Debug mode:**
   ```bash
   # Add to kernel options for one-time boot:
   systemd.show_status=1 plymouth.debug
   ```

3. **Disable Plymouth:**
   ```bash
   sudo systemctl disable plymouth-start.service
   sudo mkinitcpio -p linux
   ```

### Common Issues

**Theme not showing:**
- Verify `splash` is in kernel options
- Check theme is set: `plymouth-set-default-theme`
- Rebuild initramfs: `sudo mkinitcpio -p linux`

**Encryption prompt looks wrong:**
- Some themes handle LUKS prompts better than others
- Try `arch-charge` theme for best encryption compatibility

**Performance impact:**
- Plymouth adds ~1-2 seconds to boot time
- Minimal RAM usage (~2-4MB)
- No runtime impact after boot

## Integration with BunkerOS

### Future Enhancements

Potential BunkerOS integrations:
- Add Plymouth to main installation script
- Create custom BunkerOS-branded theme
- Integrate with theme switching system
- Match SDDM tactical theme aesthetic

### Current Status

- Plymouth is **optional** for BunkerOS
- Maintains compatibility with existing setups
- Follows BunkerOS philosophy of user choice
- No changes to core BunkerOS functionality

## Removal

To remove Plymouth:

```bash
# Remove splash from boot options
sudo sed -i 's/splash //g' /boot/loader/entries/*.conf

# Disable services
sudo systemctl disable plymouth-start.service

# Remove packages
sudo pacman -Rns plymouth
yay -Rns plymouth-theme-*

# Rebuild initramfs
sudo mkinitcpio -p linux
```

---

**Note:** This is a cosmetic enhancement that doesn't affect BunkerOS functionality. The tactical boot experience remains fully operational with or without Plymouth.