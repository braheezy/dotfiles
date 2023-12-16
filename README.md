# braheezy's dotfiles
This mostly Ansible-based project sets up my (growing) dotfiles. It is intended for a fresh machine.

It's regularly tested on Fedora 37.

## Ansible?
Most dotfile projects you'll find use Bash to install the dots. I don't like Bash.

The great thing about Ansible is the idempotency and support for dry running. You'll find all sorts of neat Ansible tricks here even if you aren't interested in my dotfiles.

# Prerequisites
* `sudo` access if apps should be installed

# Installation
1. Clone this repo to the machine you want to set up.
2. Run `bash install.sh`.

- Notes:
    - Dotfiles are symlinked to files in this project.
    - If installing apps and you want `spotify-player` to connect, set `SPOTIFY_CLIENT_ID` in the environment. The ID is obtained from Spotify's Developer Dashboard.

## Development
To test locally, try something like this:

    docker run --rm -it -v $(pwd):$(pwd) -w $(pwd) fedora:39
    ./install.sh
