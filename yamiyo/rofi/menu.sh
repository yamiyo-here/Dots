#!/usr/bin/env bash

# Prefer USB WiFi (unstable names like wlp*s*), fallback to any
WIFI_IFACE=""
for iface in /sys/class/net/wl*; do
    [[ -d "$iface/device" ]] || continue
    name=$(basename "$iface")
    # USB adapters have longer names with extra segments (e.g. wlp0s20f0u1i2)
    if [[ ${#name} -gt 4 ]]; then
        WIFI_IFACE="$name"
        break
    fi
    [[ -z "$WIFI_IFACE" ]] && WIFI_IFACE="$name"
done 2>/dev/null

chosen=$(printf "Wifi\nBluetooth\nWallpapers\nEmoji Picker\nCalculator\nPower Menu" \
    | rofi -dmenu -i -p "Menu" -theme "$HOME/.config/rofi/themes/menu.rasi")

case "$chosen" in
    "Wallpapers")   ~/.config/yamiyo/rofi/wall.sh ;;
    "Emoji Picker") rofi -show emoji ;;
    "Power Menu")   ~/.config/yamiyo/rofi/power.sh ;;
    "Calculator")   rofi -show calc ;;
    "Bluetooth")    rofi-bluetooth ;;
    "Wifi")
        if [[ -n "$WIFI_IFACE" ]]; then
            rofi -show wifi -iface "$WIFI_IFACE"
        else
            rofi -show wifi
        fi
        ;;
esac
