# BunkerOS Frequently Asked Questions

## About BunkerOS

### What is BunkerOS?

BunkerOS is a productivity-hardened, vanilla Arch-based Linux distribution with custom optimizations for a tactical, Sway-based computing environment. It's designed for users seeking distraction-free, mission-focused productivity.

### Is BunkerOS based on Arch Linux?

**Yes**. BunkerOS is a vanilla Arch-based distribution with custom optimizations.

Think of it in layers:
- **Foundation**: Arch Linux (rolling release, AUR, proven ecosystem)
- **Optimization**: BunkerOS custom tuning (performance configurations, productivity focus)
- **Experience**: BunkerOS (Sway environment, productivity tools, tactical theming)

### Why use vanilla Arch instead of a derivative?

**Clean foundation, full control**. Vanilla Arch provides:
- Complete control over system configuration
- No third-party modifications or dependencies
- Direct access to Arch's proven stability
- Clean base for custom optimizations

This allows BunkerOS to implement targeted performance enhancements specifically for productivity workflows while maintaining a pure Arch base.

### How is BunkerOS different from vanilla Arch?

**Vanilla Arch** is a minimal, do-it-yourself distribution that gives you a blank slate.

**BunkerOS** is a productivity-focused distribution that:
- Uses only Sway/SwayFX compositor (no traditional DEs)
- Emphasizes distraction-free, keyboard-driven workflows
- Features tactical theming and discipline
- Provides custom productivity automation and tooling
- Includes curated optimizations for productivity workflows
- Targets mission-focused computing over general-purpose use

### Do I get access to the AUR?

**Yes**. As an Arch-based distribution, BunkerOS has full access to the Arch User Repository (AUR) and all standard Arch packages.

### What's BunkerOS's relationship with Arch Linux?

```
Arch Linux        → Foundation (rolling release, package ecosystem)
    ↓
BunkerOS          → Custom optimizations + Sway environment + productivity focus
```

We build directly on Arch Linux, maintaining full compatibility while adding our productivity-focused enhancements.

## Installation & Setup

### How do I install BunkerOS?

**Current workflow**:
1. Install vanilla Arch Linux using the standard installer
2. Boot into your Arch system
3. Clone BunkerOS repository
4. Run `setup.sh` to configure the environment

**Future goal**: Dedicated BunkerOS installer or automated installation script.

### Why use the standard Arch installation?

**Clean, flexible foundation**. The standard Arch installation provides:
- Reliable base system setup
- Partition management and bootloader configuration
- Hardware detection and driver installation
- Clean base without any unnecessary modifications

This allows BunkerOS to focus on the environment configuration and optimizations.

### Will BunkerOS have its own installer?

**Possible future direction**. Options under consideration:
- Custom BunkerOS installer
- Automated installation script
- Calamares-based installer with BunkerOS branding

For now, the standard Arch installation provides a solid, clean foundation.

## Technical Questions

### What performance optimizations does BunkerOS provide?

Key optimizations for productivity workflows:

1. **Lightweight Environment**: Sway/SwayFX is extremely efficient compared to traditional DEs
2. **Optimized Configuration**: System tuned for productivity workflows and responsiveness
3. **Minimal Resource Usage**: ~332-380 MB RAM depending on edition
4. **Curated Package Selection**: Only essential packages, reducing bloat

These optimizations combine with BunkerOS's focused environment for exceptional performance.

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
- BunkerOS's focused configuration and testing
- Curated package selection for reliability

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
- Package signature verification (inherited from Arch Linux)
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
- Document the Arch Linux foundation in all materials
- Acknowledge Sway/SwayFX projects
- Reference all upstream projects appropriately

Smart engineering means standing on the shoulders of giants and acknowledging them.

### What's the future roadmap?

**Short-term**:
- Custom installer or automated installation script
- Additional productivity automation
- Expanded hardware support documentation
- Community theme submissions

**Long-term**:
- Potential custom BunkerOS repository for optimized packages
- Integration with productivity services
- Mobile companion tools
- Enterprise/team editions

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed technical roadmap.

## Getting Help

### Where can I get support?

- **GitHub Issues**: Bug reports and feature requests
- **Documentation**: Comprehensive guides in the repository
- **Arch Wiki**: Arch Linux documentation applies

### How do I report bugs?

1. Check if it's a BunkerOS-specific issue or upstream (Sway/Arch)
2. Search existing GitHub issues
3. Open a new issue with:
   - Edition (Standard/Enhanced)
   - Hardware specifications
   - Steps to reproduce
   - Expected vs. actual behavior

### Can I use BunkerOS configuration on vanilla Arch?

**Yes**. The BunkerOS environment (Sway config, themes, scripts) is designed for vanilla Arch and can be installed on any standard Arch-based system following the installation guide.

---

**Still have questions?** Open an issue on GitHub or check the documentation in the repository.
