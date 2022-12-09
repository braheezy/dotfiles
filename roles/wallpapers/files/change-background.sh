#!/bin/bash

set -euo pipefail

folder=$HOME/Pictures/catppuccin-wallpapers
random_pic=$(ls $folder/* | shuf -n1)

dconf write /org/gnome/desktop/background/picture-uri "'file://$random_pic'"
