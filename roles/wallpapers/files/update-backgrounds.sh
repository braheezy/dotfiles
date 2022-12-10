#!/bin/bash
# Opinionated setup of wallpapers

current_wallpapers="$HOME/Pictures/current-wallpapers"
base_wallpapers="$HOME/Pictures/catppuccin-wallpapers"

mkdir -p $current_wallpapers

# Update repo of wallpapers
command pushd $base_wallpapers >/dev/null
    gum spin "Updating wallpapers..." git pull
command popd >/dev/null

for folder in flatppuccin gradients landscapes minimalistic misc waves
do
    rsync -a $base_wallpapers/$folder/ $current_wallpapers
done
