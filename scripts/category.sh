#!/bin/bash
# category.sh — modo de script para rofi, filtra apps por categoría XDG.
# Se invoca vía symlinks "cat-<Categoria>", ej: cat-Network
# Usa un índice cacheado (~/.cache/rofi-whisker/index.tsv) para no releer
# los .desktop en cada una de las 8 categorías que rofi inicializa al arrancar.

cat_name="${0##*/}"
cat_name="${cat_name#cat-}"

CACHE="$HOME/.cache/rofi-whisker/index.tsv"
APPDIRS=(/usr/share/applications /usr/local/share/applications "$HOME/.local/share/applications")

# --- Si venimos de una selección, lanzar la app y salir ---
if [[ -n "$ROFI_INFO" ]]; then
    desktop_id="$(basename "$ROFI_INFO" .desktop)"
    gtk-launch "$desktop_id" >/dev/null 2>&1 &
    disown
    exit 0
fi

mkdir -p "$(dirname "$CACHE")"

# --- Regenerar el índice si no existe, si hay archivos nuevos o si falta alguno ---
rebuild=0
[[ -f "$CACHE" ]] || rebuild=1
if [[ "$rebuild" -eq 0 ]]; then
    current_count=$(find "${APPDIRS[@]}" -name '*.desktop' 2>/dev/null | wc -l)
    cached_count=$(wc -l < "$CACHE")
    
    if [[ "$current_count" -ne "$cached_count" ]]; then
        rebuild=1
    else
        newer=$(find "${APPDIRS[@]}" -name '*.desktop' -newer "$CACHE" -print -quit 2>/dev/null)
        [[ -n "$newer" ]] && rebuild=1
    fi
fi


# --- Filtrar el índice cacheado por categoría (rápido: un archivo chico) ---
if [[ "$cat_name" == "All" ]]; then
    filter='{ print $1 "\t" $2 "\t" $4 }'
else
    filter='$3 ~ cat { print $1 "\t" $2 "\t" $4 }'
fi
awk -F'\t' -v cat="$cat_name" "$filter" "$CACHE" |
while IFS=$'\t' read -r name icon path; do
    printf '%s\0icon\x1f%s\x1finfo\x1f%s\n' "$name" "$icon" "$path"
done