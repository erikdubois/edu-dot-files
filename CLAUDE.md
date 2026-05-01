# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Educational/reference dotfiles and system configuration suite for Kiro-ISO and Arch-based Linux desktops. It is deployed by copying files into place on target systems — there is no build step.

## Deployment

```bash
# Load kernel params immediately (no reboot needed)
sudo sysctl -p /etc/sysctl.d/99-kiro-optimizations.conf

# Full deployment: copy etc/ and usr/ trees, then reboot for udev rules
sudo cp -r etc/ /etc/
sudo cp -r usr/ /usr/
sudo reboot
```

The `up.sh` script commits all changes with message "update" and pushes to origin — it is the only release mechanism.

## Directory layout

- `etc/skel/.bin/` — 41 user-facing shell scripts installed to `~/.bin/` on new accounts. Covers system utilities (`edu-check-optimizations`, `update-system`), color tools, ASCII art demos, and network setup helpers under `samba/`.
- `etc/skel/.config/` — Application configs for alacritty, btop, fastfetch, micro, neofetch, plank, Qt5/Kvantum, GTK3/4, paru.
- `etc/sysctl.d/` — Kernel parameter tuning (BBR, ZRAM, BORE scheduler, I/O, security).
- `etc/udev/rules.d/` — Device optimization rules; `67-laptop-optimization.rules` is intentionally disabled (desktop-only system).
- `etc/systemd/` — system.conf.d, journald.conf.d, user.conf.d overrides.
- `usr/local/share/kiro/` — System-wide Kiro configs: pacman.conf (includes Nemesis and Chaotic AUR repos), gpg.conf, nsswitch.conf, mirrorlist.
- `usr/share/plank/themes/` — 30+ Plank dock themes.

## Validation

```bash
# Check live system matches expected optimizations
~/.bin/edu-check-optimizations

# Verify udev rule syntax
udevadm verify /etc/udev/rules.d/

# Check for new boot-time warnings after kernel updates
journalctl -b | grep -i "failed\|error\|warn"
```

## Shell script conventions

All scripts use bash. `up.sh` intentionally omits `set -e` (commented out). New utility scripts in `.bin/` should follow the existing pattern: bash shebang, no set -e if interactive, color output via `tput`.

## Key config notes

- `pacman.conf` includes `[nemesis_repo]` and `[chaotic-aur]` — these require the corresponding GPG keys and mirrorlist entries to be installed first.
- btop themes are Catppuccin variants stored in `.config/btop/themes/`.
- micro editor ships 200+ YAML syntax files and 4 color schemes under `.config/micro/`.
- The `vm.swappiness = 100` in sysctl is intentional for ZRAM-heavy setups — not a typo.
