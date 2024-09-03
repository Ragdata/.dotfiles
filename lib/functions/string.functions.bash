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
# STRING FUNCTIONS
####################################################################
str::split()
{
    group 'str'

	local haystack="${1?}"
	local delim="${2?}"
	local -n arr="${3?}"
	# shellcheck disable=SC2034
	mapfile -d "$delim" -t arr < <(printf '%s' "$haystack")
}
