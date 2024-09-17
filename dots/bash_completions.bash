#!/usr/bin/env bash
# shellcheck disable=SC1091
####################################################################
# .bash_completions
####################################################################
# Ragdata's Dotfiles - Dotfile Master
#
# File:         .bash_completions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# DEPENDENCIES
####################################################################
# required library files
dot::include "completion.functions"
####################################################################
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
# load all enabled completion files
if [ -f "$DOT_REG/completions.enabled" ]; then
    while IFS= read -r file
    do
        # shellcheck disable=SC1090
        if [[ "${file:0:1}" != "#" && -n "$file" ]]; then
            [ -f "$file" ] && source "$file"
        fi
    done < "$DOT_REG/completions.enabled"
fi
