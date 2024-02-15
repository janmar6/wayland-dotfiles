#!/usr/bin/env sh

blur_dropshadow=$(hyprctl getoption decoration:active_opacity | grep "float" | awk '{print $2}')
if [ "$blur_dropshadow" = "2.00000" ] ; then
    hyprctl --batch "\
        keyword decoration:inactive_opacity 1.2;\
        keyword decoration:active_opacity 1.1"
else
    hyprctl --batch "\
        keyword decoration:inactive_opacity 2.0;\
        keyword decoration:active_opacity 2.0"
fi
