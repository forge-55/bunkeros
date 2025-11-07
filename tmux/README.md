# BunkerOS Tmux Configuration

Developer-focused tmux configuration with complete BunkerOS theme integration and productivity plugins.

## ✨ Features

### 🚀 **Developer Productivity**
- **Ctrl+a prefix**: Ergonomic for heavy terminal use (like GNU Screen)
- **Mouse support**: Modern trackpad/mouse integration without losing keyboard speed
- **Large scrollback**: 100,000 lines for long development sessions
- **Vi-style copy mode**: Familiar navigation and selection
- **Smart pane management**: Intuitive splitting with `|` and `-`
- **Session persistence**: Auto-save/restore sessions across reboots

### 🎨 **BunkerOS Theme Integration**
- **All 5 themes supported**: Tactical, Night-Ops, Abyss, Sahara, Winter
- **Dynamic theme switching**: Automatically matches active BunkerOS theme
- **Tactical status bar**: Informative yet minimal design
- **Consistent colors**: Matches Sway, Waybar, and application themes

### 🔧 **Plugin Ecosystem**
- **TPM included**: Tmux Plugin Manager pre-installed
- **Essential plugins**: tmux-sensible, tmux-resurrect, tmux-continuum, tmux-battery
- **Session restoration**: Automatically restore sessions on boot
- **Battery monitoring**: Status bar shows battery level on laptops

## Installation

### Automatic Installation

Run the installation script to set up tmux with BunkerOS defaults:

```bash
cd ~/bunkeros/tmux
./install.sh
```

This will:
- Back up any existing tmux configuration
- Install the BunkerOS tmux configuration
- Provide usage instructions

### Manual Installation

```bash
# Copy the configuration file
cp ~/bunkeros/tmux/tmux.conf.default ~/.tmux.conf

# Reload tmux configuration (if tmux is running)
tmux source-file ~/.tmux.conf
```

## Key Bindings

### Session Management
| Key | Action |
|-----|---------|
| `tmux` | Start new session |
| `tmux attach` | Attach to last session |
| `tmux ls` | List all sessions |
| `Ctrl+a + d` | Detach from session |

### Window Management
| Key | Action |
|-----|---------|
| `Ctrl+a + c` | Create new window |
| `Shift+Left/Right` | Switch between windows |
| `Ctrl+a + &` | Close current window |
| `Ctrl+a + ,` | Rename current window |

### Pane Management
| Key | Action |
|-----|---------|
| `Ctrl+a + \|` | Split pane vertically |
| `Ctrl+a + -` | Split pane horizontally |
| `Alt+Arrow Keys` | Navigate between panes (no prefix needed) |
| `Ctrl+a + x` | Close current pane |
| `Ctrl+a + z` | Toggle pane zoom |

### Copy Mode (Vi-style)
| Key | Action |
|-----|---------|
| `Ctrl+a + [` | Enter copy mode |
| `v` | Begin selection (in copy mode) |
| `y` | Copy selection and exit |
| `Ctrl+a + ]` | Paste |

### Plugin Management
| Key | Action |
|-----|---------|
| `Ctrl+a + I` | Install/update plugins |
| `Ctrl+a + U` | Update plugins |
| `Ctrl+a + alt + u` | Uninstall plugins not in config |

### Configuration
| Key | Action |
|-----|---------|
| `Ctrl+a + r` | Reload configuration |

## Customization

### Theme System

The configuration automatically adapts to all BunkerOS themes:

#### **Tactical** (Default)
- Deep forest greens with vintage lume accents
- Background: `#0A0F0D` | Accent: `#2D4A3E` | Text: `#C8D5C7`

#### **Night-Ops**  
- Meteorite gray with rose gold accents
- Background: `#0D0E10` | Accent: `#4A4E52` | Text: `#E8E6E1`

#### **Abyss**
- Deep ocean blues with sky blue accents  
- Background: `#0A1628` | Accent: `#1E3A5F` | Text: `#E8E6DC`

#### **Sahara** & **Winter**
- Auto-generated color schemes matching theme aesthetics
- Dynamic theme switching without restart required

### Plugin System

BunkerOS tmux comes with essential plugins pre-configured:

#### **Pre-installed Plugins**
- **tmux-sensible**: Better defaults and quality-of-life improvements
- **tmux-resurrect**: Save/restore sessions manually
- **tmux-continuum**: Automatic session saving every 15 minutes
- **tmux-battery**: Battery percentage in status bar

#### **Plugin Installation**
```bash
# Install/update plugins (in tmux)
Ctrl+a + I

# Update plugins  
Ctrl+a + U

# Add new plugins to ~/.tmux.conf
set -g @plugin 'plugin-name'
```

#### **Recommended Additional Plugins**
```bash
# Advanced clipboard integration
set -g @plugin 'tmux-plugins/tmux-yank'

# Tmux and vim navigation integration  
set -g @plugin 'christoomey/vim-tmux-navigator'

# Enhanced search and copy
set -g @plugin 'tmux-plugins/tmux-copycat'
```

### Custom Keybindings

Add custom keybindings to your `~/.tmux.conf`:

```bash
# Example: Add Ctrl+h/j/k/l for pane navigation
bind -n C-h select-pane -L
bind -n C-j select-pane -D
bind -n C-k select-pane -U
bind -n C-l select-pane -R
```

## Integration with BunkerOS

### Terminal Integration

Tmux works seamlessly with the default Foot terminal and can be configured to:
- Auto-start with terminal sessions
- Integrate with Sway workspace management
- Work with BunkerOS screensaver and power management

### Workflow Integration

#### **Development Workflows**
- **Multi-pane coding**: Split terminal for code, tests, logs
- **Session persistence**: Resume work exactly where you left off
- **Large scrollback**: Review long compilation outputs or logs
- **Vi-mode copy**: Efficiently copy/paste code snippets and paths

#### **System Administration**
- **Multiple SSH sessions**: Manage multiple servers in separate panes
- **Monitoring dashboards**: Run htop/btop alongside active work
- **Long-running tasks**: Detach from builds, deployments, backups

#### **BunkerOS Integration**
- **Theme consistency**: Matches current BunkerOS theme automatically  
- **Foot terminal**: Optimized for the default BunkerOS terminal
- **Sway workspace**: Integrates smoothly with tiling window management
- **Power efficiency**: Battery status visible, session saving reduces resource usage

## Troubleshooting

### Configuration Not Loading
```bash
# Verify config file exists and is readable
ls -l ~/.tmux.conf

# Test configuration for errors
tmux source-file ~/.tmux.conf
```

### Plugin Issues
```bash
# Reload TPM plugins
# In tmux, press: Ctrl+a + I
```

### Color Issues
```bash
# Check terminal capabilities
echo $TERM
infocmp $TERM

# Test 256 color support
for i in {0..255}; do printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"; if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then printf "\n"; fi; done
```

## 🚀 Advanced Usage

### Session Templates for Developers

#### **Full-Stack Development Session**
```bash
#!/bin/bash
# Create a full-stack development environment
tmux new-session -d -s fullstack
tmux rename-window 'main'

# Split into 4 panes: code, server, database, tests
tmux split-window -h
tmux split-window -v  
tmux select-pane -t 0
tmux split-window -v

# Setup each pane
tmux send-keys -t 0 'cd ~/project && code .' Enter
tmux send-keys -t 1 'cd ~/project && npm run dev' Enter  
tmux send-keys -t 2 'cd ~/project && npm run test:watch' Enter
tmux send-keys -t 3 'sudo systemctl status postgresql' Enter

# Focus on code pane
tmux select-pane -t 0
tmux attach-session -s fullstack
```

#### **System Administration Session**
```bash
#!/bin/bash
# System monitoring and management session
tmux new-session -d -s sysadmin

# Window 1: System overview
tmux rename-window 'overview'
tmux split-window -h
tmux send-keys -t 0 'btop' Enter
tmux send-keys -t 1 'journalctl -f' Enter

# Window 2: Network monitoring  
tmux new-window -n 'network'
tmux send-keys 'sudo nethogs' Enter

# Window 3: Package management
tmux new-window -n 'packages'
tmux send-keys 'sudo pacman -Syu' Enter

tmux select-window -t overview
tmux attach-session -s sysadmin
```

### Session Restoration

With `tmux-resurrect` and `tmux-continuum`:

```bash
# Sessions automatically save every 15 minutes
# Restore last saved session
Ctrl+a + Ctrl+r

# Save session manually  
Ctrl+a + Ctrl+s

# Sessions restore automatically on boot (after plugin setup)
```

For more advanced configurations and tips, see the [tmux documentation](https://github.com/tmux/tmux/wiki).