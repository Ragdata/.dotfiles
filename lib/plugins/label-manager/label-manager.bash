#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2034
####################################################################
# label-manager.bash
####################################################################
# GitHub Repository Label Manager
#
# File:         label-manager.bash
# Author:       Ragdata
# Date:         04/09/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# DEPENDENCIES
####################################################################
# required library files
dot::include "log.functions"
####################################################################
# METADATA
####################################################################
about 'A label management utility for GitHub repositories'
group 'plugins'
####################################################################
# FUNCTIONS
####################################################################
label::setup()
{
    # shellcheck disable=SC2139
    alias label="source $PLUGINS/label-manager/label-manager.bash"
}
####################################################################
# MAIN
####################################################################

case "${1:-}" in
    *)
        label::setup
        ;;
esac
