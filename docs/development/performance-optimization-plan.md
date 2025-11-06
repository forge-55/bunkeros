# BunkerOS Performance Optimization Plan
## Achieving Pop!_OS Parity and Beyond

**Goal:** Match or exceed Pop!_OS's out-of-the-box performance optimization while maintaining BunkerOS's minimalist philosophy.

---

## Current State Analysis

### ✅ What We Have
- **CPU Management:** `auto-cpufreq` with 4-mode profile switching (Auto, Power Saver, Balanced, Performance)
- **Waybar Integration:** Visual battery indicator with one-click profile switching
- **Power Management:** systemd-logind configuration for suspend/screensaver
- **User Experience:** Zero-config automatic CPU optimization

### 🎯 Current Coverage: ~60-70% of Pop!_OS

---

## Gap Analysis: BunkerOS vs Pop!_OS

| Component               | BunkerOS Current        | Pop!_OS COSMIC           | Target State            |
|-------------------------|-------------------------|--------------------------|-------------------------|
| CPU Frequency Scaling   | ✅ auto-cpufreq         | ✅ system76-power        | ✅ Keep current         |
| GPU Power Management    | ❌ None                 | ✅ Automatic             | 🎯 Add detection/config |
| Profile Switching       | ✅ Waybar integration   | ✅ Built-in (3 profiles) | ✅ Keep (4 profiles)    |
| I/O Scheduler           | ❌ Default              | ✅ Optimized             | 🎯 Add intelligent      |
| PCIe Power Management   | ❌ None                 | ✅ ASPM enabled          | 🎯 Add kernel params    |
| USB Power Management    | ❌ None                 | ⚠️  Selective            | 🎯 Add intelligent      |
| Disk Power Management   | ❌ None                 | ✅ Laptop Mode           | 🎯 Add auto-detection   |
| Network Power Mgmt      | ❌ None                 | ⚠️  Basic                | 🎯 Add WiFi/BT control  |
| System Tuning           | ❌ None                 | ✅ Pre-tuned             | 🎯 Add sysctl tweaks    |
| Power Monitoring        | ⚠️  Manual (auto-cpufreq) | ✅ GUI                  | 🎯 Add waybar stats     |
| Thermal Management      | ❌ None                 | ⚠️  Basic                | 🎯 Add thermald         |

---

## Implementation Strategy

### Phase 1: Foundation (GPU + I/O) - 70% → 85%
**Priority:** HIGH  
**Complexity:** Medium  
**User Impact:** Immediate battery life improvement (15-25%)

#### 1.1 GPU Power Management
**Goal:** Automatic GPU power scaling for Intel/AMD/Nvidia

**Components:**
- Hardware detection script (expand existing `detect-display-hardware.sh`)
- GPU-specific power configurations
- Runtime PM enablement
- Nvidia-specific handling (if needed)

**Implementation:**
```bash
scripts/configure-gpu-power.sh
```

**Features:**
- Auto-detect GPU vendor (Intel/AMD/Nvidia)
- Enable appropriate power management:
  - **Intel:** i915 power management via kernel parameters
  - **AMD:** amdgpu runtime PM
  - **Nvidia:** nvidia-smi power limits (if proprietary driver)
- Set conservative power limits on battery
- Store configuration in `/etc/bunkeros/gpu-power.conf`

#### 1.2 Intelligent I/O Scheduler
**Goal:** Optimize disk I/O based on storage type (SSD/NVMe/HDD)

**Components:**
- Storage detection (NVMe vs SATA SSD vs HDD)
- udev rules for automatic scheduler selection
- Per-device optimization

**Implementation:**
```bash
systemd/udev/rules.d/60-bunkeros-io-scheduler.rules
scripts/configure-io-scheduler.sh
```

**Schedulers:**
- **NVMe:** `none` (multi-queue)
- **SSD:** `mq-deadline` or `bfq`
- **HDD:** `bfq` (better for rotational media)

---

### Phase 2: Advanced Power Tuning - 85% → 95%
**Priority:** MEDIUM  
**Complexity:** High  
**User Impact:** Additional 5-15% battery improvement, reduced heat

#### 2.1 PCIe Active State Power Management (ASPM)
**Goal:** Reduce PCIe bus power consumption

**Implementation:**
- Add kernel parameter: `pcie_aspm=force`
- Create conditional loading based on device compatibility
- Test mode for problematic hardware

**File:** `systemd/kernel-params.d/bunkeros-pcie.conf`

**Safety:**
- Test mode that monitors for PCIe errors
- Rollback mechanism for incompatible hardware
- Whitelist/blacklist for known devices

#### 2.2 USB Selective Suspend
**Goal:** Power down idle USB devices without breaking functionality

**Implementation:**
```bash
scripts/configure-usb-power.sh
systemd/udev/rules.d/60-bunkeros-usb-power.rules
```

**Features:**
- Intelligent device detection
- Blacklist for problematic devices (mice, keyboards, USB audio)
- Power mode profiles:
  - **Performance:** Disable autosuspend
  - **Balanced:** Selective (exclude HID devices)
  - **Power Saver:** Aggressive (2-second timeout)

#### 2.3 Network Power Management
**Goal:** Reduce WiFi/Bluetooth power on battery

**Implementation:**
```bash
scripts/configure-network-power.sh
```

**Features:**
- WiFi power saving mode (iwlwifi, ath10k)
- Bluetooth LE power management
- Profile-based control:
  - **Performance:** Power saving OFF
  - **Balanced:** Moderate power saving
  - **Power Saver:** Aggressive power saving

---

### Phase 3: System-Wide Optimization - 95% → 100%+
**Priority:** LOW  
**Complexity:** Low-Medium  
**User Impact:** 5-10% improvement, better responsiveness

#### 3.1 Laptop Mode Tools
**Goal:** Optimize disk and filesystem power consumption

**Implementation:**
- Install `laptop-mode-tools` as optional dependency
- Configure automatic activation on battery
- Tune writeback parameters

**Configuration:**
```bash
/etc/laptop-mode/laptop-mode.conf
```

#### 3.2 Thermal Management
**Goal:** Proactive thermal control for better performance

**Implementation:**
```bash
systemd/system/thermald.service (if Intel)
scripts/install-thermal-management.sh
```

**Features:**
- Install `thermald` for Intel CPUs
- Configure thermal profiles per power mode
- Integration with existing profile switching

#### 3.3 System-Wide Kernel Tuning
**Goal:** Optimize kernel parameters for laptop use

**Implementation:**
```bash
/etc/sysctl.d/99-bunkeros-performance.conf
```

**Tuning Areas:**
- Virtual memory management (swappiness, dirty ratios)
- Network stack efficiency
- Filesystem caching behavior
- Process scheduling (for responsive desktop)

**Example Parameters:**
```ini
# Reduce swappiness (prefer RAM over swap)
vm.swappiness = 10

# Improve desktop responsiveness
vm.vfs_cache_pressure = 50

# Network optimization
net.core.netdev_max_backlog = 16384
net.ipv4.tcp_fastopen = 3

# Writeback tuning for laptops
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5
```

---

## Phase 4: Monitoring & User Experience - Polish
**Priority:** MEDIUM  
**Complexity:** Medium  
**User Impact:** Better visibility and control

#### 4.1 Enhanced Waybar Power Stats
**Goal:** Real-time power consumption monitoring

**Features:**
- Current power draw (W) from `/sys/class/power_supply/BAT*/power_now`
- Estimated battery time remaining (intelligent calculation)
- CPU frequency and temperature
- Toggle detailed stats view

**Implementation:**
```bash
waybar/scripts/battery-stats.sh
waybar/modules/battery-enhanced.jsonc
```

#### 4.2 Power Usage Diagnostics
**Goal:** Help users identify power-hungry processes

**Implementation:**
```bash
scripts/power-usage-report.sh
```

**Features:**
- Wrapper around `powertop` with BunkerOS styling
- Identify top power consumers
- Suggest optimizations
- Export reports

#### 4.3 Performance Benchmarking
**Goal:** Measure optimization impact

**Implementation:**
```bash
scripts/benchmark-power-performance.sh
```

**Metrics:**
- Battery discharge rate (W)
- Suspend/resume latency
- Boot time
- CPU throttling frequency
- Thermal performance

---

## Architecture Decisions

### ✅ Keep auto-cpufreq (Don't Switch to TLP)
**Rationale:**
- `auto-cpufreq` is simpler and better integrated with BunkerOS
- Waybar profile switching is already implemented
- TLP and auto-cpufreq conflict (can't run both)
- We can add GPU/I/O management separately

**Alternative Considered:** Full TLP migration
**Rejected Because:**
- More complex configuration
- Would lose current Waybar integration
- Overkill for BunkerOS's target audience

### ✅ Modular, Profile-Aware Design
**Rationale:**
- Each optimization component respects power profile
- Users can enable/disable individual features
- No monolithic configuration files

**Design Pattern:**
```bash
# Each script checks current power profile
POWER_PROFILE=$(cat /tmp/auto-cpufreq-mode 2>/dev/null || echo "auto")

case "$POWER_PROFILE" in
    "powersave")
        apply_aggressive_settings
        ;;
    "performance")
        apply_performance_settings
        ;;
    *)
        apply_balanced_settings
        ;;
esac
```

### ✅ Hardware Detection First
**Rationale:**
- Don't apply settings for hardware that doesn't exist
- Prevent breaking systems with incompatible configs
- Mirror Pop!_OS's intelligent adaptation

**Implementation:**
- Extend `detect-display-hardware.sh` → `detect-system-hardware.sh`
- Create hardware profiles
- Conditional feature activation

---

## Testing Strategy

### Test Matrix

| Hardware Type        | Test Cases                                           |
|----------------------|------------------------------------------------------|
| Intel Laptop         | CPU freq scaling, GPU PM, thermal management         |
| AMD Laptop           | CPU freq scaling, amdgpu PM                          |
| Nvidia Laptop        | Hybrid graphics, nvidia power management             |
| NVMe System          | I/O scheduler, writeback tuning                      |
| SATA SSD System      | I/O scheduler                                        |
| WiFi 5/6/6E          | Power saving modes                                   |
| Bluetooth            | LE power management                                  |

### Validation Metrics

**Before/After Comparison:**
1. **Idle Power Draw:** Measure with `powertop` (target: < 5W for modern laptops)
2. **Battery Life:** Real-world usage test (target: +20% improvement)
3. **Performance:** Geekbench/stress tests (ensure no regression)
4. **Thermal:** Monitor CPU temp under load (target: stay under thermal throttle)
5. **Responsiveness:** Desktop latency, app launch times (no degradation)

---

## Rollout Plan

### Stage 1: Development (Week 1-2)
- [ ] Create GPU power management script
- [ ] Create I/O scheduler configuration
- [ ] Extend hardware detection
- [ ] Write integration tests

### Stage 2: Internal Testing (Week 3)
- [ ] Test on reference hardware (ThinkPad T480 mentioned in TODO)
- [ ] Validate power profile switching
- [ ] Measure battery life improvements
- [ ] Check for regressions

### Stage 3: Beta Release (Week 4)
- [ ] Document new features
- [ ] Create upgrade path for existing users
- [ ] Add to main installation script
- [ ] Publish benchmark results

### Stage 4: Production (Week 5+)
- [ ] Merge to main branch
- [ ] Update documentation
- [ ] Announce improvements
- [ ] Gather user feedback

---

## File Structure

```
bunkeros/
├── scripts/
│   ├── configure-gpu-power.sh           # NEW: GPU power management
│   ├── configure-io-scheduler.sh        # NEW: I/O optimization
│   ├── configure-usb-power.sh           # NEW: USB power control
│   ├── configure-network-power.sh       # NEW: WiFi/BT power
│   ├── install-thermal-management.sh    # NEW: thermald setup
│   ├── detect-system-hardware.sh        # EXPAND: detect-display-hardware.sh
│   ├── power-usage-report.sh            # NEW: User diagnostics
│   ├── benchmark-power-performance.sh   # NEW: Performance testing
│   └── install-power-management.sh      # UPDATE: Call new scripts
├── systemd/
│   ├── udev/
│   │   └── rules.d/
│   │       ├── 60-bunkeros-io-scheduler.rules    # NEW
│   │       └── 60-bunkeros-usb-power.rules       # NEW
│   ├── kernel-params.d/
│   │   └── bunkeros-pcie.conf           # NEW
│   └── sysctl.d/
│       └── 99-bunkeros-performance.conf # NEW
├── bunkeros/
│   ├── gpu-power.conf                   # NEW: GPU config
│   └── hardware-profile.conf            # NEW: Detected hardware
├── waybar/
│   ├── scripts/
│   │   └── battery-stats.sh             # UPDATE: Enhanced stats
│   └── modules/
│       └── battery-enhanced.jsonc       # NEW: Detailed battery module
└── docs/
    ├── features/
    │   ├── battery-profiles.md          # UPDATE: Document new features
    │   └── power-optimization.md        # NEW: User guide
    └── development/
        └── performance-optimization-plan.md  # THIS FILE
```

---

## Success Criteria

### Minimum Viable (85% Parity)
- [x] CPU power management working (already done)
- [ ] GPU power management for Intel/AMD
- [ ] I/O scheduler optimization
- [ ] Basic documentation

### Target (95% Parity)
- [ ] PCIe ASPM enabled
- [ ] USB selective suspend
- [ ] Network power management
- [ ] Comprehensive testing on 3+ laptop models

### Stretch (100%+ - Exceed Pop!_OS)
- [ ] Enhanced waybar power monitoring
- [ ] User-facing diagnostics tools
- [ ] Automated benchmarking
- [ ] Per-application power profiles (e.g., "gaming mode")

---

## Resources & References

### Arch Linux Wiki
- [Power Management](https://wiki.archlinux.org/title/Power_management)
- [Laptop Mode Tools](https://wiki.archlinux.org/title/Laptop_Mode_Tools)
- [Improving Performance](https://wiki.archlinux.org/title/Improving_performance)
- [CPU Frequency Scaling](https://wiki.archlinux.org/title/CPU_frequency_scaling)

### Pop!_OS / System76
- [system76-power GitHub](https://github.com/pop-os/system76-power)
- COSMIC power management approach (profile-based)

### BunkerOS Existing Docs
- `docs/features/battery-profiles.md` - Current implementation
- `scripts/install-power-management.sh` - Base installation
- `waybar/` - Profile switching UI

---

## Notes

**ThinkPad T480 Specific (from TODO):**
- Has dual battery setup (internal + external)
- Requires special handling for battery indicator
- Excellent test platform for power management (common laptop)

**Philosophy:**
- Maintain BunkerOS minimalism (no bloat)
- Everything should "just work" out of the box
- Advanced users can disable components
- Profile switching is the core UX paradigm

**Non-Goals:**
- Don't replicate `tlp` functionality wholesale (stay focused)
- Don't add GUI configuration tools (keep it lightweight)
- Don't optimize for desktop PCs (laptop-first approach is fine)

---

**Last Updated:** 2025-11-06  
**Status:** 📋 Planning Phase  
**Owner:** @forge-55  
**Next Steps:** Begin Phase 1 implementation (GPU + I/O)
