# shellcheck shell=bash
# shellcheck disable=SC2139
####################################################################
# filesys.aliases.bash
####################################################################
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# METADATA
####################################################################
about 'Filesystem aliases'
group 'aliases'
####################################################################
# ALIASES
####################################################################
if [ -x /usr/bin/dircolors ]; then
    if [ -r ~/.dircolors ]; then
    	eval "$(dircolors -b ~/.dircolors)"
    else
    	eval "$(dircolors -b)"
	fi
    alias ls='ls --color=auto'
fi
# some more ls aliases
alias ll='ls -alF --group-directories-first'
alias la='ls -A'
alias l='ls -CF'
