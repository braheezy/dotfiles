#!/bin/bash

set -euo pipefail

folder=$HOME/Pictures/wallpapers/src
random_pic=$(ls $folder/*.{png,jpg} | shuf -n1)

dconf write /org/gnome/desktop/background/picture-uri "'file://$random_pic'"
dconf write /org/gnome/desktop/background/picture-uri-dark "'file://$random_pic'"

# Pic a different pic for the screensaver
dconf write /org/gnome/desktop/screensaver/picture-uri "'file://$(ls $folder/*.png | shuf -n1)'"
