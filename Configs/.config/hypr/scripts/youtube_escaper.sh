#!/bin/bash

windows=$(hyprctl clients -j | jq -r '.[] | select(.title | contains("Firefox")) | .address')

for window in $windows; do
    hyprctl dispatch focuswindow address:$window
    sleep 0.1
    if [[ "$1" == "-r" ]]; then
        pactl set-sink-mute @DEFAULT_SINK@ false
        sleep 0.1
        ydotool key 29:1 42:1 15:1 15:0 42:0 29:0  # ctrl+Shift+Tab
        sleep 0.1
        playerctl play #ydotool key 57:1 57:0  # play/pause
    else
        pactl set-sink-mute @DEFAULT_SINK@ true
        sleep 0.1
        playerctl pause #ydotool key 57:1 57:0  # play/pause
        sleep 0.1
        ydotool key 29:1 15:1 15:0 29:0  # ctrl+Tab
    fi
done
