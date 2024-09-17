#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# script.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         script.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# SCRIPT FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# script::describe
# ------------------------------------------------------------------
script::describe()
{
    group 'script'
}
# ------------------------------------------------------------------
# script::launch
# ------------------------------------------------------------------
script::launch()
{
    group 'script'

    log::debug "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

    local result path func name="${1//[$'\t\n\r']}"

    if [ -f "$SCRIPTS/$name" ]; then
        path="$SCRIPTS/$name"
    else
        exitLog "Script file '$name' not found"
    fi

    source "$path"

    func="script::$name"

    [[ $(type -t "$func") == "function" ]] || exitLog "Script function '$func' not found"

    eval "$func"; result=$?

    return $result
}
