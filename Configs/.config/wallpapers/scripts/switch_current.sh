#!/bin/bash

# Switch wallpaper by keybinds (-f --forward, -b --back)

IMG_DIR="$HOME/.config/wallpapers/images"
CURRENT_DIR="$HOME/.config/wallpapers"
CURRENT_NAME="$CURRENT_DIR/current.jpg"
CURRENT_CACHE="$CURRENT_DIR/current"

# Get all wallpapers as array
get_wallpapers() {
    find "$IMG_DIR" -maxdepth 1 -type f -iname "*.jpg" -exec basename {} \; | sort
}

# Apply wallpaper
set_wallpaper() {
    local name=$1
    local path="$IMG_DIR/$name"
    
    [ ! -f "$path" ] && echo "Error: $path not found" && return 1
    
    cp "$path" "$CURRENT_NAME"
    echo "$name" > "$CURRENT_CACHE"
    echo "Wallpaper set: $name"
    
    # hyprctl hyprpaper wallpaper ",$CURRENT_NAME"
    return 0
}

# Args
case "$1" in
    -f|--forward|"") direction="forward" ;;
    -b|--back) direction="back" ;;
    *) echo "Usage: $0 [-f|--forward] [-b|--back]"; exit 1 ;;
esac

[ ! -d "$IMG_DIR" ] && echo "Error: $IMG_DIR not found" && exit 1
mkdir -p "$CURRENT_DIR"

# Get wallpapers array
mapfile -t wallpapers < <(get_wallpapers)
count=${#wallpapers[@]}

[ "$count" -eq 0 ] && echo "Error: no jpg files found" && exit 1

# Init if first run
if [ ! -f "$CURRENT_NAME" ] || [ ! -f "$CURRENT_CACHE" ]; then
    set_wallpaper "${wallpapers[0]}"
    exit 0
fi

# Current
current=$(cat "$CURRENT_CACHE")

# Find current index
current_index=-1
for i in "${!wallpapers[@]}"; do
    if [ "${wallpapers[$i]}" = "$current" ]; then
        current_index=$i
        break
    fi
done

# If current not found, start from beginning
[ "$current_index" -eq -1 ] && set_wallpaper "${wallpapers[0]}" && exit 0

# Calculate next index
if [ "$direction" = "forward" ]; then
    new_index=$(( (current_index + 1) % count ))
else
    new_index=$(( (current_index - 1 + count) % count ))
fi

set_wallpaper "${wallpapers[$new_index]}"

"$CURRENT_DIR/scripts/reload_all.sh"