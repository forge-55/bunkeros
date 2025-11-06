# BunkerOS

A custom Sway setup for Arch Linux.

BunkerOS delivers a distraction-free, keyboard-driven environment powered by Sway with intelligent autotiling, tactical theming, and professional-grade tools for mission-focused computing.

Read more at [bunkeros.com](https://bunkeros.com).

## What is BunkerOS?

BunkerOS is a configuration layer for Arch Linux that provides a productivity-focused Sway desktop environment. Rather than being a standalone distribution, BunkerOS is installed on top of your existing Arch Linux (or Arch-based) system.

### How It Works

1. You install vanilla Arch Linux or an Arch-based distribution (like CachyOS, EndeavourOS, etc.)
2. You run the BunkerOS installation scripts
3. BunkerOS symlinks its configurations to your system (visible in the git repo)
4. You get a complete Sway environment with curated productivity tools
5. You keep full control - standard Arch tools and workflows still apply

### Philosophy: Transparent Configuration

- **Symlinked configs** - All configuration files link back to this git repository
- **Standard packaging** - Uses pacman and yay exclusively (no custom package managers)
- **Auditable changes** - See exactly what BunkerOS modifies in your system
- **Easy updates** - Simple git pull to get latest configurations
- **Reversible** - Remove symlinks to return to vanilla Arch

This approach maintains Arch's transparency and flexibility while providing a polished, keyboard-driven desktop environment.

## Installation

### Quick Start: archinstall Profile

The fastest way to get BunkerOS up and running:

```bash
# Boot Arch Linux ISO
curl -fsSL https://raw.githubusercontent.com/forge-55/bunkeros/main/archinstall/install-bunkeros.sh | bash
```

This automates the entire process: Arch Linux installation + BunkerOS configuration.

See [archinstall/README.md](archinstall/README.md) for details.

### Manual Installation

If you already have Arch Linux installed, or prefer to install Arch manually first:

**Requirements:** Minimal Arch Linux installation (no DE/WM installed)

```bash
git clone https://github.com/forge-55/bunkeros.git
cd bunkeros
./install.sh
```

Reboot and select "BunkerOS" at login.

See [INSTALL.md](INSTALL.md) for detailed instructions. This approach gives you deeper understanding of how BunkerOS works and how Arch Linux is configured.

## Features

- Sway with intelligent autotiling
- 5 custom themes (Tactical, Night-Ops, Sahara, Abyss, Winter)
- Adaptive display scaling for HiDPI
- Multi-monitor support (1-5 displays)
- MacBook-quality touchpad support (tap-to-click, gestures)
- Web app manager
- Interactive keybinding manager
- Video conferencing ready
- Lightweight and efficient resource usage

## Documentation

- [INSTALL.md](INSTALL.md) - Installation guide
- [QUICKREF.md](QUICKREF.md) - Keyboard shortcuts
- [docs/](docs/) - Full documentation

## License

BunkerOS is released under the [MIT License](LICENSE).