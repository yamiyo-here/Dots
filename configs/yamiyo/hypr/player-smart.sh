#!/usr/bin/env bash
# Media player controller with priority: Spotify > mpv > first active
# Usage: player-smart.sh <play-pause|play|pause|stop|next|prev|shuffle>

set -euo pipefail

CMD="${1:-}"

case "$CMD" in
    play-pause|play|pause|stop|next|prev|shuffle) ;;
    *)
        echo "Usage: $0 <play-pause|play|pause|stop|next|prev|shuffle>"
        exit 1
        ;;
esac

# Get active players, pick by priority: Spotify > mpv > first
target=$(playerctl -l 2>/dev/null | awk '
    /spotify/ && !s { s=1; print; next }
    /mpv/ && !m { m=1; print; next }
    !f { f=1; print }
    END { if (!s && !m && !f) exit 1 }
')

[[ -z "$target" ]] && { echo "No active players"; exit 1; }

swayosd-client --playerctl "$CMD" --player "$target"
