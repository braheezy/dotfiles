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

gum spin --spinner minidot --title "Ensuring the system is up to date..." -- \
    sudo yum -y update

gum spin --spinner minidot --title "Checking Ansible is installed..." -- \
    sudo yum install -y ansible cowsay python3-psutil python3-jmespath

gum spin --spinner minidot --title "Checking Ansible collections are installed..." -- \
    ansible-galaxy collection install community.general

ANSIBLE_CONFIG="$SCRIPT_DIR/ansible.cfg" \
ANSIBLE_COW_SELECTION=hellokitty \
    ansible-playbook "$SCRIPT_DIR/setup.yml"
