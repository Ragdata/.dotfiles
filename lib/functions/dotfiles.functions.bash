#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# dotfiles.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         dotfiles.functions
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
# DOTFILES FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# dot::install::menu
# ------------------------------------------------------------------
dot::install::menu()
{
    group 'dot'

	echo "HERE"
}
# ------------------------------------------------------------------
# dot::sysUpdate
# ------------------------------------------------------------------
dot::sysUpdate()
{
    group 'dot'

	local result
	echoHead "Updating Package Cache"
	sudo apt-get -qq -y update; result=$?
	if [ "$result" -eq 0 ]; then echoDot "OK" -c "${LT_GREEN}"; else echoDot "FAILED!" -c "${RED}"; fi

	echoHead "Updating System Files"
	sudo apt-get -qq -y full-upgrade; result=$?
	if [ "$result" -eq 0 ]; then echoDot "OK" -c "${LT_GREEN}"; else echoDot "FAILED!" -c "${RED}"; fi
}
# ------------------------------------------------------------------
# dot::update::bin
# ------------------------------------------------------------------
dot::update::bin()
{
    group 'dot'

	echo "HERE"
}
# ------------------------------------------------------------------
# dot::update::dots
# ------------------------------------------------------------------
dot::update::dots()
{
    group 'dot'

	echo "HERE"
}
# ------------------------------------------------------------------
# dot::update::repo
# ------------------------------------------------------------------
dot::update::repo()
{
    group 'dot'

	echo "HERE"
}
# ------------------------------------------------------------------
# dot::update
# ------------------------------------------------------------------
dot::update()
{
    group 'dot'

	echo "HERE"
}
