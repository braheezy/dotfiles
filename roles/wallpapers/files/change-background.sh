#!/bin/bash

set -euo pipefail

folder=$HOME/Pictures/current-wallpapers
random_pic=$(ls $folder/*.png | shuf -n1)

dconf write /org/gnome/desktop/background/picture-uri "'ansible.builtin.file://$random_pic'"
dconf write /org/gnome/desktop/background/picture-uri-dark "'ansible.builtin.file://$random_pic'"

# Pic a different pic for the screensaver
dconf write /org/gnome/desktop/screensaver/picture-uri "'ansible.builtin.file://$(ls $folder/*.png | shuf -n1)'"
