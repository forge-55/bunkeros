# BunkerOS Menu Icon System

## Design Philosophy

BunkerOS uses a **consistent, professional icon system** based on Nerd Fonts. This creates a cohesive, tactical aesthetic that aligns with the BunkerOS brand.

### Design Principles

1. **Nerd Font Icons Only** - No emoji mixing for professional appearance
2. **Consistent Spacing** - Two spaces after every icon
3. **Visual Hierarchy** - Icons help users scan and navigate quickly
4. **Tactical Aesthetic** - Icons support the military/technical theme

## Main Menu Icons

| Icon | Label | Meaning |
|------|-------|---------|
| 󰏘 | Appearance | Visual customization (theme/palette) |
| 󰒓 | System | System controls and hardware |
| 󰏖 | Install | Package/software installation |
| 󰄀 | Screenshot | Screen capture utility |
| 󰀉 | Preferences | User preferences and personalization |
| 󰐥 | Power | Power management options |

## Appearance Menu

| Icon | Label | Meaning |
|------|-------|---------|
| 󰏘 | Theme | Color scheme selection |
| 󰖔 | Night Mode | Blue light filter toggle |
| 󰹑 | Window Gaps | Spacing between windows |
| 󰂚 | Opacity | Window transparency control |

### Window Gaps Submenu

| Icon | Label | Meaning |
|------|-------|---------|
| 󰹑 | Toggle Gaps | Enable/disable gaps |
| 󰙵 | Increase Gaps | Make gaps larger |
| 󰙴 | Decrease Gaps | Make gaps smaller |

### Opacity Submenu

| Icon | Label | Meaning |
|------|-------|---------|
| 󰂚 | Increase Opacity | More opaque |
| 󰂙 | Decrease Opacity | More transparent |

## System Menu

| Icon | Label | Meaning |
|------|-------|---------|
| 󰖩 | Network | Network configuration |
| 󰂯 | Bluetooth | Bluetooth management |
| 󰕾 | Audio | Sound settings |
| 󰍹 | Display | Monitor configuration |
| 󰹑 | Display Scaling | HiDPI/scaling settings |
| 󰍛 | Monitor | System resource monitor |

## Install Menu

| Icon | Label | Meaning |
|------|-------|---------|
| 󰏖 | Arch Packages | Official Arch repository |
| 󰣇 | AUR Packages | Arch User Repository |
| 󰖟 | Web Apps | Progressive web apps |

## Preferences Menu

| Icon | Label | Meaning |
|------|-------|---------|
| 󰒓 | Default Apps | Configure default applications |
| 󰌌 | Keybindings | Keyboard shortcut manager |
| 󰹳 | Autotiling | Automatic window tiling |
| 󰑓 | Reload Config | Refresh Sway configuration |

## Default Apps Menu

| Icon | Label | Meaning |
|------|-------|---------|
| 󰆍 | Terminal | Terminal emulator |
| 󰷉 | Editor | Code/text editor |
| 󰉋 | File Manager | File browser |
| 󰠮 | Notes | Note-taking application |

### App Selection Indicators

| Icon | Label | Meaning |
|------|-------|---------|
| 󰄬 | ✓ Current | Currently selected app |
| (spaces) | Available | Selectable option |

## Power Menu

| Icon | Label | Meaning |
|------|-------|---------|
| 󰌾 | Screensaver | Lock screen with screensaver |
| 󰐥 | Shutdown | Power off system |
| 󰜉 | Reboot | Restart system |
| 󰤄 | Suspend | Sleep mode |
| 󰍃 | Logout | Exit Sway session |

## Navigation Icons

| Icon | Label | Usage |
|------|-------|-------|
| 󰌑 | Back | Return to previous menu |

## Icon Design Guidelines

### When Adding New Menu Items

1. **Search Nerd Fonts** - Find appropriate icon at [nerdfonts.com](https://www.nerdfonts.com/cheat-sheet)
2. **Test Visibility** - Ensure icon renders correctly in wofi
3. **Maintain Spacing** - Always use two spaces after icons
4. **Update This Doc** - Keep this reference up-to-date

### Icon Selection Criteria

- **Clarity**: Icon meaning should be obvious
- **Distinctiveness**: Avoid similar-looking icons
- **Consistency**: Use same icon for same concept across menus
- **Professionalism**: Avoid novelty or cartoon-style icons

### Spacing Rules

```bash
# Correct format
options="󰏘  Theme\n󰖔  Night Mode\n󰹑  Window Gaps"

# Wrong format (inconsistent spacing)
options="󰏘 Theme\n󰖔   Night Mode\n󰹑  Window Gaps"
```

### Width Guidelines

| Menu Type | Width | Use Case |
|-----------|-------|----------|
| Main Menu | 220px | Primary navigation |
| Standard Submenu | 220px | Most submenus |
| System Menu | 240px | Longer labels (Display Scaling) |
| Default Apps | 450px | Shows current app names |
| App Selection | 320px | App picker lists |

## Color Integration

Icons inherit color from the active theme:
- **Tactical**: Khaki/olive tones (#C3B091)
- **Gruvbox**: Warm earthy colors
- **Nord**: Cool blues and grays
- **Everforest**: Soft greens
- **Tokyo Night**: Neon purples/blues

## Technical Notes

### Nerd Font Requirements

BunkerOS requires a Nerd Font to be installed for icons to render correctly. Recommended fonts:
- JetBrainsMono Nerd Font
- FiraCode Nerd Font
- Hack Nerd Font

### Wofi Configuration

Icons are rendered through wofi's GTK+ integration. The font must support the Unicode ranges used by Nerd Fonts (U+E000-U+F8FF).

### Testing Icons

```bash
# Test icon rendering in wofi
echo -e "󰏘  Test Icon 1\n󰒓  Test Icon 2" | wofi --dmenu --prompt "Icon Test"
```

## Future Considerations

As BunkerOS grows, maintain this icon system by:
- Adding new icons to this reference document
- Keeping spacing consistent
- Avoiding icon duplication across different contexts
- Periodically reviewing for visual consistency

## Quick Reference Card

```
󰏘 Theme      󰒓 System     󰏖 Install
󰖔 Night      󰖩 Network    󰀉 Prefs
󰹑 Gaps       󰂯 Bluetooth  󰖟 Web Apps
󰂚 Opacity    󰕾 Audio      󰌌 Keybinds
󰐥 Power      󰍹 Display    󰄬 Selected
             󰍛 Monitor    󰌑 Back
```

---

**Last Updated**: October 2025  
**Maintained By**: BunkerOS Project
