#!/bin/bash
# Install Chrome/Chromium configuration for BunkerOS

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "Installing Chrome/Chromium configuration for BunkerOS..."

# Ensure .config directory exists
mkdir -p "$CONFIG_DIR"

# Clean up any existing directories that were created by mistake
for flag_file in chrome-flags.conf chromium-flags.conf brave-flags.conf; do
    if [ -d "$CONFIG_DIR/$flag_file" ]; then
        echo "⚠️  Removing directory $CONFIG_DIR/$flag_file (should be a file)"
        rm -rf "$CONFIG_DIR/$flag_file"
    fi
done

# Chrome/Chromium reads flags from these files
# One flag per line, NO comments or # symbols

# Google Chrome - use chrome-flags.conf
cat > "$CONFIG_DIR/chrome-flags.conf" << 'EOF'
--disable-features=WebUITabStrip,ChromeRefresh2023
--force-dark-mode
--enable-features=WebUIDarkMode
--ozone-platform-hint=auto
--gtk-version=4
EOF

echo "✓ Created $CONFIG_DIR/chrome-flags.conf"

# Chromium - use chromium-flags.conf
cat > "$CONFIG_DIR/chromium-flags.conf" << 'EOF'
--disable-features=WebUITabStrip,ChromeRefresh2023
--force-dark-mode
--enable-features=WebUIDarkMode
--ozone-platform-hint=auto
--gtk-version=4
EOF

echo "✓ Created $CONFIG_DIR/chromium-flags.conf"

# Brave Browser (native package)
cat > "$CONFIG_DIR/brave-flags.conf" << 'EOF'
--disable-features=WebUITabStrip,ChromeRefresh2023
--force-dark-mode
--enable-features=WebUIDarkMode
--ozone-platform-hint=auto
--gtk-version=4
EOF

echo "✓ Created $CONFIG_DIR/brave-flags.conf"

# Brave Browser (Flatpak) - different location
if command -v flatpak &> /dev/null && flatpak list | grep -q com.brave.Browser; then
    BRAVE_FLATPAK_CONFIG="$HOME/.var/app/com.brave.Browser/config"
    mkdir -p "$BRAVE_FLATPAK_CONFIG"
    
    # Clean up directory if it was created by mistake
    if [ -d "$BRAVE_FLATPAK_CONFIG/brave-flags.conf" ]; then
        rm -rf "$BRAVE_FLATPAK_CONFIG/brave-flags.conf"
    fi
    
    cat > "$BRAVE_FLATPAK_CONFIG/brave-flags.conf" << 'EOF'
--disable-features=WebUITabStrip,ChromeRefresh2023
--force-dark-mode
--enable-features=WebUIDarkMode
--ozone-platform-hint=auto
--gtk-version=4
EOF
    
    echo "✓ Created $BRAVE_FLATPAK_CONFIG/brave-flags.conf (Flatpak)"
fi

echo ""
echo "✓ Chrome/Chromium flags installed successfully!"
echo ""
echo "⚠️  IMPORTANT - How to apply the changes:"
echo "1. Completely QUIT your browser (Ctrl+Q or File → Quit)"
echo "2. Make sure the process is fully closed: killall chrome chromium brave"
echo "3. Restart your browser"
echo "4. Verify flags are loaded: chrome://version (check 'Command Line')"
echo ""
echo "The flags disable rounded corners (ChromeRefresh2023) and enable dark mode."
