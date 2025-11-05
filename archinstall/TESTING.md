# Testing the BunkerOS archinstall Profile

This document describes how to test the archinstall profile before recommending it to users.

## Testing Environment

### Option 1: QEMU/KVM (Recommended)

**Advantages:**
- Fast
- No need for physical hardware or USB
- Easy to reset and retry
- Can test UEFI and BIOS boot

**Setup:**
```bash
# Install required packages
sudo pacman -S qemu-full virt-manager

# Download Arch Linux ISO
curl -O https://mirror.rackspace.com/archlinux/iso/latest/archlinux-x86_64.iso

# Create a virtual disk
qemu-img create -f qcow2 bunkeros-test.qcow2 30G

# Boot the ISO with UEFI
qemu-system-x86_64 \
    -enable-kvm \
    -m 4096 \
    -smp 2 \
    -cpu host \
    -bios /usr/share/edk2-ovmf/x64/OVMF.fd \
    -drive file=bunkeros-test.qcow2,format=qcow2 \
    -cdrom archlinux-x86_64.iso \
    -boot d \
    -netdev user,id=net0 \
    -device virtio-net-pci,netdev=net0

# After installation, boot from disk:
qemu-system-x86_64 \
    -enable-kvm \
    -m 4096 \
    -smp 2 \
    -cpu host \
    -bios /usr/share/edk2-ovmf/x64/OVMF.fd \
    -drive file=bunkeros-test.qcow2,format=qcow2 \
    -netdev user,id=net0 \
    -device virtio-net-pci,netdev=net0
```

### Option 2: VirtualBox

**Advantages:**
- GUI for easy management
- Cross-platform (works on Windows/Mac too)
- Snapshots for easy rollback

**Setup:**
```bash
# Install VirtualBox
sudo pacman -S virtualbox virtualbox-host-modules-arch

# Create VM
- Name: BunkerOS Test
- Type: Linux
- Version: Arch Linux (64-bit)
- RAM: 4096 MB
- Disk: 30 GB VDI
- Enable EFI
- Network: NAT

# Attach Arch Linux ISO and boot
```

### Option 3: Physical Hardware / USB

**Only for final testing** - use VMs for development.

## Testing Procedure

### 1. Boot Arch ISO

Boot into the Arch Linux live environment.

### 2. Test Internet Connection

```bash
# Test connectivity
ping -c 3 archlinux.org

# If WiFi needed:
iwctl
> station wlan0 connect "NETWORK_NAME"
> quit
```

### 3. Test Interactive Installation

```bash
# Download and run helper script
curl -fsSL https://raw.githubusercontent.com/forge-55/bunkeros/main/archinstall/install-bunkeros.sh -o install.sh
bash install.sh

# Choose option 1 (Interactive Installation)
# Follow prompts:
# - Disk configuration: Use entire disk, ext4
# - Timezone: Your timezone
# - Locale: en_US
# - Username: testuser
# - Password: test123
# - Review package list (should include BunkerOS packages)
```

### 4. Verify Installation

After installation completes:

```bash
# Check that post-install ran
ls -la /mnt/home/testuser/.local/share/bunkeros

# Check SDDM theme
ls /mnt/usr/share/sddm/themes/tactical

# Check Sway config
ls /mnt/home/testuser/.config/sway

# Verify symlinks
ls -l /mnt/home/testuser/.config/waybar/config
# Should show: -> /home/testuser/.local/share/bunkeros/waybar/config
```

### 5. Boot Installed System

```bash
# Unmount
umount -R /mnt

# Reboot (or in VM, boot from disk instead of ISO)
reboot
```

### 6. Test BunkerOS Session

After boot:

**Check SDDM:**
- [ ] SDDM displays with tactical theme
- [ ] "BunkerOS" session available in session menu
- [ ] Can log in with created user

**Check Sway:**
- [ ] Sway starts without errors
- [ ] Waybar appears and shows system info
- [ ] Super+Return opens terminal (Foot)
- [ ] Super+D opens application launcher (Wofi)
- [ ] Theme switching works (Super+Shift+T)

**Check Applications:**
- [ ] File manager opens (Super+E → Nautilus)
- [ ] Browser installed (firefox)
- [ ] Calculator available (mate-calc)
- [ ] PDF viewer works (evince)

**Check System:**
- [ ] Audio works (test with `speaker-test`)
- [ ] Network connection active
- [ ] Display scaling appropriate (if HiDPI)

### 7. Test AUR Packages (Optional)

```bash
# Run AUR package installer
~/.local/share/bunkeros/scripts/install-aur-packages.sh

# Verify installation
which auto-cpufreq
systemctl --user status swayosd.service
```

### 8. Test Updates

```bash
# Test git pull updates
cd ~/.local/share/bunkeros
git pull

# Verify symlinks still work
ls -l ~/.config/waybar/config

# Test theme switching after update
# Super+Shift+T and switch themes
```

## Checklist: Pre-Release

Before recommending archinstall profile to users:

- [ ] Tested in QEMU with UEFI
- [ ] Tested in QEMU with BIOS (legacy boot)
- [ ] Tested in VirtualBox
- [ ] Tested on physical hardware (at least one machine)
- [ ] All packages install successfully
- [ ] Post-install script completes without errors
- [ ] SDDM theme displays correctly
- [ ] BunkerOS session starts and functions
- [ ] All keybindings work
- [ ] Theme switching works
- [ ] Documentation is accurate
- [ ] README.md updated
- [ ] INSTALL.md updated
- [ ] archinstall/README.md is clear and complete

## Common Issues and Solutions

### archinstall config version mismatch

**Problem:** archinstall complains about config version

**Solution:** Update `config_version` in `bunkeros-config.json` to match current archinstall version:
```bash
archinstall --version
```

### Post-install script not found

**Problem:** curl fails to download post-install.sh

**Solution:** Check GitHub raw URL is correct and repository is public

### SDDM doesn't start

**Problem:** Black screen after boot

**Solution:** 
```bash
# Boot to TTY (Ctrl+Alt+F2)
journalctl -u sddm
# Check for errors
```

### BunkerOS session not listed

**Problem:** Only "Plasma" or other sessions visible

**Solution:**
```bash
ls /usr/share/wayland-sessions/
# Should show bunkeros.desktop
```

### Symlinks broken

**Problem:** Configs not loading

**Solution:**
```bash
# Check repository location
ls ~/.local/share/bunkeros

# Verify symlinks
ls -l ~/.config/waybar/config

# Re-run setup if needed
cd ~/.local/share/bunkeros
./setup.sh
```

## Performance Testing

### Resource Usage

After boot into BunkerOS session:

```bash
# Check RAM usage
free -h
# Should be around 300-400 MB used

# Check running processes
ps aux --sort=-%mem | head -20

# Monitor with btop
btop
```

### Boot Time

```bash
# Check boot time
systemd-analyze
systemd-analyze blame
```

Target: < 10 seconds to SDDM on SSD

### Sway Startup

```bash
# Check Sway logs
journalctl --user -u sway
```

Should start with no errors.

## Automation Testing Script

Create a test script for automated testing:

```bash
#!/usr/bin/env bash
# test-archinstall.sh - Automated testing in QEMU

set -e

# Download Arch ISO
if [ ! -f archlinux.iso ]; then
    curl -O https://mirror.rackspace.com/archlinux/iso/latest/archlinux-x86_64.iso
    mv archlinux-*.iso archlinux.iso
fi

# Create test disk
qemu-img create -f qcow2 test-disk.qcow2 30G

# Boot and install (this would need expect/pexpect for full automation)
qemu-system-x86_64 \
    -enable-kvm \
    -m 4096 \
    -smp 2 \
    -cpu host \
    -bios /usr/share/edk2-ovmf/x64/OVMF.fd \
    -drive file=test-disk.qcow2,format=qcow2 \
    -cdrom archlinux.iso \
    -boot d \
    -netdev user,id=net0 \
    -device virtio-net-pci,netdev=net0 \
    -nographic
```

## Documentation Testing

Verify all documentation is accurate:

- [ ] README.md installation instructions work
- [ ] INSTALL.md links are valid
- [ ] archinstall/README.md commands execute correctly
- [ ] All code examples can be copy-pasted and run
- [ ] Screenshots are up to date (if any)

## User Experience Testing

Have someone unfamiliar with the project test:

- [ ] Can they understand the installation options?
- [ ] Is it clear which method to choose?
- [ ] Do they understand what BunkerOS is?
- [ ] Can they complete installation without help?
- [ ] Do they understand how to customize after install?

## Final Verification

Before release:

```bash
# Clean install test
# 1. Boot Arch ISO
# 2. Run one-liner:
curl -fsSL https://raw.githubusercontent.com/forge-55/bunkeros/main/archinstall/install-bunkeros.sh | bash
# 3. Complete installation
# 4. Reboot
# 5. Log in to BunkerOS
# 6. Use for 30 minutes to check for issues
```

Everything should work perfectly on first try.
