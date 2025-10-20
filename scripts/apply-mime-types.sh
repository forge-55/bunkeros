#!/bin/bash
# Apply BunkerOS MIME Type Associations
# Can be run independently or as part of setup.sh

echo "Configuring default applications..."

# Set default image viewer to Eye of GNOME
xdg-mime default org.gnome.eog.desktop image/png 2>/dev/null || true
xdg-mime default org.gnome.eog.desktop image/jpeg 2>/dev/null || true
xdg-mime default org.gnome.eog.desktop image/jpg 2>/dev/null || true
xdg-mime default org.gnome.eog.desktop image/gif 2>/dev/null || true
xdg-mime default org.gnome.eog.desktop image/webp 2>/dev/null || true
xdg-mime default org.gnome.eog.desktop image/svg+xml 2>/dev/null || true

# Set default PDF viewer to Evince
xdg-mime default org.gnome.Evince.desktop application/pdf 2>/dev/null || true

# Set default text editor to VS Code
xdg-mime default code.desktop text/plain 2>/dev/null || true
xdg-mime default code.desktop text/x-readme 2>/dev/null || true
xdg-mime default code.desktop text/markdown 2>/dev/null || true
xdg-mime default code.desktop text/x-markdown 2>/dev/null || true

# Set default code file handlers to VS Code
xdg-mime default code.desktop text/x-python 2>/dev/null || true
xdg-mime default code.desktop text/x-shellscript 2>/dev/null || true
xdg-mime default code.desktop text/x-script.python 2>/dev/null || true
xdg-mime default code.desktop application/x-shellscript 2>/dev/null || true
xdg-mime default code.desktop application/javascript 2>/dev/null || true
xdg-mime default code.desktop application/json 2>/dev/null || true
xdg-mime default code.desktop application/x-yaml 2>/dev/null || true
xdg-mime default code.desktop text/html 2>/dev/null || true
xdg-mime default code.desktop text/css 2>/dev/null || true

# Set default archive manager to file-roller (if installed)
xdg-mime default org.gnome.FileRoller.desktop application/zip 2>/dev/null || true
xdg-mime default org.gnome.FileRoller.desktop application/x-tar 2>/dev/null || true
xdg-mime default org.gnome.FileRoller.desktop application/x-compressed-tar 2>/dev/null || true
xdg-mime default org.gnome.FileRoller.desktop application/x-bzip-compressed-tar 2>/dev/null || true
xdg-mime default org.gnome.FileRoller.desktop application/x-xz-compressed-tar 2>/dev/null || true
xdg-mime default org.gnome.FileRoller.desktop application/x-7z-compressed 2>/dev/null || true
xdg-mime default org.gnome.FileRoller.desktop application/x-rar 2>/dev/null || true
xdg-mime default org.gnome.FileRoller.desktop application/gzip 2>/dev/null || true

# Set default file manager to Nautilus
xdg-mime default org.gnome.Nautilus.desktop inode/directory 2>/dev/null || true
xdg-mime default org.gnome.Nautilus.desktop x-directory/normal 2>/dev/null || true

echo "✓ Default applications configured:"
echo "  • Images → Eye of GNOME (eog)"
echo "  • PDFs → Evince"
echo "  • Text/Code → VS Code"
echo "  • Archives → File Roller"
echo "  • Directories → Nautilus"
echo ""
echo "Run 'bash scripts/verify-mime-types.sh' to verify configuration"
