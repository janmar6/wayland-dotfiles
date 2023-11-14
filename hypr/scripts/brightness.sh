#!/bin/bash
# This code adds a minimum brigtness (brightness 1 instead of 1% which is 960)
# It also adds rounding to multiples of 5

brightnessctl_command="brightnessctl --device intel*"
current_brightness=$($brightnessctl_command g)

case $1 in
    5)
        if [[ $current_brightness -eq 1 ]]; then
            $brightnessctl_command s 5%
        else
        # rounding to multiples of 5
        current_brightness=$(( current_brightness / 960 ))
        rounded_brightness=$(( current_brightness / 5 * 5 ))
        $brightnessctl_command s $((rounded_brightness + 5))%
        fi
        ;;
    1)
        if [[ $current_brightness -eq 0 ]]; then
            $brightnessctl_command s 1
        else
        $brightnessctl_command s +1%
        fi
        ;;
    -5)
        if [[ $current_brightness -le 1 ]]; then
            $brightnessctl_command s 0
        elif [[ $current_brightness -lt 5760 ]]; then
            $brightnessctl_command s 1
        else
            # rounding to multiples of 5
            current_brightness=$(( current_brightness / 960 ))
            rounded_brightness=$(( (current_brightness + 4) / 5 * 5 ))
            $brightnessctl_command s $((rounded_brightness - 5))%
        fi
        ;;
    -1)
        if [[ $current_brightness -le 1 ]]; then
            $brightnessctl_command s 0
        elif [[ $current_brightness -lt 1920 ]]; then
            $brightnessctl_command s 1
        else
            $brightnessctl_command s 1%-
        fi
        ;;
    *)
        echo "error"
        ;;
esac

