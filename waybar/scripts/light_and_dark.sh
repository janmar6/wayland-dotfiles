#!/bin/bash

grep -q light ~/.cache/themeis.txt && echo dark > ~/.cache/themeis.txt || echo light > ~/.cache/themeis.txt

current_wallpaper=$(grep -o '[^/]*$' ~/.cache/wal/wal)
~/.config/hypr/scripts/change_colors.sh -f $current_wallpaper
