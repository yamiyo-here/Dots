#!/bin/bash

bar="▁▂▃▄▅▆▇█"
config_file="$HOME/.config/cava/waybarc"

dict='s/;//g;'
for i in $(seq 0 $((${#bar}-1))); do
    dict+="s/$i/${bar:i:1}/g;"
done

# Ignore SIGPIPE so sed doesn't scream when waybar exits
trap '' PIPE

# One sed process, unbuffered output
cava -p "$config_file" | sed -u "$dict"
