#!/bin/bash
# BunkerOS Emergency Recovery Terminal
# This launches a minimal Sway session with just a fullscreen terminal
# Perfect for troubleshooting and running setup.sh

# Set Wayland environment
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway

# Wayland-specific variables
export WAYLAND_DISPLAY=wayland-1
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export MOZ_ENABLE_WAYLAND=1
export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland
export ELECTRON_OZONE_PLATFORM_HINT=auto

# Create minimal Sway config for emergency mode
EMERGENCY_CONFIG="/tmp/sway-emergency-$USER.conf"

cat > "$EMERGENCY_CONFIG" << 'EOF'
# BunkerOS Emergency Recovery Mode
# Minimal Sway config with just a terminal

# Set mod key
set $mod Mod4

# Start foot terminal in fullscreen on startup
exec foot --title="BunkerOS Emergency Terminal"

# Make the emergency terminal fullscreen and focused
for_window [title="BunkerOS Emergency Terminal"] {
    fullscreen enable
    focus
}

# Basic keybindings for emergency mode
bindsym $mod+Return exec foot
bindsym $mod+t exec foot
bindsym $mod+q kill
bindsym $mod+Shift+e exit

# Window management
bindsym $mod+$left focus left
bindsym $mod+$down focus down
bindsym $mod+$up focus up
bindsym $mod+$right focus right

# Home row direction keys
set $left h
set $down j
set $up k
set $right l

# Show a message on the bar
bar {
    position top
    status_command while echo "🚨 EMERGENCY MODE - Press Mod+Shift+E to exit | Mod+T for new terminal"; do sleep 1; done
    colors {
        statusline #ffffff
        background #cc0000
    }
}

# Startup message
exec foot --title="Emergency Instructions" -e sh -c 'cat << "EMERGENCY"
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║           BunkerOS Emergency Recovery Mode                 ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

You are in EMERGENCY MODE with a minimal Sway configuration.

COMMON FIXES:

1. Run BunkerOS Setup:
   cd ~/Projects/bunkeros
   ./setup.sh

2. Create defaults manually:
   mkdir -p ~/.config/bunkeros
   cp ~/Projects/bunkeros/bunkeros/defaults.conf ~/.config/bunkeros/

3. Check if Sway config is valid:
   sway --validate ~/.config/sway/config

KEYBINDINGS IN EMERGENCY MODE:

  Super+T          - Open new terminal
  Super+Return     - Open new terminal  
  Super+Q          - Close window
  Super+Shift+E    - Exit emergency mode (logout)

After fixing issues:
  1. Press Super+Shift+E to logout
  2. Select "BunkerOS" (not Emergency) at login screen
  3. Login normally - should work now!

Press Enter to continue to terminal...
EMERGENCY
read
clear
exec bash'
EOF

# Launch Sway with emergency config
exec sway -c "$EMERGENCY_CONFIG"
