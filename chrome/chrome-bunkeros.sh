#!/bin/bash
# Launch Google Chrome with BunkerOS settings (no rounded corners)
# This ensures flags are applied even if chrome-flags.conf fails to load

exec google-chrome-stable \
    --disable-features=WebUITabStrip,ChromeRefresh2023 \
    --force-dark-mode \
    --enable-features=WebUIDarkMode \
    --ozone-platform-hint=auto \
    "$@"
