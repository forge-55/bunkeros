# BunkerOS Frequently Asked Questions

## About BunkerOS

### What is BunkerOS?

BunkerOS is a productivity-hardened, Arch-based Linux distribution that combines CachyOS's performance optimizations with a tactical, Sway-based computing environment. It's designed for users seeking distraction-free, mission-focused productivity.

### Is BunkerOS based on CachyOS or Arch Linux?

**Both**. BunkerOS is an Arch-based distribution built on CachyOS's performance-optimized foundation.

Think of it in layers:
- **Foundation**: Arch Linux (rolling release, AUR, ecosystem)
- **Performance**: CachyOS (optimized kernel, BORE scheduler, x86-64-v3 packages)
- **Experience**: BunkerOS (Sway environment, productivity tools, tactical theming)

### Why build on CachyOS instead of vanilla Arch?

**Smart engineering**. CachyOS provides battle-tested performance infrastructure:
- BORE scheduler for improved desktop responsiveness
- Link-Time Optimization (LTO) and Profile-Guided Optimization (PGO) packages
- x86-64-v3 optimized builds for modern CPUs
- Active performance testing and maintenance

Rather than recreating this infrastructure, BunkerOS leverages CachyOS's optimizations to focus on delivering the best Sway-based productivity experience.

### How is BunkerOS different from CachyOS?

**CachyOS** is a performance-optimized Arch distribution that ships with various desktop environments (KDE Plasma, GNOME, etc.) and focuses on speed optimizations.

**BunkerOS** is a productivity-focused distribution that:
- Uses only Sway/SwayFX compositor (no traditional DEs)
- Emphasizes distraction-free, keyboard-driven workflows
- Features tactical theming and discipline
- Provides custom productivity automation and tooling
- Targets mission-focused computing over general-purpose use

### Do I get access to the AUR?

**Yes**. As an Arch-based distribution, BunkerOS has full access to the Arch User Repository (AUR) and all standard Arch packages.

You also get access to CachyOS's optimized package repositories for performance-critical packages.

### What's BunkerOS's relationship with these projects?

```
Arch Linux        → Foundation (rolling release, package ecosystem)
    ↓
CachyOS           → Performance layer (optimized kernel/packages)
    ↓
BunkerOS          → Experience layer (Sway environment, productivity focus)
```

We're transparent about this architecture because it represents smart engineering: focus on what makes BunkerOS unique while leveraging proven infrastructure.

## Installation & Setup

### How do I install BunkerOS?

**Current workflow** (interim):
1. Install CachyOS using their installer
2. Choose minimal installation
3. Clone BunkerOS repository
4. Run `setup.sh` to configure the environment

**Future goal**: Dedicated BunkerOS installer or installation profile.

### Why use the CachyOS installer?

**Pragmatic interim solution**. The CachyOS installer provides:
- Reliable Arch installation with performance optimizations
- Partition management and bootloader setup
- Hardware detection and driver installation

This allows BunkerOS to focus on the environment configuration rather than building an installer from scratch.

### Will BunkerOS have its own installer?

**Possible future direction**. Options under consideration:
- Custom BunkerOS installer
- Installation profile for CachyOS installer
- Calamares-based installer with BunkerOS branding

For now, the CachyOS installer provides a solid foundation.

## Technical Questions

### What performance benefits does CachyOS provide?

Key optimizations that benefit BunkerOS:

1. **BORE Scheduler**: Burst-Oriented Response Enhancer improves desktop responsiveness and reduces latency
2. **x86-64-v3 Packages**: Optimized for modern CPUs (2015+) with SIMD instructions
3. **LTO/PGO**: Link-Time Optimization and Profile-Guided Optimization for critical packages
4. **Optimized Kernel**: Performance-focused kernel configuration

These combine with BunkerOS's lightweight Sway environment for exceptional performance.

### Does BunkerOS work on older hardware?

**Yes**. BunkerOS Standard Edition runs excellently on:
- 2018 ThinkPad T480 (Intel UHD 620)
- 2012-2019 systems
- 8GB RAM systems
- Integrated graphics

The Enhanced Edition targets modern hardware (2020+) but Standard Edition is designed specifically for older systems.

### Can I switch between Standard and Enhanced editions?

**Yes, at login**. Both editions use the same SwayFX compositor with effects toggled on/off. You can switch at the SDDM login screen with zero relearning curve—same keybindings, same configuration, same workflow.

### What's the resource usage?

**Standard Edition** (effects disabled):
- RAM: ~332 MB at idle
- GPU: Minimal overhead (~5-10%)
- Behavior: Identical to vanilla Sway

**Enhanced Edition** (effects enabled):
- RAM: ~360-380 MB at idle
- GPU: Moderate overhead (~15-25%)
- Features: Rounded corners, shadows, blur, animations

Both editions are significantly lighter than traditional desktop environments.

### Is BunkerOS stable for daily use?

**Yes**. BunkerOS combines:
- Arch's rolling release model (latest software)
- Sway's production-ready stability
- CachyOS's tested optimizations
- BunkerOS's focused configuration

The Standard Edition prioritizes stability. Enhanced Edition adds visual effects but maintains Sway's stable foundation.

## Philosophy & Direction

### What's BunkerOS's mission?

**Distraction-free, productivity-focused computing with professional-grade discipline.**

We believe:
- Productivity requires focus, not flashy animations
- Professional tools should be efficient and reliable
- Performance optimization enables, not constrains
- Smart engineering leverages existing solutions

### Why the tactical theme?

The tactical aesthetic reflects:
- **Discipline**: Structured, efficient workflows
- **Focus**: Distraction-free environment
- **Reliability**: Production-ready stability
- **Professionalism**: Clean, purposeful design

It's not about being "hardcore"—it's about operational excellence.

### Who is BunkerOS for?

**Target users**:
- Developers and engineers seeking distraction-free environments
- Power users comfortable with keyboard-driven workflows
- Anyone valuing productivity over visual flourish
- Users wanting Arch/AUR access with excellent defaults
- ThinkPad enthusiasts and vintage hardware users (Standard Edition)

### What makes BunkerOS unique?

**Unique differentiators**:
1. Dual-edition architecture (Standard/Enhanced)
2. Tactical productivity focus
3. Sway/SwayFX expertise and optimization
4. Comprehensive theming system (5 curated themes)
5. Productivity automation and custom tooling
6. Hardware range (2018 ThinkPads to modern workstations)

We don't compete with traditional desktop environments—we serve users who want keyboard-driven, tiling window manager workflows with professional polish.

### How does BunkerOS handle security?

BunkerOS implements **productivity-hardened security**: professional-grade protection that works invisibly in the background.

**Automatic security features**:
- UFW firewall (deny incoming, allow outgoing)
- Package signature verification (inherited from Arch/CachyOS)
- AppArmor application containment
- Hardened kernel parameters
- Login auditing

**Optional enhancements**:
- Home directory encryption
- Secure boot configuration
- Automatic security updates

Security serves productivity, not the other way around. Protection works automatically while you focus on work.

**See [SECURITY.md](SECURITY.md) for complete security documentation.**

## Community & Development

### Is BunkerOS open source?

**Yes**. All configuration files, scripts, and documentation are open source and available on GitHub.

### Can I contribute?

**Absolutely**. BunkerOS welcomes contributions:
- Theme development
- Documentation improvements
- Script optimizations
- Hardware testing
- Bug reports and feature requests

### How does BunkerOS credit its foundations?

**Transparently and prominently**. We:
- Document the CachyOS foundation in all materials
- Credit Arch Linux as the base ecosystem
- Acknowledge Sway/SwayFX projects
- Reference all upstream projects appropriately

Smart engineering means standing on the shoulders of giants and acknowledging them.

### What's the future roadmap?

**Short-term**:
- Custom installer or CachyOS installation profile
- Additional productivity automation
- Expanded hardware support documentation
- Community theme submissions

**Long-term**:
- Potential custom BunkerOS repository for unique packages
- Integration with productivity services
- Mobile companion tools
- Enterprise/team editions

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed technical roadmap.

## Getting Help

### Where can I get support?

- **GitHub Issues**: Bug reports and feature requests
- **Documentation**: Comprehensive guides in the repository
- **Arch Wiki**: Arch Linux documentation applies
- **CachyOS Forums**: For performance/kernel questions

### How do I report bugs?

1. Check if it's a BunkerOS-specific issue or upstream (Sway/CachyOS/Arch)
2. Search existing GitHub issues
3. Open a new issue with:
   - Edition (Standard/Enhanced)
   - Hardware specifications
   - Steps to reproduce
   - Expected vs. actual behavior

### What if I want vanilla Arch instead of CachyOS base?

BunkerOS's configuration can be adapted to vanilla Arch, but you'll lose:
- BORE scheduler optimizations
- x86-64-v3 optimized packages
- LTO/PGO compilation benefits

The BunkerOS environment (Sway config, themes, scripts) is Arch-compatible and can be installed on any Arch-based system.

---

**Still have questions?** Open an issue on GitHub or check the documentation in the repository.
