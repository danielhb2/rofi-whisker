#!/bin/bash
# install.sh — instala rofi-whisker en ~/.config/rofi/
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROFI_DIR="$HOME/.config/rofi"

echo "==> Instalando rofi-whisker en $ROFI_DIR"

# --- Verificar dependencias básicas ---
missing=()
for cmd in rofi awk find gtk-launch; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
done
if [[ ${#missing[@]} -gt 0 ]]; then
    echo "⚠️  Faltan estas dependencias: ${missing[*]}"
    echo "    Instalalas antes de continuar (ver README para detalles)."
    read -rp "    ¿Seguir de todos modos? [y/N] " resp
    [[ "$resp" =~ ^[yY]$ ]] || exit 1
fi

# --- Crear estructura de directorios ---
mkdir -p "$ROFI_DIR/scripts"
mkdir -p "$ROFI_DIR/themes/whisker"
mkdir -p "$ROFI_DIR/images"

# --- Copiar scripts ---
cp -v "$REPO_DIR"/scripts/*.sh "$ROFI_DIR/scripts/"
chmod +x "$ROFI_DIR/scripts/"*.sh

# --- Copiar temas ---
cp -v "$REPO_DIR"/themes/whisker/*.rasi "$ROFI_DIR/themes/whisker/"

# --- Copiar imágenes (si existen) ---
if compgen -G "$REPO_DIR/images/*" > /dev/null; then
    cp -v "$REPO_DIR"/images/* "$ROFI_DIR/images/"
fi

# --- Crear el symlink cat-All (necesario para la pestaña "Aplicaciones") ---
cd "$ROFI_DIR/scripts"
ln -sf category.sh cat-All

echo ""
echo "✅ Instalación completa."
echo ""
echo "Próximos pasos:"
echo "  1. Asigná un atajo de teclado a esta ruta absoluta en tu gestor de ventanas:"
echo "       $ROFI_DIR/scripts/rofi-whisker.sh"
echo "  2. La primera vez, corré manualmente:"
echo "       $ROFI_DIR/scripts/rofi-whisker.sh select"
echo "     para elegir el tema por defecto."
