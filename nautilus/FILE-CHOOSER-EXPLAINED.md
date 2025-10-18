# File Manager vs. File Chooser Dialog - Explained

## What You're Seeing

When you open a project or file in applications like **Cursor**, **VS Code**, or other Electron/GTK apps, you see a **file picker dialog**. This is **not a file manager** - it's a built-in component called the **GTK File Chooser**.

### The Difference

| Component | What It Is | When You See It | How to Open |
|-----------|-----------|----------------|-------------|
| **Nautilus** | Full file manager application | Browse files, manage folders, move/copy/delete | `Super+f` or `Super+m → File Manager` |
| **GTK File Chooser** | Dialog for picking files within apps | Inside Cursor, Gimp, etc. when opening/saving | Automatic when apps need file input |

## Why This Matters

The **GTK File Chooser** is:
- A **dialog component** built into GTK (the UI toolkit)
- **Not a separate application** you can replace
- **Themed by your GTK theme** (already using BunkerOS tactical theme)
- **Standard across all GTK/Electron applications**

Think of it like this:
- **Nautilus** = Windows Explorer / macOS Finder (standalone app)
- **GTK File Chooser** = The "Open File" dialog in any app (built-in component)

## What We've Configured

### ✅ Nautilus is Set as Default File Manager

When you:
- Click "Open in File Manager" anywhere in the system
- Press `Super+f`
- Launch from Quick Menu
- Open a directory from terminal or app

**→ Nautilus will open**

### ✅ GTK File Chooser Uses BunkerOS Theme

The file picker dialogs in Cursor and other apps:
- Use the **BunkerOS tactical theme** (dark backgrounds, tactical gold accents)
- Match the styling of Nautilus, Waybar, and other BunkerOS components
- Are configured via the GTK4 theme we've already set up

### ✅ Environment Variables Set

```bash
export FILE_MANAGER=nautilus  # In ~/.bashrc
```

This tells scripts and some applications to use Nautilus when they need to open a file manager.

### ✅ MIME Types Configured

```bash
xdg-mime default org.gnome.Nautilus.desktop inode/directory
xdg-mime default org.gnome.Nautilus.desktop x-directory/normal
```

This tells the system to open directories in Nautilus by default.

## Verifying Configuration

Check your current settings:

```bash
# Check default file manager
xdg-mime query default inode/directory
# Should output: org.gnome.Nautilus.desktop

# Check FILE_MANAGER variable
echo $FILE_MANAGER
# Should output: nautilus

# Check installed file managers
pacman -Qq | grep -E '(thunar|pcmanfm|nemo|caja|dolphin)'
# Should output: nothing (only Nautilus is installed)
```

## Visual Comparison

### Nautilus (File Manager Application)
- **Full window** with menu bars, sidebars, and toolbars
- Can have **multiple tabs**
- Shows **all file operations** (cut, copy, paste, delete)
- Has **preferences and settings**
- Can be **minimized, maximized, moved**

### GTK File Chooser (Dialog)
- **Modal dialog** (blocks the parent application)
- **No menu bar** or full file management features
- **Limited to selecting files/folders**
- **No customization options** (uses GTK theme)
- **Cannot be minimized** or moved independently

## The GTK File Chooser is Themed

BunkerOS uses the standard **GTK file chooser** with **BunkerOS tactical theme applied**. While not as feature-rich as Nautilus's file picker, it's:

- **Lightweight** - No extra dependencies
- **Fully themed** - Uses BunkerOS tactical colors (dark backgrounds, tactical gold)
- **Functional** - Does everything you need for opening/saving files
- **Fast** - Instant startup

### Why Not GNOME Portal?

We considered using `xdg-desktop-portal-gnome` (Nautilus file picker) but it requires:
- **GNOME Shell dependencies** (~50+ MB of packages)
- **GNOME-specific services** that conflict with Sway's lightweight philosophy
- **Extra complexity** for minimal benefit

The GTK file chooser works great and is already themed to match BunkerOS.

## Troubleshooting

### "Open File Manager" buttons open something other than Nautilus
**Solution**: Already configured! Run:
```bash
xdg-mime default org.gnome.Nautilus.desktop inode/directory
```

### File picker dialog doesn't match BunkerOS theme
**Solution**: Verify GTK4 theme is installed:
```bash
ls -la ~/.config/gtk-4.0/
# Should show symlinks to BunkerOS gtk-4.0/
```

### I see Thunar or another file manager
**Solution**: No other file managers are installed in BunkerOS. If you see one, uninstall it:
```bash
sudo pacman -R thunar  # or pcmanfm, nemo, etc.
```

## The Bottom Line

✅ **Nautilus IS your file manager** - it's already set as default everywhere  
✅ **GTK File Chooser IS NORMAL** - it's not a different file manager, it's a dialog  
✅ **Everything is themed consistently** - both use the BunkerOS tactical theme  
✅ **No other file managers are installed** - Nautilus is the only one  

**You don't need to do anything else.** The system is configured correctly.

---

**TL;DR**: The file picker dialog you see in Cursor is **not a file manager**, it's a **GTK file chooser dialog** (like "Open File" in Windows). Nautilus **is** your default file manager everywhere else, and it's already configured correctly. Both use the same BunkerOS tactical theme.

