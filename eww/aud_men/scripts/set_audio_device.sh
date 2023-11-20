#!/bin/bash

if [ -z "$1" ]; then
    echo "Please provide a sink name."
    exit 1
fi

SINK_NAME="$1"
PORT_NAME="$2"

pactl set-default-sink "$SINK_NAME"
#
# if [ -z $PORT_NAME ]; then
#     exit
# fi
#
# echo $SINK_NAME $PORT_NAME
pactl set-sink-port "$SINK_NAME" "$PORT_NAME"
