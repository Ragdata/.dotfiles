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
#-------------------------------------------------------------------
# str::split
#-------------------------------------------------------------------
str::split()
{
    group 'str'

	local haystack="${1?}"
	local delim="${2?}"
	local -n arr="${3?}"
	# shellcheck disable=SC2034
	mapfile -d "$delim" -t arr < <(printf '%s' "$haystack")
}
#-------------------------------------------------------------------
# str::toLower
#-------------------------------------------------------------------
str::toLower()
{
    group 'str'

    local string="${1:-}"

    printf -- '%s' "${string,,}"
}
#-------------------------------------------------------------------
# str::toUpper
#-------------------------------------------------------------------
str::toUpper()
{
    group 'str'

    local string="${1:-}"

    printf -- '%s' "${string^^}"
}
####################################################################
# ALIASED FUNCTIONS
####################################################################
#-------------------------------------------------------------------
# toLower
#-------------------------------------------------------------------
toLower()
{
    group 'str'

    local string

    string="$(</dev/stdin)"

    [ -z "$string" ] && string="${1:-}"

    [ -z "$string" ] && return 1

    str::toLower "$string"
}
#-------------------------------------------------------------------
# toUpper
#-------------------------------------------------------------------
toUpper()
{
    group 'str'

    local string

    string="$(</dev/stdin)"

    [ -z "$string" ] && string="${1:-}"

    [ -z "$string" ] && return 1

    str::toUpper "$string"
}
