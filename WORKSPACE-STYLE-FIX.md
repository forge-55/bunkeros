# Workspace Style Default Fix

## Problem
On fresh installations, the workspace style was displaying as "box" (bordered background) instead of the documented default "bottom-border" (underline).

## Root Cause
Theme templates (`themes/*/waybar-style.css.template`) contained **hardcoded workspace button styles** that overrode the system default:

- **tactical**, **night-ops**, **abyss**: Had `padding: 2px 8px; border-radius: 4px;` (box style)
- **sahara**, **winter**: Had `padding: 4px 10px;` (bottom-border style)

This meant the workspace style depended on which theme was applied, not the user's preference or system default.

## Solution

### 1. Fixed Theme Templates
- Created `scripts/fix-theme-templates.py` to replace hardcoded styles with placeholder
- Replaced workspace button sections with `/* WORKSPACE_STYLE_PLACEHOLDER */`
- Updated 3 templates (abyss, night-ops, tactical)
- Sahara and winter already had correct styles but will use placeholder going forward

### 2. Updated Installation Flow
Modified `setup.sh` to explicitly apply default workspace style after theme application:

```bash
echo "Step 15: Applying default BunkerOS theme..."
cd "$PROJECT_DIR"
"$LOCAL_BIN/theme-switcher.sh" tactical 2>/dev/null || echo "  ℹ Theme will be applied on first Sway launch"

# Apply default workspace style (bottom-border/underline)
echo "  Applying default workspace style (underline)..."
"$PROJECT_DIR/scripts/workspace-style-switcher.sh" apply bottom-border 2>/dev/null || echo "  ℹ Workspace style will be applied on first Sway launch"
```

### 3. Verified Default Behavior
- `workspace-style-switcher.sh` already defaults to "bottom-border" (line 19)
- Placeholder system allows centralized style management
- User preference overrides default when set

## Architecture

### Before
```
Theme Template → Hardcoded Styles → User Config
     ↓                                  ↓
  Different defaults            Style switcher can't override
```

### After
```
Theme Template → Placeholder → workspace-style-switcher.sh → User Config
     ↓                              ↓                            ↓
  Neutral base              System default applied        User preference wins
```

## Testing
On fresh installation:
1. Theme template installed with placeholder
2. `workspace-style-switcher.sh apply bottom-border` called
3. Placeholder replaced with bottom-border styles
4. User sees underline workspace indicators

## Files Modified
- `themes/abyss/waybar-style.css.template` - Added placeholder
- `themes/night-ops/waybar-style.css.template` - Added placeholder
- `themes/tactical/waybar-style.css.template` - Added placeholder
- `setup.sh` - Added workspace style application step
- `scripts/fix-theme-templates.py` - Created (one-time fix script)

## Future Development
When creating new themes:
1. Use `/* WORKSPACE_STYLE_PLACEHOLDER */` instead of hardcoded workspace button styles
2. Theme switcher will automatically apply user's preferred style
3. Default remains "bottom-border" unless user changes preference

## Verification
```bash
# Check theme templates use placeholder
grep -r "WORKSPACE_STYLE_PLACEHOLDER" themes/*/waybar-style.css.template

# Verify default in workspace-style-switcher.sh
grep "bottom-border.*Default" scripts/workspace-style-switcher.sh

# Test fresh installation
./setup.sh
grep "padding" ~/.config/waybar/style.css  # Should see "4px 10px" (bottom-border)
```

## Resolution
✅ Fresh installations now default to bottom-border (underline) workspace style  
✅ Theme templates use centralized style management  
✅ User preferences properly override defaults  
✅ All themes consistent in behavior
