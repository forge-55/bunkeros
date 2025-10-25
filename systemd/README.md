# BunkerOS systemd Configuration

This directory contains systemd configuration files for BunkerOS.

## Structure

```
systemd/
├── logind.conf.d/
│   └── bunkeros-power.conf    # Power management (auto-suspend)
└── README.md
```

## Installation

All systemd configurations are installed via the main installation script or individual component scripts.

### Power Management

```bash
./scripts/install-power-management.sh
```

This installs:
- `/etc/systemd/logind.conf.d/bunkeros-power.conf` - Automatic suspend configuration

## What Gets Configured

### logind.conf.d/bunkeros-power.conf

Configures systemd-logind to:
- Suspend system after 10 minutes of idle time
- Handle laptop lid close events
- Handle power button behavior

See [POWER-MANAGEMENT.md](../POWER-MANAGEMENT.md) for full documentation.

## Manual Installation

If you need to install configurations manually:

```bash
# Power management
sudo mkdir -p /etc/systemd/logind.conf.d
sudo cp logind.conf.d/bunkeros-power.conf /etc/systemd/logind.conf.d/

# Restart logind (will log you out)
sudo systemctl restart systemd-logind.service

# OR just reboot
sudo reboot
```

## Verification

```bash
# Check if logind settings are active
loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') | grep IdleAction
```

Should show: `IdleAction=suspend`

## Customization

systemd configuration files in `/etc/systemd/logind.conf.d/` can be edited directly. Changes require restarting systemd-logind:

```bash
sudo systemctl restart systemd-logind.service
```

**Note**: Restarting systemd-logind will log you out.

## Documentation

- [POWER-MANAGEMENT.md](../POWER-MANAGEMENT.md) - Complete power management guide
- `man logind.conf` - systemd-logind configuration reference
- `man systemd-inhibit` - How to prevent system suspend
