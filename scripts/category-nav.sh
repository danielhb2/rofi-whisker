#!/bin/bash
# category-nav.sh — modo "Categorías" para rofi, con navegación en dos niveles
# dentro del mismo panel (sin cambiar de modo): primero lista categorías,
# al elegir una muestra sus apps, con opción de volver.

CACHE="$HOME/.cache/rofi-whisker/index.tsv"
APPDIRS=(/usr/share/applications /usr/local/share/applications "$HOME/.local/share/applications")

LABELS=("Internet" "Oficina" "Sistema" "Multimedia" "Gráficos" "Accesorios" "Desarrollo" "Juegos" "Configuración" "Educación" "Otras")
ICONS=("🌐" "📁" "⚙️" "🎬" "🎨" "📦" "💻" "🎮" "🔧" "📚" "🗂️")
COLORS=("#e8912d" "#3daee9" "#8e8e8e" "#c0392b" "#16a085" "#2980b9" "#9b59b6" "#27ae60" "#f39c12" "#1abc9c" "#7f8c8d")
CODES=("Network" "Office" "System" "AudioVideo" "Graphics" "Utility" "Development" "Game" "Settings" "Education" "OTHER")

# Devuelve el LABEL legible ("Internet") a partir del CODE interno ("Network")
label_for_code() {
    local code="$1"
    for i in "${!CODES[@]}"; do
        [[ "${CODES[$i]}" == "$code" ]] && { echo "${LABELS[$i]}"; return; }
    done
    echo "$code"
}

build_cache_if_needed() {
    mkdir -p "$(dirname "$CACHE")"
    local rebuild=0
    [[ -f "$CACHE" ]] || rebuild=1

    if [[ "$rebuild" -eq 0 ]]; then
        local current_count cached_count
        current_count=$(find "${APPDIRS[@]}" -name '*.desktop' 2>/dev/null | wc -l)
        cached_count=$(wc -l < "$CACHE")

        if [[ "$current_count" -ne "$cached_count" ]]; then
            rebuild=1
        else
            local newer
            newer=$(find "${APPDIRS[@]}" -name '*.desktop' -newer "$CACHE" -print -quit 2>/dev/null)
            [[ -n "$newer" ]] && rebuild=1
        fi
    fi

    if [[ "$rebuild" -eq 1 ]]; then
        awk '
            FNR==1 {
                if (fname != "") doprint()
                name=""; icon=""; cats=""; nodisp=0; fname=FILENAME
            }
            /^NoDisplay=true/          { nodisp=1 }
            /^Name=/ && name==""       { sub(/^Name=/,""); name=$0 }
            /^Icon=/ && icon==""       { sub(/^Icon=/,""); icon=$0 }
            /^Categories=/ && cats=="" { sub(/^Categories=/,""); cats=$0 }
            END { if (fname != "") doprint() }
            function doprint() {
                if (!nodisp && name != "")
                    print name "\t" icon "\t" cats "\t" fname
            }
        ' ${APPDIRS[@]/%//*.desktop} 2>/dev/null > "$CACHE"
    fi
}

print_categories() {
    printf '\0prompt\x1f%s\n' "<span color='blue'></span> Categorías"
    for i in "${!LABELS[@]}"; do
        printf '<span color="%s">%s</span> %s\0markup\x1ftrue\x1finfo\x1fCAT:%s\n' \
            "${COLORS[$i]}" "${ICONS[$i]}" "${LABELS[$i]}" "${CODES[$i]}"
    done
}

print_apps_for() {
    local code="$1"
    build_cache_if_needed

    # Buscamos el índice (posición) de este código dentro de CODES,
    # para poder sacar su color e ícono correspondientes de COLORS/ICONS
    local idx
    for i in "${!CODES[@]}"; do [[ "${CODES[$i]}" == "$code" ]] && idx=$i; done
    printf '\0prompt\x1f%s\n' "<span color='${COLORS[$idx]}'>${ICONS[$idx]}</span> $(label_for_code "$code")"

    printf '⬅  Volver\0info\x1fBACK\n'

    if [[ "$code" == "OTHER" ]]; then
        local known="Network|Office|System|AudioVideo|Graphics|Utility|Development|Game|Settings|Education"
        awk -F'\t' -v known="$known" '$3 !~ known { print $1 "\t" $2 "\t" $4 }' "$CACHE" |
        while IFS=$'\t' read -r name icon path; do
            printf '%s\0icon\x1f%s\x1finfo\x1fAPP:%s\n' "$name" "$icon" "$path"
        done
    else
        awk -F'\t' -v cat="$code" '$3 ~ cat { print $1 "\t" $2 "\t" $4 }' "$CACHE" |
        while IFS=$'\t' read -r name icon path; do
            printf '%s\0icon\x1f%s\x1finfo\x1fAPP:%s\n' "$name" "$icon" "$path"
        done
    fi
}

# --- Rama de selección (segunda invocación) ---
if [[ -n "$ROFI_INFO" ]]; then
    case "$ROFI_INFO" in
        BACK)
            print_categories
            exit 0
            ;;
        CAT:*)
            print_apps_for "${ROFI_INFO#CAT:}"
            exit 0
            ;;
        APP:*)
            path="${ROFI_INFO#APP:}"
            desktop_id="$(basename "$path" .desktop)"
            gtk-launch "$desktop_id" >/dev/null 2>&1 &
            disown
            exit 0
            ;;
    esac
fi

# --- Estado inicial: lista de categorías ---
print_categories