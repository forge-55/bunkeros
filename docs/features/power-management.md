# BunkerOS Power Management

BunkerOS uses a simple, reliable approach to power management: **swayidle** for automatic lock and suspend, with battery-aware timeouts.

## Architecture

### Division of Responsibilities

| Component | Responsibility | Configuration |
|-----------|---------------|---------------|
| **swayidle** | Automatic lock & suspend | `~/.config/sway/config` |
| **systemd-logind** | Hardware events (lid, power button) | `/etc/systemd/logind.conf.d/` |
| **Sway compositor** | Idle inhibition (fullscreen apps) | Window rules in Sway config |
| **auto-cpufreq** or **TLP** | CPU frequency & power (optional) | Systemd service |

### Why This Approach?

- **Simple**: One component (swayidle) handles idle timeout → lock → suspend
- **Reliable**: Direct control flow without complex interactions
- **Battery-aware**: Different timeouts when on battery vs plugged in
- **Predictable**: Clear, linear progression from idle to suspend

## Default Settings

**On Battery (power saving):**
- 3 minutes idle → Lock screen
- 5 seconds later → Suspend

**Plugged In (convenience):**
- 5 minutes idle → Lock screen
- 5 seconds later → Suspend

**Hardware Events:**
- Lid close → Suspend immediately (with lock)
- Power button → Power off

## CPU Power Management (Laptops)

BunkerOS supports optional CPU power management tools for improved laptop battery life:

### auto-cpufreq (Recommended)

Automatic CPU speed and power optimizer that adapts to your workload.

**Installation:**
```bash
yay -S auto-cpufreq
sudo systemctl enable --now auto-cpufreq
```

**Usage:**
```bash
# View current status and statistics
sudo auto-cpufreq --stats

# Monitor live (updates every second)
sudo auto-cpufreq --monitor
```

**Features:**
- Automatic CPU frequency scaling based on load
- Battery vs AC power profiles
- Automatic turbo boost management
- Process-based optimization

### TLP (Alternative)

Advanced laptop power management with extensive configuration options.

**Installation:**
```bash
sudo pacman -S tlp tlp-rdw
sudo systemctl enable --now tlp
```

**Usage:**
```bash
# View status
sudo tlp-stat -s

# Full statistics
sudo tlp-stat
```

**Note:** Do NOT install both TLP and auto-cpufreq - they conflict with each other.

### Which to Choose?

| Feature | auto-cpufreq | TLP |
|---------|--------------|-----|
| Ease of use | ✓ Works out of the box | Requires configuration |
| Active development | ✓ Modern, actively maintained | Mature but slower updates |
| Configuration | Minimal/automatic | Extensive options |
| CPU frequency | ✓ Automatic | Manual profiles |
| Power savings | Good (20-30% typical) | Excellent (30-40% with tuning) |
| Best for | Most users | Power users who want control |

**Recommendation:** Start with auto-cpufreq. Switch to TLP only if you need specific features or want to fine-tune settings.

## Installation

The power management system is automatically configured during BunkerOS setup. No manual installation needed.

## Configuration

### Adjusting Lock and Suspend Timeouts

Edit `~/Projects/bunkeros/scripts/launch-swayidle.sh`:

```bash
# For battery power (default: 3 minutes lock, then suspend)
LOCK_TIMEOUT=180   # Change to desired seconds
SUSPEND_TIMEOUT=185  # Usually LOCK_TIMEOUT + 5

# For plugged in (default: 5 minutes lock, then suspend)
LOCK_TIMEOUT=300   # Change to desired seconds
SUSPEND_TIMEOUT=305  # Usually LOCK_TIMEOUT + 5
```

Then reload Sway configuration:
```
Super+Shift+R
```

### Disable Auto-Suspend (Keep Auto-Lock Only)

Edit `~/Projects/bunkeros/scripts/launch-swayidle.sh` and comment out the suspend timeout:

```bash
exec swayidle -w \
    timeout $LOCK_TIMEOUT "$HOME/.local/bin/bunkeros-lock" \
    # timeout $SUSPEND_TIMEOUT 'systemctl suspend' \
    before-sleep "$HOME/.local/bin/bunkeros-lock"
```

Then reload Sway: `Super+Shift+R`

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

You should see swayidle running with your configured timeout values.

### Test the system

1. Let system idle for the configured timeout → lock screen appears
2. A few seconds later → system suspends
3. Wake the system → you're at the lock screen (enter password to unlock)

## Troubleshooting

### System doesn't suspend after idle timeout

**Check swayidle is running:**
```bash
ps aux | grep swayidle
```

If not running, reload Sway: `Super+Shift+R`

**Check for inhibitors:**
```bash
systemd-inhibit --list
```

Common culprits:
- Browser tabs with active media or fullscreen videos
- System updates in progress
- Applications with "prevent sleep" features enabled
- Fullscreen applications (this is by design - see Sway config)

### Lock screen doesn't appear

**Verify the lock script exists:**
```bash
ls -l ~/.local/bin/bunkeros-lock
```

**Test manually:**
```bash
~/.local/bin/bunkeros-lock
```

### Suspend happens too quickly/slowly

Edit the timeouts in `~/Projects/bunkeros/scripts/launch-swayidle.sh` as described in the Configuration section above.

## Comparison with Other Approaches

### Old BunkerOS Approach (swayidle-based suspend)
```bash
swayidle timeout 600 'systemctl suspend'
```

**Problems:**
- swayidle has no authority over system power
- Conflicts with systemd-logind's own idle detection


## How It Works

BunkerOS uses swayidle to handle the complete idle management workflow:

1. **Idle Detection**: swayidle monitors keyboard/mouse activity
2. **Lock Screen**: After timeout, launches `bunkeros-lock` to secure the system
3. **Suspend**: A few seconds later, triggers system suspend
4. **Before Sleep**: Always locks before any sleep event (lid close, manual suspend, etc.)

The `-w` flag tells swayidle to wait for commands to complete before considering the timeout satisfied. This ensures the lock screen is fully displayed before suspend.

### Battery-Aware Behavior

The launch script automatically detects whether you're on battery or plugged in:
- **Battery**: Shorter timeout (3 min) to conserve power
- **Plugged In**: Longer timeout (5 min) for convenience

### Inhibitors

Fullscreen applications automatically prevent idle detection. This means:
- Videos playing fullscreen won't trigger auto-lock/suspend
- Presentations won't be interrupted
- Gaming sessions continue uninterrupted

## Further Reading

- `man swayidle` - Full swayidle documentation
- `man systemd-inhibit` - How to prevent/delay system suspend
- [Arch Wiki: Power Management](https://wiki.archlinux.org/title/Power_management)

