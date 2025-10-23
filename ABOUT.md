# About BunkerOS

## What is BunkerOS?

**BunkerOS is a productivity-hardened, Arch-based Linux distribution built for mission-focused computing.**

## What is BunkerOS?

Built on vanilla Arch Linux with custom optimizations, BunkerOS combines performance with disciplined productivity workflows. It delivers a distraction-free, tactical computing environment that values operational excellence over visual flourish.

## Our Mission

**Distraction-free, productivity-focused computing with professional-grade discipline.**

We believe:
- **Productivity requires focus**, not flashy animations
- **Professional tools should be efficient and reliable**
- **Performance optimization enables, not constrains**
- **Smart engineering leverages existing solutions**

## What Makes BunkerOS Unique?

### Arch-Based Excellence
- Full access to Arch ecosystem (AUR, rolling release, extensive documentation)
- Custom performance optimizations for productivity workflows
- Smart architecture: build on solid Arch foundation with targeted enhancements

### Performance-First Visual Design
- **Minimal effects by default**: Only rounded corners enabled (~0% overhead)
- **Modern look, vintage speed**: Clean professional appearance without performance cost
- **Optional enhancements**: Users with modern GPUs can enable additional effects via toggle script
- Same compositor (SwayFX), same workflow—choose your visual style anytime

### Sway-Powered Productivity
- Keyboard-driven tiling window manager
- Intelligent autotiling (COSMIC-like behavior)
- Production-ready stability
- Lightweight resource usage (~332 MB RAM)

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
│   BunkerOS Experience Layer                     │
│   • Sway/SwayFX environment                     │
│   • Productivity automation                     │
│   • Tactical theming                            │
│   • Custom workflows & tooling                  │
├─────────────────────────────────────────────────┤
│   BunkerOS Optimization Layer                   │
│   • Custom kernel configurations                │
│   • Performance tuning for productivity         │
│   • Optimized package selection                 │
├─────────────────────────────────────────────────┤
│   Arch Linux Foundation                         │
│   • Rolling release model                       │
│   • AUR access                                  │
│   • Extensive documentation                     │
│   • Proven ecosystem                            │
└─────────────────────────────────────────────────┘
```

### Why Vanilla Arch Foundation?

**Clean, controlled base**: Build on vanilla Arch for complete control over optimizations.

**Benefits**:
- Full control over system configuration and optimization
- Clean base without third-party modifications
- Direct access to Arch's proven stability and ecosystem
- Custom tuning for specific productivity workflows

**Focus**: BunkerOS concentrates on delivering the best Sway-based productivity experience with targeted performance optimizations.

## Who is BunkerOS For?

### Ideal Users
- Developers and engineers seeking distraction-free environments
- Power users comfortable with keyboard-driven workflows
- Anyone valuing productivity over visual excess
- Users wanting Arch/AUR access with excellent defaults
- ThinkPad enthusiasts and vintage hardware users
- Professionals seeking operational discipline in their computing

### Not Recommended For
- Users preferring traditional point-and-click desktop environments
- Those requiring extensive hand-holding or beginner-focused tools
- Users prioritizing flashy animations over efficiency
- Anyone uncomfortable with tiling window managers

## Performance Profile

### Default Configuration (Minimal Effects)
- **RAM**: ~332 MB at idle
- **GPU**: Minimal overhead (~5-10%)
- **Effects**: Rounded corners only (6px)
- **Target**: All hardware (2012+)
- **Behavior**: Nearly identical to vanilla Sway with modern appearance

### Optional Enhanced Mode (Full Effects)
- **RAM**: ~360-380 MB at idle
- **GPU**: Moderate overhead (~15-25%)
- **Features**: Rounded corners, shadows, blur, animations
- **Target**: Modern GPUs (Intel Xe, AMD Vega+, NVIDIA GTX 1050+)
- **Toggle**: Use `~/Projects/bunkeros/scripts/toggle-swayfx-mode.sh`

Both configurations significantly lighter than traditional desktop environments.

## Key Features

### Environment
- SwayFX compositor with minimal effects
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

**Current Process**:
1. Install vanilla Arch Linux base system
2. Clone BunkerOS repository
3. Run `setup.sh` to install Sway environment and configuration
4. Reboot and select BunkerOS session

**Future Goal**: Dedicated BunkerOS installer or installation profile.

See [INSTALL.md](INSTALL.md) for complete installation instructions.

## Philosophy: Smart Engineering

BunkerOS doesn't try to do everything. We:

**Build** on vanilla Arch's solid foundation with targeted enhancements
**Focus** on Sway environment excellence and productivity workflows
**Stand** on the shoulders of giants: Arch, Sway, SwayFX
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
