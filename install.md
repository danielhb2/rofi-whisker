# install.sh — Instalador de rofi-whisker

Script de instalación automática para **rofi-whisker**. Copia scripts, temas e imágenes a `~/.config/rofi/`, arma la estructura de carpetas necesaria y deja todo listo para usar.

---

## 📋 Qué hace

1. **Verifica dependencias**: chequea que `rofi`, `awk`, `find` y `gtk-launch` estén disponibles en el sistema. Si falta alguna, avisa y pregunta si querés continuar de todos modos.
2. **Crea la estructura de carpetas** en `~/.config/rofi/`:
   ```
   ~/.config/rofi/
   ├── scripts/
   ├── themes/whisker/
   └── images/
   ```
3. **Copia los archivos** del repo a su lugar correspondiente:
   - `scripts/*.sh` → `~/.config/rofi/scripts/`
   - `themes/*.rasi` → `~/.config/rofi/themes/whisker/`
   - `images/*` → `~/.config/rofi/images/` (si existen imágenes en el repo)
4. **Da permisos de ejecución** a todos los scripts copiados.
5. **Crea el symlink `cat-All`** dentro de `~/.config/rofi/scripts/`, necesario para que funcione la pestaña "Aplicaciones" del menú.

El script **no sobreescribe silenciosamente** — usa `cp -v`, así que vas a ver en la terminal exactamente qué se copió y adónde.

## 🚀 Uso

```bash
git clone <url-del-repo> rofi-whisker
cd rofi-whisker
chmod +x install.sh
./install.sh
```

El script debe ejecutarse **parado dentro de la carpeta del repo clonado** (usa su propia ubicación para encontrar `scripts/`, `themes/` e `images/`), no importa en qué ruta del disco lo hayas clonado.

## ⚠️ Requisitos previos

Antes de correrlo, asegurate de tener instalado:

- `rofi`
- `bash` (v4.0+)
- `gtk3` (provee `gtk-launch`)
- `findutils`, `coreutils`, `gawk`

Ver el `README.md` principal del proyecto para más detalle sobre estas dependencias y las fuentes recomendadas para los temas retro.

## ✅ Después de instalar

El script va a indicarte dos pasos manuales al terminar:

1. **Asignar un atajo de teclado** en tu gestor de ventanas apuntando a la ruta absoluta:
   ```
   ~/.config/rofi/scripts/rofi-whisker.sh
   ```
2. **Elegir el tema por defecto**, corriendo una vez:
   ```bash
   ~/.config/rofi/scripts/rofi-whisker.sh select
   ```

## 🔁 Reinstalar / actualizar

Podés correr `install.sh` las veces que quieras — vuelve a copiar los archivos (sobreescribiendo los existentes) y recrea el symlink `cat-All` si por algún motivo se perdió. No borra nada que ya tengas en `~/.config/rofi/` fuera de lo que el script gestiona (no toca tu `~/.cache/rofi-whisker/`, por ejemplo, así que el tema elegido y el índice de apps cacheado se mantienen).
