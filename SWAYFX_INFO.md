# SwayFX Installation Notes

## Important: SwayFX Replaces Sway

The `swayfx` package from the CachyOS/Arch repositories **replaces** the `/usr/bin/sway` binary. It does not install a separate `swayfx` command.

### Package Behavior

- **Binary location**: `/usr/bin/sway` (not `/usr/bin/swayfx`)
- **Conflicts with**: vanilla `sway` package
- **Cannot coexist**: You cannot have both vanilla Sway and SwayFX installed simultaneously

### How BunkerOS Editions Work

Since SwayFX replaces the sway binary, BunkerOS uses **the same compositor** for both editions:

**Standard Edition:**
- Runs SwayFX with an **empty effects configuration**
- No rounded corners, shadows, or blur
- Behaves like vanilla Sway
- Maximum performance

**Enhanced Edition:**
- Runs SwayFX with **effects enabled**
- Rounded corners, shadows, blur, animations
- Modern visual aesthetics
- Slightly higher resource usage

### Both editions use SwayFX under the hood

The launcher scripts control which config is loaded:
- `launch-bunkeros-standard.sh` - Creates empty effects file
- `launch-bunkeros-enhanced.sh` - Symlinks actual effects file

This gives you the choice between performance (Standard) and aesthetics (Enhanced) using the same compositor.

### If You Want True Vanilla Sway

To use actual vanilla Sway:

```bash
# Remove SwayFX
sudo pacman -R swayfx

# Install vanilla Sway
sudo pacman -S sway

# Reinstall session files
cd /home/ryan/Projects/bunkeros/sddm
sudo ./install-theme.sh
```

Note: You'll lose the Enhanced edition (visual effects) if you do this.

## Recommendation

**Keep SwayFX installed** - it works great and gives you both options:
- Use Standard when you need maximum performance
- Use Enhanced when you want visual polish

