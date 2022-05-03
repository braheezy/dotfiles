#!/usr/bin/env bash
set -euo pipefail

# Ensure system is up to date
sudo yum -y update

# Install Ansible, which will perform rest of setup.
sudo yum install -y ansible cowsay

# Install things Ansible needs to run
sudo yum install -y python3-psutil
ansible-galaxy collection install community.general

# Run playbook
ansible-playbook setup.yml
