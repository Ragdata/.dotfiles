#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2034
####################################################################
# wsl2-ubuntu.bash
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         wsl2-ubuntu.bash
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
dot::include "dotfiles.functions" "wsl.functions"
####################################################################
# METADATA
####################################################################
about 'An instance commissioning script for systems running Ubuntu on WSL2'
group 'instances'
####################################################################
# MAIN
####################################################################
clear

if [ "$1" != "rebooted" ]; then
    echoDot "Configuring WSL2" -s "➤" -c "${GOLD}"
    script::launch "fstab"
    script::launch "wsl"
    dot::reboot::install "$INSTANCES/wsl2-debian.bash"
else
    dot::reboot::install "$1"
    echoDot "Copying .ssh-skel" -s "➤" -c "${GOLD}"
    wsl::ssh::init
    echo ""
fi

echoDot "Processing purge list" -s "➤" -c "${GOLD}"
pkg::removeList "purge"

echo ""
echoDot "Installing packages" -s "➤" -c "${GOLD}"
pkg::install "software-properties-common"
dot::install::deps
pkg::install "shellcheck" "wslu"

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
script::launch "rhosts"
script::launch "compilers"
echo ""
pkg::cleanup
