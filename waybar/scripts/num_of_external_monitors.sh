#!/bin/bash

hyprctl -j monitors | jq '. | map(select(.name != "eDP-1")) | length'
