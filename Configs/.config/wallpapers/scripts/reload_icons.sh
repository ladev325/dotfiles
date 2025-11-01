#!/bin/bash

# Intended to use with https://github.com/catppuccin/papirus-folders

PARSE_COLOR=6
CATPPUCCIN_VARIANT="mocha"  # mocha, frappe, latte, or macchiato

# Get pywal color
pywal_color=$(sed -n "$((PARSE_COLOR + 1))p" ~/.cache/wal/colors)
hex_color=${pywal_color#"#"}

# Convert hex to RGB
hex_to_rgb() {
    local hex=$1
    printf "%d %d %d" "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

read -r r g b <<< $(hex_to_rgb "$hex_color")

# Get Catppuccin color based on RGB
get_catppuccin_color() {
    local r=$1 g=$2 b=$3
    
    local max=$r
    local min=$r
    [[ $g -gt $max ]] && max=$g
    [[ $b -gt $max ]] && max=$b
    [[ $g -lt $min ]] && min=$g
    [[ $b -lt $min ]] && min=$b
    
    local delta=$((max - min))
    local brightness=$(( (r + g + b) / 3 ))
    
    echo "DEBUG: R=$r G=$g B=$b" >&2
    echo "DEBUG: Max=$max Min=$min Delta=$delta Brightness=$brightness" >&2
    
    # Very low saturation = grayscale
    if [[ $delta -lt 25 ]]; then
        if [[ $brightness -lt 80 ]]; then
            echo "flamingo"  # Dark gray
        elif [[ $brightness -lt 150 ]]; then
            echo "blue"  # Medium gray
        else
            echo "sky"  # Light gray
        fi
        return
    fi
    
    # Determine dominant color channel
    # Red dominant
    if [[ $r -gt $g && $r -gt $b ]]; then
        local rg_diff=$((r - g))
        local rb_diff=$((r - b))
        
        if [[ $g -gt $((b + 40)) ]]; then
            # Red + Green = Yellow/Orange/Peach
            if [[ $rg_diff -lt 30 ]]; then
                echo "yellow"
            elif [[ $brightness -gt 150 ]]; then
                echo "peach"
            else
                echo "peach"
            fi
        elif [[ $b -gt $((g + 20)) ]]; then
            # Red + Blue = Pink/Mauve
            if [[ $b -gt 150 ]]; then
                echo "mauve"
            else
                echo "pink"
            fi
        else
            # Pure red
            if [[ $r -gt 180 ]]; then
                echo "red"
            else
                echo "maroon"
            fi
        fi
    
    # Green dominant
    elif [[ $g -gt $r && $g -gt $b ]]; then
        local gr_diff=$((g - r))
        local gb_diff=$((g - b))
        
        if [[ $b -gt $((r + 30)) ]]; then
            # Green + Blue = Cyan/Teal
            if [[ $b -gt 140 ]]; then
                echo "sky"
            else
                echo "teal"
            fi
        elif [[ $r -gt $((b + 30)) ]]; then
            # Green + Red = Yellow
            echo "yellow"
        else
            # Pure green
            echo "green"
        fi
    
    # Blue dominant
    else
        local br_diff=$((b - r))
        local bg_diff=$((b - g))
        
        if [[ $g -gt $((r + 20)) ]]; then
            # Blue + Green = Cyan/Sky/Teal
            if [[ $g -gt 140 ]]; then
                echo "sky"
            elif [[ $g -gt 100 ]]; then
                echo "teal"
            else
                echo "sapphire"
            fi
        elif [[ $r -gt $((g + 20)) ]]; then
            # Blue + Red = Purple/Mauve
            if [[ $r -gt 140 ]]; then
                echo "mauve"
            else
                echo "lavender"
            fi
        else
            # Pure blue
            if [[ $b -gt 180 && $delta -gt 60 ]]; then
                echo "blue"
            elif [[ $b -gt 140 ]]; then
                echo "sapphire"
            else
                echo "lavender"
            fi
        fi
    fi
}

catppuccin_color=$(get_catppuccin_color $r $g $b)

echo "Pywal color: $pywal_color (RGB: $r, $g, $b)"
echo "Selected Catppuccin color: cat-${CATPPUCCIN_VARIANT}-${catppuccin_color}"

# Update icons (you`ll need to turn off sudo with password!)
papirus-folders -C "cat-${CATPPUCCIN_VARIANT}-${catppuccin_color}" --theme Papirus-Dark
sudo gtk-update-icon-cache -f -t /usr/share/icons/Papirus-Dark
rm -rf ~/.cache/thumbnails
echo "Done"