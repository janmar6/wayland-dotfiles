#!/bin/bash
# Rounding to multiples of 5


case $1 in
    5)
        # rounding to multiples of 5
        current_volume=$(pamixer --get-volume)
        rounded_brightness=$(( current_volume / 5 * 5 ))
        pamixer --set-volume $((rounded_brightness + 5))
        pamixer --unmute
        exit 0
        ;;
    -5)
        # rounding to multiples of 5
        current_volume=$(pamixer --get-volume)
        rounded_brightness=$(( (current_volume + 4) / 5 * 5 ))
        pamixer --set-volume $((rounded_brightness - 5))
        ;;
    1)
        pamixer --increase 1
        pamixer --unmute
        exit 0
        ;;
    -1)
        pamixer --decrease 1
        ;;
    *)
        echo "error: argument must be 5; -5; 1 or -1"
        ;;
esac

current_volume=$(pamixer --get-volume)
if [[ current_volume -eq 0 ]]; then
    pamixer --mute
    exit 0
fi
pamixer --unmute
