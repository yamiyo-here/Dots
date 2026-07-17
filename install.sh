#!/usr/bin/env bash
set -euo pipefail

DOTS_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "Installing Dots to $CONFIG_DIR..."

# Folders to install
FOLDERS=(cava fastfetch hypr kitty quickshell rofi swaync swayosd wallust waybar yamiyo)

for folder in "${FOLDERS[@]}"; do
    src="$DOTS_DIR/$folder"
    dest="$CONFIG_DIR/$folder"

    if [[ ! -d "$src" ]]; then
        echo "  Skipping $folder (not found)"
        continue
    fi

    if [[ -d "$dest" ]]; then
        echo "  Backing up existing $folder → $folder.bak"
        mv "$dest" "$dest.bak"
    fi

    cp -r "$src" "$dest"
    echo "  Installed $folder"
done

echo ""
echo "Done. Log out and back in for changes to take effect."
