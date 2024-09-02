#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# log.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         log.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# PREFLIGHT
####################################################################
[[ -z ${_LOG_FUNCTIONS+x} ]] && declare -gx _LOG_FUNCTIONS
[[ "$_LOG_FUNCTIONS" -eq 1 ]] && return 0; _LOG_FUNCTIONS=1;
####################################################################
# LOG FUNCTIONS
####################################################################
