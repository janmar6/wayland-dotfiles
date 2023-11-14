#!/usr/bin/env sh
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')
blur_dropshadow=$(hyprctl getoption decoration:blur:enabled | awk 'NR==2{print $2}')
if [ "$blur_dropshadow" = 1 ] ; then
    hyprctl --batch "\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:inactive_opacity 1.2;\
        keyword decoration:active_opacity 1.08"
    exit
fi
hyprctl reload
hyprctl switchxkblayout at-translated-set-2-keyboard next
