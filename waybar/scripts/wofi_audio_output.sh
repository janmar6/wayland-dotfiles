#!/bin/bash

# Im so happy that I got this to work!!!!!!!!!
# (It looks a easier than it is)
#
# This program gets available sinks and ports using jq and pactl
# Then lists them using wofi using nice names
# Finally turns them back into correct sinks and ports and sets the default port as that

# Ugly names to pretty
declare -A name_map
name_map["[Out] HDMI1"]="HDMI"
name_map["[Out] Headphones"]="Headphones"
name_map["[Out] Speaker"]="Laptop Speakers"
name_map["headphone-output"]="AirDots"


sinks=$(pactl -f json list sinks | jq -r 'map(select(.ports[].availability != "not available") | "\"\(.name)\"\t\"\(.ports[].name)\"") | unique[]' | tr -d '"')

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


# Getting user input with wofi
output=$(printf "$cleaned_ports" | wofi -l 3 -x -370 -y 10 -W 250 -d) 

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
