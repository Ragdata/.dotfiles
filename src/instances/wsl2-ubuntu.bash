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
dot::include "dotfiles.functions"
####################################################################
# METADATA
####################################################################
about 'An instance commissioning script for systems running Ubuntu on WSL2'
group 'instances'
####################################################################
# MAIN
####################################################################
clear

dot::install::repos
pkgAddRepos "ppa:ansible/ansible" "ppa:wslutilities/wslu"
echo ""

echoDot "Processing purge list" -s "➤" -c "${GOLD}"
pkg::removeList "purge"
echo ""

dot::install::deps
pkgInstall "shellcheck" "wslu"

echo ""
echoDot "Hardening instance" -s "➤" -c "${GOLD}"
script::launch "disablenet"
script::launch "disablefs"
script::launch "disablemod"
script::launch "systemdconf"
script::launch "logindconf"
script::launch "timesyncd"
script::launch "fstab"
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
script::launch "wsl"
echo ""
pkg::cleanup
