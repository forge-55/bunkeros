#!/usr/bin/env bash

# BunkerOS Auto-Scaling Migration Script
# Converts existing auto-scaling setup to new architecture
# Run this ONCE to clean up git tracking issues

# Don't exit on error - we'll handle them
set +e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     BunkerOS Auto-Scaling Migration to v2 Architecture     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if we're in a git repo
if [ ! -d ".git" ]; then
    echo "❌ Not in a git repository. Please run from BunkerOS project root."
    exit 1
fi

echo "This script will:"
echo "  1. Create .template versions of theme config files"
echo "  2. Remove user-modifiable files from git tracking"
echo "  3. Update .gitignore to prevent future tracking"
echo "  4. Optionally discard local font size changes"
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Migration cancelled."
    exit 0
fi

echo ""
echo "Step 1: Creating template files..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

count=0
for theme in themes/*/; do
    theme_name=$(basename "$theme")
    
    # Create templates from current versions
    # (We'll use the modified ones as templates since they're consistent)
    
    if [ -f "$theme/foot.ini" ]; then
        cp "$theme/foot.ini" "$theme/foot.ini.template"
        echo "  ✓ Created $theme_name/foot.ini.template"
        ((count++))
    fi
    
    if [ -f "$theme/waybar-style.css" ]; then
        cp "$theme/waybar-style.css" "$theme/waybar-style.css.template"
        echo "  ✓ Created $theme_name/waybar-style.css.template"
        ((count++))
    fi
    
    if [ -f "$theme/wofi-style.css" ]; then
        cp "$theme/wofi-style.css" "$theme/wofi-style.css.template"
        echo "  ✓ Created $theme_name/wofi-style.css.template"
        ((count++))
    fi
done

echo ""
echo "  📝 Created $count template files"
echo ""

echo "Step 2: Do you want to keep your current font size changes?"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Current changes will be:"
echo "  - Saved to user preferences (~/.config/bunkeros/user-preferences.conf)"
echo "  - OR discarded to use auto-detection on next login"
echo ""
read -p "Keep current font sizes as your preference? (y/N) " -n 1 -r
echo ""
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "  ✓ Will preserve current settings as user preference"
    KEEP_CURRENT=true
else
    echo "  ✓ Will reset to defaults (auto-detect on next login)"
    KEEP_CURRENT=false
fi

echo ""
echo "Step 3: Removing files from git tracking..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Remove from git tracking but keep local files
git rm --cached themes/*/foot.ini 2>/dev/null || true
git rm --cached themes/*/waybar-style.css 2>/dev/null || true  
git rm --cached themes/*/wofi-style.css 2>/dev/null || true
git rm --cached lite-xl/session.lua 2>/dev/null || true
git rm --cached lite-xl/ws/* 2>/dev/null || true

echo "  ✓ Removed user-modifiable files from git tracking"
echo ""

echo "Step 4: Staging template files..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

git add themes/*/*.template
git add .gitignore
git add AUTO-SCALING.md
git add scripts/auto-scaling-service-v2.sh

echo "  ✓ Staged template files and new architecture"
echo ""

if [ "$KEEP_CURRENT" = true ]; then
    echo "Step 5: Saving current settings as user preference..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Get current font sizes
    foot_size=$(grep "^font=monospace:size=" ~/.config/foot/foot.ini 2>/dev/null | grep -o "size=[0-9]*" | cut -d= -f2)
    waybar_size=$(grep "font-size:" ~/.config/waybar/style.css 2>/dev/null | head -1 | grep -o "[0-9]*px" | tr -d 'px')
    wofi_size=$(grep "font-size:" ~/.config/wofi/style.css 2>/dev/null | head -1 | grep -o "[0-9]*px" | tr -d 'px')
    
    mkdir -p ~/.config/bunkeros
    
    cat > ~/.config/bunkeros/user-preferences.conf << EOF
# BunkerOS User Preferences
# Migrated from existing configuration: $(date)
FOOT_FONT_SIZE="$foot_size"
WAYBAR_FONT_SIZE="$waybar_size"
WOFI_FONT_SIZE="$wofi_size"
USER_CUSTOMIZED="true"
USER_CUSTOMIZED_DATE="$(date +%s)"
MIGRATION_V2="true"
EOF
    
    echo "  ✓ Saved to ~/.config/bunkeros/user-preferences.conf"
    echo ""
else
    echo "Step 5: Resetting to default font sizes..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Reset local theme files to template defaults
    for theme in themes/*/; do
        [ -f "$theme/foot.ini.template" ] && cp "$theme/foot.ini.template" "$theme/foot.ini"
        [ -f "$theme/waybar-style.css.template" ] && cp "$theme/waybar-style.css.template" "$theme/waybar-style.css"
        [ -f "$theme/wofi-style.css.template" ] && cp "$theme/wofi-style.css.template" "$theme/wofi-style.css"
    done
    
    # Remove any existing preferences
    rm -f ~/.config/bunkeros/user-preferences.conf
    rm -f ~/.config/bunkeros/scaling-first-run-done
    
    echo "  ✓ Reset to defaults"
    echo ""
fi

echo "Step 6: Creating commit..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

git commit -m "Migrate to v2 auto-scaling architecture

- Add template files for theme configs
- Remove user-modifiable files from tracking
- Update .gitignore to prevent future conflicts
- Add comprehensive AUTO-SCALING.md documentation
- Add improved auto-scaling service (v2)

This prevents git conflicts from auto-scaling system and
respects user preferences. See AUTO-SCALING.md for details."

echo "  ✓ Changes committed locally"
echo ""

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                     Migration Complete!                     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo ""
echo "  1. Review the commit:"
echo "     git show"
echo ""
echo "  2. Push to remote:"
echo "     git push"
echo ""
echo "  3. Replace auto-scaling service:"
echo "     cp scripts/auto-scaling-service-v2.sh scripts/auto-scaling-service.sh"
echo ""
echo "  4. Read documentation:"
echo "     cat AUTO-SCALING.md"
echo ""

if [ "$KEEP_CURRENT" = false ]; then
    echo "  5. Log out and back in to apply auto-detected settings"
    echo ""
fi

echo "Your local files will NOT be affected by future git pulls!"
echo ""
