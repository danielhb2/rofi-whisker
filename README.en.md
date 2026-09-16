# rofi-whisker

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg) ![Shell Script](https://img.shields.io/badge/Language-Bash-4EAA25?logo=gnu-bash&logoColor=white) ![Rofi](https://img.shields.io/badge/App-Rofi-005F87?logo=archlinux&logoColor=white) ![Status](https://img.shields.io/badge/Status-Stable-brightgreen)

A dynamic application launcher and mode switcher for **Rofi**, featuring two-level navigable XDG categorization, a live theme switcher, and a set of retro and custom looks (**Mac 1984**, **DOS Shell**, **MS-DOS**, **Windows 95**, **Palmera**, and **LCARS**).

---

## 📋 Requirements and Dependencies

To ensure the script works correctly and the themes render properly (fonts and visuals), install the following packages:

### 1. System Dependencies
* **`rofi`**: The base launcher.
* **`bash`**: Shell interpreter (v4.0+).
* **`findutils`**, **`coreutils`**, **`gawk`**: For dynamic indexing and filtering of `.desktop` files.
* **`gtk3`**: Provides `gtk-launch`, used to launch applications cleanly, detached from Rofi's own process.

### 2. Recommended Fonts

* **Nerd Fonts** (e.g. *Symbols Nerd Font* or any *Patched* variant):
  Required to display the interface's glyph icons (``, ``, etc.).
* **`ttf-pxplus-ibm-vga8`** *(Arch Linux AUR)*:
  Bitmap-style font used by the **DOS Shell**, **MS-DOS**, and **Mac 1984** themes.

```bash
  yay -S ttf-pxplus-ibm-vga8
```

## 📂 File Structure

Files should be placed in their corresponding directories under `~/.config/rofi`:

```
    ~/.config/rofi/
    ├── scripts/
    │   ├── rofi-whisker.sh     # Main executable (can live elsewhere, ideally somewhere in PATH)
    │   ├── category-nav.sh     # Dynamic two-level category browser
    │   ├── category.sh         # Filtering logic for cat-<Category> symlinks
    │   └── cat-All             # Symlink to category.sh (used by the "Applications" tab)
    ├── images/
    │   └── *                   # Backgrounds and artwork used by themes such as Palmera and LCARS
    └── themes/
        └── whisker/
            ├── whisker-mac1984.rasi
            ├── whisker-dosshell.rasi
            ├── whisker-ms-dos.rasi
            ├── whisker-win95.rasi
            ├── whisker-palmera.rasi
            └── whisker-lcars.rasi
```

**Note:** the active theme is stored in `~/.cache/rofi-whisker/selected_theme` (a plain-text file containing the chosen `.rasi` filename). Both that file and the cached `.desktop` index (`~/.cache/rofi-whisker/index.tsv`) are created automatically on first use — no manual setup needed.

Themes that use a background image (like **Palmera**) reference it with a `background-image: url("~/.config/rofi/images/name.jpg", ...)` path inside the `.rasi` file — if you move or rename files in `images/`, remember to update that path in the corresponding theme.

## 🚀 Installation and Setup

1.  **Clone/copy the scripts**: grant execute permissions to every script under `~/.config/rofi/scripts/`:

```
chmod +x ~/.config/rofi/scripts/*.sh
```

2. **Create the "Applications" symlink**: `rofi-whisker.sh`'s `-modi` only relies on `cat-All` (all apps, ungrouped); individual categories are resolved internally by `category-nav.sh`, so a per-category symlink isn't needed:

```
cd ~/.config/rofi/scripts/
ln -s category.sh cat-All
```

   *(Optional: `category.sh` also supports per-category symlinks — `cat-Network`, `cat-Office`, etc. — in case you ever want a shortcut that jumps straight into one category without going through the "Categories" drill-down. The standard menu flow doesn't need them.)*

3.  **Set a keyboard shortcut**: bind the main script to a key combination in your window manager (i3, Hyprland, bspwm, XMonad, etc.), always using its **absolute path**:

```
~/.config/rofi/scripts/rofi-whisker.sh
```

   > ⚠️ Live theme switching relaunches the script via `"$0"`. If the keybinding invokes it by relative name (resolved through `$PATH`) instead of an absolute path, `$0` may not resolve correctly and the relaunch will fail silently.

## 🎨 Creating a New Theme

Any new `.rasi` you add to `themes/whisker/` needs, besides its color palette, the following in its text widgets so icons using `<span color="...">` render correctly instead of showing up as raw markup text:

```css
prompt {
    markup: true;
}

button {
    markup: true;
}
```

Without those two lines, Pango won't parse the markup and you'll see the literal `<span>` tag on screen instead of the colored icon.

## 🎮 Usage

-   **Standard start**: Run `rofi-whisker.sh` to open the default tab with the currently active theme.
-   **Initial theme selection**: Run `rofi-whisker.sh select` to bring up an initial `dmenu` picker to choose the default theme.
-   **Live theme switching**: From the sidebar inside Rofi, go to the **🎨 Themes** mode to change the look on the fly, no session restart needed.

---

## 👥 Credits and Authors

* **Visual Design, Concept, and Layout**: **Daniel Horacio Braga**
  * Art direction, RASI layout, color palette design, and retro aesthetic recreation (*Mac 1984*, *DOS Shell*, *MS-DOS*, *Win95*, *Palmera*, *LCARS*, etc.).
* **Script Development and System Logic**:
  **Gemini (Google AI)** and **Anthropic Claude**
  * Bash programming (`rofi-whisker.sh`, `category-nav.sh`, `category.sh`), XDG `.desktop` entry caching system, Pango markup integration, and underlying process management.

* **License: MIT**
