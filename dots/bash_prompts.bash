#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# .bash_prompts
####################################################################
# Ragdata's Dotfiles - Dotfile Master
#
# File:         .bash_prompts
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################

[ -z "$DOTFILES_PROMPT" ] && DOTFILES_PROMPT="default"

if [ -f "$CUSTOM/dots/prompts/${DOTFILES_PROMPT,,}.bash" ]; then
    source "$CUSTOM/dots/prompts/${DOTFILES_PROMPT,,}.bash"
else
    source "$DOTS/prompts/${DOTFILES_PROMPT,,}.bash"
fi
