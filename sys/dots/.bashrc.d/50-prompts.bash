# shellcheck shell=bash
####################################################################
# PROMPT LOADER
####################################################################
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

[ -z "$DOTFILES_PROMPT" ] && DOTFILES_PROMPT="default"

source "$HOME/.bashrc.d/prompts/${DOTFILES_PROMPT,,}.bash"
