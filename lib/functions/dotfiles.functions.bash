#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# dotfiles.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         dotfiles.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# PREFLIGHT
####################################################################
[[ -z ${_DOTFILES_FUNCTIONS+x} ]] && declare -gx _DOTFILES_FUNCTIONS
[[ "$_DOTFILES_FUNCTIONS" -eq 1 ]] && return 0; _DOTFILES_FUNCTIONS=1;
####################################################################
# DOTFILES FUNCTIONS
####################################################################
