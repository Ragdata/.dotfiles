#!/usr/bin/env bash
####################################################################
# plugins.bash
####################################################################
# Author:       Ragdata
# Date:         22/08/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

# ------------------------------------------------------------------
# loadPlugins
# ------------------------------------------------------------------
# @description Load all enabled plugin files
# ------------------------------------------------------------------
# Load all enabled plugin files
if [ -f "$REGISTRY/plugins.enabled" ]; then
    while IFS= read -r file
    do
        # shellcheck disable=SC1090
        if [[ "${file:0:1}" != "#" && -n "$file" ]]; then
            [ -f "$file" ] && source "$file"
        fi
    done < "$REGISTRY/plugins.enabled"
fi
