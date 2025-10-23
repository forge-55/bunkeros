# BunkerOS Effects Configuration Strategy

## Philosophy

BunkerOS provides a **performance-first visual design** with optional enhancements for capable hardware. The default minimal effects configuration works excellently on all hardware while maintaining a modern, professional appearance.

## Default Configuration (Minimal Effects)

### Design Goals
- Zero visual flutter or stutter
- Instant window transitions
- Maximum responsiveness
- Modern, clean aesthetic with rounded corners
- Minimal GPU overhead (~5-10% during rendering)
- Memory usage: ~332 MB RAM at idle

### Visual Characteristics
- **Rounded corners** (6px) - Negligible performance impact
- **No shadows** - Eliminates workspace switching flicker
- **No blur effects** - Prevents GPU lag during rapid updates
- **No dim inactive** - Avoids visual flickering on Intel GPUs
- **No animations** - Instant, responsive feel
- Clean, tactical color scheme with excellent contrast
- Professional appearance optimized for productivity

### Target Hardware
- **All systems** (2012+)
- Intel HD/UHD integrated graphics (HD 520, UHD 620, etc.)
- ThinkPad T400-T490 series
- Any hardware prioritizing performance and stability
- Battery-focused laptop use

### Performance Profile
- RAM: ~332 MB at idle
- GPU: 2-5% idle, 15-20% during window operations
- Zero workspace switching delay
- Instant response to all actions

## Optional Enhanced Mode

### Design Goals
- Maximum visual polish within tactical aesthetic
- Hyprland-competitive visuals for capable hardware
- Showcase SwayFX capabilities
- Smooth animations and transitions
- Beautiful without being distracting
- Memory usage: ~360-380 MB RAM at idle

### Visual Characteristics
- **Rounded corners** (8px windows, 12px floating)
- **Window shadows** for depth and hierarchy
- **Blur effects** on bars, menus, and windows
- **Smooth animations** for workspace transitions
- **Fade effects** for window focus changes
- **Dim inactive** windows for focus clarity
- Modern, polished aesthetic

### Target Hardware
- **Modern systems** (2020+)
- Intel Iris Xe (11th gen+)
- AMD Vega 6/8+ (Ryzen 4000+)
- NVIDIA GTX 1050 or newer
- ThinkPad T14 Gen 2+
- Desktop systems with discrete GPUs

### Performance Profile
- RAM: ~360-380 MB at idle
- GPU: 8-12% idle, 25-35% during window operations
- Smooth on capable hardware
- May show flicker on Intel UHD 620 + Electron apps during workspace switching

### Enabling Enhanced Mode

```bash
~/Projects/bunkeros/scripts/toggle-swayfx-mode.sh
```

This script:
- Swaps between minimal and enhanced effects configurations
- Reloads Sway without logout
- Persists choice across reboots

## Strategic Decision: Performance First

### The Core Principle
**We optimize for performance by default, with optional enhancements for capable hardware.**

### Why This Matters

**Reasoning:**
- Rounded corners alone provide modern appearance with ~0% performance overhead
- Shadows and blur are the primary performance drains
- Intel integrated GPUs (majority of laptops) struggle with heavy effects during workspace switching
- Users with modern GPUs can enable effects anytime with toggle script
- Default configuration works excellently on all hardware

**Benefits:**
- New users get fast, responsive system out-of-the-box
- No hardware-specific installation decisions
- Modern appearance without performance compromise
- Power users can enable effects after installation
- Single unified configuration and session file

## Hardware Guidelines

### Minimal Effects Recommended (Default)
- Intel HD 5xx/6xx series (UHD 620, etc.)
- AMD pre-Vega integrated graphics
- ThinkPad T series: T400-T490
- Systems from 2012-2019
- Any laptop prioritizing battery life
- Fanless/low-power systems
- Production environments requiring stability

### Enhanced Effects Optional
- Intel Iris Xe (11th gen+)
- AMD Vega 6/8+ (Ryzen 4000+)
- NVIDIA GTX 1050 or newer
- ThinkPad T series: T14 Gen 2+
- Desktop systems with discrete GPUs
- Systems from 2020+
- Gaming laptops
- Presentation/demo systems

## User Experience

### Switching Between Editions
Both editions share:
- ✅ Same configuration files
- ✅ Same keybindings
- ✅ Same themes
- ✅ Same workflow
- ✅ Same features
- ✅ Zero relearning curve

The **only** difference:
- Standard: Visual effects OFF
- Enhanced: Visual effects ON

Switch at login screen - try both and pick what works best for your hardware!

### Testing Your Hardware

**How to Know Which Edition to Use:**

1. Try Enhanced first
2. Switch workspaces a few times
3. Open/close windows
4. Notice any flutter or stutter?

**If smooth:** Keep using Enhanced!  
**If flutter:** Switch to Standard - no shame, it's designed for your hardware.

## Future Direction

### Standard Edition
- Maintain zero-overhead performance
- Keep clean, professional aesthetic
- Focus on stability and responsiveness
- No visual effects added

### Enhanced Edition
- May add more effects for modern GPUs
- Could introduce additional animations
- Showcase new SwayFX features
- Keep pushing visual boundaries
- Target: Match or exceed Hyprland visuals

## For Contributors

When adding features:

### If It's a Visual Effect:
- Add to Enhanced edition only
- Don't worry about older GPU performance
- Make it look amazing on modern hardware
- Document GPU requirements if intensive

### If It's Core Functionality:
- Add to both editions (shared config)
- Ensure works on all hardware
- Test on both T480 and modern systems
- Performance impact should be minimal

## Documentation

When documenting BunkerOS:
- Clearly state hardware requirements
- Show both editions in screenshots
- Explain the strategic difference
- Guide users to appropriate edition
- Don't apologize for targeting modern GPUs

## Summary

**Two editions. Two audiences. Zero compromise.**

Standard = Maximum performance for older hardware  
Enhanced = Maximum visual polish for modern hardware

Both are first-class experiences. Pick the one that matches your hardware.

