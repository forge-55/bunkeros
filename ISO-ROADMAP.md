# BunkerOS Standalone Distribution Roadmap

## Current State: Configuration Layer

**What BunkerOS is now:**
- Sway-based desktop environment configuration
- Runs on top of existing Arch-based distributions
- Installation scripts to deploy configs
- Works on: Arch, Manjaro, EndeavourOS, **CachyOS**, etc.

**Current Installation Process:**
1. User has existing Arch-based system (CachyOS, etc.)
2. Runs `install.sh` (Phase 1)
3. Runs `install-sddm.sh` (Phase 2)
4. Inherits base system quirks (CachyOS ships `ly`, etc.)

## Vision: Standalone Distribution

**What BunkerOS should become:**
- **Complete Arch-based distribution** from the ground up
- **BunkerOS ISO** that users flash to USB and install
- **Vanilla Arch base** with BunkerOS defaults
- **No inherited quirks** from other distros
- **Optimized kernel** (CachyOS optimizations + BunkerOS tuning)

## Why This Matters

### Current Problems with Derivative Installs

**CachyOS Example:**
- Ships with `ly` display manager by default
- Our install script must detect and replace it
- User might have CachyOS-specific configs that conflict
- Can't guarantee clean state
- Two-phase install needed to prevent breaking sessions

**Manjaro Example:**
- Ships with specific kernel versions
- Has its own pamac/octopi package managers
- Different default configs than vanilla Arch
- Potential conflicts with BunkerOS assumptions

**The Core Issue:**
- We're building on top of someone else's foundation
- Each derivative has its own opinions
- More complexity in installation scripts
- Harder to troubleshoot user issues

### Benefits of Standalone ISO

**1. Clean Slate**
- Start from vanilla Arch
- No pre-installed display managers to replace
- No conflicting configs
- Predictable base state

**2. Simpler Installation**
- Single-phase install (no existing DM to worry about)
- Can configure everything during ISO install
- No need to detect/handle 10 different scenarios

**3. Better User Experience**
- Flash USB → Install → Done
- Just like any other Linux distro
- No "install on top of X" instructions
- Professional appearance

**4. Optimization Control**
- Custom kernel with BunkerOS-specific optimizations
- Pre-tuned for Sway/Wayland performance
- Power management configured correctly from start
- No bloat from base distro

**5. Branding & Identity**
- BunkerOS is THE distro, not a config pack
- Can ship with custom boot splash
- Custom installer with BunkerOS theming
- Positions as complete solution

## Roadmap to Standalone ISO

### Phase 1: ISO Creation (Current Priority) ✅

**Goal:** Create bootable BunkerOS ISO

**Steps:**
1. Start with vanilla Arch base
2. Use `archiso` to build custom ISO
3. Pre-configure:
   - SDDM as display manager
   - BunkerOS session files
   - All configs in place
   - PipeWire enabled by default
   - Power management configured
4. Test in VM (QEMU/VirtualBox)
5. Test on real hardware

**Deliverable:** `bunkeros-YYYY.MM.DD-x86_64.iso`

### Phase 2: Custom Installer

**Goal:** Professional installation experience

**Options:**
1. **Calamares Installer** (Most professional)
   - Used by Manjaro, EndeavourOS, etc.
   - Graphical, user-friendly
   - Easy to customize
   
2. **Archinstall** (Arch's official installer)
   - TUI-based
   - Lightweight
   - Good for advanced users
   
3. **Custom Script-based Installer**
   - Full control
   - Can be very BunkerOS-specific
   - More work to maintain

**Recommendation:** Start with Archinstall, move to Calamares later

### Phase 3: Kernel Optimization

**Goal:** Custom kernel for Sway/Wayland performance

**Optimizations:**
- CachyOS kernel patches (performance)
- Wayland-specific optimizations
- Power management tuning
- Disable unused kernel modules
- Optimize for modern hardware (2015+)

**Build System:**
- Automated kernel builds
- Version management
- Test before release

### Phase 4: Package Repository

**Goal:** BunkerOS-specific package repository

**Packages to Host:**
- Custom kernel builds
- BunkerOS configurations
- Patched/optimized versions of key software
- AUR packages we depend on (pre-built)

**Benefits:**
- Users don't need AUR helpers
- Faster installation
- Version control
- Can patch upstream bugs

### Phase 5: Automated Builds & Releases

**Goal:** Monthly ISO releases

**System:**
- GitHub Actions to build ISOs
- Automated testing in VM
- Release on schedule (e.g., monthly)
- Versioning: `bunkeros-2025.11.03-x86_64.iso`

**Distribution:**
- GitHub Releases
- Torrent support (bandwidth)
- Mirrors (if needed)

## Technical Implementation

### Directory Structure for ISO Build

```
bunkeros/
├── iso/
│   ├── archiso/           # Base archiso configs
│   ├── airootfs/          # Files to include in live environment
│   │   ├── etc/
│   │   │   └── sddm.conf
│   │   ├── usr/
│   │   │   └── share/
│   │   │       ├── sddm/themes/tactical/
│   │   │       └── wayland-sessions/
│   │   └── root/
│   │       └── install-to-disk.sh
│   ├── packages.x86_64    # Packages to include
│   └── build-iso.sh       # ISO build script
├── configs/               # Current BunkerOS configs
└── scripts/               # Current scripts
```

### Minimal packages.x86_64

```
# Base system
base
base-devel
linux
linux-firmware

# Boot
grub
efibootmgr

# Network
networkmanager
iwd

# Display
sddm
qt5-declarative
qt5-quickcontrols2

# Wayland/Sway
sway
swaybg
swaylock
swayidle
waybar
wofi
mako
foot

# BunkerOS essentials
autotiling-rs
pipewire
pipewire-pulse
wireplumber
brightnessctl
playerctl
grim
slurp
wl-clipboard

# Utilities
nautilus
btop
lite-xl
mate-calc
```

### Build ISO Command

```bash
cd bunkeros/iso
sudo mkarchiso -v -w work/ -o out/ archiso/
```

**Output:** `bunkeros-YYYY.MM.DD-x86_64.iso`

## Migration Path for Existing Users

Users who installed BunkerOS on CachyOS/Manjaro/etc. can:

**Option 1: Keep current setup**
- Continue using BunkerOS configs on their distro
- Use two-phase installation
- Update configs via git pull

**Option 2: Migrate to BunkerOS ISO**
- Backup home directory
- Install BunkerOS ISO fresh
- Restore home directory
- Cleaner, more maintainable

## Timeline Estimate

**Immediate (Next 2 weeks):**
- ✅ Two-phase installation (DONE)
- Create basic ISO with archiso
- Test in VM

**Short-term (1-2 months):**
- Refine ISO build process
- Add archinstall integration
- First public ISO release
- Documentation for ISO installation

**Medium-term (3-6 months):**
- Custom kernel builds
- Package repository setup
- Automated monthly releases
- Calamares installer integration

**Long-term (6-12 months):**
- Full-featured custom installer
- Optimized kernel performance
- Large user base on standalone ISO
- Community mirrors

## Decision Points

### Should we maintain both?

**Configuration Layer (Current):**
- For users who want BunkerOS on existing systems
- Lower barrier to entry (no reinstall needed)
- Good for testing/trying out

**Standalone ISO (Future):**
- For serious users who want full BunkerOS experience
- Best performance and reliability
- Recommended path forward

**Answer:** Yes, maintain both, but **recommend ISO** as primary method.

## Resources Needed

1. **Development:**
   - Learn archiso build system
   - Set up ISO build environment
   - Test on multiple hardware configs

2. **Infrastructure:**
   - GitHub Actions for builds (free)
   - GitHub Releases for distribution (free)
   - Optional: SourceForge mirrors (free)

3. **Documentation:**
   - ISO installation guide
   - Migration guide from config layer
   - Troubleshooting ISO-specific issues

4. **Testing:**
   - VM testing (QEMU, VirtualBox)
   - Real hardware testing (various machines)
   - Community beta testing

## Next Steps

**Immediate action items:**

1. **Create `iso/` directory** in repo
2. **Set up basic archiso config**
3. **Build first test ISO**
4. **Boot in VM and verify:**
   - Sway works
   - SDDM works
   - BunkerOS session available
   - Configs are applied
5. **Document ISO build process**
6. **Create installation script for ISO**

**Would you like me to start building the ISO structure?**

## Conclusion

Moving from a configuration layer to a standalone distribution is the natural evolution of BunkerOS. It will:

- **Eliminate** issues with derivative distros (CachyOS, Manjaro quirks)
- **Simplify** installation (single-phase, clean install)
- **Improve** reliability (known base state)
- **Enable** optimizations (custom kernel)
- **Position** BunkerOS as a complete solution

The two-phase installation we just built is the **interim solution** for users on existing systems. The **long-term solution** is a BunkerOS ISO that Just Works™.
