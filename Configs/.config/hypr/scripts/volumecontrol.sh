#!/bin/bash

SINK=$(pactl get-default-sink)
CURRENT_VOL=$(pactl get-sink-volume "$SINK" | grep -oP '\d+(?=%)' | head -1)

case "$1" in
    up)   NEW_VOL=$((CURRENT_VOL + 5)) ;;
    down) NEW_VOL=$((CURRENT_VOL - 5)) ;;
    max)  NEW_VOL=100 ;;
    *)    exit 1 ;;
esac

(( NEW_VOL > 100 )) && NEW_VOL=100
(( NEW_VOL < 0 )) && NEW_VOL=0

pactl set-sink-volume "$SINK" "${NEW_VOL}%"
