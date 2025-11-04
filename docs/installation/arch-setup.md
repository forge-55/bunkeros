# Vanilla Arch Linux Installation Guide for BunkerOS

This is the **definitive guide** for installing vanilla Arch Linux as the foundation for BunkerOS. Follow these exact steps for a perfect installation.

## Critical Prerequisites

- USB drive (2GB+) with Arch ISO
- Internet connection (ethernet strongly recommended for install)
- Basic understanding of partitioning

---

## Part 1: Base Arch Installation

### 1. Boot Arch ISO

Boot from the Arch USB. You'll land in a root shell.

### 2. Connect to Internet

**Ethernet (recommended):** Should work automatically. Test with:
```bash
ping -c 3 archlinux.org
```

**WiFi (if needed):**
```bash
iwctl
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "YOUR_NETWORK_NAME"
exit
ping -c 3 archlinux.org
```

### 3. Partition the Disk

**List disks:**
```bash
lsblk
```

**Use cfdisk (easiest):**
```bash
cfdisk /dev/sda  # Replace sda with your disk
```

**CRITICAL: Choose GPT partition table (for UEFI)**

**Create these partitions:**
1. **512MB** - Type: `EFI System`
2. **Rest of disk** - Type: `Linux filesystem`

Write and quit.

**Format partitions:**
```bash
mkfs.fat -F32 /dev/sda1     # EFI partition
mkfs.ext4 /dev/sda2         # Root partition
```

**Mount partitions:**
```bash
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
```

### 4. Install Base System

**CRITICAL: Install these exact packages (this is the minimal set for BunkerOS):**

```bash
pacstrap /mnt base linux linux-firmware \
  git sudo networkmanager base-devel \
  grub efibootmgr \
  nano vim
```

**What each package does:**
- `base` - Core Arch system
- `linux` - Kernel
- `linux-firmware` - Hardware drivers
- `git` - Required to clone BunkerOS
- `sudo` - Required for user permissions
- `networkmanager` - WiFi/network management (essential!)
- `base-devel` - Build tools (required for AUR)
- `grub` + `efibootmgr` - Bootloader
- `nano` + `vim` - Text editors

**DO NOT install a desktop environment, display manager, or window manager. BunkerOS will handle all of that.**

### 5. Generate fstab

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Verify:
```bash
cat /mnt/etc/fstab
```

### 6. Chroot into New System

```bash
arch-chroot /mnt
```

### 7. Configure System

**Timezone:**
```bash
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
```
*Replace `America/New_York` with your timezone*

**Locale:**
```bash
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

**Hostname:**
```bash
echo "bunkeros" > /etc/hostname
```

**Hosts file:**
```bash
cat > /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   bunkeros.localdomain bunkeros
EOF
```

**Root password:**
```bash
passwd
```

### 8. Install Bootloader (GRUB)

```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

### 9. Enable NetworkManager

**CRITICAL - Without this you'll have no internet after reboot:**
```bash
systemctl enable NetworkManager
```

### 10. Create User Account

**CRITICAL - Replace `yourusername` with your actual username:**
```bash
useradd -m -G wheel -s /bin/bash yourusername
passwd yourusername
```

**Enable sudo for wheel group:**
```bash
EDITOR=nano visudo
```

**Uncomment this line (remove the #):**
```
%wheel ALL=(ALL:ALL) ALL
```

Save and exit (Ctrl+X, Y, Enter).

### 11. Exit and Reboot

```bash
exit                 # Exit chroot
umount -R /mnt      # Unmount
reboot              # Remove USB and reboot
```

---

## Part 2: Post-Reboot Configuration

### 1. Login as Your User

**DO NOT login as root**. Use the user account you created.

### 2. Connect to Network

**WiFi:**
```bash
nmcli device wifi list
nmcli device wifi connect "YOUR_NETWORK" password "YOUR_PASSWORD"
```

**Test internet:**
```bash
ping -c 3 archlinux.org
```

### 3. Verify Your System

```bash
# You should see these packages:
pacman -Q | grep -E "git|sudo|base-devel|networkmanager"
```

If any are missing, install them:
```bash
sudo pacman -S git sudo base-devel networkmanager
```

---

## Part 3: Install BunkerOS

Now your system is ready for BunkerOS!

```bash
# Clone BunkerOS
cd ~
git clone https://github.com/forge-55/bunkeros.git
cd bunkeros

# Run the installer
./install.sh

# When prompted, reboot
```

After reboot, you'll see the SDDM login screen with the BunkerOS tactical theme. Select "BunkerOS" from the session menu and log in!

---

## What NOT to Install

**DO NOT install these before BunkerOS:**
- ❌ Any desktop environment (GNOME, KDE, XFCE, etc.)
- ❌ Any display manager (GDM, SDDM, LightDM, ly, etc.)
- ❌ Any window manager (i3, sway, etc.)
- ❌ Xorg or X11 packages
- ❌ PipeWire or PulseAudio

BunkerOS installer handles all of these automatically.

---

## Troubleshooting Base Installation

### No Internet After Reboot
```bash
sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager
```

### Forgot to Create User
Boot Arch USB, mount partitions, chroot:
```bash
mount /dev/sda2 /mnt
mount /dev/sda1 /mnt/boot
arch-chroot /mnt
useradd -m -G wheel -s /bin/bash yourusername
passwd yourusername
```

### Bootloader Doesn't Work
Verify EFI partition is mounted at `/boot` before running `grub-install`.

---

## Summary Checklist

Before installing BunkerOS, verify:
- ✅ Booted into your new Arch install (not the USB)
- ✅ Logged in as regular user (not root)
- ✅ Internet connection working
- ✅ These packages installed: `git sudo base-devel networkmanager`
- ✅ NO desktop environment or window manager installed
- ✅ NO display manager installed

If all checkboxes are ✅, you're ready to install BunkerOS!

---

**Next: Clone bunkeros and run `./install.sh`** 🎯
