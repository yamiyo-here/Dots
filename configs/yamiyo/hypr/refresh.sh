#!/bin/bash

pkill waybar
pkill rofi
waybar &
swaync-client -rs -R
pywalfox update
hyprctl reload