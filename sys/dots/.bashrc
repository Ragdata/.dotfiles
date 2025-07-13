# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# PATHS
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/"$USER"/.local/bin
export CDPATH=.:~

# set PATH so it includes user's private bin if it exists
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

# set PATH so it includes user's private bin if it exists
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

# iterate through the folders in the .bashrc.d directory
# and make sure that everything gets to where it ought to be.
include()
{
	for script in "$1"/*
	do
		[[ ! -f "$script" ]] && continue
		# Check if the file is a symlink
		[[ -L "$script" ]] && script=$(readlink -f "$script")
		# Source the script
		source "$script" || { echoError "Error sourcing script: $script"; continue; }
	done
}

[ -d "$HOME/.bashrc.d" ] && include "$HOME/.bashrc.d"
