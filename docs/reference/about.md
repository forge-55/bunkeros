# About BunkerOS

## What is BunkerOS?

BunkerOS is a configuration layer for Arch Linux that provides a productivity-focused Sway desktop environment. Rather than being a standalone distribution, BunkerOS is installed on top of your existing Arch Linux (or Arch-based) system.

Built on vanilla Arch Linux with transparent, symlinked configurations, BunkerOS combines performance with disciplined productivity workflows. It delivers a distraction-free, tactical computing environment that values operational excellence over visual flourish.

## Our Mission

**Distraction-free, productivity-focused computing with professional-grade discipline.**

We believe:
- **Productivity requires focus**, not flashy animations
- **Professional tools should be efficient and reliable**
- **Performance optimization enables, not constrains**
- **Smart engineering leverages existing solutions**

## Design Philosophy

### Configuration Layer, Not Distribution

BunkerOS is fundamentally a configuration layer rather than a standalone Linux distribution:

**What this means:**
- BunkerOS runs on top of vanilla Arch Linux or Arch-based distributions
- Users install their preferred base system first
- BunkerOS adds a curated Sway environment and productivity tools
- Standard Arch package management and workflows remain unchanged
- All configurations are transparent and user-auditable

**Why this approach:**
- **Respects Arch philosophy** - Users understand their base system
- **Maximum flexibility** - Works on various Arch-based distributions
- **Transparent changes** - All configs symlinked from git repo
- **Easy maintenance** - Standard Arch tools for updates and troubleshooting
- **Reversible** - Simple to modify or remove BunkerOS configurations

### Transparent Configuration Management

All BunkerOS configurations are symlinked from the git repository to your system:

- See exactly what files are modified in your system
- Configuration changes visible through git diffs
- Easy to audit, fork, or customize
- Update with a simple `git pull`
- Remove symlinks to revert to vanilla Arch

### Standard Package Management

BunkerOS uses exclusively standard Arch tools:

- **pacman** for official repository packages
- **yay** or **paru** for AUR packages
- No custom package managers or bash script installations
- Follows Arch packaging standards (PKGBUILD when needed)
- All dependencies visible in installation scripts

### Compatibility with Arch-Based Distributions

While designed for vanilla Arch Linux, BunkerOS can be installed on minimal Arch-based distributions:

**Compatible base systems:**
- Vanilla Arch Linux
- CachyOS (minimal installation)
- EndeavourOS (without desktop environment)
- Manjaro (with caution - package versions may differ)
- Other Arch derivatives using standard Arch repositories

**Requirements for compatibility:**
- Uses standard Arch repositories (core, extra, community)
- No pre-installed desktop environment (or willing to replace it)
- Standard Arch package management (pacman)
- Systemd-based init system

The installation scripts check for compatibility and warn about potential conflicts.

## What Makes BunkerOS Unique?

### Arch-Based Excellence
- Full access to Arch ecosystem (AUR, rolling release, extensive documentation)
- Custom performance optimizations for productivity workflows
- Smart architecture: build on solid Arch foundation with targeted enhancements

### Performance-First Design
- **Vanilla Sway**: Rock-solid stability with zero visual artifacts
- **No effects overhead**: Clean, flat design without GPU performance cost
- **Modern look, vintage speed**: Professional appearance on any hardware
- **Universal compatibility**: Works excellently from 2012+ systems to modern workstations

### Sway-Powered Productivity
- Keyboard-driven tiling window manager
- Intelligent autotiling (COSMIC-like behavior)
- Production-ready stability
- Lightweight resource usage (~280 MB RAM)

### Tactical Discipline
- Tactical color schemes and professional theming
- Distraction-free interface design
- Focus on operational efficiency
- Clean, functional aesthetics

### Productivity-Hardened Security
- Professional-grade protection working invisibly in background
- UFW firewall, AppArmor containment, hardened kernel
- Automatic package signature verification
- Optional encryption and secure boot
- Security serves productivity, not the other way around

### Comprehensive Theming
- 5 curated themes (Tactical, Gruvbox, Nord, Everforest, Tokyo Night)
- System-wide consistency (Waybar, Wofi, Mako, terminals, applications)
- Instant theme switching without logout

### Productivity Automation
- Custom keybinding manager with GUI
- Web app installation system
- Smart wallpaper management
- Network and Bluetooth managers
- Quick actions menu

## Technical Foundation

```
┌─────────────────────────────────────────────────┐
│   BunkerOS Configuration Layer                  │
│   • Sway environment configuration              │
│   • Productivity automation                     │
│   • Tactical theming                            │
│   • Symlinked dotfiles from git repo            │
│   • Custom workflows & tooling                  │
├─────────────────────────────────────────────────┤
│   Arch Linux Foundation                         │
│   • Rolling release model                       │
│   • AUR access                                  │
│   • Extensive documentation (Arch Wiki)         │
│   • Proven ecosystem                            │
│   • Standard package management                 │
└─────────────────────────────────────────────────┘
```

### Why This Architecture?

**Transparent and Auditable:**
- All configuration files symlinked from git repository
- Users can see exactly what BunkerOS changes
- Easy to review, modify, or remove configurations
- Version-controlled dotfiles approach

**Standard Arch Workflows:**
- No custom package managers or installation methods
- Standard `pacman` and AUR helper usage
- Arch Wiki remains the primary documentation resource
- Familiar troubleshooting and maintenance procedures

**Flexibility and Control:**
- Install on existing Arch systems without reinstalling
- Works on various Arch-based distributions
- Easy to customize or extend configurations
- Remove BunkerOS layer without affecting base system

## Who is BunkerOS For?

BunkerOS serves users who:
- Want a productivity-focused Sway environment on Arch Linux
- Value keyboard-driven workflows and tiling window managers
- Appreciate curated configurations over building from scratch
- Understand or want to learn Arch Linux fundamentals
- Prefer distraction-free computing over visual effects
- Value transparent, auditable system changes
- Work with ThinkPads or other professional hardware

BunkerOS provides a complete, polished Sway desktop environment while maintaining the transparency and control that Arch Linux users expect.

## Performance Profile

### Default Configuration (Minimal Effects)
- **RAM**: ~332 MB at idle
## Resource Usage

### Vanilla Sway Configuration
- **RAM**: ~280 MB at idle
- **GPU**: Minimal overhead (~2-5%)
- **Effects**: None - clean, flat design
- **Target**: All hardware (2012+)
- **Behavior**: Rock-solid stability, zero visual artifacts

Significantly lighter than traditional desktop environments.

## Key Features

### Environment
- Vanilla Sway compositor
- Waybar status bar with tactical styling
- Wofi application launcher
- Mako notification daemon
- Foot terminal emulator

### Applications
- Nautilus file manager (GNOME Files)
- Eye of GNOME image viewer
- Evince PDF viewer
- Lite XL note-taking app
- MATE Calculator
- btop system monitor

### Productivity Tools
- Interactive keybinding manager (GUI)
- Web app installation system
- Multi-theme switcher
- Wallpaper manager
- Network/Bluetooth managers
- Quick actions menu

### Theming
- 5 curated themes with consistent styling
- Custom GTK3/GTK4 themes
- Tactical color palette
- Professional Nord, Gruvbox, Everforest, Tokyo Night variants

## Installation

**Quick Start: archinstall Profile**

The fastest way to get started:

```bash
# Boot Arch Linux ISO
curl -fsSL https://raw.githubusercontent.com/forge-55/bunkeros/main/archinstall/install-bunkeros.sh | bash
```

This automates Arch Linux installation and BunkerOS configuration in one process.

**Manual Installation**

If you already have Arch Linux or prefer to install it manually first:

1. Install vanilla Arch Linux or an Arch-based distribution
2. Clone BunkerOS repository
3. Run `install.sh` to install Sway environment and symlink configurations
4. Reboot and select BunkerOS session at login

Manual installation offers deeper understanding of how your system is configured. See [INSTALL.md](../../INSTALL.md) for complete instructions.

**archinstall Details:** See [archinstall/README.md](../../archinstall/README.md)

**What Gets Installed:**
- Sway compositor and Wayland components
- Productivity tools and applications
- BunkerOS configurations (symlinked from git repo)
- SDDM display manager with tactical theme
- User environment setup (PipeWire, services, etc.)

See [INSTALL.md](../../INSTALL.md) for complete installation instructions.

## Philosophy: Smart Engineering

BunkerOS doesn't try to do everything. We:

**Build** on vanilla Arch's solid foundation with targeted enhancements
**Focus** on Sway environment excellence and productivity workflows
**Stand** on the shoulders of giants: Arch and Sway
**Credit** our foundations transparently and prominently
**Deliver** a unique experience that doesn't exist elsewhere

This is professional software engineering: identify core competencies, leverage proven solutions, deliver excellence in your domain.

## Get Started

- **Repository**: [github.com/forge-55/bunkeros](https://github.com/forge-55/bunkeros)
- **Documentation**: [README.md](README.md), [FAQ.md](FAQ.md), [ARCHITECTURE.md](ARCHITECTURE.md)
- **Installation**: [INSTALL.md](INSTALL.md)
- **Issues/Support**: [GitHub Issues](https://github.com/forge-55/bunkeros/issues)

## Community & Development

**Open Source**: All configuration files, scripts, and documentation available on GitHub

**Contributions Welcome**:
- Theme development
- Documentation improvements
- Script optimizations
- Hardware testing
- Bug reports and feature requests

**Transparent**: We document our technical choices, credit our foundations, and explain our decisions.

---

**BunkerOS**: Where Arch performance meets Sway productivity with tactical discipline. 🎯
