# BunkerOS Screensaver

**Tactical ASCII art screensaver with subdued terminal animations.**

---

## Overview

BunkerOS includes an elegant terminal-based screensaver that displays the BunkerOS wordmark with smooth, cycling animations. Inspired by classic terminal aesthetics but refined for BunkerOS's tactical design philosophy, the screensaver provides visual interest during idle periods without the flashy excess of traditional screensavers.

### Features

- **Terminal-native** - Runs in Foot terminal, no GUI overhead
- **Tactical aesthetic** - Khaki/olive color palette matching BunkerOS theme
- **Cycling animations** - 6 subdued effects rotate every 10 seconds
- **Automatic activation** - Triggers after 10 minutes of inactivity
- **Manual trigger** - Launch instantly from power menu or quick actions
- **Zero configuration** - Works out-of-box after setup
- **Customizable** - Easy to modify ASCII art or animation effects

---

## Usage

### Manual Activation

Trigger the screensaver manually from two locations:

**Power Menu** (via Waybar clock):
1. Click the clock in Waybar
2. Select "󰔎 Screensaver"

**Quick Actions Menu**:
1. Press `Super+M` (or `Super+Alt+Space`)
2. Select "󰔎 Screensaver"

**Exit**: Press any key or move the mouse to dismiss the screensaver.

### Automatic Activation

The screensaver automatically activates after **5 minutes (300 seconds)** of keyboard/mouse inactivity. The system will then suspend after **10 minutes (600 seconds)** of total inactivity (5 minutes after the screensaver starts). This is managed by `swayidle` in your Sway configuration.

**Preventing automatic activation**:
- Fullscreen applications (videos, presentations) automatically inhibit the screensaver
- No manual intervention needed during video playback or presentations

---

## Technical Details

### Components

The screensaver system consists of three main components:

**1. ASCII Art File** (`~/.config/bunkeros/screensaver/screensaver.txt`)
```
╭────────────────────────────────────────────────────────────────╮
│                                                                │
│         ██████╗ ██╗   ██╗███╗   ██╗██╗  ██╗███████╗██████╗   │
│         ██╔══██╗██║   ██║████╗  ██║██║ ██╔╝██╔════╝██╔══██╗  │
│         ██████╔╝██║   ██║██╔██╗ ██║█████╔╝ █████╗  ██████╔╝  │
│         ██╔══██╗██║   ██║██║╚██╗██║██╔═██╗ ██╔══╝  ██╔══██╗  │
│         ██████╔╝╚██████╔╝██║ ╚████║██║  ██╗███████╗██║  ██║  │
│         ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝  │
│                                                                │
│                  ╔══════════════════════════╗                 │
│                  ║   [ STANDBY MODE ]       ║                 │
│                  ╚══════════════════════════╝                 │
│                                                                │
│                      Mission-Focused Computing                │
│                                                                │
╰────────────────────────────────────────────────────────────────╯
```

**2. Screensaver Command Script** (`scripts/bunkeros-screensaver.sh`)
- Cycles through 6 terminal text effects using TerminalTextEffects (TTE)
- Each effect runs for 10 seconds before transitioning
- Uses tactical color palette (khaki #C3B091, olive #4A5240, off-white #D4D4D4)

**3. Launch Script** (`scripts/launch-screensaver.sh`)
- Launches Foot terminal in fullscreen with `BunkerOS-Screensaver` app-id
- Sway window rules ensure proper fullscreen behavior
- Exits cleanly on any keypress or mouse movement

### Animation Effects

The screensaver cycles through these subdued effects:

1. **Decrypt** - Characters slowly decode/reveal (tactical, methodical)
2. **Scattered** - Characters scatter from edges and assemble
3. **Slide** - Text slides smoothly into position
4. **Print** - Classic typewriter effect
5. **Swarm** - Characters swarm into formation (order from chaos)
6. **Beams** - Vertical beams reveal text column by column

**Frame rate**: 100 FPS (smooth but not excessive)
**Effect duration**: 10 seconds each
**Total cycle**: 60 seconds before repeating

---

## Customization

### Changing the ASCII Art

Edit `~/.config/bunkeros/screensaver/screensaver.txt` with your preferred ASCII art:

```bash
nano ~/.config/bunkeros/screensaver/screensaver.txt
```

**Tips**:
- Use box-drawing characters (╔╗╚╝─│) for clean frames
- Keep width under 80 characters for compatibility
- Test with `cat ~/.config/bunkeros/screensaver/screensaver.txt` before using

**ASCII art generators**:
- [patorjk.com/software/taag](https://patorjk.com/software/taag/) - Text to ASCII art
- `figlet` - Command-line ASCII art generator
- Manual creation in text editor

### Changing Animation Effects

Edit `scripts/bunkeros-screensaver.sh` to modify effects:

**Add/remove effects** from the `EFFECTS` array:
```bash
EFFECTS=(
    "decrypt --ciphertext-colors C3B091 4A5240 --final-gradient-stops C3B091"
    "scattered --final-gradient-stops C3B091 D4D4D4 --final-gradient-steps 12"
    # Add more effects here
)
```

**Available TTE effects**: Run `tte --help` for full list. Recommended subdued effects:
- `decrypt`, `scattered`, `slide`, `print`, `swarm`, `beams`
- `errorcorrect`, `burn`, `unstable`, `decrypt`

**Effects to avoid** (too flashy for BunkerOS):
- `fireworks`, `rain`, `matrix`, `bouncyballs`, `bubbles`

### Adjusting Timing

**Effect duration** (how long each animation runs):
```bash
EFFECT_DURATION=10  # Change to 5, 15, 20, etc.
```

**Automatic activation timeout** (swayidle):
```bash
# Edit sway/config, line with swayidle
timeout 600 '~/.config/sway-config/scripts/launch-screensaver.sh'
# Change 600 to desired seconds (300=5min, 1200=20min)
```

**Frame rate** (animation smoothness vs. performance):
```bash
FRAME_RATE=100  # Lower for slower machines (60), higher for smoother (120)
```

### Changing Colors

Edit the color values in `scripts/bunkeros-screensaver.sh`:

**Current tactical palette**:
- Primary: `C3B091` (khaki/tan)
- Secondary: `4A5240` (olive)
- Text: `D4D4D4` (off-white)

**Replace with your theme colors**:
```bash
"decrypt --ciphertext-colors YOUR_COLOR_1 YOUR_COLOR_2 --final-gradient-stops YOUR_COLOR_1"
```

Colors use hex format without `#` prefix.

---

## Troubleshooting

### Screensaver doesn't launch

**Check dependencies**:
```bash
which tte  # Should show path to terminaltexteffects
which foot # Should show path to foot terminal
```

**Install missing packages**:
```bash
pipx install terminaltexteffects
sudo pacman -S foot swayidle
```

### ASCII art looks corrupted

**Font issue** - Screensaver requires a monospace font with Unicode box-drawing support:
```bash
sudo pacman -S ttf-meslo-nerd  # Recommended Nerd Font
```

Edit `foot/foot.ini` to ensure proper font configuration.

### Screensaver won't exit

**Force kill**:
```bash
pkill -f bunkeros-screensaver
```

**Check Sway window rules**:
```bash
swaymsg -t get_tree | grep BunkerOS-Screensaver
```

Should show the screensaver window with proper app_id.

### Automatic screensaver not working

**Verify swayidle is running**:
```bash
ps aux | grep swayidle
```

**Check Sway config** - Look for swayidle exec line in `sway/config`:
```bash
grep -A 2 "swayidle" ~/.config/sway/config
```

**Restart Sway** to reload swayidle configuration:
```
Super+Shift+R
```

### Colors don't match theme

TTE uses hex colors without `#` prefix. Check your color values:
```bash
# Tactical theme colors (from sway/colors.conf or theme files)
C3B091  # Primary khaki
4A5240  # Secondary olive
D4D4D4  # Text off-white
```

Update `EFFECTS` array in `scripts/bunkeros-screensaver.sh` with your desired colors.

---

## Performance Considerations

### Resource Usage

**CPU**: Minimal during static display, ~10-15% during transitions
**RAM**: ~20-50 MB (Foot + Python + TTE)
**GPU**: Negligible (terminal rendering only)

**Lower-end hardware optimizations**:
1. Reduce frame rate: `FRAME_RATE=60` (from 100)
2. Increase effect duration: `EFFECT_DURATION=15` (from 10)
3. Use simpler effects: `print`, `slide` only (remove swarm, beams)

### Battery Impact (Laptops)

Screensaver has minimal battery impact compared to active desktop use:
- Terminal rendering is extremely efficient
- No GPU acceleration or compositing overhead
- Consider increasing swayidle timeout on battery: `timeout 300` (5 min)

---

## Technical Architecture

### Why Foot Terminal?

**Foot** was chosen for the screensaver because:
- Lightweight Wayland-native terminal (~2 MB binary)
- Excellent Unicode and box-drawing character support
- Fast startup time (<50ms cold start)
- Minimal dependencies compared to Alacritty or Kitty
- Perfect fullscreen support with Sway window rules

### Why TerminalTextEffects (TTE)?

**TTE** provides:
- Pure Python implementation (easy to modify)
- Terminal-agnostic (works with any ANSI terminal)
- Rich effect library with fine-grained control
- Active development and maintenance
- No GUI dependencies (stays terminal-native)

### Integration with Swayidle

Swayidle monitors keyboard/mouse activity and triggers actions after timeout:
```bash
exec swayidle -w \
    timeout 600 '~/.config/sway-config/scripts/launch-screensaver.sh' \
    resume 'swaymsg "[app_id=BunkerOS-Screensaver]" kill'
```

**Flow**:
1. User idle for 600 seconds → swayidle triggers timeout
2. Launch script starts Foot with screensaver app-id
3. Sway window rules force fullscreen with 100% opacity
4. Screensaver cycles through effects infinitely
5. User activity → swayidle triggers resume
6. Sway kills screensaver window by app-id

---

## Credits and Inspiration

**TerminalTextEffects** by Chris Builds
- GitHub: [ChrisBuilds/terminaltexteffects](https://github.com/ChrisBuilds/terminaltexteffects)
- Provides the animation engine powering BunkerOS screensaver

**Omarchy Linux**
- Inspiration for terminal-based screensaver concept
- Demonstrated the appeal of ASCII art + TTE animations

**BunkerOS Implementation**
- Refined for tactical aesthetic (subdued, professional)
- Integrated with Sway/Foot workflow
- Manual + automatic trigger options

---

## See Also

- **[README.md](../README.md)** - BunkerOS overview and features
- **[sway/config](../sway/config)** - Swayidle configuration and window rules
- **[waybar/scripts/](../waybar/scripts/)** - Power menu and quick actions integration

---

**BunkerOS Screensaver**: Tactical ASCII art for distraction-free idle periods. 🖥️
