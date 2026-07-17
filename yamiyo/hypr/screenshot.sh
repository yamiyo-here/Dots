#!/usr/bin/env bash

f="$(mktemp /tmp/screenshot-XXXXXX.png)"

case "$1" in
    full)
        grim -
        ;;
    area)
        grim -g "$(slurp)" -
        ;;
    window)
        grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" -
        ;;
esac | swappy -f - -o "$f"

wl-copy < "$f"
notify-send -i "$f" "Screenshot Copied" "Copied to clipboard"
trap 'rm -f "$f"' EXIT