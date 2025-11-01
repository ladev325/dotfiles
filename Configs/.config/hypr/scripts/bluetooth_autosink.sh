#!/usr/bin/env bash

declare -A KNOWN=()

while true; do
    mapfile -t DEVICES < <(bluetoothctl devices Connected | awk '{print $2}')

    for mac in "${DEVICES[@]}"; do
        if [[ -z "${KNOWN[$mac]}" ]]; then
            echo "Detected $mac..."
            timeout 6 bluetoothctl connect "$mac" || echo "Couldn't connect to $mac"
            KNOWN["$mac"]=1
            echo "Connected $mac"
        fi
    done

    for mac in "${!KNOWN[@]}"; do
        if [[ ! " ${DEVICES[*]} " =~ " $mac " ]]; then
            echo "Disconnected $mac"
            unset KNOWN["$mac"]
        fi
    done

    sleep 0.25
done
