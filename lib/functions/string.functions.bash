#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# string.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         string.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# PREFLIGHT
####################################################################
#declare -gx _STRING_FUNCTIONS; [[ "${_STRING_FUNCTIONS:-0}" -eq 1 ]] && return 0; _STRING_FUNCTIONS=1;
####################################################################
# STRING FUNCTIONS
####################################################################
str::split()
{
	local haystack="${1?}"
	local delim="${2?}"
	local -n arr="${3?}"
	# shellcheck disable=SC2034
	mapfile -d "$delim" -t arr < <(printf '%s' "$haystack")
}
