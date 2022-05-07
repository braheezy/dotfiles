#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="`dirname $0`"

# Ensure system is up to date
sudo yum -y update

# Install Ansible, which will perform rest of setup.
sudo yum install -y ansible cowsay

# Install things Ansible needs to run
sudo yum install -y python3-psutil
ansible-galaxy collection install community.general

# Run playbook in subshell with 
(export ANSIBLE_CONFIG="$SCRIPT_DIR/ansible.cfg"; ansible-playbook "$SCRIPT_DIR/setup.yml")
