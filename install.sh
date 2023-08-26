#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(dirname "$0")

DO_INSTALL=true
DRY_RUN=false

# Set charm binary paths
GUM=gum
GLOW=glow
LOCAL_CHARMS=$SCRIPT_DIR/local_bin

# Try to support different machines
if command -v yum &>/dev/null; then
    PKG_MAN=yum
elif command -v apt &>/dev/null; then
    PKG_MAN=apt
fi

ARCH=$(uname -m)
if [[ $ARCH == "aarch64" ]]; then
    ARCH="arm64"
fi

start_spinner() {
    if [ -z "${QUIET+x}" ]; then
    chars=("▁▃▄▅▆▇█▇▆▅▄▃")
    delay=0.2
    i=1
    # shellcheck disable=SC2004
    color=$(( ($RANDOM % 18) + 34))
    msg=$1

    while true; do
        echo -ne "\r\e[38;5;${color}m${chars:i++%${#chars}:1}\e[0m ${msg}. This may take a minute..."
        sleep $delay
    done
    fi
}
stop_spinner() {
  echo -ne "\r\033[K"  # Clear the line
}

# Install local copies of charm binaries
get_local_charm() {
    mkdir -p "$LOCAL_CHARMS"
    case $1 in
        gum)
            if [[ ! -e $LOCAL_CHARMS/gum ]]; then
                start_spinner "Adding gum locally" &
                pid=$!
                wget -qO- \
                    "https://github.com/charmbracelet/gum/releases/download/v0.10.0/gum_0.10.0_Linux_$ARCH.tar.gz" \
                    | tar -xz -C "$LOCAL_CHARMS" gum
                stop_spinner
                kill $pid
            fi
            GUM=$LOCAL_CHARMS/gum
            ;;
        glow)
            if [[ ! -e $LOCAL_CHARMS/glow ]]; then
                start_spinner "Adding glow locally" &
                pid=$!
                wget -qO- \
                    "https://github.com/charmbracelet/glow/releases/download/v1.5.1/glow_Linux_$ARCH.tar.gz" \
                    | tar -xz -C "$LOCAL_CHARMS" glow
                stop_spinner
                kill $pid
            fi
            GLOW=$LOCAL_CHARMS/glow
            ;;
    esac
}

# Run commands behind a pretty spinner
print_and_run() {
    if [ -z ${CI+z} ]; then
        title=$1
        shift
        # shellcheck disable=SC2068
        $GUM spin --spinner minidot --title "$title" -- $@
    else
        # Simply print and run commands
        # shellcheck disable=SC2068
        echo "$1" && shift && $@
    fi
}

# Process command line options
while getopts ":dnh" opt; do
  case $opt in
    n)
      DO_INSTALL=false
      ;;
    d)
      DRY_RUN=true
      ;;
    h)
      if ! command -v "$GLOW" &>/dev/null; then
        QUIET=1 get_local_charm $GLOW
      fi
      $GLOW help.md
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))


if [[ "$DO_INSTALL" == true ]]; then
    if ! command -v tput &>/dev/null || ! command -v wget &>/dev/null; then
        start_spinner "Installing ncurses and wget to system" &
        pid=$!
        sudo "$PKG_MAN" install -y ncurses wget &>/dev/null
        stop_spinner
        kill $pid
    fi
fi

if ! command -v $GUM &>/dev/null; then
    get_local_charm $GUM
fi

if [[ "$DO_INSTALL" == true ]]; then

    print_and_run "Ensuring the system is up to date..." sudo "$PKG_MAN" update -y
    if [[ $PKG_MAN == "yum " ]]; then
        print_and_run "Making local package metadata cache..." sudo "$PKG_MAN" makecache
    fi
    print_and_run "Ensuring Ansible is installed..." sudo "$PKG_MAN" install -y ansible cowsay python3-psutil python3-jmespath

    print_and_run "Ensuring Ansible collections are installed..." ansible-galaxy collection install community.general
fi

export ANSIBLE_CONFIG="$SCRIPT_DIR/ansible.cfg"
export ANSIBLE_COW_SELECTION=hellokitty

ANSIBLE_ARGS=""
if [[ $DO_INSTALL == false ]];then
    ANSIBLE_ARGS+="-e do_install="
fi
if $DRY_RUN; then
    ANSIBLE_ARGS+=" --check --diff"
fi

# shellcheck disable=SC2086
ansible-playbook "$SCRIPT_DIR/setup.yml" $ANSIBLE_ARGS
