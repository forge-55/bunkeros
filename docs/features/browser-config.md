# BunkerOS Browser Strategy

This document outlines BunkerOS's browser decisions and the rationale behind them.

## TL;DR

- **Default Browser**: Brave (privacy + containerized web apps + polished UX)
- **Included Alternative**: Firefox (independent engine, user choice)
- **User Flexibility**: Easy to switch or install other browsers

## Decision Summary

BunkerOS ships with **Brave** as the default browser, with **Firefox** also pre-installed but not set as default.

## Rationale

### 1. Web App Manager Compatibility

BunkerOS's Web App Manager is a core productivity feature that allows users to install any website as a containerized desktop application. This feature requires:

- Proper app mode with window isolation
- Custom window titles and classes
- Separate browser profiles per app
- Native PWA (Progressive Web App) support
- Seamless integration with Sway's tiling system

**Chromium-based browsers excel at this:**

| Feature | Chromium-based (Brave) | Firefox |
|---------|----------------|---------|
| App Mode Window Isolation | ✅ Excellent | ⚠️ Limited |
| Custom Window Titles | ✅ Full support | ⚠️ Partial |
| Profile Separation | ✅ Complete | ⚠️ Shared context |
| PWA Installation | ✅ Native | ⚠️ Addon required |
| Wayland Screen Sharing | ✅ Excellent (with flags) | ✅ Good |
| Integration with Sway | ✅ Perfect tiling | ✅ Works well |

By defaulting to Brave (a Chromium-based browser), BunkerOS ensures containerized web apps work seamlessly out of the box.

### 2. Privacy Focus

**Why Brave specifically?**

Brave provides excellent privacy protection with a polished user experience:

- ✅ All Google telemetry removed
- ✅ Built-in ad blocking (no extensions needed)
- ✅ Built-in tracker blocking
- ✅ Optional privacy features (Brave Shields, fingerprint protection)
- ✅ Open source and auditable
- ✅ Fast commercial updates
- ✅ Optional Brave Rewards (can be disabled)

This gives users the technical advantages of Chromium (containerized web app support, performance, standards compliance) with built-in privacy protection and a more polished experience than community-driven alternatives.

### 3. User Choice and Flexibility

BunkerOS prioritizes **working defaults with user control**:

**Firefox is Also Installed**:
- Pre-installed during BunkerOS setup
- Available immediately in app launcher
- Easy to set as default if preferred
- Independent rendering engine (not Chromium-based)
- Mozilla's privacy focus and values
- Container tabs for multi-account workflows

**Other Browsers Available**:
Users can easily install:
- **Ungoogled Chromium** (community-driven, no Google services)
- **Google Chrome** (official Google browser)
- **Chromium** (open source base)
- **Vivaldi** (feature-rich Chromium variant)
- **Firefox Developer Edition** (web development tools)

**Changing Your Default Browser**:
```bash
# Set Brave as default (default)
xdg-settings set default-web-browser brave-browser.desktop

# Set Firefox as default
xdg-settings set default-web-browser firefox.desktop

# Set Ungoogled Chromium as default
xdg-settings set default-web-browser ungoogled-chromium.desktop

# Set Chrome as default
xdg-settings set default-web-browser google-chrome.desktop
```

## User Scenarios

### Scenario 1: User Wants Privacy + Containerized Web Apps + Polished UX

**Recommended**: Brave (default)
- No Google telemetry
- Built-in ad and tracker blocking
- Full containerized web app support
- Excellent Wayland integration
- Fast commercial updates

### Scenario 2: User Wants Pure FOSS, No Commercial Products

**Recommended**: Switch to Ungoogled Chromium
```bash
yay -S ungoogled-chromium
xdg-settings set default-web-browser ungoogled-chromium.desktop
```
- Community-driven
- No commercial entity
- Full containerized web app support
- Slower updates than Brave

### Scenario 2: User Wants Pure FOSS, No Commercial Products

**Recommended**: Switch to Ungoogled Chromium
```bash
yay -S ungoogled-chromium
xdg-settings set default-web-browser ungoogled-chromium.desktop
```
- Community-driven
- No commercial entity
- Full containerized web app support
- Slower updates than Brave

### Scenario 3: User Doesn't Care About Containerized Web Apps

**Recommended**: Switch to Firefox
```bash
xdg-settings set default-web-browser firefox.desktop
```
- Independent rendering engine
- Mozilla's privacy focus
- Container tabs for multi-account workflows
- No dependency on Chromium ecosystem
- **Note**: Containerized web apps will have limited isolation

### Scenario 4: User Wants Google Integration

**Recommended**: Install Chrome
```bash
# Google Chrome (Google integration + sync)
yay -S google-chrome
xdg-settings set default-web-browser google-chrome.desktop
```

### Scenario 5: Developer Needs Latest Web Standards

**Recommended**: Firefox Developer Edition or Chrome
```bash
# Firefox Developer Edition
sudo pacman -S firefox-developer-edition

# Google Chrome (often has latest features first)
yay -S google-chrome
```

### Scenario 4: Developer Needs Latest Web Standards

**Recommended**: Firefox Developer Edition or Chrome
```bash
# Firefox Developer Edition
sudo pacman -S firefox-developer-edition

# Google Chrome (often has latest features first)
yay -S google-chrome
```

## Technical Implementation

### Default Configuration

**System-wide default** (set during installation):
```bash
xdg-settings set default-web-browser brave-browser.desktop
```

**Sway keybinding** (Super+b):
```sway
bindsym $mod+b exec xdg-open https://
```
This respects the user's XDG default browser setting.

### Wayland Configuration

BunkerOS automatically configures Chromium-based browsers for optimal Wayland support:

**Script**: `scripts/configure-browser-wayland.sh`

**Enables**:
- Native Wayland rendering (`--ozone-platform=wayland`)
- PipeWire screen sharing
- Proper HiDPI scaling
- Optimal performance flags

**Configured browsers**:
- Brave
- Ungoogled Chromium
- Chrome
- Chromium
- Edge
- Vivaldi

### Web App Manager Integration

**Script**: `webapp/bin/webapp-install`

**Browser Detection Order**:
1. Check user's XDG default browser
2. Fall back to installed browser detection:
   - Brave
   - Google Chrome
   - Chromium
   - Ungoogled Chromium
   - Firefox

**App Mode Flags**:
```bash
# Chromium-based browsers
--app="$URL" --class=WebApp-$NAME

# Firefox (limited mode)
--new-window --class="WebApp-$NAME" "$URL"
```

## Philosophy Alignment

This browser strategy aligns with BunkerOS's core principles:

1. **Productivity First**: Containerized web apps work seamlessly out of the box
2. **Privacy-Focused**: Brave has built-in ad/tracker blocking, no Google telemetry
3. **User Control**: Easy to switch browsers based on preference
4. **Informed Defaults**: Documentation explains the "why"
5. **Flexibility**: Support for all major browsers
6. **Polished Experience**: Professional UX for all user levels

## Future Considerations

### Potential Browser Additions

**Nyxt Browser** (Lisp-based, keyboard-driven):
- Aligns with BunkerOS's keyboard-focused philosophy
- Extremely customizable
- Currently niche, but interesting for power users

**Ungoogled Chromium as default** (alternative approach):
- Pure community-driven
- No commercial entity
- Requires extensions for ad blocking
- Slower update cycle

**Why not Firefox as default?**
- Firefox is excellent, but containerized web app support is limited
- BunkerOS prioritizes features that work seamlessly out of the box
- Firefox remains installed for users who prefer it
- Independent engine diversity is valuable (users can choose)

## Documentation References

This browser strategy is documented in:

- **ARCHITECTURE.md** - Technical rationale and comparison table
- **DEFAULT-APPS.md** - How to change your default browser
- **INSTALL.md** - Installation instructions for browsers
- **README.md** - Quick reference for browser keybinding
- **webapp/README.md** - Web App Manager browser compatibility
- **BROWSER-STRATEGY.md** - This comprehensive overview

## Feedback and Changes

This decision is documented for transparency. If you believe a different default would better serve BunkerOS users:

1. Open a GitHub Discussion explaining your reasoning
2. Consider the Web App Manager use case
3. Propose alternative solutions for containerized web apps
4. Engage with the community

BunkerOS values informed defaults and user choice. This strategy attempts to balance both.

---

**Last Updated**: October 2025  
**Status**: Active Strategy  
**Review Cycle**: Annually or when major browser changes occur
