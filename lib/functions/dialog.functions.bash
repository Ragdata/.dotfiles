#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# dialog.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         dialog.functions
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
# DIALOG FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# dialog::setup
# ------------------------------------------------------------------
dialog::setup()
{
    group 'dialog'

    local options

    options="$(getopt -l "backtitle:begin:cancel-label:" -o "" -a -- "$@")"

    eval set --"$options"

    while true
    do
        case "$1" in

        esac
    done
}
####################################################################
# DIALOG WIDGET FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# dialog::buildlist
# ------------------------------------------------------------------
dialog::buildlist()
{
    group 'dialog'
}
# ------------------------------------------------------------------
# dialog::buildlist::help
# ------------------------------------------------------------------
dialog::buildlist::help()
{
    group 'dialog'
}
# ------------------------------------------------------------------
# dialog::calendar
# ------------------------------------------------------------------
dialog::calendar()
{
    group 'dialog'
}
# ------------------------------------------------------------------
# dialog::calendar::help
# ------------------------------------------------------------------
dialog::calendar::help()
{
    group 'dialog'
}
# ------------------------------------------------------------------
# dialog::checklist
# ------------------------------------------------------------------
dialog::checklist()
{
    group 'dialog'
}
# ------------------------------------------------------------------
# dialog::checklist::help
# ------------------------------------------------------------------
dialog::checklist::help()
{
    group 'dialog'
}
# ------------------------------------------------------------------
# dialog::menu
# ------------------------------------------------------------------
dialog::menu()
{
    group 'dialog'

    local -n ARR="${1?}"
    local -n OPTS="${2?}"
    local -n RES="${3?}"
    local result

    result=$(dialog --clear \
        --ok-label "${ARR['ok']:-"OK"}" \
        --cancel-label "${ARR['cancel']:-"Cancel"}" \
        --backtitle "${ARR['backtitle']}" \
        --title "${ARR['title']}" \
        --menu "${ARR['text']}" "${ARR['ht']:-15}" "${ARR['wt']:-50}" "${ARR['menuHt']:-5}" \
        "${OPTS[*]}" 3>&1 1>&2 2>&3)

    printf -v "$RES" '%s' "$result"

    return $?
}
# ------------------------------------------------------------------
# dialog::menu::help
# ------------------------------------------------------------------
dialog::menu::help()
{
    group 'dialog'
}
