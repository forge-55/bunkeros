# Battery Power Profile Management# Battery Power Profile Management



BunkerOS integrates **auto-cpufreq** with an interactive waybar battery indicator that allows instant power profile switching.BunkerOS integrates **auto-cpufreq** with an interactive waybar battery indicator that allows instant power profile switching.



## Features## Features



### Automatic Power Management### Automatic Power Management

- **auto-cpufreq** runs in the background and automatically optimizes CPU frequency and power consumption- **auto-cpufreq** runs in the background and automatically optimizes CPU frequency and power consumption

- Switches between power-saving mode (on battery) and performance mode (on AC) automatically- Switches between power-saving mode (on battery) and performance mode (on AC) automatically

- Zero configuration required - works out of the box- Zero configuration required - works out of the box



### Interactive Profile Switching### Interactive Profile Switching

The battery indicator in waybar shows:The battery indicator in waybar shows:

- **Battery icon** - Current charge level and status (charging/discharging/full)- **Battery icon** - Current charge level and status (charging/discharging/full)

- **Profile icon** - Current power profile mode- **Profile icon** - Current power profile mode

- Click to open menu and select profile- Click to cycle through power profiles



### Available Profiles### Available Profiles



| Profile | Icon | Description | Best For || Profile | Icon | Description | Best For |

|---------|------|-------------|----------||---------|------|-------------|----------|

| **Auto** | 󱐌 | Automatic switching based on AC/battery | Daily use (recommended) || **Auto** | 󱐌 | Automatic switching based on AC/battery | Daily use (recommended) |

| **Power Saver** | 󱈏 | Maximum battery life, reduced performance | Long battery sessions || **Power Saver** | 󱈏 | Maximum battery life, reduced performance | Long battery sessions |

| **Balanced** | 󰾅 | Balance between performance and efficiency | General productivity || **Balanced** | 󰾅 | Balance between performance and efficiency | General productivity |

| **Performance** | 󱐋 | Maximum CPU performance | Compiling, video editing, gaming || **Performance** | 󱐋 | Maximum CPU performance | Compiling, video editing, gaming |



### Visual Indicators### Profile Cycle



The battery module changes color based on:Click the battery indicator to cycle through profiles:

- **Profile mode**: Different colors for each profile```

- **Battery level**: Warning (yellow) and critical (red) statesAuto → Power Saver → Balanced → Performance → Auto

- **Charging status**: Distinct appearance when plugged in```



## Color Coding### Visual Indicators



- **Auto mode**: Medium green (`#6B7657`)The battery module changes color based on:

- **Power Saver**: Light green (`#7A9A5A`) - Shows only profile icon- **Profile mode**: Different colors for each profile

- **Balanced**: Standard green (`#4A5240`)- **Battery level**: Warning (yellow) and critical (red) states

- **Performance**: Orange (`#CC7832`)- **Charging status**: Distinct appearance when plugged in

- **Charging**: Light green (`#7A9A5A`)

- **Warning (<30%)**: Orange## Color Coding

- **Critical (<15%)**: Red with background highlight

- **Auto mode**: Medium green (`#6B7657`)

## Manual Control- **Power Saver**: Light green (`#7A9A5A`)

- **Balanced**: Standard green (`#4A5240`)

### Command Line- **Performance**: Orange (`#CC7832`)

- **Charging**: Light green (`#7A9A5A`)

You can also switch profiles via terminal:- **Warning (<30%)**: Orange

- **Critical (<15%)**: Red with background highlight

```bash

# Switch to specific profile## Manual Control

sudo auto-cpufreq --force power        # Power saver

sudo auto-cpufreq --force balanced     # Balanced### Command Line

sudo auto-cpufreq --force performance  # Performance

sudo auto-cpufreq --force auto         # Return to automaticYou can also switch profiles via terminal:



# View current status```bash

sudo auto-cpufreq --stats# Switch to specific profile

sudo auto-cpufreq --force power        # Power saver

# Monitor in real-timesudo auto-cpufreq --force balanced     # Balanced

sudo auto-cpufreq --monitorsudo auto-cpufreq --force performance  # Performance

```sudo auto-cpufreq --force auto         # Return to automatic



### Passwordless Switching# View current status

sudo auto-cpufreq --stats

A sudoers rule is installed during setup that allows users in the `wheel` group to switch profiles without entering a password. This enables seamless clicking in waybar.

# Monitor in real-time

## Technical Detailssudo auto-cpufreq --monitor

```

### Scripts

### Passwordless Switching

- **`battery-profile-menu.sh`** - Wofi menu for selecting profiles

- **`battery-profile-status.sh`** - Updates battery and profile display every 5 secondsA polkit rule is installed during setup that allows users in the `wheel` group to switch profiles without entering a password. This enables seamless clicking in waybar.

- **`battery-profile-toggle.sh`** - Legacy toggle script (cycles through modes)

## Technical Details

### Waybar Configuration

### Scripts

The custom battery module (`custom/battery-profile`) replaces the standard battery module and provides:

- Real-time battery status- **`battery-profile-toggle.sh`** - Handles profile cycling when clicked

- Current power profile indication- **`battery-profile-status.sh`** - Updates battery and profile display every 30 seconds

- Click-to-menu functionality

- Detailed tooltip with battery and profile info### Waybar Configuration



### Power Management FilesThe custom battery module (`custom/battery-profile`) replaces the standard battery module and provides:

- Real-time battery status

- **`/etc/sudoers.d/auto-cpufreq`** - Allows passwordless profile switching- Current power profile indication

- **`/etc/systemd/logind.conf.d/bunkeros-power.conf`** - Suspend/screensaver timings- Click-to-toggle functionality

- **`/tmp/auto-cpufreq-mode`** - State file storing current profile (fast access)- Detailed tooltip with battery and profile info



## Usage Tips### Power Management Files



1. **Leave on Auto for daily use** - auto-cpufreq is smart and will optimize automatically- **`/etc/polkit-1/rules.d/50-auto-cpufreq.rules`** - Allows passwordless profile switching

2. **Use Power Saver** when you need maximum battery life and don't need much performance- **`/etc/systemd/logind.conf.d/bunkeros-power.conf`** - Suspend/screensaver timings

3. **Switch to Performance** when plugged in for demanding tasks (compiling, rendering, gaming)

4. **Use Balanced** when you want consistent performance regardless of AC status## Usage Tips



## Troubleshooting1. **Leave on Auto for daily use** - auto-cpufreq is smart and will optimize automatically

2. **Use Power Saver** when you need maximum battery life and don't need much performance

### Battery indicator not showing3. **Switch to Performance** when plugged in for demanding tasks (compiling, rendering, gaming)

```bash4. **Use Balanced** when you want consistent performance regardless of AC status

# Check if auto-cpufreq is running

systemctl status auto-cpufreq## Troubleshooting



# Restart waybar### Battery indicator not showing

killall waybar```bash

waybar &# Check if auto-cpufreq is running

```systemctl status auto-cpufreq



### Profile not switching# Restart waybar

```bashkillall waybar

# Test the menu script manuallywaybar &

~/.config/waybar/scripts/battery-profile-menu.sh```



# Check auto-cpufreq status### Profile not switching

sudo auto-cpufreq --stats```bash

```# Test the toggle script manually

~/.config/waybar/scripts/battery-profile-toggle.sh

### Permission errors

```bash# Check auto-cpufreq status

# Verify sudoers rule is installedsudo auto-cpufreq --stats

sudo ls -l /etc/sudoers.d/auto-cpufreq```



# Reinstall if needed### Permission errors

sudo cp systemd/sudoers.d/auto-cpufreq /etc/sudoers.d/```bash

sudo chmod 440 /etc/sudoers.d/auto-cpufreq# Verify polkit rule is installed

```ls -l /etc/polkit-1/rules.d/50-auto-cpufreq.rules



### State file missing# Reinstall if needed

```bashsudo cp systemd/polkit-rules/50-auto-cpufreq.rules /etc/polkit-1/rules.d/

# Initialize the state file```

echo "auto" > /tmp/auto-cpufreq-mode

```## Comparison with Other Power Tools



## Comparison with Other Power ToolsBunkerOS uses **auto-cpufreq** instead of:

- **TLP** - More automated, less configuration needed

BunkerOS uses **auto-cpufreq** instead of:- **laptop-mode-tools** - Modern, actively maintained

- **TLP** - More automated, less configuration needed- **cpupower** - Automatic switching vs manual configuration

- **laptop-mode-tools** - Modern, actively maintained- **powertop** - Focused on optimization vs just monitoring

- **cpupower** - Automatic switching vs manual configuration

- **powertop** - Focused on optimization vs just monitoring## Additional Resources



## Additional Resources- [auto-cpufreq GitHub](https://github.com/AdnanHodzic/auto-cpufreq)

- [auto-cpufreq Documentation](https://github.com/AdnanHodzic/auto-cpufreq#readme)

- [auto-cpufreq GitHub](https://github.com/AdnanHodzic/auto-cpufreq)
- [auto-cpufreq Documentation](https://github.com/AdnanHodzic/auto-cpufreq#readme)
