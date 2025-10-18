#!/usr/bin/env bash

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/.config/lite-xl"

echo "=== Installing Lite XL Configuration ==="
echo ""

# Backup existing config if it exists
if [ -e "$CONFIG_DIR" ] && [ ! -L "$CONFIG_DIR" ]; then
    backup="$CONFIG_DIR.backup.$(date +%Y%m%d-%H%M%S)"
    echo "Backing up existing Lite XL config to: $backup"
    mv "$CONFIG_DIR" "$backup"
fi

# Remove existing symlink if present
if [ -L "$CONFIG_DIR" ]; then
    rm "$CONFIG_DIR"
fi

# Create symlink
ln -sf "$PROJECT_DIR/lite-xl" "$CONFIG_DIR"

echo "✓ Lite XL configuration symlinked"
echo "  Theme: BunkerOS Tactical (dark, tactical gold accents)"
echo "  Config: $CONFIG_DIR -> $PROJECT_DIR/lite-xl"
echo ""

# Create Notes directory if it doesn't exist
NOTES_DIR="$HOME/Documents/Notes"
if [ ! -d "$NOTES_DIR" ]; then
    mkdir -p "$NOTES_DIR"
    echo "✓ Created Notes directory: $NOTES_DIR"
    
    # Create a welcome note
    cat > "$NOTES_DIR/Welcome.md" << 'EOF'
# Welcome to BunkerOS Notes

Press **Super+n** to quickly open your notes directory in Lite XL.

## Quick Tips

- **Ctrl+Shift+f**: Find in files
- **Ctrl+f**: Find in current file
- **Ctrl+p**: Quick file open
- **Ctrl+Shift+p**: Command palette
- **Ctrl+n**: New file
- **Ctrl+w**: Close tab
- **Ctrl+s**: Save

## Markdown Support

Lite XL has basic Markdown syntax highlighting built-in.

### Lists
- Quick notes
- Ideas
- Tasks

### Code Blocks
\`\`\`bash
echo "Tactical precision"
\`\`\`

---

**BunkerOS**: Focused. Efficient. Professional.
EOF
    echo "✓ Created welcome note: $NOTES_DIR/Welcome.md"
else
    echo "✓ Notes directory already exists: $NOTES_DIR"
fi

echo ""
echo "Lite XL is now configured with the BunkerOS tactical theme!"
echo "Launch with: Super+n (quick notes) or run 'lite-xl'"

