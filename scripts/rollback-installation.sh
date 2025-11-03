#!/usr/bin/env bash
# BunkerOS Installation Rollback Script
#
# This script helps you rollback BunkerOS installation to a previous state
# using the backup directory created during installation.

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║          BunkerOS Installation Rollback                    ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Find latest backup
BACKUP_BASE="$HOME/.config"
LATEST_BACKUP=$(ls -dt "$BACKUP_BASE"/bunkeros-backup-* 2>/dev/null | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "❌ No backup found in $BACKUP_BASE"
    echo ""
    echo "Looking for backups with .backup suffix..."
    
    HAS_BACKUPS=false
    for dir in sway waybar wofi mako foot btop swayosd gtk-3.0 gtk-4.0; do
        if ls -d "$HOME/.config/${dir}.backup."* &>/dev/null; then
            echo "  Found: $HOME/.config/${dir}.backup.*"
            HAS_BACKUPS=true
        fi
    done
    
    if [ "$HAS_BACKUPS" = "false" ]; then
        echo "❌ No backups found"
        exit 1
    fi
    
    echo ""
    echo "Found individual config backups with .backup suffix."
    echo "These were created by setup.sh"
    echo ""
    read -p "Restore these individual backups? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
    
    echo ""
    echo "Restoring individual backups..."
    
    for dir in sway waybar wofi mako foot btop swayosd gtk-3.0 gtk-4.0; do
        LATEST_DIR_BACKUP=$(ls -dt "$HOME/.config/${dir}.backup."* 2>/dev/null | head -1)
        if [ -n "$LATEST_DIR_BACKUP" ]; then
            echo "  Restoring $dir from $LATEST_DIR_BACKUP..."
            rm -rf "$HOME/.config/$dir"
            cp -r "$LATEST_DIR_BACKUP" "$HOME/.config/$dir"
            echo "  ✅ $dir restored"
        fi
    done
    
    # Restore bashrc if backup exists
    if [ -f "$HOME/.bashrc.backup" ]; then
        echo "  Restoring .bashrc..."
        cp "$HOME/.bashrc.backup" "$HOME/.bashrc"
        echo "  ✅ .bashrc restored"
    fi
    
    echo ""
    echo "✅ Individual backups restored"
    echo ""
    echo "You may need to log out and log back in for changes to take effect."
    exit 0
fi

echo "Found backup: $LATEST_BACKUP"
echo ""
ls -lh "$LATEST_BACKUP" | head -10
echo ""

read -p "Restore from this backup? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Rollback cancelled"
    exit 0
fi

echo ""
echo "Starting rollback..."
echo ""

# Restore configs
for config in sway waybar wofi mako foot btop swayosd gtk-3.0 gtk-4.0; do
    if [ -d "$LATEST_BACKUP/$config" ]; then
        echo "  Restoring $config..."
        rm -rf "$HOME/.config/$config"
        cp -r "$LATEST_BACKUP/$config" "$HOME/.config/$config"
        echo "  ✅ $config restored"
    fi
done

# Restore bashrc
if [ -f "$LATEST_BACKUP/bashrc.bak" ]; then
    echo "  Restoring .bashrc..."
    cp "$LATEST_BACKUP/bashrc.bak" "$HOME/.bashrc"
    echo "  ✅ .bashrc restored"
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║          Rollback Complete!                                ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Backup location: $LATEST_BACKUP"
echo ""
echo "Next steps:"
echo "  1. Log out and log back in"
echo "  2. If you want to try BunkerOS again, run:"
echo "     cd ~/Projects/bunkeros && ./install.sh"
echo ""
