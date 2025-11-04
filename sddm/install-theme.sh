#!/usr/bin/env bash

set -e  # Exit on error

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEME_DIR="/usr/share/sddm/themes/tactical"
SOURCE_DIR="$PROJECT_DIR/sddm/tactical"
SESSION_DIR="/usr/share/wayland-sessions"
SESSION_SOURCE="$PROJECT_DIR/sddm/sessions"

echo "=== BunkerOS SDDM Installation ==="
echo ""

# Check if we have sudo access
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo access. Please authenticate:"
    if ! sudo true; then
        echo "ERROR: Failed to get sudo access"
        exit 1
    fi
fi

# Verify source files exist
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: SDDM theme source directory not found: $SOURCE_DIR"
    exit 1
fi

if [ ! -f "$SESSION_SOURCE/bunkeros.desktop" ]; then
    echo "ERROR: BunkerOS session file not found: $SESSION_SOURCE/bunkeros.desktop"
    exit 1
fi

echo "Checking compositor installations..."
if ! command -v sway &> /dev/null; then
    echo "WARNING: sway not found. Install with: sudo pacman -S sway"
fi

echo ""
echo "Installing BunkerOS SDDM theme..."
if sudo mkdir -p "$THEME_DIR" && sudo cp -r "$SOURCE_DIR"/* "$THEME_DIR/"; then
    echo "  ✓ Theme files installed to $THEME_DIR"
else
    echo "  ERROR: Failed to install theme files"
    exit 1
fi

echo ""
echo "Installing BunkerOS session files..."
if sudo mkdir -p "$SESSION_DIR"; then
    echo "  Installing main BunkerOS session..."
    if sudo cp "$SESSION_SOURCE/bunkeros.desktop" "$SESSION_DIR/"; then
        echo "  ✓ BunkerOS session installed"
    else
        echo "  ERROR: Failed to install BunkerOS session"
        exit 1
    fi
    
    echo "  Installing emergency recovery session..."
    if sudo cp "$SESSION_SOURCE/bunkeros-recovery.desktop" "$SESSION_DIR/"; then
        echo "  ✓ Emergency recovery session installed"
    else
        echo "  WARNING: Failed to install emergency recovery session (non-critical)"
    fi
else
    echo "  ERROR: Failed to create session directory"
    exit 1
fi

echo ""
echo "Installing launch scripts to /usr/local/bin..."

echo "  Installing BunkerOS launch script..."
if sudo cp "$PROJECT_DIR/scripts/launch-bunkeros.sh" /usr/local/bin/ && \
   sudo chmod +x /usr/local/bin/launch-bunkeros.sh; then
    echo "  ✓ Launch script installed"
else
    echo "  ERROR: Failed to install launch script"
    exit 1
fi

echo "  Installing emergency recovery script..."
if sudo cp "$PROJECT_DIR/scripts/launch-bunkeros-emergency.sh" /usr/local/bin/ && \
   sudo chmod +x /usr/local/bin/launch-bunkeros-emergency.sh; then
    echo "  ✓ Emergency recovery script installed"
else
    echo "  WARNING: Failed to install emergency recovery script (non-critical)"
fi

echo ""
echo "Configuring SDDM theme..."
if [ ! -f /etc/sddm.conf ]; then
    echo "  Creating /etc/sddm.conf..."
    if echo -e "[Theme]\nCurrent=tactical" | sudo tee /etc/sddm.conf > /dev/null; then
        echo "  ✓ SDDM configuration created"
    else
        echo "  ERROR: Failed to create SDDM configuration"
        exit 1
    fi
else
    if ! grep -q "^\[Theme\]" /etc/sddm.conf; then
        echo "  Adding theme configuration..."
        if echo -e "\n[Theme]\nCurrent=tactical" | sudo tee -a /etc/sddm.conf > /dev/null; then
            echo "  ✓ Theme configuration added"
        else
            echo "  ERROR: Failed to add theme configuration"
            exit 1
        fi
    else
        echo "  Updating theme configuration..."
        # Update or add Current= line in Theme section
        if sudo sed -i '/^\[Theme\]/,/^\[/{s/^Current=.*/Current=tactical/}' /etc/sddm.conf; then
            # If Current= doesn't exist in Theme section, add it
            if ! grep -A 5 "^\[Theme\]" /etc/sddm.conf | grep -q "^Current="; then
                sudo sed -i '/^\[Theme\]/a Current=tactical' /etc/sddm.conf
            fi
            echo "  ✓ Theme configuration updated"
        else
            echo "  WARNING: Failed to update theme configuration (SDDM may use default theme)"
        fi
    fi
fi

echo ""
echo "=== BunkerOS SDDM Installation Complete! ==="
echo ""
echo "Available sessions at login:"
echo "  - BunkerOS              - Full desktop environment"
echo "  - BunkerOS Emergency    - Recovery terminal (for troubleshooting)"
echo ""
echo "✓ Installation successful"
echo ""
echo "Note: SDDM service should already be enabled by the main installer."
echo "The themed login screen will appear on next reboot or when SDDM starts."
echo ""

