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

    if read -t 0; then
        while read -r data; do
            string="$data"
        done
    else
        string="${1:-}"
    fi

    str::toLower "$string"
}
#-------------------------------------------------------------------
# toUpper
#-------------------------------------------------------------------
toUpper()
{
    group 'str'

    local string

    if read -t 0; then
        while read -r data; do
            string="$data"
        done
    else
        string="${1:-}"
    fi

    str::toUpper "$string"
}
