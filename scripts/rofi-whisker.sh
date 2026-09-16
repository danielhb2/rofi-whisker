#!/bin/bash



DIR="$HOME/.config/rofi/scripts"
THEME_DIR="$HOME/.config/rofi/themes/whisker"
CONFIG_FILE="$HOME/.cache/rofi-whisker/selected_theme"

mkdir -p "$(dirname "$CONFIG_FILE")"

# --- MODO INTERNO: Submenú para seleccionar el tema ---
if [[ "$1" == "--theme-mode" ]]; then
    # Si el usuario eligió un tema del listado
    if [[ -n "$ROFI_INFO" ]]; then
        # 1. Guardar el nuevo tema
        echo "$ROFI_INFO" > "$CONFIG_FILE"
        
        # 2. Desvincular e iniciar rofi limpiando ROFI_INFO
        coproc (sleep 0.15 && ROFI_INFO="" "$0" --show-themes >/dev/null 2>&1)
        
        exit 0
    fi

    # Listar los temas disponibles (imprime la lista cuando ROFI_INFO está vacío)
    find "$THEME_DIR" -maxdepth 1 -name "whisker-*.rasi" -printf "%f\n" | sort | while read -r theme; do
        clean_name="${theme#whisker-}"
        clean_name="${clean_name%.rasi}"
        printf '%s\0info\x1f%s\n' "🎨 $clean_name" "$theme"
    done
    exit 0
fi

# --- MODO NORMAL: Lanzar el menú principal ---

# Si se pasa "select" por consola o no existe tema guardado, abrir el selector rápido inicial
if [[ "$1" == "select" || ! -f "$CONFIG_FILE" ]]; then
    SELECTED=$(find "$THEME_DIR" -maxdepth 1 -name "whisker-*.rasi" -printf "%f\n" | sort | rofi -dmenu -p "Seleccionar tema predeterminado:" -i)
    [[ -z "$SELECTED" && ! -f "$CONFIG_FILE" ]] && exit 0
    [[ -n "$SELECTED" ]] && echo "$SELECTED" > "$CONFIG_FILE"
fi

# Leer el tema guardado
CURRENT_THEME=$(cat "$CONFIG_FILE" 2>/dev/null)
[[ -z "$CURRENT_THEME" ]] && CURRENT_THEME="whisker-dark.rasi"

# Determinar cuál pestaña mostrar al iniciar
SHOW_TAB="<span color='blue'></span> Categorías"
if [[ "$1" == "--show-themes" ]]; then
    SHOW_TAB="<span color='magenta'>🎨</span> Temas"
fi

# Lanzar Rofi con el tema guardado
rofi -theme "$THEME_DIR/$CURRENT_THEME" \
  -modi "<span color='blue'></span> Categorías:$DIR/category-nav.sh,<span color='yellow'></span> Aplicaciones:$DIR/cat-All,run,window,filebrowser,<span color='magenta'>🎨</span> Temas:$0 --theme-mode,<span color='red'><big>✖</big></span> Salir:$DIR/power-menu.sh" \
  -show "$SHOW_TAB"