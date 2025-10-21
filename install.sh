#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cat << "EOF"
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║                    BunkerOS Installer                      ║
║                                                            ║
║      Productivity-hardened Arch Linux environment          ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
EOF

echo ""
echo "This will install BunkerOS on top of your CachyOS/Arch base system."
echo ""
echo "Installation directory: $SCRIPT_DIR"
echo ""
echo "What will be installed:"
echo "  • Sway/SwayFX compositor and dependencies"
echo "  • Waybar, Wofi, Mako, Foot terminal, and other tools"
echo "  • BunkerOS configurations (symlinked to this repo)"
echo "  • SDDM login theme and session files"
echo "  • GTK themes and application defaults"
echo "  • Audio/video support (PipeWire)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Continue with installation? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Installation cancelled."
    exit 0
fi

# Stage 1: Dependencies
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Stage 1/4: Installing Dependencies                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
"$SCRIPT_DIR/scripts/install-dependencies.sh"

# Stage 2: Configuration
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Stage 2/4: Setting Up Configuration                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
"$SCRIPT_DIR/setup.sh"

# Stage 3: System Services
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Stage 3/4: Installing System Services                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
"$SCRIPT_DIR/scripts/install-system-services.sh"

# Stage 4: User Environment
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Stage 4/4: Configuring User Environment                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
"$SCRIPT_DIR/scripts/install-user-environment.sh"

# Done!
cat << "EOF"

╔════════════════════════════════════════════════════════════╗
║                                                            ║
║           BunkerOS Installation Complete! ✓                ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

Next steps:

1. Reboot your system:
   $ reboot

2. At the login screen, select one of the BunkerOS sessions:
   • BunkerOS (Standard)  - Optimized for older hardware
   • BunkerOS (Enhanced)  - Full visual effects for modern hardware

3. Start being productive!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

To update BunkerOS in the future:
   $ cd $SCRIPT_DIR
   $ git pull
   # Changes take effect immediately (configs are symlinked)

To switch themes:
   • Press Super+Shift+T (theme switcher)
   • Or: Super+M → Appearance → Theme

Need help? Check the documentation:
   • README.md - Overview and features
   • INSTALL.md - Installation guide
   • FAQ.md - Frequently asked questions
   • ARCHITECTURE.md - Technical details

Enjoy your tactical computing environment! 🎯

EOF
