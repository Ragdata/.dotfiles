#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2034
####################################################################
# wsl2-debian.bash
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         wsl2-debian.bash
# Author:       Ragdata
# Date:         15/09/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# DEPENDENCIES
####################################################################
# required config files
source "$CUSTOM/cfg/.node"
# required library files
dot::include "dotfiles.functions" "script.functions"
####################################################################
# METADATA
####################################################################
about 'An instance commissioning script for systems running Debian on WSL2'
group 'instances'
####################################################################
# MAIN
####################################################################
clear

source "$INSTANCES/helpers/wsl.bash" "$@"

if [ "$1" == "rebooted" ]; then
    echoDot "Processing purge list" -s "➤" -c "${GOLD}"
    pkg::removeList "purge"

    echo ""
    echoDot "Installing packages" -s "➤" -c "${GOLD}"
    pkg::install "software-properties-common"
    dot::install::deps
    pkg::install "shellcheck"

    echo ""
    echoDot "Hardening instance" -s "➤" -c "${GOLD}"
    script::launch "disablenet"
    script::launch "disablefs"
    script::launch "disablemod"
    script::launch "systemdconf"
    script::launch "logindconf"
    script::launch "timesyncd"
    script::launch "hosts"
    script::launch "issue"
    script::launch "logindefs"
    script::launch "sysctl"
    script::launch "limits"
    script::launch "user"
    script::launch "sshd"
    script::launch "password"
    script::launch "ctraltdel"
    script::launch "compilers"
    echo ""
    pkg::cleanup
fi
