#!/usr/bin/env bash

THEME_DIR="/usr/share/sddm/themes/tactical"
SOURCE_DIR="/home/ryan/Projects/sway-config/sddm/tactical"

echo "Installing Tactical SDDM theme..."

sudo mkdir -p "$THEME_DIR"
sudo cp -r "$SOURCE_DIR"/* "$THEME_DIR/"

if [ ! -f /etc/sddm.conf ]; then
    echo "Creating /etc/sddm.conf..."
    sudo touch /etc/sddm.conf
fi

if ! grep -q "^\[Theme\]" /etc/sddm.conf; then
    echo "Adding theme configuration..."
    echo "" | sudo tee -a /etc/sddm.conf > /dev/null
    echo "[Theme]" | sudo tee -a /etc/sddm.conf > /dev/null
    echo "Current=tactical" | sudo tee -a /etc/sddm.conf > /dev/null
else
    echo "Updating theme configuration..."
    sudo sed -i 's/^Current=.*/Current=tactical/' /etc/sddm.conf
fi

echo ""
echo "Tactical SDDM theme installed successfully!"
echo ""
echo "To enable SDDM as your display manager:"
echo "  sudo systemctl enable sddm.service"
echo "  sudo systemctl start sddm.service"
echo ""
echo "To preview the theme (test mode):"
echo "  sddm-greeter --test-mode --theme /usr/share/sddm/themes/tactical"
echo ""

