#!/usr/bin/env bash

# Install Ansible, which will perform rest of setup.
sudo yum install -y ansible cowsay

# Install things Ansible needs to run
sudo yum install -y python3-psutil
ansible-galaxy collection install community.general

# Run playbook
ansible-playbook setup.yml
