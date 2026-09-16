# install.sh — rofi-whisker Installer

Automatic installation script for **rofi-whisker**. Copies scripts, themes, and images into `~/.config/rofi/`, sets up the required folder structure, and leaves everything ready to use.

---

## 📋 What it does

1. **Checks dependencies**: verifies that `rofi`, `awk`, `find`, and `gtk-launch` are available on the system. If something is missing, it warns you and asks whether to continue anyway.
2. **Creates the folder structure** under `~/.config/rofi/`:
   ```
   ~/.config/rofi/
   ├── scripts/
   ├── themes/whisker/
   └── images/
   ```
3. **Copies files** from the repo into place:
   - `scripts/*.sh` → `~/.config/rofi/scripts/`
   - `themes/*.rasi` → `~/.config/rofi/themes/whisker/`
   - `images/*` → `~/.config/rofi/images/` (if any images exist in the repo)
4. **Grants execute permissions** to every copied script.
5. **Creates the `cat-All` symlink** inside `~/.config/rofi/scripts/`, required for the "Applications" tab in the menu to work.

The script **doesn't overwrite silently** — it uses `cp -v`, so you'll see in the terminal exactly what got copied and where.

## 🚀 Usage

```bash
git clone <repo-url> rofi-whisker
cd rofi-whisker
chmod +x install.sh
./install.sh
```

The script must be run **from inside the cloned repo folder** (it uses its own location to find `scripts/`, `themes/`, and `images/`), regardless of where on disk you cloned it.

## ⚠️ Prerequisites

Before running it, make sure you have installed:

- `rofi`
- `bash` (v4.0+)
- `gtk3` (provides `gtk-launch`)
- `findutils`, `coreutils`, `gawk`

See the project's main `README.md` for more detail on these dependencies and the recommended fonts for the retro themes.

## ✅ After installing

The script will print two manual steps once it finishes:

1. **Set a keyboard shortcut** in your window manager pointing to the absolute path:
   ```
   ~/.config/rofi/scripts/rofi-whisker.sh
   ```
2. **Choose the default theme** by running once:
   ```bash
   ~/.config/rofi/scripts/rofi-whisker.sh select
   ```

## 🔁 Reinstalling / updating

You can run `install.sh` as many times as you like — it re-copies the files (overwriting existing ones) and recreates the `cat-All` symlink if it's ever lost for some reason. It doesn't delete anything else you may have in `~/.config/rofi/` outside of what the script manages (it never touches `~/.cache/rofi-whisker/`, for example, so your chosen theme and the cached app index are preserved).
