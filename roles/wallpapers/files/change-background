#!/bin/bash

set -euo pipefail

script_dir=$(dirname "$(readlink -f "$0")")

folder=$HOME/Pictures/wallpapers/
search_link="https://github.com/D3Ext/aesthetic-wallpapers/tree/main/images"
download_link="https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main/images"
blocklist_file="$script_dir/blocklist.txt"

# Create the wallpapers directory if it doesn't exist
mkdir -p "$folder"
# Download the list of wallpapers
wallpapers_list=$(curl -s $search_link | grep -oE 'name":"([^"#]+)"' | cut -d'"' -f3 | grep -E '\.(png|jpg|jpeg)$')

# Remove wallpapers that are on the blocklist
if [ -e "$blocklist_file" ]; then
    wallpapers_list=$(comm -23 <(echo "$wallpapers_list" | sort) <(sort "$blocklist_file"))
fi

# Choose a random wallpaper from the remaining list
random_pic=$(echo "$wallpapers_list" | shuf -n1)
wget -q "$download_link/$random_pic" -P "$folder"

# Check if the selected picture is too small (based on dimensions)
min_width=0
min_height=0
actual_width=$(identify -format "%w" "$folder/$random_pic" 2>/dev/null)
actual_height=$(identify -format "%h" "$folder/$random_pic" 2>/dev/null)

if [ "$actual_width" -lt "$min_width" ] || [ "$actual_height" -lt "$min_height" ]; then
    print_error "Selected picture is too small. Exiting."
    exit 1
fi

dconf write /org/gnome/desktop/background/picture-uri "'file://$folder/$random_pic'"
dconf write /org/gnome/desktop/background/picture-uri-dark "'file://$folder/$random_pic'"

# Pick a different pic for the screensaver
random_screensaver_pic=$(ls $folder/*.{png,jpg}} | shuf -n1)
dconf write /org/gnome/desktop/screensaver/picture-uri "'file://$folder/$random_screensaver_pic'"
