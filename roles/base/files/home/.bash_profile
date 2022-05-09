# Source all the custom dots into the environment
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
        # If file is regular readable file, source it.
        [ -r "$rc" ] && [ -f "$rc" ] && . "$rc"
	done
fi

unset rc

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Don't attempt to search the PATH for possible completions when on an empty line
shopt -s no_empty_cmd_completion
