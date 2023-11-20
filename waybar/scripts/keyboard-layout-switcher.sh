#!/bin/bash

case $1 in
    "next") hyprctl switchxkblayout at-translated-set-2-keyboard next;;
    "prev") hyprctl switchxkblayout at-translated-set-2-keyboard prev;;
esac

layout=$(hyprctl devices | grep at-translated-set-2-keyboard -A 2 | tail -n 1 | cut -d ':' -f 2 | xargs)

notify-send $layout -r 20 -t 1000

# case $layout in
#     "English (Colemak-DH)")     notify-send COLEMAK -r 20 -t 1000;;
#     "Estonian")                 notify-send ESTONIAN -r 20 -t 1000;;
#     "English (US)")             notify-send ENGLISH -r 20 -t 1000;;
#     *)                          notify-send $layout -r 20 -t 1000;;
# esac
