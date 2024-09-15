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
# required library files
dot::include "dotfiles.functions"
####################################################################
# MAIN
####################################################################
clear

dot::install::repos
pkgAddRepos "ppa:ansible/ansible" "ppa:wslutilities/wslu"
echo ""
pkg::removeList "purge"
echo ""
dot::install::deps
#
#pkgInstall "shellcheck" "wslu"
#
#dot::launch::script "disablenet"
#dot::launch::script "disablefs"
#dot::launch::script "disablemod"
#dot::launch::script "systemdconf"
#dot::launch::script "logindconf"
#dot::launch::script "timesyncd"
#dot::launch::script "fstab"
#dot::launch::script "hosts"
#dot::launch::script "issue"
#dot::launch::script "logindefs"
#dot::launch::script "sysctl"
#dot::launch::script "limits"
#dot::launch::script "user"
#dot::launch::script "sshd"
#dot::launch::script "password"
#dot::launch::script "cron"
#dot::launch::script "ctrlaltdel"
#dot::launch::script "rhosts"
#dot::launch::script "compilers"
#dot::launch::script "wsl"
echo ""
pkg::cleanup
