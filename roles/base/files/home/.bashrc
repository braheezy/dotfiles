# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source all the custom dots into the environment
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
        # If file is regular readable file, source it.
        [ -r "$rc" ] && [ -f "$rc" ] && . "$rc"
	done
fi

unset rc
