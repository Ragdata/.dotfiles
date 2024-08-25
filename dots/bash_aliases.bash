#!/usr/bin/env bash
####################################################################
# .bash_aliases
####################################################################
# Ragdata's Dotfiles - Dotfile Master
#
# File:         .00bash_aliases
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# BASIC ALIASES
####################################################################

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then

    if [ -r ~/.dircolors ]; then
    	eval "$(dircolors -b ~/.dircolors)"
    else
    	eval "$(dircolors -b)"
	fi

    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF --color --group-directories-first'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
