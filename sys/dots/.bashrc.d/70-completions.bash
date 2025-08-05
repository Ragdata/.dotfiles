# shellcheck shell=bash
####################################################################
# COMPLETIONS LOADER
####################################################################
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

# Load bash-completions if available
[ -f /etc/bash_completion ] && source /etc/bash_completion

# ------------------------------------------------------------------
# loadCompletions
# ------------------------------------------------------------------
# @description Load all enabled completion files
# ------------------------------------------------------------------
# Load all enabled completion files
if [ -f "$REGISTRY/comp/completions.enabled" ]; then
    while IFS= read -r line
    do
        # shellcheck disable=SC1090
        if [[ "${line:0:1}" != "#" && -n "$line" ]]; then
			script="$COMPLETIONS/$line.completions.bash"
			file=$(checkOverride "$script")
            [ -f "$file" ] && source "$file"
        fi
    done < "$REGISTRY/completions.enabled"
fi
# ------------------------------------------------------------------
