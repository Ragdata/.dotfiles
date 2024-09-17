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
# DEPENDENCIES
####################################################################
# required library files
dot::include "alias.functions"
####################################################################
# ALIASES
####################################################################
# Load all enabled alias files
if [ -f "$DOT_REG/aliases.enabled" ]; then
    while IFS= read -r file
    do
        # shellcheck disable=SC1090
        if [[ "${file:0:1}" != "#" && -n "$file" ]]; then
            [ -f "$file" ] && source "$file"
        fi
    done < "$DOT_REG/aliases.enabled"
fi
