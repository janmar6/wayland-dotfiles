#!/bin/bash

playing=$(playerctl status)

# 󰝛 󰝚  
if [ -z "$playing" ]; then
    echo "󰝛 No audio playing"
    echo "Click to launch Youtube Music"
    exit 0

elif [ "$playing" == "Playing" ]; then
    echo -n " "


elif [ "$playing" == "Paused" ]; then
    echo -n " "
else
    echo "something went wrong"
    exit 1
fi

title=$(playerctl metadata --format "{{title}}")
tooltip=$(playerctl metadata --format "{{artist}}")

# Escape special characters in title and tooltip
title="${title//&/&amp;}"
tooltip="${tooltip//&/&amp;}"

echo "$title"
echo "$tooltip"
