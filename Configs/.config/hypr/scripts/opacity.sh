#!/bin/bash
HYPRLAND_CONFIG="$HOME/.config/hypr/opacity.conf"
WAYBAR_CONFIG="$HOME/.config/waybar/style.css"
WAYBAR_PATTERN='@define-color waybar_bg @waybar_tint_2;'
WAYBAR_BACKUP="$HOME/.config/waybar/style-backup.css"

toggle_hyprland() {
    if grep -q "^#[^#]" "$HYPRLAND_CONFIG"; then
        sed -i 's/^#//' "$HYPRLAND_CONFIG"
    else
        sed -i '/^$/! s/^/#/' "$HYPRLAND_CONFIG"
    fi
}

toggle_waybar() {
    if [ ! -f "$WAYBAR_BACKUP" ]; then
        cp "$WAYBAR_CONFIG" "$WAYBAR_BACKUP"
    fi

    if grep -q "^[[:space:]]*/\*.*$WAYBAR_PATTERN.*\*/" "$WAYBAR_CONFIG"; then
        sed -i "/\/\*.*$WAYBAR_PATTERN.*\*\//s|^[[:space:]]*\/\*\(.*\)\*\/|\1|" "$WAYBAR_CONFIG"
    else
        sed -i "/$WAYBAR_PATTERN/s|^[[:space:]]*\(.*\)|/*\1*/|" "$WAYBAR_CONFIG"
    fi
}

if [ "$1" = "-a" ]; then
    toggle_hyprland
    toggle_waybar
    killall waybar
    waybar &
else
    hyprctl dispatch setprop active noblur toggle
    hyprctl dispatch setprop active opaque toggle
fi