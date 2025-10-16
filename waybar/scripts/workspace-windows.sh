#!/usr/bin/env bash

temp_file="/tmp/sway-workspace-overview-$$"
window_file="/tmp/sway-windows-$$"

# Get all windows with workspace numbers
swaymsg -t get_tree | jq -r '
    .. |
    select(.type? == "workspace") as $ws |
    $ws | .. |
    select(.type? == "con") |
    select(.name? != null) |
    select(.pid? != null) |
    select(.name != "__i3_scratch") |
    "\(.id)|\($ws.num)|\(.name)"
' > "$window_file"

# Build workspace overview
for ws_num in $(seq 1 9); do
    windows=$(grep "|$ws_num|" "$window_file")
    
    if [ -z "$windows" ]; then
        continue
    fi
    
    # Check if current or visible
    ws_info=$(swaymsg -t get_workspaces | jq -r ".[] | select(.num == $ws_num) | \"\(.focused)|\(.visible)\"")
    focused=$(echo "$ws_info" | cut -d'|' -f1)
    visible=$(echo "$ws_info" | cut -d'|' -f2)
    
    # Build window preview
    window_preview=""
    count=0
    
    while IFS='|' read -r con_id workspace window_title && [ $count -lt 5 ]; do
        # Extract just the essential info
        case "$window_title" in
            *Chrome*|*Chromium*|*Brave*|*Google*)
                icon="󰖟"
                # Get page title (before the " - ")
                title=$(echo "$window_title" | sed 's/ - Google Chrome.*//; s/ - Chromium.*//; s/ - Brave.*//; s/^New Tab$/New Tab/' | cut -c1-30)
                ;;
            *Firefox*)
                icon="󰈹"
                title=$(echo "$window_title" | sed 's/ — Mozilla Firefox.*//; s/ - Mozilla Firefox.*//' | cut -c1-30)
                ;;
            *Cursor*|*Code*|*VSCode*)
                icon="󰨞"
                # Get filename before the " - "
                title=$(echo "$window_title" | awk -F' - ' '{print $1}' | cut -c1-30)
                ;;
            *foot*|*bash*|*terminal*|*Terminal*)
                icon="󰆍"
                title="Terminal"
                ;;
            *Thunar*|*thunar*|*Files*)
                icon="󰉋"
                title=$(echo "$window_title" | sed 's/ - File Manager.*//' | cut -c1-30)
                ;;
            *Slack*)
                icon="󰒱"
                title="Slack"
                ;;
            *Discord*)
                icon="󰙯"
                title="Discord"
                ;;
            *Spotify*)
                icon="󰓇"
                title="Spotify"
                ;;
            *)
                icon="󰈙"
                title=$(echo "$window_title" | cut -c1-25)
                ;;
        esac
        
        if [ -z "$window_preview" ]; then
            window_preview="$icon $title"
        else
            window_preview="$window_preview  •  $icon $title"
        fi
        
        ((count++))
    done < <(echo "$windows")
    
    total_windows=$(echo "$windows" | wc -l)
    if [ $total_windows -gt 5 ]; then
        more_count=$((total_windows - 5))
        window_preview="$window_preview  •  +$more_count more"
    fi
    
    # Format workspace line with better visual hierarchy
    if [ "$focused" = "true" ]; then
        echo "WS:$ws_num|  ▸  $ws_num  │  $window_preview" >> "$temp_file"
    elif [ "$visible" = "true" ]; then
        echo "WS:$ws_num|  ●  $ws_num  │  $window_preview" >> "$temp_file"
    else
        echo "WS:$ws_num|  ○  $ws_num  │  $window_preview" >> "$temp_file"
    fi
done

if [ ! -s "$temp_file" ]; then
    notify-send "Workspace Overview" "No active workspaces"
    rm -f "$temp_file" "$window_file"
    exit 0
fi

# Display with clean format
selected=$(sed 's/^[^|]*|//' "$temp_file" | wofi \
    --dmenu \
    --prompt "🔍 Type number to jump  •  Use ↑↓ to browse" \
    --width 1400 \
    --height 450 \
    --cache-file=/dev/null \
    --insensitive)

if [ -n "$selected" ]; then
    # Extract workspace number from selection
    line=$(grep -F "$selected" "$temp_file" | head -1)
    ws_num=$(echo "$line" | grep -oP '^WS:\K[0-9]+')
    
    if [ -n "$ws_num" ]; then
        swaymsg workspace number "$ws_num"
    fi
fi

rm -f "$temp_file" "$window_file"
