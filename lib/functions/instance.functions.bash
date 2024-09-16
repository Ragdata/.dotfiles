#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# instance.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         instance.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# INSTANCE FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# instance::describe
# ------------------------------------------------------------------
instance::describe()
{
    group 'instance'
}
# ------------------------------------------------------------------
# instance::launch
# ------------------------------------------------------------------
instance::launch()
{
    group 'instance'

    debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

    local path

    if [ -f "$INSTANCES/$1.bash" ]; then
        path="$INSTANCES/$1.bash"
    else
        exitLog "Instance file '$1' not found"
    fi

    source "$path"
}
