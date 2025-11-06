# Chrome/Chromium Rounded Corners Fix

## Problem
Chrome and Chromium-based browsers (Brave, Edge, Chromium, etc.) use GTK decorations with rounded corners on Linux, which creates a visual mismatch with Sway's square window borders.

## Solution
BunkerOS includes a GTK CSS override that forces all GTK window decorations to use square corners (border-radius: 0).

## What's Fixed
- ✅ Chrome
- ✅ Chromium
- ✅ Brave Browser
- ✅ Vivaldi
- ✅ Any other Chromium-based browser using GTK decorations

## How It Works
The fix is applied in both `gtk-3.0/gtk.css` and `gtk-4.0/gtk.css`:

```css
decoration,
window {
    border-radius: 0 !important;
}

.titlebar,
headerbar {
    border-radius: 0 !important;
}
```

This removes rounded corners from all GTK window decorations system-wide, ensuring visual consistency across your entire BunkerOS desktop.

## Applying the Fix
The fix is automatically applied when you run:
```bash
./gtk-3.0/install.sh
./gtk-4.0/install.sh
```

After installation, **restart your browser** to see the square corners.

## Why Not Use SwayFX?
SwayFX adds rounded corners to the compositor itself, but BunkerOS maintains vanilla Sway for stability and simplicity. This GTK CSS approach gives us visual consistency without requiring a fork of Sway.
