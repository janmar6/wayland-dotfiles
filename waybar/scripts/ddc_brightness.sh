#!/bin/bash

# Check if the file exists
settings_file="/tmp/display_settings.txt"


update_waybar() {
    pkill -RTMIN+6 waybar
}


print_usage() {
    echo "script usage: $(basename $0) [-r] [-s somevalue] [-i somevalue] [-d somevalue] [-M] [-m] [-t] [-T] [-h]" >&2
    echo '    -r reload monitor information'
    echo '    -s [value] set brightness'
    echo '    -i [value] increase brightness'
    echo '    -d [value] decrease brightness'
    echo '    -M maximum brightness'
    echo '    -m minimum brightness'
    echo '    -t toggle between maximum and minimum'
    echo '    -T temporary_brightness decrease or increase brightness. meant to be used with swayidle'
    echo '    -h show this help message'
}


set_monitor_brightness() {
    second_time=$1

    sleep_multiplier=0.1
    counter=0
    [ "$verbose" = true ] && echo ""
    [ "$verbose" = true ] && echo "setting monitor($bus_value) brightness to $change:"

    while [ "$counter" -lt 3 ]; do
        # ddcutil --sleep-multiplier "$sleep_multiplier" --bus "$bus_value" setvcp 10 "$change"
        ddcutil --bus "$bus_value" setvcp 10 "$change"
        if [ "$?" -eq 0 ]; then
            sed -i "s/brightness_value=.*/brightness_value=$change/" "$settings_file"
            [ "$verbose" = true ] && echo "    setting successful =========================="
            return
        else
            [ "$verbose" = true ] && echo "    ERROR: setting not successful ==============="
            counter=$(( counter + 1 ))
        fi
    done
    if [ "$second_time" = true ]; then
        [ "$verbose" = true ] && echo "Maximum attempts reached, command failed"
        exit 1
    fi
    second_time=true
    [ "$verbose" = true ] && echo ""
    [ "$verbose" = true ] && echo "reloading monitor info and trying again..."
    reload_monitor_info
    set_monitor_brightness "$second_time"
}


get_monitor_brightness() {
    sleep_multiplier=0.01
    counter=0
    [ "$verbose" = true ] && echo ""
    [ "$verbose" = true ] && echo "getting monitor($bus) brightness from ddc:"
    while [ "$counter" -lt 3 ]; do

        # brightness=$(ddcutil --bus $bus --sleep-multiplier $sleep_multiplier getvcp 10 | awk -F"[=,]" "{print \$2}" | tr -d " ")
        brightness=$(ddcutil --bus $bus getvcp 10 | awk -F"[=,]" "{print \$2}" | tr -d " ")
        if [ "$?" -eq 0 ]; then
            [ "$verbose" = true ] && echo "    successful =================================="
            [ "$verbose" = true ] && echo "new retrived brightness is $brightness"
            return
        else
            [ "$verbose" = true ] && echo "    ERROR: not successful ======================="
            sleep_multiplier=$(( counter + 1 ))
        fi
        counter=$(( counter + 1 ))
    done
    [ "$verbose" = true ] && echo "Maximum attempts reached, command failed"
    exit 1
}


get_monitor_bus() {
    sleep_multiplier=0.01
    counter=0
    [ "$verbose" = true ] && echo ""
    [ "$verbose" = true ] && echo "getting monitor bus from ddc:"
    while [ "$counter" -lt 3 ]; do

        # ddc_value=$(ddcutil detect --sleep-multiplier "$sleep_multiplier" | grep -A 1 "Display 1")
        ddc_value=$(ddcutil detect | grep -A 1 "Display 1")
        grep_exit_code=$?
        if [ "$grep_exit_code" -eq 0 ]; then
            bus=$(echo "$ddc_value" | tail -n 1 | cut -d "-" -f 2)
            [ "$verbose" = true ] && echo "    successful =================================="
            [ "$verbose" = true ] && echo "new monitor bus is $bus"
            return
        else
            [ "$verbose" = true ] && echo "    ERROR: not successful ======================="
            sleep_multiplier=$(( counter + 1 ))
        fi
        counter=$(( counter + 1 ))
    done
    [ "$verbose" = true ] && echo "Maximum attempts reached, command failed"
    exit 1
}


# Get bus and brightness of monitor and write it into a tmp file.
reload_monitor_info() {
    rm "$settings_file" 2> "/dev/null"

    get_monitor_bus
    get_monitor_brightness

    echo "bus_value=$bus" > "$settings_file"
    echo "brightness_value=$brightness" >> "$settings_file"

    source "$settings_file"
}


source "$settings_file"


# Reload monitor info if there is a problem with the settings file
if [ $? -ne 0 ] || [ -z "$bus_value" ] || [ -z "$brightness_value" ]; then
    reload_monitor_info
fi

while getopts 'vhrTtMmi:d:s:' OPTION; do
    case "$OPTION" in
        v)
            verbose=true
            ;;
        h)
            print_usage
            exit
            ;;
        r)
            # echo "rel"
            # update_waybar
            reload_monitor_info
            update_waybar
            exit
            ;;
        T)
            temporary_brightness=true
            ;;
        t)
            toggle=true
            ;;
        M)
            change="100"
            ;;
        m)
            change="0"
            ;;
        i)
            avalue="$OPTARG"
            change=$((brightness_value + avalue))
            ;;
        d)
            avalue="$OPTARG"
            change=$((brightness_value - avalue))
            ;;
        s)
            avalue="$OPTARG"
            change="$avalue"
            ;;
        ?)
            print_usage
            exit 1
            ;;
    esac
done
shift "$(($OPTIND -1))"

if [ "$temporary_brightness" = true ]; then
    # Set brightness back to what it was.
    if [ -n "$brigtness_before" ]; then
        change="$brigtness_before"
        set_monitor_brightness
        # Delete the variable brightness_before.
        sed -i '/brigtness_before/d' "$settings_file"
        update_waybar
        exit
    # Save a brightness_before variable in config file and continue.
    else
        if [ -n "$change" ]; then
            echo "brigtness_before=$brightness_value" >> "$settings_file"
        else
            exit 1
        fi
    fi
fi

if [ -n "$change" ]; then
    [ "$change" -gt 100 ] && change=100
    [ "$change" -lt 0 ] && change=0
fi

# Query the brightness.
if [ -z "$change" ] && [ -z "$toggle" ]; then
    echo "$brightness_value"
    exit
fi

# Toggle the brightness between max and min.
if [ "$toggle" = true ]; then
    if [ "$brightness_value" -eq 0 ]; then
        change=100
    else
        change=0
    fi
fi

# Change to whatever the user wants.
set_monitor_brightness

update_waybar
