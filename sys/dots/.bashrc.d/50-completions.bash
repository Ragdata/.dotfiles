#!/usr/bin/env bash
####################################################################
# completions.bash
####################################################################
# Author:       Ragdata
# Date:         22/08/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

# Install bash-completion if not already installed
# if ! installed "bash-completion"; then
#     sudo apt install -y bash-completion
# fi
# Load bash-completion if available
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi
# # Create the bash-completion directory if it doesn't exist
# if [[ ! -d "$HOME"/.local/share/bash-completion/completions ]]; then
#     mkdir -p "$HOME"/.local/share/bash-completion/completions
# fi
# if installed "docker-ce"; then
#     # Install Docker completion if not already installed
#     if [[ ! -f "$HOME"/.local/share/bash-completion/completions/docker ]]; then
#         docker completion bash > "$HOME"/.local/share/bash-completion/completions/docker
#     fi
# fi
# ------------------------------------------------------------------
# loadCompletions
# ------------------------------------------------------------------
# @description Load all enabled completion files
# ------------------------------------------------------------------
# Load all enabled completion files
if [ -f "$DOT_REG/completions.enabled" ]; then
    while IFS= read -r file
    do
        # shellcheck disable=SC1090
        if [[ "${file:0:1}" != "#" && -n "$file" ]]; then
            [ -f "$file" ] && source "$file"
        fi
    done < "$DOT_REG/completions.enabled"
fi
