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
# PREFLIGHT
####################################################################

####################################################################
# DOTFILES FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# dotfiles
# ------------------------------------------------------------------
dotfiles()
{
	local verb="${1:-}"
	local component="${2:-}"
	local func

	case "$verb" in
		show)
			;;
		enable)
			;;
		disable)
			;;
		help)
			;;
		profile)
			;;
		search)
			;;
		preview)
			;;
		update)
			;;
		migrate)
			;;
		version)
			;;
		restart)
			;;
		reload)
			;;
		*)
			;;
	esac
}
