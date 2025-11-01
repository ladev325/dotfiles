#!/bin/bash
# Wallpaper
swww img "$HOME/.config/wallpapers/current.jpg" --transition-type wipe --transition-angle 45

# Pywal & Waybar
killall waybar
wal -ct
wal -i "$HOME/.config/wallpapers/current.jpg" #-b "#0f0903"
waybar &

# Third-party
walogram -s -f "$HOME/.cache/wal/colors-walogram.sh"
pywal-discord -t new
pywalfox update

# VSCode
"$HOME/.config/wallpapers/scripts/reload_vscode.sh"

# Qt (Kvantum)
cp "$HOME/.cache/wal/colors-kvantum.kvconfig" "$HOME/.config/Kvantum/pywal/pywal.kvconfig"
cp "$HOME/.cache/wal/colors-kvantum.svg" "$HOME/.config/Kvantum/pywal/pywal.svg"

# GTK
rm "$HOME/.config/gtk-4.0/gtk.css"
gradience-cli import -p "$HOME/.cache/wal/colors-gradience.json"
gradience-cli apply -n "colors-gradience" --gtk both

# Dunst
cp "$HOME/.cache/wal/colors-dunst" "$HOME/.config/dunst/dunstrc"
pkill -HUP dunst

hyprctl reload
"$HOME/.config/wallpapers/scripts/reload_icons.sh"