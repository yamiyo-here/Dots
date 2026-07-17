#!/usr/bin/env bash
set -euo pipefail

REC_DIR="$HOME/Videos/Recordings"
mkdir -p "$REC_DIR"

if pgrep -x wl-screenrec >/dev/null; then
    # --- Stop recording ---
    FILE=$(ps -o args= -C wl-screenrec | grep -oP '(?<=--filename )\S+')

    pkill -INT -x wl-screenrec
    while pgrep -x wl-screenrec >/dev/null; do
        sleep 0.2
    done

    notify-send -i video-x-generic "Recording stopped" "Saved to ${FILE/#$HOME/\~}"
else
    # --- Start recording ---
    GEOM=$(slurp) || {
        notify-send "Recording cancelled" "No region selected"
        exit 1
    }

    FILE="$REC_DIR/$(date +%Y-%m-%d_%H-%M-%S).mp4"

    notify-send -i video-x-generic "Recording started" "$(basename "$FILE")"

    wl-screenrec --geometry "$GEOM" --codec avc --max-fps 60 \
        --bitrate "12 MB" --filename "$FILE" &
    disown
fi