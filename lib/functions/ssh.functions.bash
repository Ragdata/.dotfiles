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
# ssh::id::send
#-------------------------------------------------------------------
ssh::copy::id()
{
    group 'ssh'

    log::debug "${FUNCNAME[0]}"

    local destination="${1?}" username result

    username="$(git config --get user.name | toLower)"

    ssh-copy-id -i "id_$username" "$destination"; result=$?

    return $result
}
#-------------------------------------------------------------------
# ssh::keygen::user
#-------------------------------------------------------------------
ssh::keygen::user()
{
    group 'ssh'

    log::debug "${FUNCNAME[0]}"

    local username email result

    username="$(git config --get user.name | toLower)"
    email="$(git config --get user.email | toLower)"

    ssh-keygen -q -f "$HOME/.ssh/id_$username" -t ed25519 -C "$email" -N ""; result=$?

    return $result
}
#-------------------------------------------------------------------
# ssh::get
#-------------------------------------------------------------------
ssh::get()
{
    group 'ssh'

    log::debug "${FUNCNAME[0]}"

    local source="${1?}"
    local filePath="${2?}"
    local destPath="${3?}"
    local result

    scp "$source:$filePath" "$destPath"; result=$?

    return $result
}
#-------------------------------------------------------------------
# ssh::put
#-------------------------------------------------------------------
ssh::put()
{
    group 'ssh'

    log::debug "${FUNCNAME[0]}"

    local filePath="${1?}"
    local destination="${2?}"
    local destPath="${3?}"
    local result

    scp "$filePath" "$destination:$destPath"; result=$?

    return $result
}
