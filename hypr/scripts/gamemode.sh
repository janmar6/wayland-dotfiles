#!/usr/bin/env sh
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:inactive_opacity 2.0;\
        keyword decoration:active_opacity 2.0;\
        keyword decoration:rounding 0"
    exit
else
    hyprctl --batch "\
        keyword animations:enabled 1;\
        keyword decoration:drop_shadow 1;\
        keyword decoration:blur:enabled 1;\
        keyword general:gaps_in 4;\
        keyword general:gaps_out 6;\
        keyword general:border_size 2;\
        keyword decoration:inactive_opacity 1.0;\
        keyword decoration:active_opacity 1.0;\
        keyword decoration:rounding 10"

fi
# hyprctl reload
