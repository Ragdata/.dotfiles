# shellcheck shell=bash
####################################################################
# ALIAS LOADER
####################################################################
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################
# ESSENTIAL ALIASES
####################################################################

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
    while IFS= read -r line
    do
        # shellcheck disable=SC1090
        if [[ "${line:0:1}" != "#" && -n "$line" ]]; then
			script="$ALIASES/$line.aliases.bash"
			file=$(checkOverride "$script")
            [ -f "$file" ] && source "$file"
        fi
    done < "$REGISTRY/aliases.enabled"
fi
# ------------------------------------------------------------------
