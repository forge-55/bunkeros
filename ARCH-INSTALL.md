# Vanilla Arch Linux Installation Guide for BunkerOS

This guide walks you through installing vanilla Arch Linux from scratch as a foundation for BunkerOS. This is the **recommended** installation method for the cleanest, most reliable BunkerOS experience.

## Why Vanilla Arch?

- ✅ **Cleanest installation** - No pre-installed display managers or conflicting packages
- ✅ **Single-phase install** - BunkerOS installer handles everything including SDDM
- ✅ **No derivative quirks** - Avoid CachyOS/Manjaro-specific patches and assumptions
- ✅ **Rolling release** - Latest packages, bleeding-edge Wayland support
- ✅ **Full control** - You know exactly what's on your system

## Prerequisites

- USB drive (2GB+)
- Bootable Arch Linux ISO ([download here](https://archlinux.org/download/))
- Internet connection (ethernet recommended for initial install)
- Basic terminal knowledge

---

## Installation Steps

### 1. Boot Arch Installation Media

1. Download the Arch Linux ISO from [archlinux.org](https://archlinux.org/download/)
2. Create bootable USB with `dd` or [Etcher](https://etcher.balena.io/)
3. Boot from USB
4. You'll land in a root shell

### 2. Verify Boot Mode (UEFI vs BIOS)

```bash
ls /sys/firmware/efi/efivars
```

- **Directory exists**: UEFI mode (modern, recommended)
- **Directory doesn't exist**: BIOS mode (older systems)

### 3. Connect to Internet

**For WiFi:**
```bash
iwctl
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "YOUR_NETWORK_NAME"
exit
```

**Test connection:**
```bash
ping -c 3 archlinux.org
```

### 4. Partition the Disk

**List disks:**
```bash
lsblk
```

**Start partitioning** (replace `/dev/sda` with your disk):
```bash
cfdisk /dev/sda
```

**Recommended partition scheme (UEFI):**
- `/dev/sda1`: 512MB - EFI System Partition
- `/dev/sda2`: Rest of disk - Linux filesystem (ext4)

**For BIOS systems:**
- `/dev/sda1`: Rest of disk - Linux filesystem (ext4)

**Create filesystems:**

For UEFI:
```bash
mkfs.fat -F32 /dev/sda1        # EFI partition
mkfs.ext4 /dev/sda2            # Root partition
```

For BIOS:
```bash
mkfs.ext4 /dev/sda1            # Root partition
```

### 5. Mount Filesystems

**For UEFI:**
```bash
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
```

**For BIOS:**
```bash
mount /dev/sda1 /mnt
```

### 6. Install Base System

**Essential packages for BunkerOS:**
```bash
pacstrap /mnt base linux linux-firmware git sudo networkmanager vim nano
```

**What these packages do:**
- `base` - Minimal Arch system
- `linux` - Linux kernel
- `linux-firmware` - Hardware drivers
- `git` - Required to clone BunkerOS
- `sudo` - Required for user permissions
- `networkmanager` - Network management (WiFi support)
- `vim/nano` - Text editors (choose one or both)

### 7. Generate Filesystem Table

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Verify it looks correct:
```bash
cat /mnt/etc/fstab
```

### 8. Chroot into New System

```bash
arch-chroot /mnt
```

You're now inside your new Arch installation!

### 9. Configure System

**Set timezone:**
```bash
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
```
Replace `Region/City` with your timezone (e.g., `America/New_York`, `Europe/London`)

**Set locale:**
```bash
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

**Set hostname:**
```bash
echo "bunkeros" > /etc/hostname
```

**Configure hosts file:**
```bash
cat > /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   bunkeros.localdomain bunkeros
EOF
```

**Set root password:**
```bash
passwd
```

### 10. Install Bootloader

**For UEFI (GRUB):**
```bash
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

**For BIOS (GRUB):**
```bash
pacman -S grub
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

**Alternative for UEFI (systemd-boot, simpler):**
```bash
bootctl --path=/boot install
cat > /boot/loader/loader.conf << EOF
default arch.conf
timeout 3
console-mode max
editor no
EOF

cat > /boot/loader/entries/arch.conf << EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=/dev/sda2 rw
EOF
```
*(Replace `/dev/sda2` with your root partition)*

### 11. Enable NetworkManager

```bash
systemctl enable NetworkManager
```

### 12. Create User Account

```bash
useradd -m -G wheel -s /bin/bash yourusername
passwd yourusername
```

**Enable sudo for wheel group:**
```bash
EDITOR=nano visudo
```

Uncomment this line:
```
%wheel ALL=(ALL:ALL) ALL
```

Save and exit (Ctrl+X, Y, Enter for nano)

### 13. Exit and Reboot

```bash
exit                    # Exit chroot
umount -R /mnt         # Unmount all partitions
reboot                 # Reboot (remove USB drive)
```

---

## Post-Installation Setup

### 1. Login and Connect to Network

**Login with your user account** (not root!)

**For WiFi:**
```bash
nmcli device wifi list
nmcli device wifi connect "YOUR_NETWORK" password "YOUR_PASSWORD"
```

### 2. Install BunkerOS

**Clone the repository:**
```bash
cd ~
git clone https://github.com/YOUR_USERNAME/bunkeros.git
cd bunkeros
```

**Run the installer:**
```bash
./install.sh
```

That's it! The installer will:
- ✅ Detect vanilla Arch
- ✅ Install all BunkerOS dependencies
- ✅ Configure user environment
- ✅ Install and enable SDDM
- ✅ Set up themed login screen

**After installation completes:**
```bash
sudo reboot
```

At the SDDM login screen, select "BunkerOS" and log in!

---

## Quick Installation (Using archinstall)

For a faster installation, you can use the `archinstall` script:

```bash
archinstall
```

**Recommended settings:**
- Profile: `minimal`
- Bootloader: `grub` or `systemd-boot`
- Network: `NetworkManager`
- Additional packages: `git sudo vim`
- User: Create your user and add to `wheel` group

After `archinstall` completes, reboot and follow **Post-Installation Setup** above.

---

## Troubleshooting

### No Internet After Reboot
```bash
sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager
```

### Forgot to Create User
Boot into installation media, mount partitions, chroot, then:
```bash
useradd -m -G wheel -s /bin/bash yourusername
passwd yourusername
```

### Bootloader Issues (UEFI)
Verify EFI partition is mounted:
```bash
mount /dev/sda1 /boot
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```

### Screen Resolution Issues
These will be handled by BunkerOS auto-scaling. If needed:
```bash
xrandr  # List available modes
xrandr --output HDMI-1 --mode 1920x1080  # Set resolution
```

---

## Next Steps

Once you have Arch installed and BunkerOS running:

1. ✅ Customize themes: See `QUICKREF.md`
2. ✅ Configure multi-monitor: See `MULTI-MONITOR.md`
3. ✅ Set up power management: See `POWER-MANAGEMENT.md`
4. ✅ Explore keybindings: Super+Shift+/ (in BunkerOS)

---

## Additional Resources

- [Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide) (Official)
- [Arch Wiki](https://wiki.archlinux.org/) (Comprehensive documentation)
- [BunkerOS README](README.md) (Project overview)
- [BunkerOS Installation](INSTALL.md) (Detailed installation options)

---

**Welcome to BunkerOS on vanilla Arch Linux!** 🎯
