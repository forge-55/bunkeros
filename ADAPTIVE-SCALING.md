# BunkerOS Adaptive Display Scaling

BunkerOS includes an **automatic** display scaling system that detects your hardware and applies optimal font sizes and scaling **immediately on first login**. No user interaction required - it just works, similar to Pop_OS!/COSMIC.

## How It Works

The system runs automatically when you start a Sway session and consists of three main components:

### 1. Hardware Detection (`detect-display-hardware.sh`)
- Automatically detects display resolution, DPI, and physical dimensions
- Identifies GPU capabilities for edition recommendations
- Classifies hardware into device types:
  - `standard-laptop` - ThinkPad T480, older laptops with standard displays
  - `high-dpi-laptop` - Modern laptops with high-resolution screens
  - `standard-monitor` - 1920x1080, 1680x1050 external monitors
  - `ultrawide-monitor` - 3440x1440, 3840x1600 ultrawide displays  
  - `high-dpi-monitor` - 4K and high-DPI external monitors

### 2. Auto-Scaling Service (`auto-scaling-service.sh`)
- **Runs automatically on every Sway session start**
- Applies optimal scaling settings silently in background
- Updates font sizes across all BunkerOS components:
  - Foot terminal font size
  - Waybar status bar fonts
  - Wofi application launcher fonts
  - Wayland output scaling (when beneficial)
- Caches results to prevent unnecessary re-processing
- **Zero user interaction required**

### 3. Manual Configuration (`configure-display-scaling.sh`)
- Available for manual overrides and fine-tuning
- Provides interactive mode for advanced users
- Creates backup of existing configurations

## Usage

### Automatic Operation (Default)
**The system works automatically with zero configuration needed.**

When you first login to BunkerOS:
1. Sway starts and launches the auto-scaling service
2. Service detects your display hardware (resolution, DPI, type)
3. Optimal font sizes are calculated and applied immediately
4. Waybar restarts with new settings
5. All future terminals open with correct font sizes

**That's it!** Your system is now optimized for your hardware.

### Manual Configuration
```bash
# Set specific scaling factor
./scripts/configure-display-scaling.sh --manual-scale 1.25

# Set specific font sizes
./scripts/configure-display-scaling.sh --foot-font 12 --waybar-font 16

# Interactive mode for fine-tuning
./scripts/configure-display-scaling.sh --interactive
```

### Hardware Detection Only
```bash
# View hardware analysis without applying changes
./scripts/detect-display-hardware.sh

# Get configuration variables for scripting
./scripts/detect-display-hardware.sh --config-vars

# JSON output for integration
./scripts/detect-display-hardware.sh --json
```

## Configuration Profiles

### ThinkPad T480 (1366x768, Standard Laptop)
- **Wayland scaling**: 1.0x
- **Terminal font**: 11pt
- **UI fonts**: 15pt waybar, 16pt wofi
- **Edition**: Standard (optimized for Intel UHD 620)

### LG Ultrawide (3440x1440, Ultrawide Monitor)
- **Wayland scaling**: 1.0x
- **Terminal font**: 12pt
- **UI fonts**: 16pt waybar, 17pt wofi
- **Edition**: Enhanced or Standard (based on GPU)

### 4K Monitor (3840x2160, High-DPI Monitor)
- **Wayland scaling**: 1.75x
- **Terminal font**: 11pt
- **UI fonts**: 16pt waybar, 17pt wofi
- **Edition**: Enhanced (requires capable GPU)

### Modern Laptop (2560x1440, High-DPI Laptop)
- **Wayland scaling**: 1.5x
- **Terminal font**: 9pt
- **UI fonts**: 14pt waybar, 15pt wofi
- **Edition**: Enhanced

## Integration

### Setup Process
The adaptive scaling system is automatically integrated into `setup.sh` at Step 11.8. During initial installation, BunkerOS will:

1. Detect your display hardware
2. Calculate optimal scaling settings
3. Apply configuration to all components
4. Create a scaling profile for future reference

### Quick Actions Menu
Access display scaling configuration via:
- **Super+M** → System → Display Scaling
- Interactive terminal interface for real-time adjustments

### Manual Reconfiguration
Run the configuration script anytime to:
- Adjust settings for new hardware
- Fine-tune existing configuration
- Switch between automatic and manual modes

## Technical Details

### DPI Calculation
- Uses display resolution and physical dimensions when available
- Falls back to resolution-based estimation for unknown displays
- Accounts for common display sizes (24", 27", 34" monitors)

### Font Size Logic
- **Terminal**: Prioritizes readability for extended coding sessions
- **UI Elements**: Balances information density with usability
- **Scaling Factor**: Applied when text scaling alone isn't sufficient

### GPU Detection
Recommends BunkerOS edition based on graphics capabilities:
- **Enhanced**: Modern GPUs (GTX 1050+, RX 500+, Intel Xe)
- **Standard**: Older or integrated graphics for optimal performance

### Backup System
- All configuration changes are backed up to `~/.config/bunkeros-backups/`
- Timestamped backups allow easy restoration
- Original settings preserved for rollback

## Troubleshooting

### Font Too Small/Large
```bash
# Increase all font sizes by ~15%
./scripts/configure-display-scaling.sh --foot-font 14 --waybar-font 18 --wofi-font 19

# Or use interactive mode for precise control
./scripts/configure-display-scaling.sh --interactive
```

### Wayland Scaling Issues
```bash
# Disable Wayland scaling, use font scaling only
./scripts/configure-display-scaling.sh --manual-scale 1.0

# Force specific scaling
./scripts/configure-display-scaling.sh --manual-scale 1.25
```

### Restore Defaults
```bash
# Find your backup
ls ~/.config/bunkeros-backups/

# Manually restore from backup directory
cp ~/.config/bunkeros-backups/scaling-YYYYMMDD-HHMMSS/* ~/.config/
```

### Different Scaling Per Monitor
The current system applies global scaling. For per-monitor scaling:
```bash
# Edit sway config manually for specific outputs
vim ~/.config/sway/config

# Add output-specific scaling
output HDMI-A-1 scale 1.25
output eDP-1 scale 1.0
```

## Hardware Examples

### Tested Configurations

**ThinkPad T480 (Intel UHD 620)**
- Resolution: 1366x768
- Result: Standard Edition, larger fonts for readability
- Performance: Optimal with visual effects disabled

**LG 34" Ultrawide (AMD HawkPoint)**  
- Resolution: 3440x1440
- Result: Larger fonts, Standard/Enhanced based on GPU
- Performance: Smooth with appropriate edition selection

**Dell XPS 13 (Intel Iris)**
- Resolution: 2560x1600
- Result: 1.5x scaling, Enhanced Edition
- Performance: Excellent with modern integrated graphics

## Pop_OS!/COSMIC Comparison

BunkerOS adaptive scaling provides similar benefits to Pop_OS!/COSMIC:

✅ **Automatic hardware detection**  
✅ **Intelligent scaling recommendations**  
✅ **Per-component font optimization**  
✅ **Manual override capabilities**  
✅ **Seamless hardware transitions**  

**BunkerOS Advantages:**
- Lightweight, shell-based implementation
- Integrated with existing theme system
- Tactical/minimalist design philosophy maintained
- Compatible with both Standard and Enhanced editions

This system ensures BunkerOS provides excellent hardware compatibility across the full spectrum of devices, from vintage ThinkPads to modern ultrawide workstations.