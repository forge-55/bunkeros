#!/usr/bin/env python3
"""
Fix all theme templates to use hardcoded workspace button styles
"""

import re
from pathlib import Path

PROJECT_DIR = Path(__file__).parent.parent
THEMES_DIR = PROJECT_DIR / "themes"

# Pattern to match the entire workspace button section
WORKSPACE_SECTION_PATTERN = re.compile(
    r'(#workspaces \{[^}]*\}\s*)'  # Match #workspaces { ... } with trailing whitespace
    r'((?:#workspaces button[^}]*\}[\s\n]*)+)'  # Match all #workspaces button blocks
    r'(?=\n*#mode\s)',  # Stop before #mode
    re.DOTALL | re.MULTILINE
)

REPLACEMENT = r'\1\n/* Workspace Button Styles - Underline */\n'

def fix_template(template_path):
    """Replace workspace button styles with placeholder"""
    print(f"Processing {template_path.parent.name}...")
    
    content = template_path.read_text()
    
    # Replace the workspace section
    new_content = WORKSPACE_SECTION_PATTERN.sub(REPLACEMENT, content)
    
    if content != new_content:
        template_path.write_text(new_content)
        print(f"  ✓ Updated {template_path.parent.name}")
        return True
    else:
        print(f"  - No changes needed for {template_path.parent.name}")
        return False

def main():
    print("Fixing theme templates...\n")
    
    fixed_count = 0
    for theme_dir in sorted(THEMES_DIR.iterdir()):
        if not theme_dir.is_dir():
            continue
            
        template = theme_dir / "waybar-style.css.template"
        if not template.exists():
            continue
            
        if fix_template(template):
            fixed_count += 1
    
    print(f"\n✓ Fixed {fixed_count} theme templates")
    print("Workspace button styles are now hardcoded with underline style")

if __name__ == "__main__":
    main()
