# braheezy dotfiles installer
Run this Bash script to setup dotfiles for a bunch of apps I use. By default, the apps are installed too but that can be disabled.

Options:
- **-h**: Show this help message.
- **-d**: Run in dry-run mode. Ansible is run with the *--check* flag.
- **-n**: No-install mode. Only dotfiles are linked, no system binary installs.

Note, some binaries may download to `local_bin/` in this project.

Environment Variables:
- *$CI*: Environment variable declaring this is being run in CI. Some Ansible stuff isn't run.
