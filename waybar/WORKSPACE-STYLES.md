# Workspace Button Styles

BunkerOS now supports two different workspace button styles that you can switch between:

## Available Styles

### 1. Bottom Border (Minimal) - Default
- Clean, minimal design with a bottom border highlight
- Transparent background for active workspace
- 2px solid bottom border in theme accent color
- No rounded corners (border-radius: 0)
- Smoother transitions

### 2. Box (Classic)
- More visible design with background color and full border
- Background color on active workspace
- 2px border on all sides in theme accent color
- Rounded corners (border-radius: 4px)
- Includes urgent state with pulse animation

## How to Switch Styles

### Via Appearance Menu (Recommended)
1. Press `Super + M` to open the main menu
2. Select **Appearance**
3. Select **Workspace Style**
4. Choose your preferred style

### Via Command Line
```bash
# Toggle between styles
~/Projects/bunkeros/scripts/workspace-style-switcher.sh toggle

# Or apply a specific style
~/Projects/bunkeros/scripts/workspace-style-switcher.sh apply bottom-border
~/Projects/bunkeros/scripts/workspace-style-switcher.sh apply box

# Show menu to select style
~/Projects/bunkeros/scripts/workspace-style-switcher.sh menu
```

## How It Works

- Your workspace style preference is saved in `~/.config/bunkeros/workspace-style`
- When you switch themes, your workspace style preference is automatically maintained
- The style definitions use CSS variables so they adapt to each theme's color scheme
- Waybar automatically reloads to apply the changes

## Technical Details

- Workspace styles are stored as separate CSS files in `waybar/workspace-styles/`
- Theme templates use CSS variables for workspace colors (e.g., `--workspace-active`)
- The theme switcher automatically applies your preferred workspace style after changing themes
- All changes take effect immediately without requiring a Sway reload

## Customization

You can customize the workspace button colors by editing the CSS variables in each theme's `waybar-style.css.template`:

```css
--workspace-inactive: #6B7657;     /* Color for inactive workspaces */
--workspace-active: #C3B091;       /* Color for active workspace */
--workspace-dim: #4A5240;          /* Color for dimmed elements */
--workspace-hover-bg: rgba(60, 74, 47, 0.3);  /* Hover background */
--workspace-active-bg: rgba(195, 176, 145, 0.4);  /* Active background (box style) */
```

After editing, apply your theme again to see the changes.
