#!/bin/bash
# This code adds a minimum brigtness (brightness 1 instead of 1% which is 960)
# It also adds rounding to multiples of 5

brightnessctl_command="brightnessctl --device intel*"
current_brightness=$($brightnessctl_command g)
input="$1"

# while getopts 'vhrTtMmi:d:s:' OPTION; do
#     case "$OPTION" in
#         v)
#             verbose=true
#             ;;
#         h)
#             print_usage
#             exit
#             ;;
#         r)
#             # echo "rel"
#             # update_waybar
#             reload_monitor_info
#             update_waybar
#             exit
#             ;;
#         T)
#             temporary_brightness=true
#             ;;
#         t)
#             toggle=true
#             ;;
#         M)
#             change="100"
#             ;;
#         m)
#             change="0"
#             ;;
#         i)
#             avalue="$OPTARG"
#             change=$((brightness_value + avalue))
#             ;;
#         d)
#             avalue="$OPTARG"
#             change=$((brightness_value - avalue))
#             ;;
#         s)
#             avalue="$OPTARG"
#             change="$avalue"
#             ;;
#         ?)
#             print_usage
#             exit 1
#             ;;
#     esac
# done
# shift "$(($OPTIND -1))"

case $input in
    # 5)
    #     if [[ $current_brightness -eq 1 ]]; then
    #         $brightnessctl_command s 5%
    #     else
    #     # rounding to multiples of 5
    #     current_brightness=$(( current_brightness / 960 ))
    #     rounded_brightness=$(( current_brightness / 5 * 5 ))
    #     $brightnessctl_command s $((rounded_brightness + 5))%
    #     fi
    #     ;;
    1)
        if [[ $current_brightness -eq 0 ]]; then
            $brightnessctl_command s 1
        else
        $brightnessctl_command s +1%
        fi
        ;;
    # -5)
    #     if [[ $current_brightness -le 1 ]]; then
    #         $brightnessctl_command s 0
    #     elif [[ $current_brightness -lt 5760 ]]; then
    #         $brightnessctl_command s 1
    #     else
    #         # rounding to multiples of 5
    #         current_brightness=$(( current_brightness / 960 ))
    #         rounded_brightness=$(( (current_brightness + 4) / 5 * 5 ))
    #         $brightnessctl_command s $((rounded_brightness - 5))%
    #     fi
    #     ;;
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
        
        # rounding to multiples of 5
        if [ "$input" -lt 0 ]; then
            # Doing some logic to be able to get
            # absolutely minimum brightness.
            if [[ $current_brightness -le 1 ]]; then
                $brightnessctl_command s 0
            elif [[ $current_brightness -lt 5760 ]]; then
                $brightnessctl_command s 1
            else
                # rounding to multiples of 5
                current_brightness_percentage=$(( current_brightness / 960 ))
                # Adding input to brightness.
                brightness=$((current_brightness_percentage + input))
                rounded_brightness=$(( (brightness + 4) / 5 * 5 ))

                $brightnessctl_command s "$rounded_brightness"%
            fi
        elif [ "$input" -gt 0 ]; then
            if [[ $current_brightness -eq 1 ]]; then
                $brightnessctl_command s 5%
            else
                # rounding to multiples of 5
                current_brightness_percentage=$(( current_brightness / 960 ))
                # Adding input to brightness.
                brightness=$((current_brightness_percentage + input))
                rounded_brightness=$(( brightness / 5 * 5 ))

                $brightnessctl_command s "$rounded_brightness"%
            fi
        else
            echo "error"
            exit 1
        fi
        ;;
esac

