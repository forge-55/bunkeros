# Vanilla Arch Linux Installation Guide for BunkerOS

This is the **definitive guide** for installing vanilla Arch Linux as the foundation for BunkerOS.

## Two Installation Methods

Choose the method that best suits your experience level:

### Option A: archinstall (Guided Installer) - Recommended for Beginners
**Pros:** Automated, user-friendly, handles most configuration  
**Cons:** Less learning about the system internals  
**Time:** ~10 minutes  
**See:** [Method A: Using archinstall](#method-a-using-archinstall-guided-installer)

### Option B: Manual Installation - Recommended for Learning
**Pros:** Full control, learn how Arch works, troubleshooting skills  
**Cons:** More steps, requires careful attention  
**Time:** ~20 minutes  
**See:** [Method B: Manual Installation](#method-b-manual-installation)

---

## Method A: Using archinstall (Guided Installer)

The `archinstall` script is included on the Arch ISO and provides a guided installation process.

### 1. Boot Arch ISO and Connect to Internet

Boot from the Arch USB. You'll land in a root shell.

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

### 2. Launch archinstall

```bash
archinstall
```

### 3. Configuration Settings for BunkerOS

Follow the guided prompts and use these **exact settings**:

**Archinstall Language:** English  
**Keyboard Layout:** us (or your preferred layout)  
**Mirror Region:** Select your country  
**Locale Language:** en_US  
**Locale Encoding:** UTF-8  

**Disk Configuration:**
- Select your disk
- Choose: `Use a best-effort default partition layout`
- Filesystem: `btrfs` (recommended - enables snapshots for recovery)
  - Alternative: `ext4` (simpler, if you prefer traditional)
- **IMPORTANT:** Select `yes` for bootloader

**Disk Encryption:** Optional (your choice)

**Bootloader:** `systemd-boot` (recommended - faster, simpler)
  - Alternative: `Grub` (if you need dual-boot support)

**Swap:** `True` (recommended for laptops)

**Hostname:** `bunkeros` (or your preferred name)

**Root Password:** Set a password (you may not need this if using sudo)

**User Account:**
- Create a user account
- Set username (e.g., `ryan`)
- Set password
- **CRITICAL:** Answer `yes` to "Should this user be a superuser (sudo)?"

**Profile:** 
- **IMPORTANT:** Select `minimal`
- **DO NOT** select desktop, server, or any other profile
- **DO NOT** install any desktop environment

**Audio:** Select `pipewire` (BunkerOS will configure it)

**Kernels:** `linux` (default kernel)

**Additional Packages:**
**CRITICAL - Install these packages when prompted:**
```
git sudo base-devel networkmanager
```
Type exactly as shown above, separated by spaces.

**Network Configuration:** `Use NetworkManager`

**Timezone:** Select your timezone

**Automatic Time Sync (NTP):** `True`

**Optional Repositories:** None needed (you can skip this)

### 4. Install and Reboot

- Review your configuration
- Confirm and start installation
- Wait for installation to complete (~5-10 minutes)
- When prompted, choose to reboot

### 5. Post-Install Configuration

After reboot:

**Login with your user account**

**Verify packages are installed:**
```bash
pacman -Q | grep -E "git|sudo|base-devel|networkmanager"
```

If any are missing:
```bash
sudo pacman -S git sudo base-devel networkmanager
```

**Verify NetworkManager is enabled:**
```bash
systemctl status NetworkManager
```

If not running:
```bash
sudo systemctl enable --now NetworkManager
```

**Connect to WiFi (if needed):**
```bash
nmcli device wifi list
nmcli device wifi connect "YOUR_NETWORK" password "YOUR_PASSWORD"
```

### 6. Install BunkerOS

Your system is now ready!

```bash
# Clone BunkerOS
cd ~
git clone https://github.com/forge-55/bunkeros.git
cd bunkeros

# Run the installer
./install.sh

# When prompted, reboot
```

---

## Method B: Manual Installation

### Critical Prerequisites

- USB drive (2GB+) with Arch ISO
- Internet connection (ethernet strongly recommended for install)
- Basic understanding of partitioning

### Recommended Configuration for BunkerOS

This guide recommends:
- **Filesystem: btrfs** - Enables system snapshots for easy recovery and rollback
- **Bootloader: systemd-boot** - Faster, simpler, and more lightweight than GRUB
- Both align with BunkerOS's philosophy of tactical reliability and minimal overhead

Alternative options (ext4/GRUB) are provided for specific needs.

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

**Option A: btrfs (Recommended - enables snapshots)**
```bash
mkfs.fat -F32 /dev/sda1           # EFI partition
mkfs.btrfs /dev/sda2              # Root partition with btrfs
```

**Option B: ext4 (Traditional, simpler)**
```bash
mkfs.fat -F32 /dev/sda1           # EFI partition
mkfs.ext4 /dev/sda2               # Root partition with ext4
```

**Mount partitions:**

**For btrfs (with subvolumes for snapshots):**
```bash
# Mount the btrfs partition
mount /dev/sda2 /mnt

# Create subvolumes
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home

# Unmount and remount with subvolumes
umount /mnt

# Mount root subvolume
mount -o noatime,compress=zstd,subvol=@ /dev/sda2 /mnt

# Create and mount home
mkdir -p /mnt/home
mount -o noatime,compress=zstd,subvol=@home /dev/sda2 /mnt/home

# Mount EFI
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
```

**For ext4 (traditional):**
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
  btrfs-progs \
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
- `btrfs-progs` - Btrfs utilities (for snapshots, needed even if using ext4)
- `nano` + `vim` - Text editors

**Note:** We don't install a bootloader here - systemd-boot is installed in the next steps.

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

### 8. Install Bootloader (systemd-boot)

**Install systemd-boot:**
```bash
bootctl install
```

**Create bootloader entry:**
```bash
cat > /boot/loader/entries/arch.conf << EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=/dev/sda2 rw
EOF
```

**For btrfs, update the options line to include subvolume:**
```bash
# Edit /boot/loader/entries/arch.conf and change options to:
options root=/dev/sda2 rootflags=subvol=@ rw
```

**Configure loader:**
```bash
cat > /boot/loader/loader.conf << EOF
default arch.conf
timeout 3
console-mode max
editor  no
EOF
```

**Verify installation:**
```bash
bootctl status
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

### Part 2: Post-Reboot Configuration

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

### Part 3: Install BunkerOS

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
```bash
# From Arch USB, mount and chroot:
mount /dev/sda2 /mnt
mount /dev/sda1 /mnt/boot
arch-chroot /mnt
bootctl install
# Then recreate the loader entries (see step 8 above)
```

### Want to Take Snapshots (btrfs)
```bash
# Create a snapshot before major changes:
sudo btrfs subvolume snapshot / /.snapshots/$(date +%Y%m%d-%H%M%S)

# List snapshots:
sudo btrfs subvolume list /

# Restore from snapshot (from live USB):
mount /dev/sda2 /mnt
btrfs subvolume delete /mnt/@
btrfs subvolume snapshot /mnt/.snapshots/SNAPSHOT_NAME /mnt/@
```

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
