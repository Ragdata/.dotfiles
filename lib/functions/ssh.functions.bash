#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2034
####################################################################
# ssh.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         ssh.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# DEPENDENCIES
####################################################################
# required library files
dot::include "log.functions"
####################################################################
# SSH FUNCTIONS
####################################################################
#-------------------------------------------------------------------
# ssh::keygen::user
#-------------------------------------------------------------------
ssh::keygen::user()
{
    group 'ssh'

    log::debug "${FUNCNAME[0]}"

    local username email

    username="$(git config --get user.name | toLower)"
    email="$(git config --get user.email | toLower)"

    ssh-keygen -q -f "$HOME/.ssh/id_$username" -t ed25519 -C "$email" -N ""
}
