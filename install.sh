#!/bin/bash

set -euo pipefail

DO_INSTALL=true
DRY_RUN=false

# Set charm binary paths
GUM=gum
GLOW=glow
SKATE=skate

print_fetch_message() {
    if [ -z "${QUIET+x}" ]; then
        echo "$(tput setaf 3)Installing ${1} locally. This may take a minute...$(tput sgr 0)"
    fi
}

# Install local copies of charm binaries
get_local_charm() {
    mkdir -p local_bin
    case $1 in
        gum)
            if [[ ! -e local_bin/gum ]]; then
                print_fetch_message gum
                wget -qO- \
                    https://github.com/charmbracelet/gum/releases/download/v0.10.0/gum_0.10.0_Linux_x86_64.tar.gz \
                    | tar -xz -C local_bin/ gum
            fi
            GUM=./local_bin/gum
            ;;
        glow)
            if [[ ! -e local_bin/glow ]]; then
                print_fetch_message glow
                wget -qO- \
                    https://github.com/charmbracelet/glow/releases/download/v1.5.1/glow_Linux_x86_64.tar.gz \
                    | tar -xz -C local_bin/ glow
            fi
            GLOW=./local_bin/glow
            ;;
        skate)
            if [[ ! -e local_bin/skate ]]; then
                print_fetch_message skate
                wget -qO- \
                    https://github.com/charmbracelet/skate/releases/download/v0.2.2/skate_0.2.2_Linux_x86_64.tar.gz \
                    | tar -xz -C local_bin/ skate
            fi
            SKATE=./local_bin/skate
            ;;
    esac
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

SCRIPT_DIR=$(dirname "$0")

# Get Gum
if ! command -v $GUM &>/dev/null; then
    get_local_charm $GUM
fi

if [ -z ${CI+z} ]; then
    # Run commands behind a pretty spinner
    print_and_run() {
        title=$1
        shift
        cmd=$@
        $GUM spin --spinner minidot --title "$title" -- $cmd
    }
else
    # Simply print and run commands
    print_and_run() {
        echo "$1" && shift && "$@"
    }
fi

# Get skate and try to get a spotify client id
if ! command -v $SKATE &>/dev/null; then
    get_local_charm $SKATE
fi
print_and_run "Ensuring the system is up to date..." sudo yum -y update

print_and_run "Ensuring Ansible is installed..." sudo yum install -y ansible cowsay python3-psutil python3-jmespath

print_and_run "Ensuring Ansible collections are installed..." ansible-galaxy collection install community.general

if [ -z ${SPOTIFY_CLIENT_ID+x} ]; then
    export SPOTIFY_CLIENT_ID=$($GUM spin --spinner minidot --show-output --title "Using skate to fetch Spotify Client ID..." -- $SKATE get spotify_client_id | echo "")
fi


export ANSIBLE_CONFIG="$SCRIPT_DIR/ansible.cfg"
export ANSIBLE_COW_SELECTION=hellokitty

ANSIBLE_ARGS=""
if ! $DO_INSTALL; then
    ANSIBLE_ARGS+=" -e do_install=false"
fi
if $DRY_RUN; then
    ANSIBLE_ARGS+=" --check --diff"
fi

ansible-playbook "$SCRIPT_DIR/setup.yml" $ANSIBLE_ARGS
