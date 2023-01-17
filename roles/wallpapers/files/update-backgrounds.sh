#!/bin/bash
# Opinionated setup of wallpapers

set -uo pipefail

current_wallpapers="$HOME/Pictures/current-wallpapers"
base_wallpapers="$HOME/Pictures/catppuccin-wallpapers"

mkdir -p $current_wallpapers

# Update repo of wallpapers
command pushd $base_wallpapers >/dev/null
    gum spin "Updating wallpapers..." git pull
command popd >/dev/null

getImages() {
    html_string=$(cat README.md)
    urls=$(grep -ozE '<img\s+src="https[^"]*"[^>]*>' <<< "$html_string" | perl -nle 'print $1 while /(https:\/\/[^"]*)/g')
    i=0
    for url in $urls
    do
        gum spin --title "Getting extra wallpapers..." -- wget $url -O "$(basename $PWD)-$i"
        i=$((i + 1))
    done
}

for folder in flatppuccin gradients landscapes minimalistic misc waves
do
    command pushd $base_wallpapers/$folder >/dev/null
        getImages
    command popd >/dev/null
    rsync -a $base_wallpapers/$folder/ $current_wallpapers
done
