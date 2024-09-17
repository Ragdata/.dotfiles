#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2034
####################################################################
# label-manager.bash
####################################################################
# Ragdata's Dotfiles - Function Definitions
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
# metadata support
source "$DOTFILES/vendor/github.com/erichs/composure/composure.sh"
# required library files
dot::include "log.functions"
####################################################################
# METADATA
####################################################################
about 'A label management utility for GitHub repositories'
group 'plugins'
####################################################################
# HARDENING FUNCTIONS
####################################################################
