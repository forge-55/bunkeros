# JetBrains IDEs on BunkerOS

This guide covers installing and configuring JetBrains IDEs (PyCharm, WebStorm, IntelliJ IDEA, etc.) on BunkerOS.

## Prerequisites

BunkerOS includes all necessary Java runtimes and Python dependencies for JetBrains IDEs:
- ✅ `jdk-openjdk` - Java Development Kit
- ✅ `jre-openjdk` - Java Runtime Environment
- ✅ `python-setuptools` - Required for PyCharm
- ✅ `python-pip` - Python package manager

## Installation Options

### Option 1: AUR Installation (Recommended for Auto-Updates)

Install your preferred IDE via yay:

```bash
# PyCharm Community Edition
yay -S pycharm-community-edition

# PyCharm Professional
yay -S pycharm-professional

# WebStorm
yay -S webstorm

# IntelliJ IDEA Community
yay -S intellij-idea-community-edition

# IntelliJ IDEA Ultimate
yay -S intellij-idea-ultimate-edition
```

### Option 2: Official Tarball (Recommended for Stability)

Download from [JetBrains official site](https://www.jetbrains.com/products/):

```bash
# Example for PyCharm
cd ~/Downloads
wget https://download.jetbrains.com/python/pycharm-community-2024.3.tar.gz
tar -xzf pycharm-community-2024.3.tar.gz
sudo mv pycharm-community-2024.3 /opt/pycharm
```

## First Launch & Runtime Configuration

### Common "Cannot Find Runtime" Fix

If you encounter "Cannot find a runtime" error on first launch:

1. **Launch via shell script** (instead of desktop file):
   ```bash
   # PyCharm
   /opt/pycharm/bin/pycharm.sh
   
   # WebStorm
   /opt/webstorm/bin/webstorm.sh
   
   # IntelliJ IDEA
   /opt/idea/bin/idea.sh
   ```

2. **Set Boot Runtime** (at the welcome screen, before opening any project):
   - Press: `Ctrl + Shift + A`
   - Type: `Choose Boot Java Runtime for the IDE`
   - Select "New" and pick the latest JetBrains Java runtime version
   - Click OK and restart the IDE

3. **Alternative: Use System Java**
   If the above doesn't work, you can set the IDE to use the system JDK:
   ```bash
   export IDEA_JDK=/usr/lib/jvm/java-21-openjdk
   /opt/pycharm/bin/pycharm.sh
   ```

### Config Folder Fix (If Runtime Setup Fails)

Sometimes the config directory isn't created for new IDE versions. Fix by duplicating from a previous version:

```bash
# Example: WebStorm 2024.2 → 2024.3
cp -r ~/.config/JetBrains/WebStorm2024.2 ~/.config/JetBrains/WebStorm2024.3

# Example: PyCharm 2024.2 → 2024.3
cp -r ~/.config/JetBrains/PyCharm2024.2 ~/.config/JetBrains/PyCharm2024.3
```

Adjust folder names based on your installed versions.

## PyCharm Specific Issues

### Python Dependencies

If PyCharm fails to start after AUR installation:

```bash
# Ensure setuptools is installed (already included in BunkerOS)
pip install --user setuptools

# If using virtual environments, ensure venv is available
python -m venv --help
```

### Setting Python Interpreter

1. Open Settings: `Ctrl + Alt + S`
2. Navigate to: **Project → Python Interpreter**
3. Click the gear icon → **Add Interpreter**
4. Choose:
   - **System Interpreter**: `/usr/bin/python`
   - **Virtual Environment**: Create or select existing venv

## WebStorm Specific Issues

### Node.js Configuration

BunkerOS includes Node.js and npm by default. To configure in WebStorm:

1. Open Settings: `Ctrl + Alt + S`
2. Navigate to: **Languages & Frameworks → Node.js**
3. Set Node interpreter: `/usr/bin/node`
4. Package manager: Automatic detection should find npm

## Desktop Integration

### Create Desktop Entry (for Tarball Installs)

If you installed via tarball and want a desktop launcher:

```bash
# Example for PyCharm
cat > ~/.local/share/applications/pycharm.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=PyCharm Community
Icon=/opt/pycharm/bin/pycharm.svg
Exec=/opt/pycharm/bin/pycharm.sh %f
Comment=Python IDE for Professional Developers
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-pycharm
EOF

# Update desktop database
update-desktop-database ~/.local/share/applications/
```

Adjust paths for other IDEs (WebStorm, IntelliJ, etc.).

## Performance Optimization

### Increase Memory Allocation (for large projects)

Edit the IDE's custom VM options:

1. Help → **Edit Custom VM Options**
2. Adjust heap size:
   ```
   -Xms512m
   -Xmx4096m
   ```

### Disable Unnecessary Plugins

1. File → Settings → Plugins
2. Disable plugins you don't use to reduce memory footprint

## Wayland Compatibility

JetBrains IDEs work well on BunkerOS's Wayland environment. If you experience rendering issues:

1. Edit the IDE's custom properties:
   - Help → **Edit Custom Properties**
   
2. Add (if not already present):
   ```properties
   # Force native Wayland support (experimental)
   # Only enable if you have specific rendering issues
   # sun.java2d.xrender=false
   ```

Most users won't need this - the default X11 compatibility layer works perfectly.

## Troubleshooting

### IDE Won't Start After Update

1. **Clear caches**:
   ```bash
   # PyCharm
   rm -rf ~/.cache/JetBrains/PyCharm*
   
   # WebStorm
   rm -rf ~/.cache/JetBrains/WebStorm*
   ```

2. **Reset runtime configuration**:
   ```bash
   # Remove custom runtime configs
   rm ~/.config/JetBrains/*/user.jdk
   ```

3. **Reinstall** (AUR):
   ```bash
   yay -Rns pycharm-community-edition
   yay -S pycharm-community-edition
   ```

### Check Java Version

Verify your Java installation:

```bash
java -version
javac -version
```

Should show OpenJDK 21 or later.

### AUR Package Issues

If persistent issues occur with AUR packages, check the package comments:
- [PyCharm AUR](https://aur.archlinux.org/packages/pycharm-community-edition)
- [WebStorm AUR](https://aur.archlinux.org/packages/webstorm)

Or switch to the official tarball installation method.

## Summary

**BunkerOS is fully compatible with JetBrains IDEs.** All necessary Java runtimes and Python dependencies are pre-installed. If you encounter startup issues:

1. ✅ Launch via shell script (`/opt/*/bin/*.sh`)
2. ✅ Configure Boot Runtime via `Ctrl + Shift + A`
3. ✅ Use official tarball if AUR packages have issues

For most users, AUR installation works flawlessly after initial runtime configuration.
