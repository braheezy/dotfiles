#!/bin/bash
# Opinionated setup of wallpapers

set -euo pipefail

# Update repo of wallpapers
command pushd "$HOME/Pictures/wallpapers" >/dev/null
    git pull
command popd >/dev/null
