#!/bin/bash
# Interactive AUR Package Installer
# Uses paru with fzf for fuzzy search

# Check if paru is installed
if ! command -v paru &> /dev/null; then
    notify-send "Error" "paru is not installed. Install with: sudo pacman -S paru"
    exit 1
fi

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    notify-send "Error" "fzf is not installed. Install with: sudo pacman -S fzf"
    exit 1
fi

# Launch terminal with the interactive AUR search
foot --title "AUR Package Installer" bash -c '
    echo "🔍 Searching Arch User Repository (AUR)..."
    echo "Type to search, use arrow keys to navigate, Enter to select, Esc to cancel"
    echo ""
    
    # Get search term from user first
    echo -n "Enter search term: "
    read search_term
    
    if [ -z "$search_term" ]; then
        echo ""
        echo "❌ No search term provided. Exiting..."
        sleep 1
        exit 0
    fi
    
    echo ""
    echo "Searching AUR for: $search_term"
    echo ""
    
    # Search AUR and let user select with fzf
    selected=$(paru -Sl aur | grep -i "$search_term" | awk "{print \$2\" \"\$4}" | \
        fzf --ansi \
            --height=80% \
            --reverse \
            --prompt="Select AUR Package: " \
            --preview="paru -Si {1} 2>/dev/null || echo \"Loading package info...\"" \
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
    echo "🔧 Installing from AUR: $package"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Install the package from AUR
    paru -S "$package"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Successfully installed $package from AUR"
    else
        echo ""
        echo "❌ Failed to install $package"
    fi
    
    echo ""
    echo "Press Enter to close..."
    read
'
