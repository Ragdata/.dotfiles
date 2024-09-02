#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# regex.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         regex.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# PREFLIGHT
####################################################################
[[ -z ${_REGEX_FUNCTIONS+x} ]] && declare -gx _REGEX_FUNCTIONS
[[ "$_REGEX_FUNCTIONS" -eq 1 ]] && return 0; _REGEX_FUNCTIONS=1;
####################################################################
# REGEX FUNCTIONS
####################################################################
