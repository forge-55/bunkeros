# BunkerOS Fresh Installation Checklist

## Before Running install.sh

Verify these conditions are met:

### System Requirements
- [ ] Vanilla Arch Linux installed (no desktop environment)
- [ ] Logged in as regular user (NOT root)
- [ ] Internet connection working (`ping archlinux.org`)
- [ ] Git installed (`which git`)
- [ ] Sudo configured (`sudo -v`)
- [ ] Base-devel installed (`pacman -Q base-devel`)
- [ ] NetworkManager installed and enabled

### Directory Structure
- [ ] BunkerOS cloned to `~/bunkeros` or `~/Projects/bunkeros`
- [ ] Currently in bunkeros directory (`pwd`)

## What install.sh Does

The installer will automatically:

1. **Install Packages**
   - Core: sway, waybar, wofi, mako, foot, etc.
   - Apps: nautilus, lite-xl, btop, calculator
   - Media: Full PipeWire audio stack
   - System: SDDM, fonts, desktop portals
   - AUR: yay (AUR helper), swayosd-git

2. **Configure Environment**
   - Copy all configs to ~/.config
   - Set up user services (PipeWire)
   - Add user to 'input' group
   - Configure environment variables

3. **Install SDDM**
   - Install SDDM theme
   - Install session files
   - Enable sddm.service

4. **Validate**
   - Test Sway configuration
   - Verify services enabled
   - Check critical files exist

## After Installation

1. **MUST REBOOT** (not just logout)
2. At SDDM login, select "BunkerOS" session
3. Log in with your password
4. Everything should just work

## If Something Goes Wrong

### Check Logs
```bash
cat /tmp/bunkeros-install.log
```

### Verify Installation
```bash
~/bunkeros/scripts/validate-installation.sh
```

### Manual Fixes

**SDDM not showing:**
```bash
sudo systemctl enable sddm.service
sudo systemctl start sddm.service
```

**No audio:**
```bash
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service
systemctl --user enable --now wireplumber.service
```

**Missing yay:**
```bash
~/bunkeros/scripts/install-yay.sh
```

**Themes not showing:**
```bash
cd ~/bunkeros
./setup.sh
```

## Expected Results

After successful installation and reboot:

- ✅ SDDM login screen with tactical theme
- ✅ "BunkerOS" session available in menu
- ✅ Waybar at top with workspace indicators
- ✅ Keybindings work (Super+Return for terminal)
- ✅ Audio works
- ✅ Theme switcher shows all 5 themes
- ✅ All applications launch correctly

## Installation Time

- Arch base install: ~15 minutes
- BunkerOS install.sh: ~10-15 minutes
- **Total: ~30 minutes from blank drive to working BunkerOS**

---

**Ready? Run: `./install.sh`** 🎯
