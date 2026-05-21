# edu-dot-files

User-level dotfiles and shared assets for the Kiro distro: the `/etc/skel/` snapshot that new users inherit, a curated Plank dock theme library, and Kiro-branded reference configs for pacman / GPG / DNS. The user-facing companion to the system-level [edu-system-files](https://github.com/erikdubois/edu-system-files).

## What's in this repo

### `etc/skel/` — new-user home template
- `.bin/` — helper scripts shipped into `$HOME/.bin/`
- `.cache/`, `.local/` — XDG cache / state scaffolding
- `.config/` — user-level program configs (one subdir per app)
- `.fehbg` — `feh` wallpaper restore helper

New users created after installation inherit this content automatically. Existing users can sync it in with `cp -rT /etc/skel ~/`.

### `usr/share/plank/themes/` — Plank dock theme library
~160 [Plank](https://launchpad.net/plank) dock themes bundled together: macOS, Gnosemite, Cyberpunk, Catppuccin, Solarized, TokyoNight, Mojave, Monterey, and many more. Selectable from Plank's right-click menu once installed.

### `usr/local/share/kiro/` — Kiro reference configs
Read-only canonical copies of the configs that the `kiro-fix-*` toolchain (in [edu-system-files](https://github.com/erikdubois/edu-system-files)) restores when things drift:

- `pacman.conf`
- `mirrorlist`
- `gpg.conf`
- `nsswitch.conf`

## Installation

### From `nemesis_repo` (recommended)

```ini
[nemesis_repo]
SigLevel = Never
Server = https://erikdubois.github.io/$repo/$arch
```

```bash
sudo pacman -Syu
sudo pacman -S edu-dot-files
```

This installs `etc/skel/` into `/etc/skel/`, the Plank themes into `/usr/share/plank/themes/`, and the Kiro reference configs into `/usr/local/share/kiro/`.

### Manual

```bash
git clone https://github.com/erikdubois/edu-dot-files.git
cd edu-dot-files
sudo cp -r etc/. /etc/
sudo cp -r usr/. /usr/
```

Existing users can pull the skel content into their own home:

```bash
cp -rT /etc/skel ~/
```

## Related

- [edu-system-files](https://github.com/erikdubois/edu-system-files) — system-level companion repo (`/etc/sysctl.d`, `/etc/udev`, the `kiro-*` toolchain in `/usr/local/bin/`).

## Websites

Information : https://erikdubois.be

## Social Media

Youtube : https://www.youtube.com/erikdubois

## License

See [LICENSE](./LICENSE).
