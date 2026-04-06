#!/usr/bin/env bash
## Power Menu — Rofi
## Hardened rewrite: safer variable handling, guarded commands,
## consistent $() syntax, defensive desktop logout.

# ── Config ────────────────────────────────────────────────────────────────────
DIR="${HOME}/.config/powermenu"
THEME="style-default"

# ── Runtime info ──────────────────────────────────────────────────────────────
UPTIME="$(uptime -p | sed 's/up //')"
HOST="$(hostname 2>/dev/null || echo "localhost")"

# ── Menu labels ───────────────────────────────────────────────────────────────
SHUTDOWN="⏻  Shutdown"
REBOOT="  Reboot"
LOCK="  Lock"
SUSPEND="  Suspend"
LOGOUT="  Logout"
YES="  Yes"
NO="  No"

# ── Rofi helpers ──────────────────────────────────────────────────────────────
rofi_menu() {
    rofi -dmenu \
        -p "${HOST}" \
        -mesg "Uptime: ${UPTIME}" \
        -theme "${DIR}/${THEME}.rasi"
}

rofi_confirm() {
    rofi \
        -theme-str 'window    {location: center; anchor: center; fullscreen: false; width: 250px;}' \
        -theme-str 'mainbox   {children: ["message","listview"];}' \
        -theme-str 'listview  {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox   {horizontal-align: 0.5;}' \
        -dmenu \
        -p "Confirm" \
        -mesg "Are you sure?" \
        -theme "${DIR}/${THEME}.rasi"
}

# ── Ask for confirmation; returns 0 if user picked Yes ────────────────────────
confirmed() {
    local answer
    answer="$(printf '%s\n%s' "${YES}" "${NO}" | rofi_confirm)"
    [[ "${answer}" == "${YES}" ]]
}

# ── Suspend helper: gracefully mute before sleeping ───────────────────────────
pre_suspend() {
    command -v mpc    &>/dev/null && mpc -q pause
    command -v amixer &>/dev/null && amixer -q set Master mute
}

# ── Logout: detect the running desktop and exit cleanly ───────────────────────
do_logout() {
    local desktop="${DESKTOP_SESSION:-}"

    # Fallback: try to detect common compositors / WMs if var is unset
    if [[ -z "${desktop}" ]]; then
        for wm in hyprland sway i3 openbox bspwm dk herbstluftwm; do
            pgrep -x "${wm}" &>/dev/null && desktop="${wm}" && break
        done
    fi

    case "${desktop}" in
        dk)             dkcmd exit ;;
        hyprland)       hyprctl dispatch exit ;;
        herbstluftwm)   herbstclient quit ;;
        sway)           swaymsg exit ;;
        i3)             i3-msg exit ;;
        "")
            echo "ERROR: Could not detect desktop session." >&2
            exit 1
            ;;
        *)
            # Generic: kill the WM process by name
            if ! pkill -x "${desktop}"; then
                echo "ERROR: pkill '${desktop}' failed." >&2
                exit 1
            fi
            ;;
    esac
}

# ── Lock screen ───────────────────────────────────────────────────────────────
do_lock() {
    if command -v betterlockscreen &>/dev/null; then
        betterlockscreen -l dim -- --time-str="%H:%M"
    elif command -v i3lock &>/dev/null; then
        i3lock -c 000000
    else
        echo "ERROR: No lock screen found (betterlockscreen / i3lock)." >&2
        exit 1
    fi
}

# ── Main ──────────────────────────────────────────────────────────────────────
chosen="$(printf '%s\n' "${LOGOUT}" "${REBOOT}" "${LOCK}" "${SUSPEND}" "${SHUTDOWN}" | rofi_menu)"

case "${chosen}" in
    "${SHUTDOWN}")
        confirmed && systemctl poweroff
        ;;
    "${REBOOT}")
        confirmed && systemctl reboot
        ;;
    "${LOCK}")
        do_lock
        ;;
    "${SUSPEND}")
        if confirmed; then
            pre_suspend
            systemctl suspend
        fi
        ;;
    "${LOGOUT}")
        confirmed && do_logout
        ;;
    *)
        # User dismissed rofi or pressed Escape — exit silently
        exit 0
        ;;
esac
