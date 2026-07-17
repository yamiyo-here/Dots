#!/usr/bin/env bash

THEMEDIR="$HOME/.config/rofi/themes"

chosen=$(printf "Shutdown\nReboot\nHibernate\nSleep\nLogout" \
    | rofi -dmenu -i -p Power -theme "$THEMEDIR/menu.rasi")

[[ -z "$chosen" ]] && exit 0

action=$(echo "$chosen" | awk '{print $NF}')

confirm() {
    printf "No\nYes" | rofi -dmenu -i -p "Are you sure?" \
        -theme "$THEMEDIR/menu.rasi" \
        -theme-str 'listview { columns: 1; lines: 2; }'
}

case "$action" in
    Shutdown)  [[ $(confirm) == *Yes* ]] && sudo systemctl poweroff ;;
    Reboot)    [[ $(confirm) == *Yes* ]] && sudo systemctl reboot ;;
    Hibernate) [[ $(confirm) == *Yes* ]] && sudo systemctl hibernate ;;
    Sleep)     [[ $(confirm) == *Yes* ]] && systemctl suspend ;;
    Logout)    [[ $(confirm) == *Yes* ]] && loginctl terminate-user "$USER" ;;
esac
