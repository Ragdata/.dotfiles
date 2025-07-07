# shellcheck shell=bash
# shellcheck disable=SC2139
####################################################################
# filesys.aliases.bash
####################################################################
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
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
