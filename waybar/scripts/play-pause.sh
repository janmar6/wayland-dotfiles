#!/bin/bash

music_url="https://music.youtube.com/"
playing=$(playerctl status)

# Check if music is not playing
if [ -z "$playing" ]; then
    firefox "$music_url"
    exit 0
fi

# Toggle play/pause and refresh Waybar
playerctl play-pause
pkill -RTMIN+9 waybar

