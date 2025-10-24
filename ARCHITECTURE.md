# BunkerOS Architecture

Technical documentation of BunkerOS design decisions, architecture, and future roadmap.

## Overview

**BunkerOS** is a vanilla Arch-based Linux distribution with custom optimizations. This architectural decision enables BunkerOS to maintain full control over the system while delivering an exceptional Sway-based productivity environment.

### Technical Stack

```
┌─────────────────────────────────────────────────┐
│   BunkerOS Experience Layer                     │
│   • Vanilla Sway environment                    │
│   • Productivity automation                     │
│   • Tactical theming                            │
│   • Custom workflows & tooling                  │
├─────────────────────────────────────────────────┤
│   BunkerOS Optimization Layer                   │
│   • Custom kernel configurations                │
│   • Performance tuning                          │
│   • Curated package selection                   │
│   • Productivity-focused optimizations          │
├─────────────────────────────────────────────────┤
│   Arch Linux Foundation                         │
│   • Rolling release model                       │
│   • AUR access                                  │
│   • Extensive documentation                     │
│   • Proven ecosystem                            │
└─────────────────────────────────────────────────┘
```

### Why Vanilla Arch Foundation?

**Clean foundation, full control**: Build on vanilla Arch for complete control over optimizations.

**Benefits**:
- **Full Control**: Complete control over system configuration and optimization
- **Clean Base**: No third-party modifications or dependencies
- **Direct Updates**: Direct access to Arch's proven stability and ecosystem
- **Custom Tuning**: Targeted optimizations for specific productivity workflows

**BunkerOS's Focus**: With a clean Arch base, BunkerOS concentrates on:
- Exceptional Sway experience
- Productivity automation and workflows
- Tactical aesthetic and discipline
- Distraction-free computing environment

## Design Philosophy

BunkerOS is built around four core principles:

1. **Performance First** - Custom optimizations + lightweight Sway environment
2. **Configuration Compatibility** - Single codebase that works across both compositor editions
3. **Operational Efficiency** - Keyboard-driven, distraction-free interface with professional discipline
4. **Productivity-Hardened Security** - Professional-grade protection that works invisibly in the background

### Security Architecture

BunkerOS treats security as a **productivity enabler**, not the primary focus. Security features protect workflow integrity automatically without operational burden:

**Automatic Protection**:
- **UFW Firewall**: Default deny incoming, allow outgoing (protects network exposure)
- **AppArmor Containment**: Basic application confinement profiles
- **Package Verification**: Cryptographic signature validation (inherited from Arch Linux)
- **Hardened Kernel**: Security-focused parameters
- **Login Auditing**: Failed authentication logging

**Optional Enhancements**:
- Home directory encryption (installation choice)
- Secure boot configuration
- Automatic security updates

Security works silently in the background—users focus on work, not security administration.

**See [SECURITY.md](SECURITY.md) for comprehensive security documentation.**

## Compositor Architecture

### Vanilla Sway

BunkerOS uses **vanilla Sway** for maximum stability and performance:

#### Configuration
- **Base**: Vanilla Sway from official Arch repositories
- **Memory**: ~280 MB RAM at idle
- **GPU**: Minimal overhead (~2-5% during rendering)
- **Effects**: None - clean, flat design
- **Target**: All hardware (2012+), maximum performance and stability
- **Behavior**: Rock-solid reliability, zero visual artifacts

### Why Vanilla Sway?

**Stability**: Production-ready compositor with years of proven reliability
**Performance**: Minimal resource usage without visual effects overhead
**Compatibility**: Works excellently on all hardware from ThinkPad T480 to modern workstations
**Simplicity**: No effects configuration or GPU-specific tuning required
**Philosophy Alignment**: Function over decoration, operational efficiency over eye candy

### Why Not Hyprland?

Extensive research led to excluding Hyprland:

| Criterion | Sway | Hyprland |
|-----------|------|----------|
| Config Compatibility | Standard | Incompatible syntax |
| RAM Usage | ~280 MB | ~532 MB |
| Stability | Production-ready | Breaking changes common |
| Hardware Range | T480 to modern | Modern hardware only |
| Effects Overhead | None | Always-on effects |
| Visual Artifacts | Zero | Flicker during transitions |

Hyprland prioritizes flashy animations over operational efficiency, contradicting BunkerOS's mission-focused philosophy.

## Theme System Architecture

### Design Goals

1. **Instant Switching**: Change themes without logout
2. **Complete Coverage**: All components themed consistently
3. **Extensibility**: Easy to add new themes

### Components Themed

1. **Sway** - Window borders, focus indicators (`sway-colors.conf`)
2. **Waybar** - Status bar colors and styling (`waybar-style.css`)
3. **Wofi** - Application launcher (`wofi-style.css`)
4. **Mako** - Notification daemon (`mako-config`)
5. **SwayOSD** - Volume/brightness overlays (`swayosd-style.css`)
6. **Foot** - Terminal colors (`foot.ini`)
7. **btop** - System monitor (`btop.theme`)
8. **Bash** - Shell prompt colors (`bashrc-colors`)
9. **dircolors** - File listing colors (`dircolors`)
10. **GTK** - Application theming via CSS

### Theme Switcher Implementation

```
theme-switcher.sh
├── apply_theme()
│   ├── Copy theme files to active configs
│   ├── Apply Sway border colors dynamically (swaymsg client.*)
│   ├── Restart Waybar, Mako, SwayOSD
│   └── Update active theme marker
├── show_theme_menu()
│   └── Wofi interface for theme selection
└── Utility functions (list, current, etc.)
```

**Key Innovation**: Sway border colors are applied using `swaymsg client.focused` commands, eliminating the need for full compositor reload. This preserves workspace state and running applications.

### Adding New Themes

Theme structure:

```
themes/THEME_NAME/
├── theme.conf          # Metadata (name, description, colors)
├── waybar-style.css    # Status bar
├── wofi-style.css      # Launcher
├── sway-colors.conf    # Window borders
├── bashrc-colors       # Shell prompt
├── btop.theme          # System monitor
├── mako-config         # Notifications
├── swayosd-style.css   # OSD
├── foot.ini            # Terminal
└── dircolors           # File listings
```

All files must be present for a theme to work correctly.

## Display Manager Integration

### SDDM Theme

Custom QML theme providing:
- Professional login interface
- Centered design with tactical color palette
- BunkerOS session launcher
- Power management buttons

### Session File

Single `.desktop` file in `/usr/share/wayland-sessions/`:

**bunkeros.desktop**:
```
Exec=/usr/local/bin/launch-bunkeros.sh
```
- Single unified launcher for vanilla Sway
- SDDM remembers session choice across reboots

## Performance Benchmarks

### Memory Usage (Idle, 1920x1080)

### Launch Architecture

BunkerOS uses a single launch script (`launch-bunkeros.sh`) that:
- Sets up Wayland environment variables
- Exports desktop session metadata
- Launches vanilla Sway compositor

The launcher is installed to `/usr/local/bin/` during setup and referenced by the SDDM session file.

### Resource Footprint

| Component | Memory Usage | Notes |
|-----------|--------------|-------|
| Sway Compositor | 180 MB | Vanilla Sway base |
| Waybar | 45 MB | Status bar |
| Mako | 12 MB | Notifications |
| Foot (1 instance) | 25 MB | Terminal |
| **Total System** | **~280 MB** | With 3 terminals open |

### GPU Usage (Intel UHD 620)

| Scenario | Vanilla Sway |
|----------|--------------|
| Idle | 2-5% |
| Window Moving | 10-15% |
| Window Resizing | 15-20% |
| Video Playback | +10% |

### Comparison with Alternatives

| Compositor | RAM (Idle) | GPU (Idle) | Stability | T480 Compatible |
|------------|------------|------------|-----------|----------------|
| **BunkerOS (Vanilla Sway)** | 280 MB | 3% | Excellent | Yes |
| Hyprland | 532 MB | 25% | Good | Marginal |
| GNOME Wayland | 780 MB | 35% | Excellent | No |
| KDE Plasma | 650 MB | 30% | Very Good | Marginal |

## Keybinding Architecture

### Design Principles

1. **Cross-WM Compatibility**: Standard bindings that work in i3, Sway, Hyprland
2. **Vim-like Navigation**: hjkl for directional movement
3. **Logical Grouping**: Related functions on adjacent keys
4. **Discoverability**: Quick Actions menu (Super+m) for all features

### Keybinding Categories

- **Core**: Super+Return (terminal), Super+d (launcher), Super+Shift+q (close)
- **Navigation**: Super+hjkl (focus), Super+Shift+hjkl (move)
- **Workspaces**: Super+1-7 (switch), Super+Shift+1-7 (move window)
- **Tools**: Super+w (overview), Super+m (menu), Super+c (calculator)
- **System**: Super+Shift+e (exit), Super+l (lock)

## Future Roadmap

### Phase 1: Current (Manual Install)
- ✅ Dual compositor support
- ✅ Multi-theme system
- ✅ Complete documentation
- ✅ SDDM integration

### Phase 2: Automated Installer (Q2 2025)
- Interactive installation script
- Dependency checking and resolution
- Backup existing configs automatically
- Post-install validation

### Phase 3: Distribution ISO (Q3 2025)
- Arch-based live ISO
- Graphical installer
- Hardware detection and optimization
- Pre-configured with BunkerOS defaults

### Phase 4: Advanced Features (Q4 2025)
- Workspace templates
- Profile system (work, gaming, development)
- Cloud config sync
- Plugin system for extensions

## Technical Decisions

### Why Waybar Over Alternatives?

- **Performance**: Lighter than Polybar, more features than i3status
- **Wayland Native**: No X11 dependencies
- **CSS Styling**: Powerful theming without recompilation
- **Module System**: Easy to extend

### Why Wofi Over Rofi?

- **Wayland Native**: Rofi requires X11 compatibility layer
- **Maintained**: Active development, regular updates
- **Lightweight**: Minimal dependencies
- **GTK Integration**: Consistent with system theme

### Why Foot Over Alternatives?

- **Performance**: Fastest Wayland terminal (benchmark-proven)
- **Wayland Native**: No X11 emulation overhead
- **Configurability**: INI-based config, easy theming
- **Standards Compliant**: Full xterm compatibility

### Why MATE Calculator?

- **GTK3 Based**: Fully themeable with custom CSS
- **Simple**: No libadwaita restrictions
- **Functional**: Basic + scientific modes
- **Lightweight**: Minimal dependencies

### Browser Strategy: Brave as Default

**Decision**: BunkerOS ships with **Brave** as the default browser, with **Firefox** also installed but not set as default.

#### Rationale

**Web App Feature Compatibility**:
- BunkerOS's Web App Manager (Omarchy-style containerized web apps) provides critical productivity features
- Chromium-based browsers support proper app mode (`--app=URL`) with chrome-less windows
- Firefox's app mode implementation lacks feature parity (no proper window isolation, limited PWA support)
- This ensures the "Install Web App" feature works seamlessly out of the box

**Privacy-First with Better UX**:
- **Brave** provides Chromium's technical advantages without Google telemetry
- Built-in ad blocking and tracker protection (no extensions needed)
- Open source, actively maintained with fast commercial updates
- Privacy-focused by default with optional features (Brave Rewards)
- Polished user experience for non-technical users

**User Flexibility**:
- Firefox remains installed for users who prefer it or don't need containerized web apps
- Users can easily set Firefox as default: `xdg-settings set default-web-browser firefox.desktop`
- Installation scripts support Chrome, Chromium, Ungoogled Chromium, and other browsers if users prefer alternatives

#### Technical Advantages of Chromium for Web Apps

| Feature | Chromium-based | Firefox |
|---------|----------------|---------|
| App Mode Window Isolation | Excellent | Limited |
| Custom Window Titles | Full support | Partial |
| Profile Separation | Complete | Shared context |
| PWA Installation | Native | Addon required |
| Wayland Screen Sharing | Excellent (with flags) | Good |
| Integration with Sway | Perfect tiling | Works well |

#### User Choice Philosophy

BunkerOS prioritizes **productivity features that work seamlessly out of the box** while respecting user choice:

1. **Default**: Brave (privacy + features + polished UX)
2. **Included**: Firefox (alternative for users who don't need web apps)
3. **Optional**: Chrome, Chromium, Ungoogled Chromium (user can install via package manager)
4. **Documented**: Clear instructions for changing defaults in README.md

Users who value Firefox's independent engine, Mozilla's privacy focus, or container tabs can easily switch, understanding they'll lose containerized web app functionality. Users who need containerized web apps benefit from seamless functionality immediately.

#### Package Information

- **Default Browser**: `brave-bin` (AUR package)
- **Secondary Browser**: `firefox` (official repositories)
- **XDG Default Setting**: `xdg-settings set default-web-browser brave-browser.desktop`

This decision aligns with BunkerOS's philosophy: **productivity-focused defaults with full user control**.

## Project Structure Philosophy

### Modular Configuration

Each component has isolated config:
```
component/
├── config              # Main config
├── style.css           # Styling (if applicable)
└── scripts/            # Component-specific scripts
```

### Theme Modularity

Themes are self-contained directories with all required files. No cross-theme dependencies.

### Script Organization

Scripts are organized by function:
- `waybar/scripts/` - Bar modules and menus
- `scripts/` - System-wide utilities (theme-switcher)
- `webapp/bin/` - Web app management tools

### Documentation Structure

- `README.md` - User-facing features and usage
- `INSTALL.md` - Step-by-step installation
- `ARCHITECTURE.md` - Technical design (this file)
- Component READMEs - Specific feature documentation

## Contribution Guidelines

### Adding Features

1. Maintain Sway compatibility
2. Theme all visual components (5+ themes)
3. Document in appropriate README section
4. Test on both old (T480) and modern hardware

### Adding Themes

1. Include all 10 required config files
2. Maintain tactical aesthetic
3. Ensure good contrast (WCAG AA minimum)
4. Test with all components (Waybar, Wofi, terminal, etc.)
5. Document color palette in `theme.conf`

### Code Style

- Shell scripts: ShellCheck compliant
- CSS: Organized by component
- Comments: Explain why, not what
- Naming: Descriptive, lowercase with hyphens

## Research References

This architecture was informed by:
- Performance benchmarks across vanilla Sway and Hyprland
- User experience reports from T480 and modern hardware users
- Configuration compatibility testing
- Stability analysis of compositor update histories
- Memory profiling across different setups

## Contact and Support

- GitHub: https://github.com/forge-55/bunkeros
- Issues: https://github.com/forge-55/bunkeros/issues
- Discussions: https://github.com/forge-55/bunkeros/discussions

