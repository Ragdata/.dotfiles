# shellcheck shell=bash
####################################################################
# FUNCTIONS LOADER
####################################################################
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################
# ESSENTIAL FUNCTIONS
####################################################################



# ------------------------------------------------------------------
# loadFunctions
# ------------------------------------------------------------------
# @description Load all enabled function files
# ------------------------------------------------------------------
# Load all enabled function files
if [ -f "$REGISTRY/functions.enabled" ]; then
    while IFS= read -r line
    do
        # shellcheck disable=SC1090
        if [[ "${line:0:1}" != "#" && -n "$line" ]]; then
			script="$FUNCTIONS/$line.functions.bash"
			file=$(checkOverride "$script")
            [ -f "$file" ] && source "$file"
        fi
    done < "$REGISTRY/functions.enabled"
fi
# ------------------------------------------------------------------
