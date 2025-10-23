# Lite XL Note-Taking Integration

BunkerOS uses **Lite XL** as its default note-taking and lightweight text editing application. Lite XL provides a clean, modern, and fast experience perfectly aligned with BunkerOS's tactical aesthetic.

## Why Lite XL?

Lite XL is the ideal note-taking app for BunkerOS:

- **Lightweight**: ~10 MB RAM footprint, instant startup
- **Modern Design**: Rounded dark theme, hardware-accelerated rendering, smooth scrolling
- **Tactically Clean**: Minimalist interface that stays out of your way
- **Lua-Extensible**: Optional plugins for advanced features without bloat
- **Wayland-Native**: Fully functional under Sway
- **Multi-Cursor**: Power-user features when you need them
- **Syntax Highlighting**: Built-in support for Markdown, code, and more

### vs. Other Text Editors

| Feature | Lite XL | VS Code | Nano | Mousepad |
|---------|---------|---------|------|----------|
| Startup Time | <0.5s | ~2-3s | <0.1s | ~1s |
| Memory | ~10 MB | ~200 MB | <1 MB | ~15 MB |
| Modern UI | ✓ | ✓ | ✗ | ✗ |
| Wayland | ✓ | ✓ | N/A | ✓ |
| Tabs | ✓ | ✓ | ✗ | ✓ |
| Multi-Cursor | ✓ | ✓ | ✗ | ✗ |
| Extensions | Lua | JS | ✗ | ✗ |

Lite XL strikes the perfect balance: fast like Nano, capable like VS Code, clean like Mousepad.

## Installation

Install Lite XL on Arch:
```bash

```bash
sudo pacman -S lite-xl
```

## BunkerOS Theme

BunkerOS includes a custom **Tactical Theme** for Lite XL:

### Color Palette
- **Background**: `#1C1C1C` (dark tactical base)
- **Sidebar**: `#2B2D2E` (secondary background)
- **Accent**: `#C3B091` (tactical gold for highlights)
- **Selection**: `rgba(107, 122, 84, 0.25)` (tactical green, subtle)
- **Text**: `#D4D4D4` (clear, high contrast)
- **Line Numbers**: `#6B7A54` (tactical green)
- **Current Line**: `#C3B091` (tactical gold)

### Theme Features
- Dark, focused interface matching Waybar, Wofi, and Nautilus
- Tactical gold accents for cursor and keywords
- Subtle tactical green for line numbers and selections
- High-contrast text for readability
- Minimal distractions (no unnecessary UI elements)

## Configuration

BunkerOS provides a pre-configured `init.lua` with tactical preferences:

- **60 FPS**: Smooth rendering
- **Line numbers**: Always visible
- **No animations**: Instant responsiveness (tactical discipline)
- **Auto-reload**: Files modified externally auto-refresh
- **Highlight current line**: Visual focus aid
- **Scroll past end**: Comfortable note-taking
- **4-space indentation**: Consistent formatting
- **100-character line limit**: Readable code/text

## Keybindings

### BunkerOS Integration
- **Super+n**: Open Lite XL with Notes directory (quick note-taking)
- **Super+e**: Open Lite XL (general text editor)
- **Super+m → Notes**: Launch from Quick Menu

### Within Lite XL
- **Ctrl+Shift+f**: Find in files (search all notes)
- **Ctrl+f**: Find in current file
- **Ctrl+h**: Find and replace
- **Ctrl+p**: Quick file open (fuzzy finder)
- **Ctrl+Shift+p**: Command palette
- **Ctrl+n**: New file
- **Ctrl+w**: Close tab
- **Ctrl+Tab**: Next tab
- **Ctrl+Shift+Tab**: Previous tab
- **Ctrl+s**: Save
- **Ctrl+Shift+s**: Save as
- **Ctrl+d**: Duplicate line
- **Ctrl+Shift+d**: Delete line
- **Ctrl+l**: Select line
- **Ctrl+/**: Toggle comment
- **Ctrl+Shift+[**: Fold block
- **Ctrl+Shift+]**: Unfold block

### Multi-Cursor (Power User)
- **Ctrl+Click**: Add cursor
- **Ctrl+Shift+↑/↓**: Add cursor above/below
- **Ctrl+d**: Select next occurrence (multi-edit)

## Notes Organization

### Default Location
Notes are stored in `~/Documents/Notes/` and automatically created on first use.

### Recommended Structure
```
~/Documents/Notes/
├── Welcome.md          # BunkerOS welcome note (created automatically)
├── Daily/
│   ├── 2025-10-18.md
│   └── 2025-10-19.md
├── Projects/
│   ├── BunkerOS.md
│   └── Ideas.md
├── Reference/
│   ├── Commands.md
│   └── Shortcuts.md
└── Todo.md
```

### Markdown Support
Lite XL has built-in Markdown syntax highlighting, making it perfect for structured notes:

```markdown
# Task List

## Today
- [ ] Review BunkerOS keybindings
- [x] Configure Lite XL theme
- [ ] Write documentation

## Ideas
- Integrate calendar widget
- Add weather to status bar

## Code Snippets
\`\`\`bash
# Quick system info
neofetch
\`\`\`
```

## Plugins (Optional)

Lite XL supports optional plugins for extended functionality:

### Recommended Plugins
- **autocomplete**: Intelligent code/text completion
- **autosave**: Automatically save files after edits
- **bracketmatch**: Highlight matching brackets
- **indentguide**: Visual indent guides
- **minimap**: Code minimap (like Sublime Text)
- **spellcheck**: Spell checking for notes

### Installing Plugins
```bash
cd ~/.config/lite-xl/plugins
# Download plugin files here
```

**Note**: BunkerOS ships without plugins for a clean, fast experience. Add only what you need.

## Integration with BunkerOS Workflow

### Quick Note-Taking
1. Press `Super+n` anywhere in BunkerOS
2. Lite XL opens instantly to your Notes directory
3. Press `Ctrl+n` for a new note
4. Type your thoughts
5. Press `Ctrl+s` to save
6. Close with `Ctrl+w` or `Super+q`

### As Default Text Editor
Lite XL is configured as the backup text editor (primary is `cursor`):
- Config variable: `$editor` in `sway/config`
- Change to Lite XL by setting: `set $editor lite-xl`

### File Associations
To make Lite XL the default for text files:
```bash
xdg-mime default lite-xl.desktop text/plain
xdg-mime default lite-xl.desktop text/markdown
```

## Troubleshooting

### Theme not applied
**Solution**: Ensure config is symlinked correctly:
```bash
ls -la ~/.config/lite-xl
# Should show: lite-xl -> /home/you/Projects/bunkeros/lite-xl
```

Re-run the install script if needed:
```bash
cd ~/Projects/bunkeros
./lite-xl/install.sh
```

### Fonts look wrong
**Solution**: Install a Nerd Font for better icon/glyph support:
```bash
sudo pacman -S ttf-meslo-nerd ttf-firacode-nerd
```

Then edit `~/.config/lite-xl/init.lua` to specify the font.

### Lite XL won't start
**Solution**: Check if it's installed:
```bash
which lite-xl
sudo pacman -S lite-xl
```

### Notes directory doesn't auto-open
**Solution**: Verify the keybinding in `sway/config`:
```bash
grep "mod+n" ~/Projects/bunkeros/sway/config
# Should show: bindsym $mod+n exec $notes ~/Documents/Notes
```

Reload Sway: `Super+Shift+c`

## Philosophy

Lite XL embodies BunkerOS's core principles:

- **Speed**: Instant startup, no loading screens or splash pages
- **Discipline**: No distracting animations, focused interface
- **Clarity**: High-contrast tactical theme for maximum readability
- **Efficiency**: Multi-cursor editing and fuzzy file finding
- **Simplicity**: Does one thing well—editing text—without bloat
- **Extensibility**: Lua plugins available when you need more power

It's the tactical field notebook for your digital workspace.

## Alternatives

If Lite XL doesn't fit your workflow, BunkerOS supports alternatives:

### For Terminal Lovers
- **Nano**: Simple, instant, classic
- **Vim/Neovim**: Modal editing powerhouse
- **Micro**: Modern terminal editor with mouse support

### For GUI Preferences
- **Cursor**: Full-featured IDE (BunkerOS default for `$editor`)
- **VS Code**: Heavy but feature-rich
- **Gedit**: GNOME's simple text editor

To change the default notes app, edit `~/Projects/bunkeros/sway/config`:
```bash
set $notes micro  # or nano, vim, cursor, etc.
```

## Resources

- [Lite XL Official Site](https://lite-xl.com/)
- [Lite XL GitHub](https://github.com/lite-xl/lite-xl)
- [Lite XL Plugins](https://github.com/lite-xl/lite-xl-plugins)
- [Lua Documentation](https://www.lua.org/manual/5.4/)

---

**Quick Reference**:
- Launch: `Super+Shift+n` or `lite-xl`
- Config: `~/.config/lite-xl/`
- Theme: `~/.config/lite-xl/colors/bunkeros-tactical.lua`
- Notes: `~/Documents/Notes/`

