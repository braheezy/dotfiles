#!/bin/bash

set -euo pipefail

DO_INSTALL=true
DRY_RUN=false

# Process command line options
while getopts ":dn" opt; do
  case $opt in
    n)
      DO_INSTALL=false
      ;;
    d)
      DRY_RUN=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

SCRIPT_DIR=$(dirname "$0")

GUM_INSTALLED=false
if ! command -v gum &>/dev/null; then
    if $DO_INSTALL; then
        echo "$(tput setaf 3)Installing Gum. This may take a minute...$(tput sgr 0)"
        wget -qO- \
            https://github.com/charmbracelet/gum/releases/download/v0.10.0/gum_0.10.0_Linux_x86_64.tar.gz \
            | tar -xz gum
        sudo mv gum /usr/local/bin
        GUM_INSTALLED=true
    fi
else
    GUM_INSTALLED=true
fi

if [ -z ${CI+z} && $GUM_INSTALLED ]; then
    # Run commands behind a pretty spinner
    print_and_run() {
        title=$1
        shift
        cmd=$@
        gum spin --spinner minidot --title "$title" -- $cmd
    }
    export SPOTIFY_CLIENT_ID=$(skate get spotify_client_id)
else
    # Simply print and run commands
    print_and_run() {
        echo "$1" && shift && "$@"
    }
fi
RUN_PREFIX="print_and_run"

"${RUN_PREFIX}" "Ensuring the system is up to date..." sudo yum -y update

"${RUN_PREFIX}" "Checking Ansible is installed..." sudo yum install -y ansible cowsay python3-psutil python3-jmespath

"${RUN_PREFIX}" "Checking Ansible collections are installed..." ansible-galaxy collection install community.general

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
