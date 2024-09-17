#!/usr/bin/env bash
# shellcheck disable=SC1091
####################################################################
# .bash_plugins
####################################################################
# Ragdata's Dotfiles - Dotfile Master
#
# File:         .bash_plugins
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# DEPENDENCIES
####################################################################
# required library files
dot::include "plugin.functions"
####################################################################
# PLUGINS TO LOAD
####################################################################
# load all enabled plugin files
if [ -f "$DOT_REG/plugins.enabled" ]; then
    while IFS= read -r file
    do
        # shellcheck disable=SC1090
        if [[ "${file:0:1}" != "#" && -n "$file" ]]; then
            [ -f "$file" ] && source "$file"
        fi
    done < "$DOT_REG/plugins.enabled"
fi
