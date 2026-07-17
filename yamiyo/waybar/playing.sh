#!/usr/bin/env bash
# Media player status for Waybar
# Usage: playing.sh          → title + tooltip
#        playing.sh status   → status icon only

MODE="${1:-}"
ALL=$(playerctl -l 2>/dev/null || true)

if [[ -z "$ALL" ]]; then
    [[ "$MODE" == "status" ]] \
        && printf '{"text":"","tooltip":"No player","class":"Idle","alt":""}\n' \
        || printf '{"text":"Nothing is playing","tooltip":"No player","class":"Idle","alt":""}\n'
    exit 0
fi

# Filter active players
ACTIVE=()
while IFS= read -r p; do
    s=$(playerctl -p "$p" status 2>/dev/null || true)
    [[ "$s" == "Playing" || "$s" == "Paused" ]] && ACTIVE+=("$p")
done <<< "$ALL"

# Pick player: Spotify > mpv > first
player=""
for pattern in spotify mpv; do
    for p in "${ACTIVE[@]}"; do
        [[ "$p" == $pattern* ]] && { player="$p"; break 2; }
    done
done
[[ -z "$player" && ${#ACTIVE[@]} -gt 0 ]] && player="${ACTIVE[0]}"
[[ -z "$player" ]] && player=$(head -1 <<< "$ALL")

status=$(playerctl -p "$player" status 2>/dev/null || echo "Stopped")
title=$(playerctl -p "$player" metadata --format '{{title}}' 2>/dev/null || echo "")
player_name=$(playerctl -p "$player" metadata --format '{{playerName}}' 2>/dev/null || echo "")

[[ -z "$title" ]] && title="Nothing playing"
((${#title} > 24)) && title="${title:0:24}…"

case "$status" in
    Playing) icon="󰏤" ;;
    Paused)  icon="󰐊" ;;
    *)       icon="" ;;
esac

if [[ "$MODE" == "status" ]]; then
    printf '{"text":"%s","tooltip":"%s","class":"%s","alt":"%s"}\n' "$icon" "$status" "$status" "$player_name"
else
    printf '{"text":"%s","tooltip":"%s","class":"%s","alt":"%s"}\n' "$title" "$player" "$status" "$player_name"
fi
