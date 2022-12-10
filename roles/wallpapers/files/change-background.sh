#!/bin/bash

set -euo pipefail

folder=$HOME/Pictures/current-wallpapers
random_pic=$(ls $folder/*.png | shuf -n1)

dconf write /org/gnome/desktop/background/picture-uri "'file://$random_pic'"
dconf write /org/gnome/desktop/background/picture-uri-dark "'file://$random_pic'"