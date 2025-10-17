#!/usr/bin/env bash

SWAY_CONFIG="$HOME/.config/sway/config"
TEMP_FILE="/tmp/sway-keybindings.tmp"
MENU_STATE="/tmp/keybinding-menu-state"

extract_keybindings() {
    grep "^[[:space:]]*bindsym" "$SWAY_CONFIG" | \
    sed 's/^[[:space:]]*//' | \
    grep -v "^#" | \
    while IFS= read -r line; do
        key=$(echo "$line" | sed 's/bindsym //' | awk '{print $1, $2, $3}' | sed 's/ exec.*//' | sed 's/ [a-z].*$//')
        action=$(echo "$line" | sed 's/.*bindsym [^ ]* //')
        
        if [ ${#action} -gt 55 ]; then
            action="${action:0:52}..."
        fi
        
        printf "%-28s  │  %s\n" "$key" "$action"
    done
}

show_keybindings() {
    extract_keybindings | \
    wofi --dmenu \
        --prompt "📋 All Keybindings" \
        --width 900 \
        --height 600 \
        --cache-file=/dev/null \
        --insensitive \
        --lines 20
    
    main
}

show_categories() {
    echo "main" > "$MENU_STATE"
    
    local choice=$(echo -e "📚 Keybinding Cheatsheet
➕ Add New Keybinding
✏️  Edit Keybinding
🗑️  Remove Keybinding
💾 Backup Keybindings
🔧 Open Config File
⬅️  Back to Quick Menu" | \
    wofi --dmenu \
        --prompt "⌨️  BunkerOS Keybinding Manager" \
        --width 380 \
        --height 330 \
        --cache-file=/dev/null \
        --insensitive \
        --lines 7)
    
    # Handle ESC or empty selection
    if [ -z "$choice" ]; then
        ~/.config/waybar/scripts/quick-menu.sh
        exit 0
    fi
    
    echo "$choice"
}

show_cheatsheet() {
    cat << 'EOF' | wofi --dmenu \
        --prompt "📚 BunkerOS Keybinding Reference" \
        --width 750 \
        --height 550 \
        --cache-file=/dev/null \
        --lines 22

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ESSENTIAL                                                      

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Super + Return         Launch terminal
  Super + d              Application launcher
  Super + q              Close window
  Super + m              Quick actions menu
  Super + w              Workspace overview
  Super + Escape         Lock screen
  Super + Shift + r      Reload Sway config

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  WINDOW MANAGEMENT                                             

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Super + h/j/k/l        Move focus (vim style)
  Super + ← ↓ ↑ →        Move focus (arrows)
  Super + Shift + hjkl   Move window (vim style)
  Super + Shift + ←↓↑→   Move window (arrows)
  Super + v              Toggle split direction
  F11                    Fullscreen toggle
  Super + Shift + Space  Toggle floating
  Super + r              Resize mode

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  WORKSPACES                                                    

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Super + 1-9            Switch to workspace
  Super + Shift + 1-9    Move window to workspace
  PgUp / PgDn            Previous / Next workspace

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  APPLICATIONS                                                  

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Super + b              Web browser
  Super + e              Text editor
  Super + f              File manager
  Super + c              Calculator

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  SCREENSHOTS                                                   

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Print                  Interactive screenshot
  Shift + Print          Full screen (save)
  Ctrl + Print           Area (copy to clipboard)
  Ctrl + Shift + Print   Window (save)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  SYSTEM                                                        

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Super + n              Toggle night mode
  Fn + F1-F6             Volume / brightness (OSD)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⬅️  Back to Keybinding Manager
EOF
    
    main
}

get_installed_apps() {
    # Get desktop applications
    find /usr/share/applications ~/.local/share/applications -name "*.desktop" 2>/dev/null | \
    grep -v "webapp-" | \
    while read desktop_file; do
        name=$(grep "^Name=" "$desktop_file" | head -1 | cut -d= -f2)
        exec_line=$(grep "^Exec=" "$desktop_file" | head -1 | cut -d= -f2 | sed 's/%[A-Za-z]//g' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
        # Only include if both name and exec are non-empty, and exec is a valid command
        if [ -n "$name" ] && [ -n "$exec_line" ] && [[ ! "$exec_line" =~ ^--.* ]]; then
            echo "$name|$exec_line"
        fi
    done | sort -u
}

get_web_apps() {
    # Get installed web apps
    find ~/.local/share/applications -name "webapp-*.desktop" 2>/dev/null | \
    while read desktop_file; do
        name=$(grep "^Name=" "$desktop_file" | head -1 | cut -d= -f2)
        # Extract full Exec line including URLs and arguments
        exec_line=$(grep "^Exec=" "$desktop_file" | head -1 | cut -d= -f2-)
        if [ -n "$name" ] && [ -n "$exec_line" ]; then
            echo "🌐 $name|$exec_line"
        fi
    done | sort
}

browse_action_category() {
    local category=$(echo -e "📱 Launch Application
🌐 Launch Web App
🖥️  Window Actions
🗂️  Workspace Actions
🎨 Theme & Appearance
⚙️  System Actions
📝 Custom Command
⬅️  Back" | \
    wofi --dmenu \
        --prompt "Step 4/5: Choose Action Category" \
        --width 380 \
        --height 380 \
        --cache-file=/dev/null \
        --lines 8)
    
    case "$category" in
        "📱 Launch Application")
            browse_applications
            ;;
        "🌐 Launch Web App")
            browse_web_apps
            ;;
        "🖥️  Window Actions")
            browse_window_actions
            ;;
        "🗂️  Workspace Actions")
            browse_workspace_actions
            ;;
        "🎨 Theme & Appearance")
            browse_theme_actions
            ;;
        "⚙️  System Actions")
            browse_system_actions
            ;;
        "📝 Custom Command")
            custom_command
            ;;
        "⬅️  Back")
            capture_keybinding 3
            ;;
        *)
            capture_keybinding 3
            ;;
    esac
}

browse_applications() {
    local apps=$(get_installed_apps | \
        awk -F'|' '{printf "%-40s  │  %s\n", $1, $2}')
    
    local selected=$(echo "$apps" | \
        wofi --dmenu \
            --prompt "📱 Select Application to Launch" \
            --width 900 \
            --height 500 \
            --cache-file=/dev/null \
            --insensitive \
            --lines 18)
    
    if [ -z "$selected" ]; then
        browse_action_category
        return
    fi
    
    local exec_cmd=$(echo "$selected" | awk -F'│' '{print $2}' | xargs)
    echo "exec $exec_cmd" > /tmp/kb-action
    capture_keybinding 5
}

browse_web_apps() {
    local web_apps=$(get_web_apps)
    
    if [ -z "$web_apps" ]; then
        notify-send "No Web Apps" "No web apps installed. Install some via Quick Menu → Web Apps"
        browse_action_category
        return
    fi
    
    local selected=$(echo "$web_apps" | \
        awk -F'|' '{printf "%-40s  │  %s\n", $1, $2}' | \
        wofi --dmenu \
            --prompt "🌐 Select Web App to Launch" \
            --width 900 \
            --height 400 \
            --cache-file=/dev/null \
            --insensitive \
            --lines 12)
    
    if [ -z "$selected" ]; then
        browse_action_category
        return
    fi
    
    local exec_cmd=$(echo "$selected" | awk -F'│' '{print $2}' | xargs)
    # Add exec prefix if not already present
    if [[ ! "$exec_cmd" =~ ^exec ]]; then
        exec_cmd="exec $exec_cmd"
    fi
    echo "$exec_cmd" > /tmp/kb-action
    capture_keybinding 5
}

browse_window_actions() {
    local action=$(echo -e "🗙 Close Window  │  kill
🖼️  Toggle Fullscreen  │  fullscreen toggle
🎈 Toggle Floating  │  floating toggle
📌 Toggle Sticky  │  sticky toggle
⬆️  Focus Up  │  focus up
⬇️  Focus Down  │  focus down
⬅️  Focus Left  │  focus left
➡️  Focus Right  │  focus right
⬆️  Move Up  │  move up
⬇️  Move Down  │  move down
⬅️  Move Left  │  move left
➡️  Move Right  │  move right
⬅️  Back" | \
    wofi --dmenu \
        --prompt "🖥️  Select Window Action" \
        --width 450 \
        --height 520 \
        --cache-file=/dev/null \
        --lines 13)
    
    if [[ "$action" == "⬅️  Back" ]] || [ -z "$action" ]; then
        browse_action_category
        return
    fi
    
    local cmd=$(echo "$action" | awk -F'│' '{print $2}' | xargs)
    echo "$cmd" > /tmp/kb-action
    capture_keybinding 5
}

browse_workspace_actions() {
    local action=$(echo -e "1️⃣  Switch to Workspace 1  │  workspace number 1
2️⃣  Switch to Workspace 2  │  workspace number 2
3️⃣  Switch to Workspace 3  │  workspace number 3
4️⃣  Switch to Workspace 4  │  workspace number 4
5️⃣  Switch to Workspace 5  │  workspace number 5
6️⃣  Switch to Workspace 6  │  workspace number 6
7️⃣  Switch to Workspace 7  │  workspace number 7
8️⃣  Switch to Workspace 8  │  workspace number 8
9️⃣  Switch to Workspace 9  │  workspace number 9
➡️  Next Workspace  │  workspace next
⬅️  Previous Workspace  │  workspace prev
📤 Move to Workspace 1  │  move container to workspace number 1
📤 Move to Workspace 2  │  move container to workspace number 2
📤 Move to Workspace 3  │  move container to workspace number 3
⬅️  Back" | \
    wofi --dmenu \
        --prompt "🗂️  Select Workspace Action" \
        --width 550 \
        --height 550 \
        --cache-file=/dev/null \
        --lines 15)
    
    if [[ "$action" == "⬅️  Back" ]] || [ -z "$action" ]; then
        browse_action_category
        return
    fi
    
    local cmd=$(echo "$action" | awk -F'│' '{print $2}' | xargs)
    echo "$cmd" > /tmp/kb-action
    capture_keybinding 5
}

browse_theme_actions() {
    local action=$(echo -e "🎨 Open Theme Switcher  │  exec ~/.config/waybar/scripts/theme-menu.sh
🌓 Toggle Night Mode  │  exec ~/.config/waybar/scripts/night-mode-toggle.sh
➕ Increase Gaps  │  gaps inner all plus 2
➖ Decrease Gaps  │  gaps outer all plus 2
🔄 Reload Sway Config  │  reload
🖼️  Change Wallpaper  │  exec killall swaybg; swaybg -i ~/Pictures/wallpaper.jpg -m fill
⬅️  Back" | \
    wofi --dmenu \
        --prompt "🎨 Select Theme/Appearance Action" \
        --width 550 \
        --height 350 \
        --cache-file=/dev/null \
        --lines 7)
    
    if [[ "$action" == "⬅️  Back" ]] || [ -z "$action" ]; then
        browse_action_category
        return
    fi
    
    local cmd=$(echo "$action" | awk -F'│' '{print $2}' | xargs)
    echo "$cmd" > /tmp/kb-action
    capture_keybinding 5
}

browse_system_actions() {
    local action=$(echo -e "🔒 Lock Screen  │  exec swaylock -f -c 000000
💤 Suspend  │  exec systemctl suspend
🔊 Volume Up  │  exec swayosd-client --output-volume +5
🔉 Volume Down  │  exec swayosd-client --output-volume -5
🔇 Mute Toggle  │  exec swayosd-client --output-volume mute-toggle
☀️  Brightness Up  │  exec swayosd-client --brightness +5
🌙 Brightness Down  │  exec swayosd-client --brightness -5
📸 Screenshot  │  exec ~/.config/waybar/scripts/screenshot-area.sh
🖥️  Display Settings  │  exec wdisplays
📶 Network Settings  │  exec foot -e nmtui
🎛️  Audio Settings  │  exec pavucontrol
⬅️  Back" | \
    wofi --dmenu \
        --prompt "⚙️  Select System Action" \
        --width 550 \
        --height 520 \
        --cache-file=/dev/null \
        --lines 12)
    
    if [[ "$action" == "⬅️  Back" ]] || [ -z "$action" ]; then
        browse_action_category
        return
    fi
    
    local cmd=$(echo "$action" | awk -F'│' '{print $2}' | xargs)
    echo "$cmd" > /tmp/kb-action
    capture_keybinding 5
}

custom_command() {
    local cmd=$(echo "" | wofi --dmenu \
        --prompt "📝 Enter Custom Command (e.g., exec firefox, reload)" \
        --cache-file=/dev/null \
        --lines 1 \
        --width 550)
    
    if [ -z "$cmd" ]; then
        browse_action_category
        return
    fi
    
    echo "$cmd" > /tmp/kb-action
    capture_keybinding 5
}

capture_keybinding() {
    local step=$1
    
    case $step in
        1)
            local choice=$(echo -e "🔘 Super (Mod4)
🔘 Alt (Mod1)
🔘 Ctrl
🔘 Shift
🔘 No modifier
⬅️  Back" | wofi --dmenu \
                --prompt "Step 1/5: Select Primary Modifier" \
                --width 350 \
                --height 280 \
                --cache-file=/dev/null \
                --lines 6)
            
            case "$choice" in
                "🔘 Super (Mod4)")
                    echo "\$mod" > /tmp/kb-modifier
                    capture_keybinding 2
                    ;;
                "🔘 Alt (Mod1)")
                    echo "Mod1" > /tmp/kb-modifier
                    capture_keybinding 2
                    ;;
                "🔘 Ctrl")
                    echo "Ctrl" > /tmp/kb-modifier
                    capture_keybinding 2
                    ;;
                "🔘 Shift")
                    echo "Shift" > /tmp/kb-modifier
                    capture_keybinding 2
                    ;;
                "🔘 No modifier")
                    echo "" > /tmp/kb-modifier
                    capture_keybinding 2
                    ;;
                "⬅️  Back"|"")
                    main
                    ;;
            esac
            ;;
        2)
            local choice=$(echo -e "🔘 Add Shift
🔘 Add Ctrl  
🔘 Add Alt
🔘 No additional modifier
⬅️  Back" | wofi --dmenu \
                --prompt "Step 2/5: Additional Modifier (Optional)" \
                --width 350 \
                --height 260 \
                --cache-file=/dev/null \
                --lines 5)
            
            local mod=$(cat /tmp/kb-modifier)
            case "$choice" in
                "🔘 Add Shift")
                    if [ -n "$mod" ]; then
                        echo "${mod}+Shift" > /tmp/kb-modifier
                    else
                        echo "Shift" > /tmp/kb-modifier
                    fi
                    capture_keybinding 3
                    ;;
                "🔘 Add Ctrl")
                    if [ -n "$mod" ]; then
                        echo "${mod}+Ctrl" > /tmp/kb-modifier
                    else
                        echo "Ctrl" > /tmp/kb-modifier
                    fi
                    capture_keybinding 3
                    ;;
                "🔘 Add Alt")
                    if [ -n "$mod" ]; then
                        echo "${mod}+Mod1" > /tmp/kb-modifier
                    else
                        echo "Mod1" > /tmp/kb-modifier
                    fi
                    capture_keybinding 3
                    ;;
                "🔘 No additional modifier")
                    capture_keybinding 3
                    ;;
                "⬅️  Back"|"")
                    capture_keybinding 1
                    ;;
            esac
            ;;
        3)
            local mod=$(cat /tmp/kb-modifier)
            local preview=""
            if [ -n "$mod" ]; then
                preview="Current: ${mod}+"
            else
                preview="Current: "
            fi
            
            local key=$(echo "" | wofi --dmenu \
                --prompt "Step 3/5: Enter Key (e.g., x, Return, F1, space) - ${preview}_" \
                --cache-file=/dev/null \
                --lines 1 \
                --width 550)
            
            if [ -z "$key" ]; then
                capture_keybinding 2
                return
            fi
            
            if [ -n "$mod" ]; then
                echo "${mod}+${key}" > /tmp/kb-full
            else
                echo "${key}" > /tmp/kb-full
            fi
            
            browse_action_category
            ;;
        5)
            local full_binding=$(cat /tmp/kb-full)
            local action=$(cat /tmp/kb-action)
            
            # Format action nicely for display
            local action_display="$action"
            if [ ${#action} -gt 60 ]; then
                action_display="${action:0:57}..."
            fi
            
            local confirm=$(echo -e "✅ Add This Keybinding

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Keybinding:  ${full_binding}

Action:      ${action_display}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⬅️  Back to edit" | wofi --dmenu \
                --prompt "Step 5/5: Confirm Keybinding" \
                --cache-file=/dev/null \
                --width 650 \
                --height 280 \
                --lines 8)
            
            if [[ "$confirm" == "✅ Add This Keybinding" ]]; then
                add_keybinding_to_config "$full_binding" "$action"
                notify-send "✅ Keybinding Added!" "${full_binding}\n→ ${action:0:50}"
                main
            elif [ -z "$confirm" ]; then
                browse_action_category
            else
                browse_action_category
            fi
            ;;
    esac
}

add_keybinding_to_config() {
    local key="$1"
    local action="$2"
    
    # Check if this keybinding already exists
    if grep -q "bindsym.*${key}[[:space:]]" "$SWAY_CONFIG"; then
        notify-send "⚠️ Keybinding Exists" "${key} is already bound. Please edit or remove the existing binding first."
        main
        return 1
    fi
    
    # Validate action is not empty
    if [ -z "$action" ] || [ "$action" = " " ]; then
        notify-send "❌ Error" "Action cannot be empty"
        main
        return 1
    fi
    
    if grep -q "^# Custom Keybindings" "$SWAY_CONFIG"; then
        sed -i "/^# Custom Keybindings/a \\    bindsym $key $action" "$SWAY_CONFIG"
    else
        echo "" >> "$SWAY_CONFIG"
        echo "# Custom Keybindings" >> "$SWAY_CONFIG"
        echo "    bindsym $key $action" >> "$SWAY_CONFIG"
    fi
    
    swaymsg reload >/dev/null 2>&1
}

edit_keybinding() {
    local selected=$(extract_keybindings | wofi --dmenu \
        --prompt "✏️  Select Keybinding to Edit" \
        --width 900 \
        --height 450 \
        --cache-file=/dev/null \
        --insensitive \
        --lines 15)
    
    if [ -z "$selected" ]; then
        main
        return
    fi
    
    local key=$(echo "$selected" | awk -F'│' '{print $1}' | xargs)
    
    notify-send "Opening Editor" "Editing: $key"
    
    local line_num=$(grep -n "bindsym.*${key}" "$SWAY_CONFIG" | head -1 | cut -d: -f1)
    
    if command -v cursor &> /dev/null; then
        cursor "$SWAY_CONFIG:$line_num"
    elif command -v code &> /dev/null; then
        code --goto "$SWAY_CONFIG:$line_num"
    else
        foot -e nano "+$line_num" "$SWAY_CONFIG" &
    fi
}

remove_keybinding() {
    local selected=$(extract_keybindings | wofi --dmenu \
        --prompt "🗑️  Select Keybinding to Remove" \
        --width 900 \
        --height 450 \
        --cache-file=/dev/null \
        --insensitive \
        --lines 15)
    
    if [ -z "$selected" ]; then
        main
        return
    fi
    
    local key=$(echo "$selected" | awk -F'│' '{print $1}' | xargs)
    local action=$(echo "$selected" | awk -F'│' '{print $2}' | xargs)
    
    # Show confirmation dialog
    local confirm=$(echo -e "⚠️  Remove This Keybinding?

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Keybinding:  ${key}

Action:      ${action}

This will permanently remove this keybinding
from your configuration.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Yes, Remove It
⬅️  Cancel" | wofi --dmenu \
        --prompt "Confirm Removal" \
        --cache-file=/dev/null \
        --width 650 \
        --height 320 \
        --lines 8)
    
    if [[ "$confirm" == "✅ Yes, Remove It" ]]; then
        # Escape special characters in key for sed
        local escaped_key=$(echo "$key" | sed 's/[]\/$*.^[]/\\&/g')
        
        # Remove the line containing this keybinding
        sed -i "/bindsym.*${escaped_key}[[:space:]]/d" "$SWAY_CONFIG"
        
        # Reload Sway config
        swaymsg reload >/dev/null 2>&1
        
        notify-send "🗑️ Keybinding Removed" "${key} has been removed"
        main
    elif [ -z "$confirm" ]; then
        main
    else
        main
    fi
}

backup_keybindings() {
    local backup_file="$HOME/.config/sway/keybindings-backup-$(date +%Y%m%d-%H%M%S).txt"
    extract_keybindings > "$backup_file"
    notify-send "💾 Keybindings Backed Up" "Saved to:\n$(basename "$backup_file")"
}

search_keybindings() {
    local search=$(echo "" | wofi --dmenu \
        --prompt "🔍 Search keybindings (type key or action)" \
        --cache-file=/dev/null \
        --lines 1 \
        --width 450)
    
    if [ -z "$search" ]; then
        main
        return
    fi
    
    local results=$(extract_keybindings | grep -i "$search")
    
    if [ -z "$results" ]; then
        notify-send "No Results" "No keybindings found matching: $search"
        main
        return
    fi
    
    echo "$results" | wofi --dmenu \
        --prompt "🔍 Results: $search" \
        --width 900 \
        --height 400 \
        --cache-file=/dev/null \
        --lines 12
    
    main
}

main() {
    local choice=$(show_categories)
    
    case "$choice" in
        "📚 Keybinding Cheatsheet")
            show_cheatsheet
            ;;
        "➕ Add New Keybinding")
            capture_keybinding 1
            ;;
        "✏️  Edit Keybinding")
            edit_keybinding
            ;;
        "🗑️  Remove Keybinding")
            remove_keybinding
            ;;
        "💾 Backup Keybindings")
            backup_keybindings
            main
            ;;
        "🔧 Open Config File")
            if command -v cursor &> /dev/null; then
                cursor "$SWAY_CONFIG"
            elif command -v code &> /dev/null; then
                code "$SWAY_CONFIG"
            else
                foot -e nano "$SWAY_CONFIG" &
            fi
            ;;
        "⬅️  Back to Quick Menu")
            ~/.config/waybar/scripts/quick-menu.sh
            ;;
        *)
            # Empty or ESC - return to Quick Menu
            ~/.config/waybar/scripts/quick-menu.sh
            ;;
    esac
}

# Cleanup temp files on exit
trap "rm -f /tmp/kb-* $MENU_STATE 2>/dev/null" EXIT

main
