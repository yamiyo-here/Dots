#!/usr/bin/env bash
# Wallpaper browser with rofi grid navigation

ROOT="${WALLPAPER_DIR:-$HOME/Pictures/wallz}"
ROFI_THEME="$HOME/.config/rofi/themes/Wall.rasi"
AWWW_PARAMS="--transition-fps 60 --transition-type wave --transition-duration 1 --transition-angle 56"
PYWALFOX="${HOME}/.local/bin/pywalfox"
IMG_PATTERN="-iname *.jpg -o -iname *.jpeg -o -iname *.png -o -iname *.gif -o -iname *.webp"

set_wallpaper() {
    local img="$1"
    command -v awww &>/dev/null || { notify-send "Error" "awww not found" -u critical; exit 1; }

    wallust run "$img"
    awww img "$img" $AWWW_PARAMS
    pkill swayosd-server; swayosd-server &
    "$PYWALFOX" update
    hyprctl reload
    ln -sf "$img" "$HOME/.current_wallpaper"

    local name="${img##*/}"; name="${name%.*}"
    local thumb="/tmp/wallthumb.jpg"
    magick "$img[0]" -resize 512x512 "$thumb" 2>/dev/null || thumb="$img"

    local action
    action=$(notify-send -i "$thumb" -a "Wallpaper Switcher" \
        "Wallpaper set" "$name" -u low -t 0 \
        -h "string:x-canonical-private-synchronous:wallpaper-switcher" \
        --action="open-sxiv=Open in sxiv")

    [[ "$action" == "open-sxiv" ]] && sxiv "$img" &
}

reload_wallpaper() {
    local current="$HOME/.current_wallpaper"
    [[ ! -L "$current" && ! -f "$current" ]] && { notify-send "Wallpaper Switcher" "No current wallpaper set"; exit 1; }
    local img; img=$(readlink -f "$current")
    [[ ! -f "$img" ]] && { notify-send "Wallpaper Switcher" "Current wallpaper missing:\n$img" -u critical; exit 1; }
    set_wallpaper "$img"
}

find_images() { find -L "$1" -maxdepth "${2:-}" -type f \( $IMG_PATTERN \) 2>/dev/null; }
get_random() { find_images "$1" | shuf -n 1; }

# Handle --reload / -r
[[ "${1:-}" == "-r" || "${1:-}" == "--reload" ]] && reload_wallpaper

DIR="${1:-$ROOT}"

while true; do
    entries=(); icons=()
    entries+=("🎲 Random" "🔄 Reload")
    icons+=("" "")

    [[ "$DIR" != "$ROOT" ]] && { entries+=("[..]"); icons+=(""); }

    for d in "$DIR"/*/; do
        [[ -d "$d" ]] || continue
        local icon; icon=$(find_images "$d" 1 | shuf -n 1)
        entries+=("📂 ${d##*/}"); icons+=("${icon:-}")
    done

    for f in "$DIR"/*; do
        [[ -f "$f" ]] && case "${f,,}" in
            *.jpg|*.jpeg|*.png|*.gif|*.webp|*.bmp|*.tiff)
                entries+=("${f##*/}"); icons+=("$f") ;;
        esac
    done

    tmpfile=$(mktemp)
    for i in "${!entries[@]}"; do
        [[ -n "${icons[$i]}" ]] \
            && printf '%s\0icon\x1f%s\n' "${entries[$i]}" "${icons[$i]}" >> "$tmpfile" \
            || printf '%s\n' "${entries[$i]}" >> "$tmpfile"
    done

    CHOICE=$(rofi -dmenu -p "Wallpaper" -theme "$ROFI_THEME" -show-icons < "$tmpfile")
    rm -f "$tmpfile"
    [[ -z "$CHOICE" ]] && exit 0

    SELECTED=$(printf '%s' "$CHOICE" | cut -d $'\x00' -f1)

    case "$SELECTED" in
        "🎲 Random")   IMG=$(get_random "$DIR"); [[ -n "$IMG" ]] && set_wallpaper "$IMG"; exit 0 ;;
        "🔄 Reload")   reload_wallpaper ;;
        "[..]")         DIR=$(dirname "$DIR"); continue ;;
        📂*)            DIR="$DIR/${SELECTED#📂 }"; continue ;;
    esac

    IMG="$DIR/$SELECTED"
    [[ -f "$IMG" ]] && { set_wallpaper "$IMG"; exit 0; }
done
