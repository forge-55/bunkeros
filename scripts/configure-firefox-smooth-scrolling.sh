#!/bin/bash
# Firefox Smooth Scrolling Optimization for BunkerOS
# Adds subtle, professional smooth scrolling without performance impact

echo "Configuring Firefox for BunkerOS smooth scrolling..."

# Find Firefox profile
PROFILE=$(find ~/.mozilla/firefox -maxdepth 1 -name "*.default*" -type d | head -1)

if [ -z "$PROFILE" ]; then
    echo "❌ No Firefox profile found. Launch Firefox first, then run this script."
    exit 1
fi

USER_JS="$PROFILE/user.js"

# Create user.js with smooth scrolling preferences
cat > "$USER_JS" << 'EOF'
// BunkerOS Firefox Configuration - Smooth Scrolling
// These settings enable subtle, professional smooth scrolling

// Enable smooth scrolling
user_pref("general.smoothScroll", true);
user_pref("general.smoothScroll.lines", true);
user_pref("general.smoothScroll.pages", true);
user_pref("general.smoothScroll.mouseWheel", true);

// Optimize for speed (not slow animations)
user_pref("general.smoothScroll.lines.durationMaxMS", 150);
user_pref("general.smoothScroll.lines.durationMinMS", 100);
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 200);
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 100);
user_pref("general.smoothScroll.pages.durationMaxMS", 150);
user_pref("general.smoothScroll.pages.durationMinMS", 100);

// Use "ease-out" curve for natural feel
user_pref("general.smoothScroll.msdPhysics.enabled", true);

// Performance optimizations
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);

// Wayland optimizations (already in your chrome flags)
user_pref("widget.use-xdg-desktop-portal.file-picker", 1);
EOF

echo "✓ Firefox smooth scrolling configured: $USER_JS"
echo ""
echo "⚠️  Restart Firefox for changes to take effect"
echo ""
echo "Settings applied:"
echo "  - Smooth scrolling enabled (fast, not slow)"
echo "  - Durations: 100-200ms (barely noticeable, professional)"
echo "  - WebRender acceleration enabled"
echo "  - Wayland optimizations"
