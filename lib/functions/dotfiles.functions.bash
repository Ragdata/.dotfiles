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

	debugLog "${FUNCNAME[0]}"

	echoHead "Updating Package Cache"
	sudo apt-get -qq -y update; result=$?
	if [ "$result" -eq 0 ]; then 
		log::info "Package cache updated successfully"
		echoDot "OK" -c "${LT_GREEN}"
	else
		log::error "Package cache update failed"
		echoDot "FAILED!" -c "${RED}"
	fi

	echoHead "Upgrading System Files"
	sudo apt-get -qq -y full-upgrade; result=$?
	if [ "$result" -eq 0 ]; then 
		log::info "System files upgraded successfully"
		echoDot "OK" -c "${LT_GREEN}"
	else
		log::error "System files upgrade failed"
		echoDot "FAILED!" -c "${RED}"
	fi
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
