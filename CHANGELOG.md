# CHANGELOG

## 2026.05.21

### What Changed
- Added the four other required markdown scaffold files (created stubs for whichever of `IDEAS.md` / `TODO.md` / `CLAUDE.md` were missing) per the new ecosystem MD-scaffold rule codified in [Kiro-HQ/CLAUDE.md](/home/erik/Insync/Kiro/Kiro-HQ/CLAUDE.md#required-markdown-scaffold-every-repo). README was already substantial; left untouched.

### Files Modified
- CHANGELOG.md
- IDEAS.md (created where missing)
- TODO.md (created where missing)
- CLAUDE.md (created where missing)

## 2026.05.01

**What Changed:** Added CLAUDE.md and CHANGELOG.md to document the repo for Claude Code sessions.

**Technical Details:** CLAUDE.md covers deployment workflow, directory layout, validation commands, shell script conventions, and non-obvious config values (intentional `vm.swappiness=100`, disabled laptop udev rule, pacman GPG key prerequisite).

**Files Modified:** `CLAUDE.md` (created), `CHANGELOG.md` (created)

---

## 2026.04.15 – 2026.04.30

**What Changed:** Major migration from ArcoLinux/edu branding to Kiro. Added Kiro-specific system optimization configs and a comprehensive validation script. Removed large volume of legacy components no longer applicable to the Kiro desktop target.

**Technical Details:**

- Systemd optimization suite added: `journald.conf.d/`, `system.conf.d/`, `user.conf.d/`, `coredump.conf.d/`, `systemd-logind.service.d/` — all centralized under `etc/systemd/`
- `etc/skel/.bin/edu-check-optimizations` added (607 lines) — validates ZRAM, BBR, THP, GPU, kernel params live on the running system
- `usr/local/share/edu/` renamed to `usr/local/share/kiro/` (pacman.conf, gpg.conf, nsswitch.conf, mirrorlist)
- `etc/sysctl.d/99-kiro-optimizations.conf` and full `etc/udev/rules.d/` rule set added for kernel/device tuning
- `README.md` written documenting all kernel params, udev rules, and systemd settings with validation status
- Alacritty theme renamed from `default-arcolinux.toml` to `default-kiro.toml`

**Removed (legacy cleanup):**

- `etc/modprobe.d/` — all entries (amdgpu, audio-hda, nvidia, realtek, intel-ethernet, nobeep, blacklist-watchdog, etc.)
- `etc/X11/xorg.conf.d/` — touchpad and killX rules
- `etc/samba/` — smb.conf examples
- `etc/pacman.d/hooks/` — bootloader hook
- `etc/skel/.bin/` — powermenu-change-colors, powermenu-change-style, starwars
- `etc/skel/.config/nlogout/` — entire nlogout application (source, themes, binary)
- `etc/skel/.config/nitrogen/` and `etc/skel/.config/powermenu/`
- `usr/local/bin/` — ~20 system scripts (sfetch, skel, use, var, velo, sysinfo, toggle-chaotic-repo, remove-socials, and others)
- `usr/share/backgrounds/arco/` — ArcoLinux wallpapers

**Files Modified:** `etc/systemd/**`, `etc/sysctl.d/99-kiro-optimizations.conf`, `etc/udev/rules.d/**`, `etc/skel/.bin/edu-check-optimizations`, `usr/local/share/kiro/**`, `README.md`, `LICENSE`, `.gitignore`
