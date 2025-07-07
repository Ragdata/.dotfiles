#!/usr/bin/env bash
####################################################################
# functions.bash
####################################################################
# Author:       Ragdata
# Date:         22/08/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

# ------------------------------------------------------------------
# loadFunctions
# ------------------------------------------------------------------
# @description Load all enabled function files
# ------------------------------------------------------------------
# Load all enabled function files
if [ -f "$DOT_REG/functions.enabled" ]; then
    while IFS= read -r file
    do
        # shellcheck disable=SC1090
        if [[ "${file:0:1}" != "#" && -n "$file" ]]; then
            [ -f "$file" ] && source "$file"
        fi
    done < "$DOT_REG/functions.enabled"
fi
