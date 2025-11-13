#!/bin/bash
# Install missing BunkerOS menu tools
# Run this after a fresh BunkerOS installation to enable all menu features

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  BunkerOS Missing Tools Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This script will install recommended tools for BunkerOS menu features."
echo ""

# List of packages to install
PACKAGES=()

# Check for fzf (required for package installers)
if ! command -v fzf &> /dev/null; then
    echo "❌ fzf not found (required for Arch/AUR package installers)"
    PACKAGES+=("fzf")
else
    echo "✅ fzf already installed"
fi

# Check for audio mixer
if ! command -v pulsemixer &> /dev/null && ! command -v pavucontrol &> /dev/null; then
    echo "❌ No audio mixer found"
    PACKAGES+=("pulsemixer")
elif command -v pavucontrol &> /dev/null; then
    echo "✅ pavucontrol already installed (audio mixer)"
else
    echo "✅ pulsemixer already installed (audio mixer)"
fi

# Check for display manager
if ! command -v wdisplays &> /dev/null && ! command -v wlr-randr &> /dev/null; then
    echo "❌ No display manager found"
    PACKAGES+=("wdisplays")
elif command -v wdisplays &> /dev/null; then
    echo "✅ wdisplays already installed (display manager)"
else
    echo "✅ wlr-randr already installed (display manager)"
fi

echo ""

if [ ${#PACKAGES[@]} -eq 0 ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  ✅ All recommended tools already installed!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    exit 0
fi

echo "The following packages will be installed:"
for pkg in "${PACKAGES[@]}"; do
    echo "  • $pkg"
done

echo ""
read -p "Continue with installation? [Y/n] " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ ! -z $REPLY ]]; then
    echo "Installation cancelled."
    exit 0
fi

echo ""
echo "Installing packages..."
sudo pacman -S --needed "${PACKAGES[@]}"

if [ $? -eq 0 ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  ✅ All packages installed successfully!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "All BunkerOS menu features should now work correctly."
else
    echo ""
    echo "❌ Installation failed. Please check the errors above."
    exit 1
fi
