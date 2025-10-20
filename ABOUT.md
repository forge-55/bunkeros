# About BunkerOS

## What is BunkerOS?

**BunkerOS is a productivity-hardened, Arch-based Linux distribution built for mission-focused computing.**

Built on Arch Linux via CachyOS's performance-optimized foundation, BunkerOS combines cutting-edge performance with disciplined productivity workflows. It delivers a distraction-free, military-inspired computing environment that values operational excellence over visual flourish.

## Our Mission

**Distraction-free, productivity-focused computing with military-grade discipline.**

We believe:
- **Productivity requires focus**, not flashy animations
- **Professional tools should be efficient and reliable**
- **Performance optimization enables, not constrains**
- **Smart engineering leverages existing solutions**

## What Makes BunkerOS Unique?

### Arch-Based Excellence
- Full access to Arch ecosystem (AUR, rolling release, extensive documentation)
- CachyOS performance optimizations (BORE scheduler, LTO/PGO packages, x86-64-v3 builds)
- Smart architecture: leverage proven infrastructure, focus on unique experience

### Dual-Edition Philosophy
- **Standard Edition**: Maximum performance for older hardware (2018+)
- **Enhanced Edition**: Modern visual polish for capable systems (2020+)
- Same compositor (SwayFX), same config, same workflow—choose your style at login

### Sway-Powered Productivity
- Keyboard-driven tiling window manager
- Intelligent autotiling (COSMIC-like behavior)
- Production-ready stability
- Lightweight resource usage (~332-380 MB RAM)

### Military-Inspired Discipline
- Tactical color schemes and professional theming
- Distraction-free interface design
- Focus on operational efficiency
- Clean, functional aesthetics

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
│   • Military-inspired theming                   │
│   • Custom workflows & tooling                  │
├─────────────────────────────────────────────────┤
│   CachyOS Performance Layer                     │
│   • Optimized kernel (BORE scheduler)           │
│   • x86-64-v3 optimized packages (LTO/PGO)      │
│   • Performance-focused repository              │
├─────────────────────────────────────────────────┤
│   Arch Linux Foundation                         │
│   • Rolling release model                       │
│   • AUR access                                  │
│   • Extensive documentation                     │
│   • Proven ecosystem                            │
└─────────────────────────────────────────────────┘
```

### Why CachyOS Foundation?

**Smart engineering decision**: Leverage proven optimization rather than recreating performance infrastructure.

**Benefits**:
- BORE Scheduler for improved desktop responsiveness
- Link-Time Optimization (LTO) and Profile-Guided Optimization (PGO) packages
- x86-64-v3 builds optimized for modern CPUs (2015+)
- Maintained infrastructure with active performance testing

**Focus**: With performance handled by CachyOS, BunkerOS concentrates on delivering the best Sway-based productivity experience.

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

### Standard Edition (Effects Disabled)
- **RAM**: ~332 MB at idle
- **GPU**: Minimal overhead (~5-10%)
- **Behavior**: Identical to vanilla Sway
- **Target**: 2018+ hardware, production environments

### Enhanced Edition (Effects Enabled)
- **RAM**: ~360-380 MB at idle
- **GPU**: Moderate overhead (~15-25%)
- **Features**: Rounded corners, shadows, blur, animations
- **Target**: 2020+ hardware, modern GPUs

Both editions significantly lighter than traditional desktop environments.

## Key Features

### Environment
- SwayFX compositor (both editions)
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
- Military-inspired tactical palette
- Professional Nord, Gruvbox, Everforest, Tokyo Night variants

## Installation

**Current Process**:
1. Install CachyOS base system using their installer
2. Clone BunkerOS repository
3. Run `setup.sh` to install Sway environment and configuration
4. Reboot and select BunkerOS session

**Future Goal**: Dedicated BunkerOS installer or installation profile.

See [INSTALL.md](INSTALL.md) for complete installation instructions.

## Philosophy: Smart Engineering

BunkerOS doesn't try to do everything. We:

**Leverage** CachyOS's performance infrastructure rather than recreating it
**Focus** on Sway environment excellence and productivity workflows
**Stand** on the shoulders of giants: Arch, CachyOS, Sway, SwayFX
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

**BunkerOS**: Where Arch performance meets Sway productivity with military discipline. 🎯
