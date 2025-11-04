#!/bin/bash
# Validate Waybar Theme Fix
# Run this script to verify all fixes are in place

echo "🔍 BunkerOS Waybar Theme Fix Validation"
echo "========================================"
echo ""

PASS=0
FAIL=0

# Test 1: Check for placeholders (should be none)
echo "[1/5] Checking for WORKSPACE_STYLE_PLACEHOLDER..."
if grep -q "WORKSPACE_STYLE_PLACEHOLDER" themes/*/waybar-style.css.template 2>/dev/null; then
    echo "❌ FAIL: Placeholders still exist in templates"
    grep -l "WORKSPACE_STYLE_PLACEHOLDER" themes/*/waybar-style.css.template
    ((FAIL++))
else
    echo "✅ PASS: No placeholders found"
    ((PASS++))
fi
echo ""

# Test 2: Verify all themes have proper CSS selectors
echo "[2/5] Checking for #workspaces button selectors..."
missing=0
for theme in tactical night-ops abyss sahara winter; do
    if ! grep -q "#workspaces button {" "themes/$theme/waybar-style.css.template" 2>/dev/null; then
        echo "❌ FAIL: Missing selector in $theme theme"
        missing=1
    fi
done

if [ $missing -eq 0 ]; then
    echo "✅ PASS: All 5 themes have valid CSS selectors"
    ((PASS++))
else
    ((FAIL++))
fi
echo ""

# Test 3: Check workspace-style-switcher doesn't pollute git
echo "[3/6] Checking workspace-style-switcher.sh for git pollution..."
if grep -q "cp.*PROJECT_DIR/waybar/style.css" scripts/workspace-style-switcher.sh 2>/dev/null; then
    echo "❌ FAIL: Git-polluting code still present"
    grep -n "PROJECT_DIR/waybar/style.css" scripts/workspace-style-switcher.sh
    ((FAIL++))
else
    echo "✅ PASS: No git-polluting code found"
    ((PASS++))
fi
echo ""

# Test 4: Verify theme-switcher.sh flow is correct
echo "[4/6] Checking theme-switcher.sh copies templates correctly..."
if grep -q "cp.*waybar-style.css.template.*\.config/waybar/style.css" scripts/theme-switcher.sh; then
    echo "✅ PASS: Theme switcher copies templates to user config"
    ((PASS++))
else
    echo "❌ FAIL: Theme switcher flow may be broken"
    ((FAIL++))
fi
echo ""

# Test 5: Check for duplicate #mode selectors
echo "[5/6] Checking for duplicate #mode selectors..."
duplicate=0
for theme in tactical night-ops abyss sahara winter; do
    count=$(grep -c "^#mode {" "themes/$theme/waybar-style.css.template" 2>/dev/null)
    if [ "$count" -gt 1 ]; then
        echo "❌ FAIL: Theme $theme has $count #mode selectors (should be 1)"
        duplicate=1
    fi
done

if [ $duplicate -eq 0 ]; then
    echo "✅ PASS: No duplicate #mode selectors found"
    ((PASS++))
else
    ((FAIL++))
fi
echo ""

# Test 6: Check if current user config has placeholders
echo "[6/6] Checking user's active Waybar config..."
if [ -f "$HOME/.config/waybar/style.css" ]; then
    if grep -q "WORKSPACE_STYLE_PLACEHOLDER" "$HOME/.config/waybar/style.css"; then
        echo "⚠️  WARNING: User config has placeholder - needs theme re-application"
        echo "    Run: ~/Projects/bunkeros/scripts/theme-switcher.sh tactical"
    else
        echo "✅ User config looks clean"
    fi
else
    echo "ℹ️  No user Waybar config found (this is OK on fresh install)"
fi
echo ""

# Summary
echo "========================================"
echo "Summary: $PASS passed, $FAIL failed"
echo "========================================"

if [ $FAIL -eq 0 ]; then
    echo "✅ All fixes are in place!"
    echo ""
    echo "Next steps:"
    echo "1. Switch to a broken theme to test:"
    echo "   ~/Projects/bunkeros/scripts/theme-switcher.sh tactical"
    echo ""
    echo "2. Verify Waybar is running:"
    echo "   pgrep waybar"
    echo ""
    echo "3. Check git status stays clean:"
    echo "   git status"
    exit 0
else
    echo "❌ Some issues found. Review output above."
    exit 1
fi
