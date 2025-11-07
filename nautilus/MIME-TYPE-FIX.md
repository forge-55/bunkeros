# MIME Type Association - Proactive Bug Prevention

## Background

Many Linux distributions encounter a bug where double-clicking files in Nautilus does nothing, and right-click "Open With" menus fail silently. This is caused by missing MIME type associations - the system doesn't know which application should handle which file types.

**Common symptoms:**
- Double-clicking files does nothing
- Right-click → "Open With" closes without opening anything
- No error messages, just silent failure
- `xdg-open` may work from terminal but Nautilus doesn't

## BunkerOS Solution

BunkerOS **proactively prevents this bug** by setting comprehensive default application associations during initial setup (`setup.sh` Step 12.6).

### What We Configure

| File Type | MIME Types | Default Application |
|-----------|------------|-------------------|
| **Images** | `image/png`, `image/jpeg`, `image/gif`, `image/webp`, `image/svg+xml` | Eye of GNOME (`eog`) |
| **PDFs** | `application/pdf` | Evince |
| **Text Files** | `text/plain`, `text/markdown`, `text/x-readme` | VS Code |
| **Code Files** | `text/x-python`, `text/x-shellscript`, `application/javascript`, `application/json`, `text/html`, `text/css` | VS Code |
| **Archives** | `application/zip`, `application/x-tar`, `application/x-compressed-tar`, `application/x-7z-compressed`, etc. | File Roller |
| **Directories** | `inode/directory`, `x-directory/normal` | Nautilus |

### How It Works

The setup script runs:
```bash
xdg-mime default <application>.desktop <mime/type>
```

This creates associations in `~/.config/mimeapps.list` that tell the system (and Nautilus) which application handles which file type.

## Verification

After running `setup.sh`, verify your configuration:

```bash
# Check image handler
xdg-mime query default image/png
# Expected: org.gnome.eog.desktop

# Check PDF handler
xdg-mime query default application/pdf
# Expected: org.gnome.Evince.desktop

# Check text file handler
xdg-mime query default text/plain
# Expected: code.desktop

# Check archive handler
xdg-mime query default application/zip
# Expected: org.gnome.FileRoller.desktop

# Check directory handler
xdg-mime query default inode/directory
# Expected: org.gnome.Nautilus.desktop
```

## Manual Fix (If Needed)

If you encounter a file type that doesn't open:

1. **Find the MIME type:**
   ```bash
   xdg-mime query filetype yourfile.ext
   ```

2. **Find available applications:**
   ```bash
   ls /usr/share/applications/ | grep -i <app-name>
   ```

3. **Set the default:**
   ```bash
   xdg-mime default <application>.desktop <mime/type>
   ```

4. **Verify:**
   ```bash
   xdg-mime query default <mime/type>
   ```

### Example: Setting Neovim for Python files

```bash
# Find the MIME type
xdg-mime query filetype script.py
# Output: text/x-python

# Set neovim as default
xdg-mime default nvim.desktop text/x-python

# Verify
xdg-mime query default text/x-python
# Output: nvim.desktop
```

## Common MIME Types Reference

```
Text Files:
  text/plain              → Plain text files (.txt)
  text/markdown           → Markdown files (.md)
  text/html               → HTML files (.html)
  text/css                → CSS files (.css)
  text/x-python           → Python scripts (.py)
  text/x-shellscript      → Shell scripts (.sh)
  application/javascript  → JavaScript files (.js)
  application/json        → JSON files (.json)
  application/x-yaml      → YAML files (.yaml, .yml)

Images:
  image/png               → PNG images
  image/jpeg              → JPEG images
  image/gif               → GIF images
  image/webp              → WebP images
  image/svg+xml           → SVG vector graphics

Archives:
  application/zip                      → ZIP archives
  application/x-tar                    → TAR archives
  application/x-compressed-tar         → .tar.gz files
  application/x-bzip-compressed-tar    → .tar.bz2 files
  application/x-xz-compressed-tar      → .tar.xz files
  application/x-7z-compressed          → 7-Zip archives
  application/x-rar                    → RAR archives

Documents:
  application/pdf         → PDF documents
  application/vnd.oasis.opendocument.text → ODT documents

Directories:
  inode/directory         → Directories/folders
  x-directory/normal      → Directories (alternative)
```

## Debugging Commands

```bash
# View all MIME associations
cat ~/.config/mimeapps.list

# View system-wide defaults
cat /usr/share/applications/mimeapps.list

# Test if xdg-open works (should match Nautilus behavior)
xdg-open testfile.txt

# Check tracker status (GNOME file indexer)
tracker3 status

# Reset tracker if needed
tracker3 reset --filesystem --rss

# Launch Nautilus with debug output
G_DEBUG="all" NAUTILUS_DEBUG="All" nautilus .
```

## Why This Matters

Without proper MIME type associations:
- ❌ Nautilus appears "broken" to new users
- ❌ Silent failures with no error messages
- ❌ Frustrating experience requiring terminal debugging
- ❌ Obscure bug that's hard to diagnose

With comprehensive MIME associations:
- ✅ Files open as expected on double-click
- ✅ "Open With" menus work correctly
- ✅ Professional, polished user experience
- ✅ Works out-of-the-box without configuration

## Related Issues

This fix prevents bugs similar to:
- Common Linux distribution issue
- Various "Nautilus doesn't open files" reports across Linux distributions
- GNOME/GTK file association issues on minimal installations

## Future Considerations

Potential additions:
- Video files → MPV or VLC
- Audio files → Audacious or similar
- Office documents → LibreOffice
- E-books → Foliate or similar

These can be added to `setup.sh` as BunkerOS evolves.

---

**Bottom line**: BunkerOS proactively prevents the Nautilus file-opening bug through comprehensive MIME type configuration. Users can double-click files with confidence. 🎯
