#!/usr/bin/env bash

rm -rf "$HOME/Dots/config/"*
rclone copy ~/.config/ ~/Dots/config --filter-from ~/Dots/include.txt

echo "Sync complete! Check ~/Dots/ for your backed up config files."
find ~/Dots/ -name "*.sh"
