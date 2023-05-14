#!/bin/bash

set -euo pipefail

SCRIPT_DIR="`dirname $0`"

if ! command -v gum &>/dev/null
then
    echo "Installing Gum. This may take a minute..."
    sudo bash -c 'echo "[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key" > /etc/yum.repos.d/charm.repo'
    sudo yum install -y gum &>/dev/null
fi

if [ -z ${CI+z} ]; then
    RUN_PREFIX="gum spin --spinner minidot --title"
else
    RUN_PREFIX="echo"
fi
"${RUN_PREFIX}" sudo yum -y update

"${RUN_PREFIX}" sudo yum install -y ansible cowsay python3-psutil python3-jmespath

"${RUN_PREFIX}" ansible-galaxy collection install community.general

export ANSIBLE_CONFIG="$SCRIPT_DIR/ansible.cfg"
export ANSIBLE_COW_SELECTION=hellokitty
ansible-playbook "$SCRIPT_DIR/setup.yml"
