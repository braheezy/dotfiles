#!/usr/bin/env bash -x
set -euo pipefail

SCRIPT_DIR="`dirname $0`"

if ! command -v gum &>/dev/null
then
    # Quick! Install Gum!
    sudo echo '[charm]
    name=Charm
    baseurl=https://repo.charm.sh/yum/
    enabled=1
    gpgcheck=1
    gpgkey=https://repo.charm.sh/yum/gpg.key' > /etc/yum.repos.d/charm.repo
    sudo yum install gum 2>/dev/null
fi

wait_command()
{
    echo "gum spin --spinner minidot --title $1 $2"
     \"${1}\" "${2}"
}

gum spin --spinner minidot --title "Ensuring the system is up to date..." -- \
    sudo yum -y update

gum spin --spinner minidot --title "Checking Ansible is installed..." -- \
    sudo yum install -y ansible cowsay python3-psutil

gum spin --spinner minidot --title "Checking Ansible collections are installed..." -- \
    ansible-galaxy collection install community.general

ANSIBLE_CONFIG="$SCRIPT_DIR/ansible.cfg" \
ANSIBLE_COW_SELECTION=hellokitty \
    ansible-playbook "$SCRIPT_DIR/setup.yml"
