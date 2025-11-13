#!/bin/bash
# Interactive Arch Official Repository Package Installer
# Uses fzf for fuzzy search with live preview

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    notify-send "Missing Dependency" "fzf is required. Installing..."
    foot -T "Installing fzf" -e bash -c 'sudo pacman -S --noconfirm fzf && echo "✅ fzf installed! Please try again." && sleep 2'
    exit 1
fi

# Launch terminal with the interactive package search
foot --title "Arch Package Installer" bash -c '
    echo "🔍 Searching Arch Official Repository..."
    echo "Type to search, use arrow keys to navigate, Enter to select, Esc to cancel"
    echo ""
    
    # Get list of all packages with descriptions
    selected=$(pacman -Sl | awk "{print \$2\" \"\$4}" | \
        fzf --ansi \
            --height=80% \
            --reverse \
            --prompt="Search Arch Packages: " \
            --preview="pacman -Si {1} 2>/dev/null || echo \"Loading...\"" \
            --preview-window=right:60%:wrap \
            --bind "ctrl-d:preview-page-down,ctrl-u:preview-page-up" \
            --header="Ctrl-D/U: scroll preview | Enter: install | Esc: cancel")
    
    if [ -z "$selected" ]; then
        echo ""
        echo "❌ No package selected. Exiting..."
        sleep 1
        exit 0
    fi
    
    # Extract package name (first field)
    package=$(echo "$selected" | awk "{print \$1}")
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦 Installing: $package"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Install the package
    sudo pacman -S "$package"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Successfully installed $package"
    else
        echo ""
        echo "❌ Failed to install $package"
    fi
    
    echo ""
    echo "Press Enter to close..."
    read
'
