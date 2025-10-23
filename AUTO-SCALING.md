# BunkerOS Auto-Scaling System

## Overview

BunkerOS automatically detects your display hardware and applies optimal font sizes and scaling on first login. The system respects user customizations and never overwrites manual changes.

## How It Works

### First Login
1. **Detection**: System detects screen resolution, DPI, and device type
2. **Apply**: Optimal font sizes are calculated and applied
3. **Profile Created**: Settings saved to `~/.config/bunkeros/scaling-profile.conf`

### Subsequent Logins
- Auto-scaling **only applies on first login**
- If you manually change font sizes, the system **detects this** and:
  - Saves your preferences to `~/.config/bunkeros/user-preferences.conf`
  - **Disables auto-scaling** permanently
  - Shows one-time notification

## Architecture

### User-Specific Files (NOT in git)

These files are modified by auto-scaling and **should never be committed**:

```
~/.config/
├── foot/foot.ini                  # Your font config (symlinked from theme)
├── waybar/style.css               # Your waybar config
├── wofi/style.css                 # Your wofi config
└── bunkeros/
    ├── scaling-profile.conf       # Auto-detected settings
    ├── user-preferences.conf      # Your manual customizations
    ├── scaling-disabled           # Flag to disable auto-scaling
    └── scaling-first-run-done     # Tracks first run
```

### Theme Source Files (IN git)

These are **templates** that should have default values:

```
themes/
├── tactical/
│   ├── foot.ini.template          # Default: size=12
│   ├── waybar-style.css.template  # Default: 16px
│   └── wofi-style.css.template    # Default: 17px
└── [other themes...]
```

## User Controls

### Disable Auto-Scaling

```bash
# Disable completely
touch ~/.config/bunkeros/scaling-disabled

# Re-enable
rm ~/.config/bunkeros/scaling-disabled
```

### Reset to Auto-Scaling

```bash
# Remove user preferences to let auto-scaling take over again
rm ~/.config/bunkeros/user-preferences.conf
rm ~/.config/bunkeros/scaling-first-run-done

# Log out and log back in
```

### Manual Scaling Configuration

```bash
# Use the interactive tool
~/Projects/bunkeros/scripts/configure-display-scaling.sh

# This will:
# 1. Show current settings
# 2. Detect your hardware
# 3. Let you choose or customize
# 4. Save as user preferences
```

## For Developers

### Setting Up Themes

When creating/updating themes, use **template files**:

```bash
# Create template with defaults
cp themes/tactical/foot.ini themes/tactical/foot.ini.template

# Git tracks only templates
git add themes/tactical/foot.ini.template
git add .gitignore  # Excludes non-template versions
```

### What Gets Committed

✅ **DO commit:**
- `themes/*/foot.ini.template` (defaults)
- `themes/*/waybar-style.css.template` (defaults)
- `themes/*/wofi-style.css.template` (defaults)
- Scripts in `scripts/`
- Documentation

❌ **DO NOT commit:**
- `themes/*/foot.ini` (user-modified)
- `themes/*/waybar-style.css` (user-modified)
- `themes/*/wofi-style.css` (user-modified)
- `lite-xl/session.lua` (user session)
- `lite-xl/ws/*` (user workspace)

### Testing Changes

```bash
# Test auto-scaling
./scripts/test-auto-scaling.sh

# Simulate first login
rm ~/.config/bunkeros/scaling-*
# Log out and back in
```

## Detection Profiles

The system detects and applies different profiles based on hardware:

| Device Type | Resolution | Scale | Terminal | Waybar | Wofi |
|------------|-----------|-------|----------|--------|------|
| **Laptop (HD)** | 1366x768 | 1.0 | 10pt | 13px | 14px |
| **Laptop (FHD)** | 1920x1080 | 1.0 | 10pt | 14px | 15px |
| **Desktop (FHD)** | 1920x1080 | 1.0 | 11pt | 15px | 16px |
| **Desktop (QHD)** | 2560x1440 | 1.25 | 11pt | 15px | 16px |
| **Desktop (4K)** | 3840x2160 | 1.5 | 12pt | 16px | 17px |
| **Hi-DPI Laptop** | 3200x1800 | 1.75 | 12pt | 16px | 17px |

## Benefits of This Approach

### For Users
- ✅ Automatic optimal settings on first use
- ✅ Manual changes are preserved forever
- ✅ Can always reset to auto-detected settings
- ✅ Can completely disable if desired
- ✅ No surprise overwrites

### For Developers
- ✅ No git conflicts from auto-scaling
- ✅ Clean git history
- ✅ Easy to test different devices
- ✅ Templates serve as documentation
- ✅ User configs separate from source

## Migration Guide

If you have existing modified theme files in git:

```bash
cd ~/Projects/bunkeros

# 1. Create templates from current state
for theme in themes/*/; do
    [ -f "$theme/foot.ini" ] && cp "$theme/foot.ini" "$theme/foot.ini.template"
    [ -f "$theme/waybar-style.css" ] && cp "$theme/waybar-style.css" "$theme/waybar-style.css.template"
    [ -f "$theme/wofi-style.css" ] && cp "$theme/wofi-style.css" "$theme/wofi-style.css.template"
done

# 2. Commit templates
git add themes/*/*.template
git commit -m "Add theme templates for auto-scaling system"

# 3. Remove tracked versions (git will ignore them now)
git rm --cached themes/*/foot.ini themes/*/waybar-style.css themes/*/wofi-style.css
git commit -m "Remove user-modifiable theme files from git tracking"

# 4. Push changes
git push
```

## Troubleshooting

### Auto-scaling not working
```bash
# Check if disabled
ls ~/.config/bunkeros/scaling-disabled

# Check logs
journalctl --user -b | grep -i bunkeros
```

### Want to change detection logic
Edit: `scripts/detect-display-hardware.sh`

### Settings keep reverting
You might have multiple scripts running. Check:
```bash
systemctl --user list-timers  # For systemd timers
pgrep -af scaling  # For running processes
```

### Fonts too small/large
Just change them! The system will detect your preference and never override again.
