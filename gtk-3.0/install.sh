#!/usr/bin/env bash

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Installing GTK 3.0 tactical theme configuration..."

mkdir -p ~/.config/gtk-3.0

if [ -f ~/.config/gtk-3.0/settings.ini ] && [ ! -L ~/.config/gtk-3.0/settings.ini ]; then
    echo "Backing up existing settings.ini..."
    mv ~/.config/gtk-3.0/settings.ini ~/.config/gtk-3.0/settings.ini.backup
fi

if [ -f ~/.config/gtk-3.0/gtk.css ] && [ ! -L ~/.config/gtk-3.0/gtk.css ]; then
    echo "Backing up existing gtk.css..."
    mv ~/.config/gtk-3.0/gtk.css ~/.config/gtk-3.0/gtk.css.backup
fi

ln -sf "$PROJECT_DIR/gtk-3.0/settings.ini" ~/.config/gtk-3.0/settings.ini
ln -sf "$PROJECT_DIR/gtk-3.0/gtk.css" ~/.config/gtk-3.0/gtk.css

echo "GTK 3.0 tactical theme installed!"
echo ""
echo "Restart GTK applications to see the changes."

