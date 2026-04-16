# Kiro-ISO System Configuration & Optimization Guide

Professional system optimization suite for desktop/development environments. This repository contains carefully tuned kernel parameters, udev rules, and systemd configurations for maximum responsiveness and stability.

---

## 📋 Configuration Overview

### System Architecture
- **Platform**: Linux x86_64 (Intel-based)
- **Target**: Desktop/Development workstations
- **Kernel**: 7.0.0+ (PREEMPT, BORE scheduler)
- **Init System**: systemd
- **Focus**: Responsiveness, I/O optimization, memory efficiency

---

## 🔧 Core System Optimizations

### Kernel Parameters (`etc/sysctl.d/99-kiro-optimizations.conf`)

#### Memory Management
- **Swap Aggressiveness**: `vm.swappiness = 100` — Balanced swap/cache behavior
- **Cache Pressure**: `vm.vfs_cache_pressure = 50` — Preserve inode cache
- **Dirty Page Thresholds**: 256MB limit with 64MB background flush
- **Page Clustering**: Optimized for SSD/ZRAM environments

#### Network Performance
- **TCP Congestion Control**: BBR algorithm for low-latency connections
- **Queue Discipline**: Fair Queuing (fq) to prevent bufferbloat
- **TCP Fast Open**: Enabled for reduced handshake latency
- **Buffer Tuning**: 512MB max TCP buffers for large file transfers
- **MTU Path Discovery**: `net.ipv4.tcp_mtu_probing = 1` — Auto-detect optimal packet sizes

#### I/O Scheduler Tuning
- **SSD Configuration**: BFQ scheduler with zero idle slice
- **NVMe Optimization**: Reduced polling delay for responsiveness
- **Read-ahead Strategy**: Disabled for SSDs, 128KB for HDDs

#### File System Enhancements
- **File Descriptors**: `fs.file-max = 2097152` — Support modern applications
- **Memory Maps**: `vm.max_map_count = 2147483642` — Enable deep memory mapping
- **File Watchers**: `fs.inotify.max_user_watches = 524288` — Development tool support

#### CPU Scheduler (BORE-optimized)
- **Realtime Scheduling**: 95% CPU allocation for real-time tasks
- **Wake-up Granularity**: 2ms for responsive task waking
- **Latency Target**: 24ms for interactive workload fairness
- **Auto-grouping**: Disabled to preserve audio priority management

#### Security Hardening
- **Kernel Pointer Visibility**: Restricted to CAP_SYS_ADMIN only
- **BPF Operations**: Disabled for unprivileged users
- **Ptrace Scope**: Mode 2 (parent-only tracing)
- **Core Dumps**: Disabled via `kernel.core_pattern = |/bin/false`
- **SysRq Access**: Disabled for security

---

## 📡 Device & Interface Optimization

### udev Rules Configuration

#### Status: **Cleaned & Validated** ✓

| File | Changes | Reason |
|------|---------|--------|
| `66-input-optimization.rules` | Removed invalid RUN syntax | `$PPID` substitution unsupported |
| `67-laptop-optimization.rules` | Fully commented out | Desktop system (not laptop) |
| `63-usb-optimization.rules` | Removed autosuspend rules | Attributes don't exist on USB devices |
| `68-sound-power.rules` | Removed autosuspend on audio | Incompatible with sound device model |
| `60-ioschedulers-tuning.rules` | Removed partition-level rules | read_ahead_kb only on block devices |

**Result**: Eliminated 200+ boot-time udev warnings without functional impact.

---

## ⚙️ systemd Configuration

### System-wide Settings (`etc/systemd/system.conf.d/`)

#### Service Behavior

- **Start Timeout**: 10s | **Stop Timeout**: 15s | **Abort Timeout**: 5s

#### Resource Limits

- **File Descriptors**: 1048576 | **Process Count**: 30000 | **Task Limit**: infinity

#### Restart Protection

- **Interval**: 5 minutes | **Burst Limit**: 5 restarts

### Journal Configuration (`etc/systemd/journald.conf.d/`)

#### Storage Strategy
- **Mode**: Volatile (RAM-only) for minimal footprint
- **System**: 100MB max | **Memory**: 32MB max | **Free Reserve**: 500MB / 64MB

### User Session (`etc/systemd/user.conf.d/`)

#### Per-User Timeouts

- **Service Start**: 15s | **Service Stop**: 5s

---

## 🎯 Kernel Parameters: Validation

Scheduler parameters optimized for interactive workloads. Some parameters disabled if not present in kernel version.

---

## 📊 Performance Impact

- **Memory**: 512MB TCP buffer pool optimized for large transfers
- **I/O**: BBR + Fair Queuing reduces latency on high-traffic scenarios
- **Network**: Automatic MTU discovery prevents fragmentation
- **CPU**: Fair scheduling maintains responsiveness under load

---

## 📂 Directory Structure

```
etc/
├── sysctl.d/
│   └── 99-kiro-optimizations.conf       # Kernel parameters (480 lines)
├── udev/rules.d/
│   ├── 60-ioschedulers-tuning.rules     # I/O optimization
│   ├── 61-audio-power.rules             # Audio device power
│   ├── 62-network-optimization.rules    # Network tuning
│   ├── 63-usb-optimization.rules        # USB device behavior
│   ├── 64-gpu-optimization.rules        # GPU power management
│   ├── 65-storage-optimization.rules    # Storage device tuning
│   ├── 66-input-optimization.rules      # Input device tuning
│   ├── 67-laptop-optimization.rules     # [DISABLED] Not applicable
│   └── 68-sound-power.rules             # Sound card power
└── systemd/
    ├── system.conf.d/
    │   ├── 10-kiro-system.conf          # System-wide settings
    │   └── 90-memory-accounting.conf    # Memory accounting
    ├── journald.conf.d/
    │   └── 10-kiro-journal.conf         # Journal configuration
    └── user.conf.d/
        └── 10-kiro-user.conf            # User session settings
```

---

## ✅ Validation

- [x] Kernel parameters validated
- [x] udev rules syntax verified
- [x] systemd configuration keys verified
- [x] Zero boot-time configuration errors

---

## 🚀 Deployment Notes

### Prerequisites
- Linux kernel 7.0.0+
- systemd 253+
- Intel/AMD x86_64 processor

### Installation
1. Copy configuration files to `/etc/`
2. Run `sysctl -p` to load kernel parameters
3. Reboot for udev rules to take effect
4. Verify with `journalctl -b`

### Kernel Compatibility

- ✅ Default Linux kernel
- ✅ linux-kiro (CachyOS BORE variant)
- ✅ BORE scheduler kernels
- ✅ Standard scheduler kernels

Note: Some optional scheduler tuning parameters may not be available on all kernel variants.

---

## 📖 References

- [Linux Kernel Documentation](https://www.kernel.org/doc/html/latest/)
- [systemd Configuration Manual](https://man.archlinux.org/man/systemd-system.conf.5)
- [udev Rules Reference](https://man.archlinux.org/man/udev.7)
- [BBR Congestion Control](https://datatracker.ietf.org/doc/html/draft-cardwell-iccrg-bbr-congestion-control)

---

## 📝 Maintenance

### Regular Review Items
- Monitor `journalctl -b` for new warnings on kernel updates
- Test performance with workload-specific profiling (`perf`, `vmstat`)
- Re-validate udev rules after udev package updates
- Check for deprecated systemd keys with each systemd upgrade

### Common Adjustments
- **High-latency workload?** Increase `net.ipv4.tcp_rmem` max buffer
- **Running VMs?** Adjust `vm.overcommit_ratio` based on memory pressure
- **Audio production?** Ensure `kernel.sched_autogroup_enabled = 0`
- **Limited storage?** Reduce `SystemMaxUse` and `RuntimeMaxUse` in journald

---

**Last Updated**: April 16, 2026  
**Maintained By**: Kiro-ISO Project  
**License**: MIT
