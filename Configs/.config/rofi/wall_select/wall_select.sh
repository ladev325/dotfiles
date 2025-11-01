#!/bin/bash
# Author: https://github.com/gh0stzk/dotfiles
# Modified by: https://github.com/develcooking/hyprland-dotfiles
# Modified again by: ladev325

wallpaper_dir="${HOME}/.config/wallpapers/images"
current_dir="${HOME}/.config/wallpapers"
cache_dir="${HOME}/.cache/jp/${theme}"
rofi_command="rofi -x11 -dmenu -theme ${HOME}/.config/rofi/wall_select/style.rasi -theme-str ${rofi_override}"
reload_script="${HOME}/.config/wallpapers/scripts/reload_all.sh"

# Create cache directory
if [ ! -d "${cache_dir}" ]; then
    mkdir -p "${cache_dir}"
fi

physical_monitor_size=24
monitor_res=$(hyprctl monitors | grep -A2 Monitor | head -n 2 | awk '{print $1}' | grep -oE '^[0-9]+')
dots_per_inch=$(echo "scale=2; $monitor_res / $physical_monitor_size" | bc | xargs printf "%.0f")
monitor_res=$(( monitor_res * physical_monitor_size / dots_per_inch ))
rofi_override="element-icon{size:${monitor_res}px;border-radius:0px;}"

# Generate thumbnails
for imagen in "$wallpaper_dir"/*.{jpg,jpeg}; do
    if [ -f "$imagen" ]; then
        nombre_archivo=$(basename "$imagen")
        if [ ! -f "${cache_dir}/${nombre_archivo}" ]; then
            convert -strip "$imagen" -thumbnail 500x500^ -gravity center -extent 500x500 "${cache_dir}/${nombre_archivo}"
        fi
    fi
done

# Select wallpaper with rofi
wall_selection=$(find "${wallpaper_dir}" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) \
    -exec basename {} \; | sort | while read -r a; do
        echo -en "$a\x00icon\x1f${cache_dir}/$a\n"
    done | $rofi_command)

[[ -n "$wall_selection" ]] || exit 1

# Copy selected wallpaper
full_path="${wallpaper_dir}/${wall_selection}"
cp "$full_path" "${current_dir}/current.jpg"

# Reload everything
"$reload_script"
exit 0