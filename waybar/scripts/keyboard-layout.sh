#!/bin/bash

layout=$(hyprctl devices | grep at-translated-set-2-keyboard -A 2 | tail -n 1 | cut -d ':' -f 2 | xargs)

case $layout in
    "English (Colemak-DH)")
        echo "DH"
        echo "English (Colemak-DH)"
        ;;
    "Estonian")
        echo "EE"
        echo "Estonian"
        ;;
    "English (US)")
        echo "US"
        echo "English (US)"
        ;;
    *)
    echo $layout
    echo "add this layout to ~/.config/waybar/scripts/keyboard-layout.sh to make it look nice"
esac
