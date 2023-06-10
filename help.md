# braheezy dotfiles installer
Run this Bash script to setup and install applications and their associated dotfiles:

    bash install.sh

Options:
    -h      Show this help message.
    -d      Run in dry-run mode. Ansible is run with the *--check* flag.
    -n      No-install mode. Only dotfiles are linked, no binary installs.
    $CI     Environment variable declaring this is being run in CI.
