#FEATURES
1. Second private repository for specific apps apps and keybindings, with helper script in menu
2. ✅ COMPLETED: Comprehensive performance optimization (Pop!_OS parity achieved)
   - GPU power management (Intel/AMD/Nvidia)
   - I/O scheduler optimization (NVMe/SSD/HDD)
   - Kernel parameter tuning (sysctl)
   - Network stack optimization (TCP BBR)
   - See: docs/features/power-optimization.md
3. ✅ COMPLETED: Tmux terminal multiplexer integration (default installation)
   - Productivity-focused configuration with Ctrl+a prefix
   - Mouse support and intuitive keybindings
   - BunkerOS tactical theme integration
   - Automatic installation with default configuration
   - See: tmux/README.md
4. Future: Per-application power profiles (auto-switch based on running apps)

#IMPROVEMENTS
1. Better structure to project directories
2. Multi-monitor support (Pop!_OS/Fedora/Ubuntu quality). Current experience is terrible.
#DESIGN
1. Improve wallpaper and design of all themes, with better color and brightness. Maybe opting for abstract style.
2. ✅ Improve battery indicator of T480 to account for second external battery life

#BUG FIXES
1. Screensaver and suspend logic
2. Autoscaling for different resolutions
3. All configuration working in a fresh install
4. Arch Linux logo visible on boot