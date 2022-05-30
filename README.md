# braheezy's dotfiles
This mostly Ansible-based project sets up my (growing) dotfiles. It is intended for a fresh machine.

## Ansible?
Most dotfile projects you'll find use Bash to install the dots. I don't like Bash.

The great thing about Ansible is the idempotency and support for dry running. You'll find all sorts of neat Ansible usage here even if you aren't interested in dotfiles. Check out the `roles/` directory for more.

# Prerequites
* `sudo` access
* GNOME desktop

# Installation
1. Clone this repo to the machine you want to set up.
2. Run `sh install.sh`

# From a minimal machine
If you often find yourself with a minimal OS install as a starting point, this section's for you.

**Fedora 35**

Install GNOME and update system to use a Desktop.
```bash
yum -y update
yum makecache
yum -y groupinstall gnome
systemctl set-default graphical.target
reboot
```
