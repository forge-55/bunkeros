#!/bin/bash
# Interactive AUR Package Installer
# Uses yay/paru with fzf for fuzzy search

# Check for AUR helper (prefer yay, fallback to paru)
AUR_HELPER=""
if command -v yay &> /dev/null; then
    AUR_HELPER="yay"
elif command -v paru &> /dev/null; then
    AUR_HELPER="paru"
else
    notify-send "Missing AUR Helper" "Neither yay nor paru found. Please install one first."
    exit 1
fi

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    notify-send "Missing Dependency" "fzf is required. Installing..."
    foot -T "Installing fzf" -e bash -c 'sudo pacman -S --noconfirm fzf && echo "✅ fzf installed! Please try again." && sleep 2'
    exit 1
fi

# Launch terminal with the interactive AUR search
foot --title "AUR Package Installer" bash -c "
    AUR_HELPER=\"$AUR_HELPER\"
    echo \"🔍 Searching Arch User Repository (AUR) using \$AUR_HELPER...\"
    echo \"Type to search, use arrow keys to navigate, Enter to select, Esc to cancel\"
    echo \"\"
    
    # Get search term from user first
    echo -n \"Enter search term: \"
    read search_term
    
    if [ -z \"\$search_term\" ]; then
        echo \"\"
        echo \"❌ No search term provided. Exiting...\"
        sleep 1
        exit 0
    fi
    
    echo \"\"
    echo \"Searching AUR for: \$search_term\"
    echo \"\"
    
    # Search AUR and let user select with fzf
    selected=\$(\$AUR_HELPER -Sl aur | grep -i \"\$search_term\" | awk '{print \$2\" \"\$4}' | \
        fzf --ansi \
            --height=80% \
            --reverse \
            --prompt=\"Select AUR Package: \" \
            --preview=\"\$AUR_HELPER -Si {1} 2>/dev/null || echo 'Loading package info...'\" \
            --preview-window=right:60%:wrap \
            --bind \"ctrl-d:preview-page-down,ctrl-u:preview-page-up\" \
            --header=\"Ctrl-D/U: scroll preview | Enter: install | Esc: cancel\")
    
    if [ -z \"\$selected\" ]; then
        echo \"\"
        echo \"❌ No package selected. Exiting...\"
        sleep 1
        exit 0
    fi
    
    # Extract package name (first field)
    package=\$(echo \"\$selected\" | awk '{print \$1}')
    
    echo \"\"
    echo \"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\"
    echo \"🔧 Installing from AUR: \$package\"
    echo \"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\"
    echo \"\"
    
    # Install the package from AUR
    \$AUR_HELPER -S \"\$package\"
    
    if [ \$? -eq 0 ]; then
        echo \"\"
        echo \"✅ Successfully installed \$package from AUR\"
    else
        echo \"\"
        echo \"❌ Failed to install \$package\"
    fi
    
    echo \"\"
    echo \"Press Enter to close...\"
    read
"
