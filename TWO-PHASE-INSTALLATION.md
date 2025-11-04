# Two-Phase Installation Implementation

## Overview

BunkerOS now uses a **two-phase installation** approach to prevent display manager conflicts and ensure safe, testable deployment.

## The Problem We Solved

### Previous Single-Phase Installer Issues:
- Attempted to switch display managers while graphical session was active
- Could kill the current session → blank screen
- Users might get locked out without TTY access
- System in unstable transition state during installation
- If anything failed, system could be unusable

### Real-World Issue That Triggered This:
> "Hmm, something went very wrong with the installation, I came to a blank screen partway through, and it is very difficult to get into a tty on my keyboard."

This happened because the installer tried to:
1. Stop the running display manager (GDM/LightDM/etc.)
2. Enable SDDM
3. Continue installation

**Result**: Killed the graphical session mid-install → blank screen.

## The Two-Phase Solution

### Phase 1: `install.sh` - User Environment (Safe)
**What it does:**
- System preparation and preflight checks
- Package installation (Sway, Waybar, etc.)
- User configuration deployment (~/.config)
- PipeWire and user service setup
- Sway configuration validation
- **Does NOT touch display manager**

**Safety:**
- Runs in your current graphical environment
- No risk of session interruption
- Can be re-run if interrupted
- Checkpoint-based resumption

**Result:** 
- Working BunkerOS environment
- Testable with `sway` command
- Current desktop environment intact

### Phase 2: `install-sddm.sh` - System Integration (Safe)
**What it does:**
- Verifies Phase 1 completed successfully
- Prompts user to test BunkerOS first
- Installs SDDM theme and session files
- Handles existing display manager intelligently
- Enables SDDM for next boot
- **Changes take effect only after reboot**

**Safety:**
- Doesn't stop running display manager
- No session interruption
- Graceful transition on reboot
- Can be skipped if user wants

**Result:**
- SDDM themed login screen (after reboot)
- BunkerOS sessions available
- Original DM disabled safely

## Installation Flow

```
┌─────────────────────────────────────────────────────────┐
│ Phase 1: ./install.sh                                   │
├─────────────────────────────────────────────────────────┤
│ • Install packages                                      │
│ • Deploy configs                                        │
│ • Setup services                                        │
│ • Validate Sway                                         │
│ ✓ User environment ready                               │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
         ┌───────────────────────────────┐
         │ TEST: Run 'sway' command      │
         │ Verify everything works       │
         │ Exit with Super+Shift+E       │
         └───────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│ Phase 2: ./install-sddm.sh (Optional)                  │
├─────────────────────────────────────────────────────────┤
│ • Install SDDM theme                                    │
│ • Install session files                                 │
│ • Handle DM switching                                   │
│ • Enable SDDM (no immediate effect)                     │
│ ✓ SDDM configured for next boot                        │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
         ┌───────────────────────────────┐
         │ REBOOT                        │
         │ SDDM starts                   │
         │ Select "BunkerOS" session     │
         │ Themed login experience       │
         └───────────────────────────────┘
```

## Key Benefits

### 1. Safety First
- No risk of killing active session
- System remains stable throughout
- Testable before committing

### 2. Better UX
- User can verify BunkerOS works
- Clear separation of concerns
- Explicit opt-in for SDDM

### 3. Fault Tolerance
If Phase 2 fails, user still has:
- ✅ Working BunkerOS (launch with `sway`)
- ✅ Original display manager
- ✅ Stable system

### 4. Flexibility
- Can use BunkerOS without SDDM
- Can install SDDM later
- Can test thoroughly first

## Implementation Details

### Phase 1 Changes (`install.sh`)
**Removed:**
- `handle_display_manager()` function
- SDDM theme installation call
- Display manager conflict handling

**Added:**
- Clear instructions for Phase 2
- Emphasis on testing with `sway`
- Pointer to `install-sddm.sh`

### Phase 2 Script (`install-sddm.sh`)
**Features:**
- Pre-flight check for Phase 1 completion
- Prompts user to test first
- Installs SDDM theme via `sddm/install-theme.sh`
- Smart display manager detection
- Safe switching (disable old, enable new, effective on reboot)
- Clear instructions for what happens next

## Usage

### For Users
```bash
# Phase 1: Install user environment
./install.sh

# Test it works
sway
# (Verify Waybar, keybindings, audio, etc.)
# Exit with Super+Shift+E

# Phase 2: Install SDDM (optional)
./install-sddm.sh

# Reboot to see SDDM
sudo reboot
```

### For Developers
When adding features, consider:
- Does this need to run before testing? → Phase 1
- Does this need system-wide installation? → Phase 2
- Could this interrupt the session? → Phase 2 (and make it reboot-safe)

## Documentation Updates

### Updated Files:
1. **`INSTALL.md`**
   - New section: "Why Two-Phase Installation?"
   - Updated Quick Installation with two phases
   - Added testing instructions between phases

2. **`install.sh`**
   - Removed display manager handling
   - Updated final message to explain phases
   - Clear instructions for next steps

3. **`install-sddm.sh`** (NEW)
   - Complete Phase 2 installer
   - Comprehensive error handling
   - User-friendly prompts and explanations

## Future Enhancements

For a fully bundled installation or ISO:
- Could merge phases again (since fresh install = no running DM)
- Add automated testing between phases
- Pre-configure SDDM in the ISO itself
- Skip DM switching logic entirely

Until then, **two-phase installation is the safest approach** for existing systems.

## Lessons Learned

1. **Never stop active display manager during installation**
   - Kills user's session
   - Leaves them with blank screen
   - Very difficult to recover

2. **Test before committing**
   - Users should verify BunkerOS works
   - Prevents post-installation surprises
   - Builds confidence

3. **Separate user and system concerns**
   - User configs: Can install anytime, anywhere
   - System services: Require care, planning, reboots

4. **Prioritize stability over convenience**
   - Two steps is better than one broken step
   - Users prefer working systems to fast installs

## Conclusion

The two-phase installation solved a **critical safety issue** where users could get locked out mid-installation. By separating user environment setup from system-wide display manager changes, we've created a **robust, testable, and safe** installation process that works on systems with existing display managers.

This approach will remain until we have a fully bundled installation or ISO where we control the entire environment from boot.
