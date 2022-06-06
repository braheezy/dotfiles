# braheezy's dotfiles
This mostly Ansible-based project sets up my (growing) dotfiles. It is intended for a fresh machine.

## Ansible?
Most dotfile projects you'll find use Bash to install the dots. I don't like Bash.

The great thing about Ansible is the idempotency and support for dry running. You'll find all sorts of neat Ansible usage here even if you aren't interested in dotfiles. Check out the `roles/` directory for more.

# Prerequisites
* `sudo` access
* VS Code installed
* Kitty terminal installed

# Installation
1. Clone this repo to the machine you want to set up.
2. Run `sh install.sh`
