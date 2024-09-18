#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# wsl.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         wsl.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# WSL FUNCTIONS
####################################################################
#-------------------------------------------------------------------
# wsl::ssh::init
#-------------------------------------------------------------------
wsl::ssh::init()
{
    group 'ssh'

    log::debug "${FUNCNAME[0]}"

    local gpg_key

    [ -d "$WIN_HOME/.ssh-skel" ] || return 0

    cp "$WIN_HOME/.ssh-skel" "$WSL_HOME/.ssh"

    gpg_key="$(find "$WSL_HOME/.ssh" -type f -name "*_SECRET.asc")"

    if [ -f "$gpg_key" ]; then
        if gpg --import "$gpg_key"; then
            rm -f "$gpg_key"
        fi
    fi
}
