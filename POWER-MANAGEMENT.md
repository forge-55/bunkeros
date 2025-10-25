# BunkerOS Power Management

BunkerOS uses the standard Linux power management system: **systemd-logind**. This is the same approach used by GNOME, KDE, and most modern Linux distributions.

## Architecture

### Division of Responsibilities

| Component | Responsibility | Configuration |
|-----------|---------------|---------------|
| **systemd-logind** | System suspend/hibernate | `/etc/systemd/logind.conf.d/` |
| **swayidle** | Screensaver activation | `~/.config/sway/config` |
| **Sway compositor** | Idle inhibition (fullscreen apps) | Window rules in Sway config |

### Why This Approach?

- **Standard**: Same system used across all major Linux distributions
- **Reliable**: systemd-logind has proper idle detection and power management
- **Compatible**: Works with system-wide inhibitor locks (video players, updates, etc.)
- **Battery-aware**: Can have different settings for AC vs battery power

## Default Settings

```
5 minutes  → Screensaver activates (swayidle)
10 minutes → System suspends (systemd-logind)
```

## Installation

```bash
cd ~/Projects/bunkeros
./scripts/install-power-management.sh
```

**Note**: This will require logging out or rebooting to take effect.

## Configuration

### Adjusting Suspend Timeout

Edit `/etc/systemd/logind.conf.d/bunkeros-power.conf`:

```ini
[Login]
# Change from 10min to your preferred timeout
IdleActionSec=15min  # or 5min, 20min, etc.
```

Then restart logind (will log you out):
```bash
sudo systemctl restart systemd-logind.service
```

Or just reboot:
```bash
sudo reboot
```

### Adjusting Screensaver Timeout

Edit `~/.config/sway/config`:

```bash
# Find the swayidle line and change timeout value
timeout 300  # Change to 180 (3min), 600 (10min), etc.
```

Then reload Sway:
```
Super+Shift+R
```

### Disable Auto-Suspend (Keep Screensaver)

Edit `/etc/systemd/logind.conf.d/bunkeros-power.conf`:

```ini
[Login]
# Set action to ignore
IdleAction=ignore
```

Restart logind or reboot.

### Different Settings for Laptop Battery

systemd-logind supports different timeouts based on power state, but this requires more advanced configuration. See `man logind.conf` for details.

## Inhibiting Suspend

### Automatic Inhibition

BunkerOS automatically prevents suspend during:
- **Fullscreen applications** (videos, presentations, games)
- **System updates** (pacman/pamac automatically sets inhibitor)
- **Active downloads** (many browsers set inhibitors)

### Manual Inhibition

Prevent suspend temporarily:

```bash
# Keep system awake while running a command
systemd-inhibit sleep 3600  # Stay awake for 1 hour

# Keep awake while a process runs
systemd-inhibit ffmpeg -i input.mp4 output.mp4
```

### Check What's Preventing Suspend

```bash
systemd-inhibit --list
```

## Verification

### Check logind configuration

```bash
loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') | grep Idle
```

You should see:
```
IdleAction=suspend
```

### Check screensaver configuration

```bash
ps aux | grep swayidle
```

You should see swayidle running with your timeout values.

### Test the system

1. Let system idle for 5 minutes → screensaver should activate
2. Let system idle for 10 minutes total → system should suspend
3. Press any key → system wakes up, screensaver dismissed

## Troubleshooting

### System doesn't suspend after 10 minutes

**Check if logind settings are active:**
```bash
loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') | grep IdleAction
```

If it shows `IdleAction=ignore`, the configuration didn't load. Reboot or restart logind.

**Check for inhibitors:**
```bash
systemd-inhibit --list
```

Common culprits:
- Browser tabs with active media
- System updates in progress
- Applications with "prevent sleep" features enabled

### Screensaver doesn't activate

**Check swayidle is running:**
```bash
ps aux | grep swayidle
```

If not running, reload Sway: `Super+Shift+R`

### Suspend happens too quickly

Increase `IdleActionSec` in `/etc/systemd/logind.conf.d/bunkeros-power.conf`

### Want suspend without screensaver

Set screensaver timeout higher than suspend timeout:

```bash
# In sway/config
timeout 900  # 15 minutes for screensaver

# In /etc/systemd/logind.conf.d/bunkeros-power.conf
IdleActionSec=10min  # 10 minutes for suspend
```

## Comparison with Other Approaches

### Old BunkerOS Approach (swayidle-based suspend)
```bash
swayidle timeout 600 'systemctl suspend'
```

**Problems:**
- swayidle has no authority over system power
- Conflicts with systemd-logind's own idle detection
- Doesn't respect system inhibitor locks
- Not the standard Linux approach

### systemd-logind Approach (current)
```ini
[Login]
IdleAction=suspend
IdleActionSec=10min
```

**Advantages:**
- Standard across all Linux distributions
- Properly integrates with system components
- Respects inhibitor locks from all applications
- Can be battery-aware
- Managed by the init system (systemd)

## Further Reading

- `man logind.conf` - Full logind configuration documentation
- `man systemd-inhibit` - How to prevent/delay system suspend
- [Arch Wiki: Power Management](https://wiki.archlinux.org/title/Power_management)
