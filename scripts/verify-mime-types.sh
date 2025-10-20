#!/bin/bash
# BunkerOS MIME Type Verification Script
# Checks if default applications are properly configured

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  BunkerOS MIME Type Association Verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
PASS=0
FAIL=0
WARN=0

check_mime() {
    local mime_type="$1"
    local expected="$2"
    local description="$3"
    
    local actual=$(xdg-mime query default "$mime_type" 2>/dev/null)
    
    if [ -z "$actual" ]; then
        echo -e "${RED}✗${NC} $description"
        echo "  MIME: $mime_type → ${RED}NOT SET${NC}"
        ((FAIL++))
    elif [ "$actual" = "$expected" ]; then
        echo -e "${GREEN}✓${NC} $description"
        echo "  MIME: $mime_type → $actual"
        ((PASS++))
    else
        echo -e "${YELLOW}⚠${NC} $description"
        echo "  MIME: $mime_type → $actual (expected: $expected)"
        ((WARN++))
    fi
    echo ""
}

echo "Checking Image Files..."
echo "─────────────────────────────────────────────────────"
check_mime "image/png" "org.gnome.eog.desktop" "PNG Images"
check_mime "image/jpeg" "org.gnome.eog.desktop" "JPEG Images"
check_mime "image/gif" "org.gnome.eog.desktop" "GIF Images"
check_mime "image/webp" "org.gnome.eog.desktop" "WebP Images"

echo "Checking Document Files..."
echo "─────────────────────────────────────────────────────"
check_mime "application/pdf" "org.gnome.Evince.desktop" "PDF Documents"

echo "Checking Text Files..."
echo "─────────────────────────────────────────────────────"
check_mime "text/plain" "code.desktop" "Plain Text Files"
check_mime "text/markdown" "code.desktop" "Markdown Files"

echo "Checking Code Files..."
echo "─────────────────────────────────────────────────────"
check_mime "text/x-python" "code.desktop" "Python Scripts"
check_mime "text/x-shellscript" "code.desktop" "Shell Scripts"
check_mime "application/javascript" "code.desktop" "JavaScript Files"
check_mime "application/json" "code.desktop" "JSON Files"
check_mime "text/html" "code.desktop" "HTML Files"

echo "Checking Archive Files..."
echo "─────────────────────────────────────────────────────"
check_mime "application/zip" "org.gnome.FileRoller.desktop" "ZIP Archives"
check_mime "application/x-tar" "org.gnome.FileRoller.desktop" "TAR Archives"
check_mime "application/x-compressed-tar" "org.gnome.FileRoller.desktop" "TAR.GZ Archives"

echo "Checking Directories..."
echo "─────────────────────────────────────────────────────"
check_mime "inode/directory" "org.gnome.Nautilus.desktop" "Directories"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✓ Passed:${NC}  $PASS"
echo -e "${YELLOW}⚠ Warning:${NC} $WARN"
echo -e "${RED}✗ Failed:${NC}  $FAIL"
echo ""

if [ $FAIL -gt 0 ]; then
    echo -e "${RED}Some MIME types are not configured.${NC}"
    echo "Run the following to fix:"
    echo "  cd ~/Projects/bunkeros"
    echo "  bash setup.sh"
    echo ""
    echo "Or manually configure with:"
    echo "  xdg-mime default <application>.desktop <mime/type>"
    exit 1
elif [ $WARN -gt 0 ]; then
    echo -e "${YELLOW}Some MIME types have unexpected handlers.${NC}"
    echo "This may be intentional if you've customized your setup."
    exit 0
else
    echo -e "${GREEN}All MIME types are properly configured! 🎯${NC}"
    exit 0
fi
