#!/usr/bin/env bash
####################################################################
# aliases.bash
####################################################################
# Author:       Ragdata
# Date:         22/08/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

# # general aliases
# alias reload='reload'
# alias relog='relog'
# alias daemon-reload='sudo systemctl daemon-reload'

# some more ls aliases
alias ll='ls -avlF --color --group-directories-first'
alias la='ls -A'
alias l='ls -CF'

# python aliases
alias py='python3'
alias pip='pip3'

# ------------------------------------------------------------------
# loadAliases
# ------------------------------------------------------------------
# @description Load all enabled alias files
# ------------------------------------------------------------------
# Load all enabled alias files
if [ -f "$REGISTRY/aliases.enabled" ]; then
    while IFS= read -r file
    do
        # shellcheck disable=SC1090
        if [[ "${file:0:1}" != "#" && -n "$file" ]]; then
            [ -f "$file" ] && source "$file"
        fi
    done < "$REGISTRY/aliases.enabled"
fi
