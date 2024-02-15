#!/bin/bash

# This program gets available sinks and ports using jq and pactl
# Then lists them using wofi using nice defined names
# Finally turns them back into correct sinks and ports and sets the default port as that

wofi_prompt="Choose audio output"

if pgrep -af "$wofi_prompt" > /dev/null; then
    # If yes, kill the existing wofi process
    pkill -f "$wofi_prompt"
    exit
fi

# Ugly names to pretty
declare -A name_map
name_map["[Out] HDMI1"]="󰦉   HDMI"
name_map["[Out] Headphones"]="   Headphones"
name_map["[Out] Speaker"]="󰌢   Laptop Speakers"
name_map["headphone-output"]="󰂯 Bluetooth headphones"
name_map["headset-output"]="󰂯 Bluetooth headset"


sinks=$(pactl -f json list sinks | jq -r '.[] | .name as $parent_name | .ports[] | select(.availability != "not available") | "\($parent_name)\t\(.name)"')

ports=$(printf "$sinks" | cut -f 2)

# Turning ugly names into pretty names (but still allowing other ports)
cleaned_ports=""
while read -r port; do
    for key in "${!name_map[@]}"; do
        if [ "$port" == "$key" ];then
            port=${name_map[$key]}
            break
        fi
    done
    cleaned_ports+="$port\n"
done <<< "$ports"

number_of_ports=$(printf "$cleaned_ports" | wc -l)
# Adding two to the variable so that formatting isnt messed up.
number_of_ports=$(($number_of_ports + 2))

# Getting user input with wofi
output=$(printf "$cleaned_ports" | wofi --location 3 -x -370 -y 10 --width 250 --lines "$number_of_ports" --dmenu -i -p "$wofi_prompt") 

[ -z "$output" ] && exit

# turning pretty name back to key
for key in "${!name_map[@]}"; do
    if [[ "${name_map[$key]}" == "$output" ]]; then
        output=$key
        break
    fi
done

while IFS= read -r line; do
    if [[ "$line" == *"$output"* ]]; then
        sink=$(echo "$line" | awk -F '\t' '{print $1}')
        port=$(echo "$line" | awk -F '\t' '{print $2}')
        break
    fi
done <<< "$sinks"


pactl set-default-sink "$sink"
pactl set-sink-port "$sink" "$port"
