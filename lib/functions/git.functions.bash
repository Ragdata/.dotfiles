#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2091
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
# DEPENDENCIES
####################################################################
# required library files
dot::include "log.functions"
####################################################################
# VARIABLES
####################################################################
export TREEFILE="$DOTFILES/.subtrees.yml"
####################################################################
# GIT FUNCTIONS
####################################################################
#-------------------------------------------------------------------
# git::subtree::add
#-------------------------------------------------------------------
git::subtree::add()
{
    group 'git'

    (($# >= 3)) || errorExit "Missing Argument(s)"

    local name path url branch

    name="${1,,}"
    path="${2-}"
    url="${3:-}"
    branch="${4:-master}"

    [ ! -f "$TREEFILE" ] && touch "$TREEFILE"

    # shellcheck disable=SC2091
    if $(yq 'has("subtree")' "$TREEFILE"); then
        if $(yq ".subtree | has(\"$name\")" "$TREEFILE"); then exitLog "Subtree '$name' already exists"; fi
    fi

    git remote add -f "$name" "$url"
    git subtree add --prefix "$path" "$name" "$branch" --squash || exitLog "Failed to add subtree '$name'"

    yq -n -I4 ".subtree.$name.path = $path" -i "$TREEFILE"
    yq -n -I4 ".subtree.$name.url = $url" -i "$TREEFILE"
    yq -n -I4 ".subtree.$name.branch = $branch" -i "$TREEFILE"
}
#-------------------------------------------------------------------
# git::subtree::fetch
#-------------------------------------------------------------------
git::subtree::fetch()
{
    group 'git'

    (($# >= 1)) || errorExit "Missing Argument(s)"

    local name branch

    name="${1?}"

    # shellcheck disable=SC2091
    if $(yq 'has("subtree")' "$TREEFILE"); then
        if $(yq ".subtree | has(\"$name\")" "$TREEFILE"); then
            if $(yq ".subtree.$name | has(\"branch\")" "$TREEFILE"); then branch="$(yq ".subtree.$name.branch" "$TREEFILE")"; else exitLog "Subtree has no branch"; fi
        else
            exitLog "Subtree '$name' not found"
        fi
    fi

    git fetch "$name" "$branch"
}
#-------------------------------------------------------------------
# git::subtree::list
#-------------------------------------------------------------------
git::subtree::list()
{
    group 'git'

    local name path url branch header entry
    local -a NAMES

    echo ""
    echoYellow "Subtrees"
    echo ""
    header="$(printf -- '%-15s %s' "Name" "Path")"
    echoGold "$header"
    echoGold "line"

    if $(yq 'has("subtree")' "$TREEFILE"); then
        readarray NAMES < <(yq '.subtree | keys' "$TREEFILE")
        for name in "${NAMES[@]}"
        do
            name="${name//- }"
            name="${name//[$'\t\n\r']}"
            path="$(yq ".subtree.$name.path" "$TREEFILE")"
            url="$(yq ".subtree.$name.url" "$TREEFILE")"
            branch="$(yq ".subtree.$name.branch" "$TREEFILE")"
            entry="$(printf -- '%-15s %s' "$name" "$path")"
            echoLtGreen "$entry"
        done
    fi
    echo ""
}
#-------------------------------------------------------------------
# git::subtree::pull
#-------------------------------------------------------------------
git::subtree::pull()
{
    group 'git'

    (($# >= 1)) || errorExit "Missing Argument(s)"

    local name path branch

    name="${1?}"

    # shellcheck disable=SC2091
    if $(yq 'has("subtree")' "$TREEFILE"); then
        if $(yq ".subtree | has(\"$name\")" "$TREEFILE"); then
            if $(yq ".subtree.$name | has(\"path\")" "$TREEFILE"); then path="$(yq ".subtree.$name.path" "$TREEFILE")"; else exitLog "Subtree has no path"; fi
            if $(yq ".subtree.$name | has(\"branch\")" "$TREEFILE"); then branch="$(yq ".subtree.$name.branch" "$TREEFILE")"; else exitLog "Subtree has no branch"; fi
        else
            exitLog "Subtree '$name' not found"
        fi
    fi

    git subtree pull --prefix "$path" "$name" "$branch" --squash
}
#-------------------------------------------------------------------
# git::subtree::remove
#-------------------------------------------------------------------
git::subtree::remove()
{
    group 'git'

    (($# >= 1)) || errorExit "Missing Argument(s)"

    local name path

    name="${1?}"

    # shellcheck disable=SC2091
    if $(yq 'has("subtree")' "$TREEFILE"); then
        if $(yq ".subtree | has(\"$name\")" "$TREEFILE"); then
            if $(yq ".subtree.$name | has(\"path\")" "$TREEFILE"); then path="$(yq ".subtree.$name.path" "$TREEFILE")"; else exitLog "Subtree has no path"; fi
        else
            exitLog "Subtree '$name' not found"
        fi
    fi

    yq -i "del(.subtree.$name)" "$TREEFILE"

    [ -d "$DOTFILES/$path" ] || exitLog "Path '$path' not found"

    sudo rm -rf "$DOTFILES/$path"
}
