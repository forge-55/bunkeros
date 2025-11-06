#!/bin/bash
# Launch Google Chrome with BunkerOS settings (no rounded corners)
# This ensures flags are applied even if chrome-flags.conf fails to load

exec google-chrome-stable \
    --disable-features=WebUITabStrip,ChromeRefresh2023 \
    --enable-features=UseOzonePlatform,WebUIDarkMode,WaylandWindowDecorations \
    --ozone-platform=wayland \
    --enable-wayland-ime \
    --force-dark-mode \
    --gtk-version=4 \
    "$@"
