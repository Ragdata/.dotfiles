#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# git.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         git.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# GIT FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# git::subtree::add
# ------------------------------------------------------------------
git::subtree::add()
{
    group 'git'

    (($# >= 3)) || errorExit "Missing Argument(s)"

    local name path url branch
    
    name="${1?}"
    path="${2?}"
    url="${3?}"
    branch="${4:-master}"

    git remote add -f "$name" "$url"
    git subtree add --prefix "$path" "$name" "$branch" --squash
}
# ------------------------------------------------------------------
# git::subtree::fetch
# ------------------------------------------------------------------
git::subtree::fetch()
{
    group 'git'

    (($# >= 1)) || errorExit "Missing Argument(s)"

    local name branch
    
    name="${1?}"
    branch="${2:-master}"

    git fetch "$name" "$branch"
}
# ------------------------------------------------------------------
# git::subtree::pull
# ------------------------------------------------------------------
git::subtree::pull()
{
    group 'git'

    (($# >= 3)) || errorExit "Missing Argument(s)"

    local name path url branch
    
    name="${1?}"
    path="${2?}"
    url="${3?}"
    branch="${4:-master}"

    git subtree pull --prefix "$path" "$name" "$branch" --squash
}
