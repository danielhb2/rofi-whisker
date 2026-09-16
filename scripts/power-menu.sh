#!/bin/bash
# power-menu.sh — modo "Salir" para rofi.
# Universal vía systemd/logind (funciona con cualquier WM/DE sobre systemd);
# agrega ítems extra de Openbox solo si detecta que está corriendo.

is_openbox() {
    pgrep -x openbox >/dev/null 2>&1
}

if [[ -n "$ROFI_INFO" ]]; then
    case "$ROFI_INFO" in
        LOGOUT)   loginctl terminate-session "${XDG_SESSION_ID}" ;;
        EDOB)     "${EDITOR:-mousepad}" "$HOME/.config/openbox/rc.xml" ;;
        RECONF)   openbox --reconfigure ;;
        SUSPEND)  systemctl suspend ;;
        REBOOT)   systemctl reboot ;;
        POWEROFF) systemctl poweroff ;;
    esac
    exit 0
fi

printf '🔒 Cerrar sesión\0info\x1fLOGOUT\n'
if is_openbox; then
    printf '🛠️ Editar obconf\0info\x1fEDOB\n'
    printf '🔄 Reconfigurar Openbox\0info\x1fRECONF\n'
fi
printf '🌙 Suspender\0info\x1fSUSPEND\n'
printf '♻️  Reiniciar\0info\x1fREBOOT\n'
printf '⏻  Apagar\0info\x1fPOWEROFF\n'
