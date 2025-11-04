# Video Conferencing on BunkerOS

Complete guide to setting up and using video conferencing applications (Zoom, Teams, Google Meet, Slack, Discord, etc.) on BunkerOS with full screen sharing, webcam, and audio support.

## Overview

BunkerOS is fully configured for modern video conferencing on Wayland using:
- **PipeWire** - Modern audio/video routing system
- **xdg-desktop-portal-wlr** - Screen sharing capability for Wayland
- **v4l-utils** - Webcam device management
- **Browser Wayland flags** - Native screen capture in Chromium-based browsers

All components work together seamlessly for professional video calls with screen sharing.

## Automatic Setup

**Video conferencing works out of the box after running `setup.sh`!**

The setup script automatically:
1. ✅ Enables PipeWire audio services (if not already enabled)
2. ✅ Configures all installed Chromium-based browsers with Wayland flags
3. ✅ Sets up desktop portals for screen sharing
4. ✅ No manual configuration needed

**For new users:** Just run `setup.sh` during installation and you're ready for video calls.

**For existing users:** Re-run `setup.sh` or manually run:
```bash
~/Projects/bunkeros/scripts/configure-browser-wayland.sh
```

## Prerequisites

All required packages are included in the setup requirements. If you need to verify or install manually:

```bash
# Audio/Video system (PipeWire)
sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber

# Desktop portal for screen sharing
sudo pacman -S xdg-desktop-portal xdg-desktop-portal-wlr

# Webcam utilities
sudo pacman -S v4l-utils

# Enable PipeWire services
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service
systemctl --user enable --now wireplumber.service
```

## Browser Configuration

### Automatic Setup (Recommended)

The setup script automatically configures all installed Chromium-based browsers. To run manually:

```bash
~/Projects/bunkeros/scripts/configure-browser-wayland.sh
```

This configures:
- Chromium
- Google Chrome
- Brave
- Microsoft Edge
- Vivaldi

### What Gets Configured

The script adds Wayland-specific flags to enable:
- **WebRTCPipeWireCapturer** - PipeWire screen capture (required for screen sharing)
- **Ozone platform auto** - Native Wayland rendering
- **VaapiVideoDecodeLinuxGL** - Hardware video acceleration
- **Wayland IME** - Input method support

### Manual Configuration

If you prefer manual setup or use a different browser, create a flags file:

**Chromium**: `~/.config/chromium-flags.conf`
**Chrome**: `~/.config/chrome-flags.conf`
**Brave**: `~/.config/brave-flags.conf`

```
--enable-features=WebRTCPipeWireCapturer,VaapiVideoDecodeLinuxGL
--ozone-platform-hint=auto
--enable-wayland-ime
```

After creating the file, restart your browser.

## Supported Applications

### Web-Based (Recommended)

These work in any properly configured Chromium-based browser:

| Application | URL | Notes |
|------------|-----|-------|
| **Google Meet** | meet.google.com | Full screen sharing, excellent quality |
| **Zoom** | zoom.us (web) | Screen sharing works, may prompt for native app |
| **Microsoft Teams** | teams.microsoft.com | Full functionality in Chromium/Edge |
| **Slack** | app.slack.com | Calls, screen sharing, huddles all work |
| **Jitsi Meet** | meet.jit.si | Open source, privacy-focused |
| **Discord** | discord.com/app | Web version has full screen sharing |
| **Whereby** | whereby.com | Simple, no account needed for joining |

### Native Applications

| Application | Installation | Screen Sharing | Notes |
|------------|--------------|----------------|-------|
| **Zoom** | `yay -S zoom` | ✅ Full support | Native app has best performance |
| **Discord** | `sudo pacman -S discord` | ✅ Works well | Native app recommended |
| **Slack** | `yay -S slack-desktop` | ✅ Full support | Electron-based |
| **Teams** | `yay -S teams-for-linux` | ✅ Works | Unofficial but functional |
| **Signal** | `sudo pacman -S signal-desktop` | ✅ Voice/video calls | Privacy-focused |

### Firefox

Firefox uses a different screen sharing implementation:

```bash
# Install Firefox
sudo pacman -S firefox

# Configuration (automatic in recent versions)
# Should work out of the box with xdg-desktop-portal-wlr
```

**Note**: Firefox may show a different screen picker UI than Chromium. Both work correctly.

## Testing Your Setup

### 1. Verify PipeWire

Check that PipeWire is running:

```bash
systemctl --user status pipewire
systemctl --user status wireplumber
```

Should show `active (running)` in green.

### 2. Check Desktop Portal

```bash
systemctl --user status xdg-desktop-portal-wlr.service
```

Or check for the process:

```bash
ps aux | grep xdg-desktop-portal
```

### 3. Test Webcam

```bash
# List video devices
v4l2-ctl --list-devices

# Test webcam (opens viewer)
ffplay /dev/video0
```

Press `q` to quit ffplay.

### 4. Test Screen Sharing

**Quick Test** (no account needed):
1. Open https://meet.jit.si in Chromium/Chrome/Brave
2. Create a random meeting room
3. Click "Share screen" button
4. You should see a screen picker showing:
   - Individual windows
   - Entire screen
   - Workspaces

**Expected Behavior**:
- Screen picker appears immediately
- Preview of screens/windows
- Select what to share → Click "Share"
- Your screen should be visible in the meeting

### 5. Test Audio

```bash
# Test microphone input
arecord -d 5 test.wav && aplay test.wav

# Open audio settings
pavucontrol
```

Check that:
- Input devices show your microphone
- Output devices show your speakers/headphones
- Levels move when you speak

## Troubleshooting

### Screen Sharing Doesn't Work

**Symptom**: "Share screen" button does nothing or shows error

**Solutions**:

1. **Restart desktop portal**:
   ```bash
   pkill -f xdg-desktop-portal
   # It will auto-restart
   ```

2. **Verify browser flags**:
   ```bash
   # For Chromium
   cat ~/.config/chromium-flags.conf
   ```
   Should contain `WebRTCPipeWireCapturer`

3. **Check PipeWire**:
   ```bash
   systemctl --user restart pipewire
   systemctl --user restart wireplumber
   ```

4. **Test portal manually**:
   ```bash
   # Install test utility
   sudo pacman -S xdg-desktop-portal

   # Check available portals
   gdbus introspect --session \
     --dest org.freedesktop.portal.Desktop \
     --object-path /org/freedesktop/portal/desktop
   ```

### No Audio in Calls

**Symptom**: Others can't hear you or you can't hear them

**Solutions**:

1. **Check PipeWire status**:
   ```bash
   systemctl --user status pipewire-pulse
   ```

2. **Verify audio devices**:
   ```bash
   pactl list sources short  # Input devices
   pactl list sinks short    # Output devices
   ```

3. **Test audio**:
   ```bash
   # Record 5 seconds and play back
   arecord -f cd -d 5 test.wav && aplay test.wav
   ```

4. **Open audio mixer**:
   ```bash
   pavucontrol
   ```
   Check "Input Devices" and "Output Devices" tabs

5. **Check browser permissions**:
   - In Chromium: `chrome://settings/content/microphone`
   - Ensure your video conferencing sites have permission

### Webcam Not Detected

**Symptom**: "No camera found" in video calls

**Solutions**:

1. **List video devices**:
   ```bash
   v4l2-ctl --list-devices
   ls -l /dev/video*
   ```

2. **Check permissions**:
   ```bash
   # Add user to video group
   sudo usermod -aG video $USER
   # Log out and back in
   ```

3. **Test camera**:
   ```bash
   ffplay /dev/video0
   ```

4. **Check browser permissions**:
   - In Chromium: `chrome://settings/content/camera`

### Screen Picker Shows Nothing

**Symptom**: Screen picker dialog appears but shows no screens/windows

**Solutions**:

1. **Check Sway version**:
   ```bash
   sway --version
   ```
   Should be 1.11+

2. **Verify xdg-desktop-portal-wlr**:
   ```bash
   pacman -Q xdg-desktop-portal-wlr
   ```
   Should be version 0.7.0+

3. **Check portal config**:
   ```bash
   cat ~/.config/xdg-desktop-portal/portals.conf
   ```
   Should show `default=wlr`

4. **Restart everything**:
   ```bash
   pkill -f xdg-desktop-portal
   systemctl --user restart pipewire wireplumber
   # Then reload Sway: Super+Shift+R
   ```

### Poor Video Quality

**Solutions**:

1. **Enable hardware acceleration** (already configured by setup):
   - Check browser flags include `VaapiVideoDecodeLinuxGL`

2. **Check network**:
   ```bash
   speedtest-cli  # Install: sudo pacman -S speedtest-cli
   ```

3. **Close other applications** consuming CPU/GPU

4. **Adjust video quality** in app settings:
   - Most apps let you set resolution (720p vs 1080p)
   - Lower resolution = better performance

### Echo or Audio Feedback

**Solutions**:

1. **Enable echo cancellation in PipeWire**:
   ```bash
   mkdir -p ~/.config/pipewire/pipewire.conf.d
   cat > ~/.config/pipewire/pipewire.conf.d/echo-cancel.conf << 'EOF'
   context.modules = [
       { name = libpipewire-module-echo-cancel }
   ]
   EOF
   
   systemctl --user restart pipewire
   ```

2. **Use headphones** instead of speakers

3. **Check for duplicate audio devices** in pavucontrol

## Best Practices

### Performance Tips

1. **Use native apps when available** - Generally better performance than web
2. **Close unnecessary browser tabs** - Each tab uses resources
3. **Monitor resource usage** with btop during calls

### Privacy Recommendations

1. **Review which windows are shared** before clicking "Share"
2. **Use virtual backgrounds** when supported to hide your environment
3. **Check microphone indicator** in Waybar to know when mic is active
4. **Lock screen when stepping away**: `Super+Escape`

### Professional Setup

1. **Test before meetings**:
   ```bash
   # Quick test in Jitsi
   xdg-open https://meet.jit.si/test-room-$(date +%s)
   ```

2. **Create web apps** for frequent platforms:
   ```bash
   # From Quick Menu (Super+m) → Web App Manager
   # Or directly:
   ~/.config/waybar/scripts/webapp-manager.sh
   ```

3. **Set up keybindings** for quick mute/video toggle:
   - Super+m → Keybindings → Add custom bindings
   - Example: `$mod+F12` for mute toggle (app-specific)

## Recommended Video Conferencing Apps

### For Business

1. **Google Meet** (web) - Best overall compatibility, no install needed
2. **Zoom** (native) - Most stable for large meetings
3. **Microsoft Teams** (web or teams-for-linux) - Required for many organizations

### For Casual/Personal

1. **Discord** (native or web) - Great for communities and gaming
2. **Jitsi Meet** (web) - Privacy-focused, no account needed
3. **Signal** (native) - Encrypted, privacy-first

### For Open Source Preference

1. **Jitsi Meet** - Fully open source, self-hostable
2. **Element/Matrix** - Federated, encrypted
3. **Signal** - Open source, audited

## Quick Reference

### Key Files

- Browser flags: `~/.config/chromium-flags.conf` (or similar)
- Portal config: `~/.config/xdg-desktop-portal/portals.conf`
- Audio config: `~/.config/pipewire/`

### Essential Commands

```bash
# Restart desktop portal
pkill -f xdg-desktop-portal

# Restart audio
systemctl --user restart pipewire wireplumber

# Test webcam
v4l2-ctl --list-devices

# Open audio mixer
pavucontrol

# Configure browsers
~/Projects/bunkeros/scripts/configure-browser-wayland.sh
```

### Support Resources

- [xdg-desktop-portal-wlr Wiki](https://github.com/emersion/xdg-desktop-portal-wlr/wiki)
- [PipeWire Documentation](https://docs.pipewire.org/)
- [Arch Wiki: PipeWire](https://wiki.archlinux.org/title/PipeWire)
- [Arch Wiki: Wayland](https://wiki.archlinux.org/title/Wayland)

## Known Limitations

1. **Zoom native app** may occasionally show a "screen sharing not available" warning on first use - restart the app
2. **Microsoft Teams native** is not officially supported on Linux - use web version or teams-for-linux
3. **Some corporate VPNs** may require additional configuration
4. **Virtual backgrounds** work in Zoom native but may need additional libraries (check Zoom docs)

## Contributing

Found a solution that works? Help improve this guide:
1. Test your fix thoroughly
2. Document the exact steps
3. Submit a PR or issue with your findings

---

**Quick Start**: Most users just need to run `setup.sh` and everything works. If you experience issues, start with the "Testing Your Setup" section above to identify the problem.
