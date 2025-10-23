# Nautilus File Manager Integration

BunkerOS uses **Nautilus** (GNOME Files) as its default file manager, providing a modern, user-friendly graphical interface while maintaining the tactical aesthetic through custom GTK4 theming.

## Why Nautilus?

After evaluating several file managers (Thunar, lf, Yazi), Nautilus emerged as the ideal choice:

- **Modern & User-Friendly**: Provides an intuitive GUI experience for all users
- **Lightweight**: Despite GNOME origins, runs efficiently (~14 MiB memory footprint)
- **Native Wayland**: Full support for Wayland protocol in Sway
- **Libadwaita Integration**: Modern GTK4/libadwaita stack with dark mode support
- **Extensible**: Plugin architecture for previews, integrations, and extensions
- **Well-Maintained**: Active development by GNOME project

## Nautilus Ecosystem

BunkerOS includes a complete file management ecosystem:

### 1. **GNOME Sushi** (File Previewer)
- **Package**: `sushi`
- **Usage**: Select a file and press **Spacebar** to preview
- **Features**:
  - Image previews (JPG, PNG, SVG, WebP, etc.)
  - PDF and document previews
  - Text files with syntax highlighting
  - Audio/video playback via GStreamer
  - Fonts and vector graphics
- **Integration**: DBus-activated, works seamlessly in Sway
- **Style**: Lightweight pop-up overlay (macOS Quick Look-like)

### 2. **Eye of GNOME (eog)** (Image Viewer)
- **Package**: `eog`
- **Usage**: Double-click any image to open
- **Formats**: JPG, PNG, GIF, TIFF, BMP, WebP, SVG, and more
- **Features**:
  - Fast, lightweight image viewer
  - Native Wayland rendering
  - Dark mode compatible
  - Slideshow mode
  - Basic image operations (rotate, zoom)
- **Integration**: Default handler for image files in Nautilus

### 3. **Evince** (Document Viewer)
- **Package**: `evince`
- **Usage**: Double-click any PDF/document to open
- **Formats**: PDF, PostScript, DjVu, XPS, TIFF, DVI, comic archives (CBR, CBZ)
- **Features**:
  - Annotations and bookmarks
  - Full-text search
  - Encrypted PDF support
  - Presentation mode
  - Native Wayland support
  - Dark mode compatible
- **Integration**:
  - Default handler for PDF files
  - Optional Nautilus plugin (`nautilus-evince`) for PDF thumbnails
  - Sushi integration for spacebar preview

## Installation

All packages are installed automatically by the BunkerOS setup:

```bash
sudo pacman -S nautilus sushi eog evince
```

### Default Application Configuration

BunkerOS automatically sets comprehensive MIME type associations during setup (`setup.sh` Step 12.6) to prevent the "double-click does nothing" bug that affects some Linux distributions:

```bash
# Images → Eye of GNOME (eog)
xdg-mime default org.gnome.eog.desktop image/png
xdg-mime default org.gnome.eog.desktop image/jpeg
xdg-mime default org.gnome.eog.desktop image/jpg
xdg-mime default org.gnome.eog.desktop image/gif
xdg-mime default org.gnome.eog.desktop image/webp
xdg-mime default org.gnome.eog.desktop image/svg+xml

# PDFs → Evince
xdg-mime default org.gnome.Evince.desktop application/pdf

# Text files → VS Code
xdg-mime default code.desktop text/plain
xdg-mime default code.desktop text/markdown
xdg-mime default code.desktop text/x-readme

# Code files → VS Code
xdg-mime default code.desktop text/x-python
xdg-mime default code.desktop text/x-shellscript
xdg-mime default code.desktop application/javascript
xdg-mime default code.desktop application/json
xdg-mime default code.desktop text/html
xdg-mime default code.desktop text/css

# Archives → File Roller
xdg-mime default org.gnome.FileRoller.desktop application/zip
xdg-mime default org.gnome.FileRoller.desktop application/x-tar
xdg-mime default org.gnome.FileRoller.desktop application/x-compressed-tar
```

To verify your configuration:
```bash
xdg-mime query default image/png          # Should output: org.gnome.eog.desktop
xdg-mime query default application/pdf    # Should output: org.gnome.Evince.desktop
xdg-mime query default text/plain         # Should output: code.desktop
xdg-mime query default application/zip    # Should output: org.gnome.FileRoller.desktop
```

## Theming

Nautilus is styled to match the BunkerOS tactical aesthetic through custom GTK4 CSS (`gtk-4.0/gtk.css`):

### Color Palette
- **Background**: `#1C1C1C` (dark tactical base)
- **Sidebar**: `#2B2D2E` (slightly lighter)
- **Accent**: `#C3B091` (tactical gold)
- **Selection**: `rgba(107, 122, 84, 0.25)` (tactical green, subtle)
- **Borders**: `#3C4A2F` (dark tactical green)

### Theme Features
- Dark backgrounds throughout (no white sidebars)
- Minimal borders and visual clutter
- Subtle selection highlights
- Tactical color accents on buttons and headers
- Consistent with Waybar, Wofi, and other BunkerOS components

### Dark Mode Configuration

BunkerOS sets the proper dark theme preference for libadwaita applications:

```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

This is applied automatically during setup (`setup.sh` Step 12.5).

## Keybindings

### File Manager
- **Super+f**: Open Nautilus file manager
- **Super+q**: Close Nautilus window

### Within Nautilus
- **Spacebar**: Quick preview (via Sushi)
- **Ctrl+h**: Toggle hidden files
- **Ctrl+l**: Show location bar (type path)
- **Ctrl+t**: New tab
- **Ctrl+w**: Close tab
- **Alt+Up**: Navigate to parent directory
- **Alt+Left/Right**: Navigate back/forward
- **F2**: Rename file
- **Delete**: Move to trash
- **Shift+Delete**: Permanently delete

## File Operations

### Quick Preview (Sushi)
1. Navigate to any folder in Nautilus
2. Select a file (images, PDFs, text, etc.)
3. Press **Spacebar**
4. Preview appears as an overlay
5. Press **Spacebar** or **Escape** to close

### Open in Viewer
- **Images**: Double-click → Opens in Eye of GNOME (eog)
- **PDFs**: Double-click → Opens in Evince
- **Text**: Double-click → Opens in default text editor
- **Archives**: Right-click → Extract here

## Extensions (Optional)

Additional Nautilus extensions can enhance functionality:

```bash
# File compression/extraction in context menu
sudo pacman -S file-roller

# Archive manager integration
sudo pacman -S nautilus-archive-integration

# Image tools (resize, rotate) in context menu
sudo pacman -S nautilus-image-converter
```

**Note**: Extensions are optional and not required for core BunkerOS functionality.

## Troubleshooting

### Nautilus shows white sidebar
**Solution**: Ensure dark theme preference is set:
```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
pkill nautilus
nautilus &
```

### GTK theme not applied
**Solution**: Verify GTK4 config symlinks:
```bash
ls -la ~/.config/gtk-4.0/
# Should show symlinks to ~/Projects/bunkeros/gtk-4.0/
```

### Sushi preview not working
**Solution**: Ensure Sushi is installed and DBus is running:
```bash
sudo pacman -S sushi
# Restart Nautilus
pkill nautilus && nautilus &
```

### Images/PDFs/files open in wrong application (e.g., in web browser)
**Cause**: MIME type associations not configured.

**Solution**: Set default applications:
```bash
# Fix images opening in browser instead of eog
xdg-mime default org.gnome.eog.desktop image/png
xdg-mime default org.gnome.eog.desktop image/jpeg
xdg-mime default org.gnome.eog.desktop image/gif
xdg-mime default org.gnome.eog.desktop image/webp

# Fix PDFs opening in browser instead of evince
xdg-mime default org.gnome.Evince.desktop application/pdf

# Fix text files opening in wrong application
xdg-mime default code.desktop text/plain
xdg-mime default code.desktop text/markdown

# Fix code files
xdg-mime default code.desktop text/x-python
xdg-mime default code.desktop text/x-shellscript
xdg-mime default code.desktop application/javascript

# Fix archives
xdg-mime default org.gnome.FileRoller.desktop application/zip
xdg-mime default org.gnome.FileRoller.desktop application/x-tar
```

Verify the fix:
```bash
xdg-mime query default image/png      # Should show: org.gnome.eog.desktop
xdg-mime query default text/plain     # Should show: code.desktop
xdg-mime query default application/zip # Should show: org.gnome.FileRoller.desktop
```

### Double-clicking files does nothing
**Cause**: No default application set for that file type (system-wide MIME association issue).

**Solution**: This is prevented by BunkerOS's comprehensive MIME type configuration in `setup.sh`. If you encounter this for a specific file type:
```bash
# Find the MIME type
xdg-mime query filetype yourfile.ext

# Set a default application
xdg-mime default <application>.desktop <mime/type>
```

## Philosophy

Nautilus represents a balance between BunkerOS's tactical, efficiency-focused design and user accessibility:

- **Productivity First**: A well-designed GUI file manager enhances productivity
- **User-Friendly**: Not everyone prefers terminal-based file managers
- **Resource Conscious**: Nautilus is surprisingly lightweight for its feature set
- **Professional**: A polished file manager reflects the professional ethos of BunkerOS
- **Inclusive**: Accessible to newcomers without sacrificing power-user features

BunkerOS is not about being "terminal-only" or "hardcore" for the sake of it. It's about creating a focused, efficient, and enjoyable computing environment that respects both beginners and seasoned users.

## Performance

Typical resource usage on idle:
- **Memory**: ~13-15 MiB
- **CPU**: <1% (when idle)
- **Startup**: <1 second on modern hardware

This is comparable to or better than many "lightweight" file managers when considering the full feature set.

## Future Enhancements

Potential future additions:
- Custom Nautilus toolbar theme (minimize buttons, simplify layout)
- Integration with BunkerOS theme switcher (automatic color updates)
- Custom action scripts in context menu (compress, encrypt, etc.)
- Automated setup for common MIME types and default applications

---

**Quick Reference**:
- Launch: `Super+f` or `nautilus`
- Preview: Select file, press `Spacebar`
- Image viewer: `eog filename.jpg`
- PDF viewer: `evince document.pdf`
- Theme files: `~/Projects/bunkeros/gtk-4.0/`

