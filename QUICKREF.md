# BunkerOS Installation - Quick Reference

## For Fresh Install

```bash
cd ~/Projects/bunkeros
./install.sh
```

**What happens:**
1. Preflight checks (internet, disk space, pacman)
2. Backup existing config
3. Install/configure SDDM
4. Install all packages (with conflict handling)
5. Set up configurations (symlinks from git repo)
6. Validate Sway config
7. Install optional tools (power management)
8. Verify services
9. Run final validation

**If interrupted:** Just run `./install.sh` again - it resumes from last checkpoint.

## Emergency Recovery

**Access:** Select "BunkerOS Emergency Recovery" from SDDM login screen

**Keybindings:**
- `Super+T` - Open terminal
- `Super+Shift+E` - Exit to login

**Common tasks:**
```bash
# View installation log
ls /tmp/bunkeros-install-*.log

# Restore backup
ls ~/.config/.bunkeros-backup-*
cp -r ~/.config/.bunkeros-backup-TIMESTAMP/* ~/.config/

# Validate Sway config
sway --validate

# Re-run installation
cd ~/Projects/bunkeros
./install.sh
```

## Installation Checkpoints

Progress is saved after each stage:
- ✓ backup_complete
- ✓ sddm_configured
- ✓ core_packages_installed
- ✓ app_packages_installed
- ✓ media_packages_installed
- ✓ system_packages_installed
- ✓ portal_packages_installed
- ✓ aur_packages_installed
- ✓ setup_complete
- ✓ sway_validated
- ✓ python_tools_installed
- ✓ services_verified
- ✓ power_management_complete
- ✓ session_fixed
- ✓ installation_complete

## Common Issues

### Terminal keybindings don't work
**Fix:** Auto-fixed by installer (creates defaults.conf)

### Desktop portal conflicts
**Fix:** Auto-handled with --overwrite flag

### Installation interrupted
**Fix:** Re-run ./install.sh (resumes automatically)

### Can't get to TTY from SDDM
**Fix:** Use Emergency Recovery session from login menu

### Emergency session appears as default
**Fix:** Auto-fixed (proper session naming/ordering)

## Files to Know

- **Installation log:** `/tmp/bunkeros-install-*.log`
- **Checkpoint file:** `/tmp/bunkeros-install-checkpoint`
- **Config backup:** `~/.config/.bunkeros-backup-*`
- **Main config:** `~/.config/sway/config`
- **Defaults:** `~/.config/bunkeros/defaults.conf`
- **SDDM sessions:** `/usr/share/wayland-sessions/bunkeros*.desktop`

## Documentation

- **INSTALL.md** - Full installation guide
- **IMPROVEMENTS.md** - Technical details of all fixes
- **EMERGENCY-RECOVERY.md** - Recovery mode guide
- **TROUBLESHOOTING.md** - Common issues
- **TROUBLESHOOTING-SDDM.md** - Display manager issues

## Testing Checklist

Before deploying:
- [ ] Fresh CachyOS install
- [ ] Fresh Arch Linux install
- [ ] Installation with interruption
- [ ] Emergency recovery boots
- [ ] All keybindings work
- [ ] SDDM session ordering correct

## Next Steps

1. Test on fresh CachyOS (X1 Carbon Gen9)
2. Report any issues
3. Refine based on feedback
4. Deploy to production

---

**Ready to test? Reinstall CachyOS and run ./install.sh**
