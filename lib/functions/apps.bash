#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# apps.bash
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         apps.bash
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# APPS FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# app
# ------------------------------------------------------------------
# @description The function which provides access to all parts of an
#			   app management file.
#
# @arg $app		[string]	The name of the app file (no path)	(required)
#
# @options
#		-a | --auto
#		-e | --exists
#		-t | --test
#		-c | --config
#		-i | --install
#		-r | --remove
#		-d | --download
#			::	Accepts an OPTIONAL argument - a destination directory for
#				the package once downloaded.  If the directory does not exist,
#				an attempt will be made to create it prior to download.
#					- If the app management file does not contain its own
#					  download function, the generic `apt-get` download will
#					  be used instead.
#
#
#
# ------------------------------------------------------------------
app()
{
	(($# < 2)) && errorExit "No packages requested for installation"

	local app="$1" options

	shift

	options=$(getopt -l "auto,exists,test,config,install,remove,download::,source::" -o "aetcird::s::" -a -- "$@")

	eval set --"$options"

	while true
	do
		case "$1" in
			-a | --auto)
				app::auto "$app"
				shift
				# If this option is chosen, we don't allow the function to loop
				break
				;;
			-e | --exists)
				;;
			-t | --test)
				app::check "$app"
				shift
				;;
			-c | --config)
				app::config "$app"
				shift
				;;
			-i | --install)
				app::install "$app"
				shift
				;;
			-r | --remove)
				app::remove "$app"
				shift
				;;
			-d | --download)
				if [[ -n "$optarg" ]]; then
					[[ "${optarg:0:1}" == "=" ]] && optarg="${optarg:1}"
					if [[ ! -d "$optarg" ]]; then
						mkdir -p "$optarg" || errorExit "Unable to create directory '$optarg'"
					fi
					cd "$optarg" || errorExit "Unable to switch to directory '$optarg'"
				fi
				func="$app::download"
				if [[ $(type -t "$func") == "function" ]]; then
					$(eval "$func") || echoWarning "Failed to download '$app'"
				else
					sudo apt-get -qq download "$app" || echoWarning "Failed to download '$app'"
				fi
				if [[ -n "$optarg" ]]; then
					cd - || errorExit "Unable to return to previous directory"
					shift 2
				else
					shift
				fi
				;;
			-s | --source)
				;;
			--)
				shift
				break
				;;
			*)
				errorExit "Invalid Argument"
				;;
		esac
	done
}
# ------------------------------------------------------------------
# app::auto
# ------------------------------------------------------------------
app::auto()
{
	(($# < 1)) && errorExit "No packages requested for processing"

	local app="$1" func

	[[ -f "$APPS/$app" ]] || errorExit "App file '$APPS/$app' not found"

	dotImport "$APPS/$app" || errorExit "Unable to import app file '$APPS/$app'"

	func="$app::check"

	[[ $(type -t "$func") == "function" ]] || errorExit "'$func' is not a function"

	eval "$func"

#				func="$app::check"
#				[[ $(type -t "$func") == "function" ]] || errorExit "'$func' is not a function"
#				eval "$func"

}
# ------------------------------------------------------------------
# app::check
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# app::config
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# app::install
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# app::remove
# ------------------------------------------------------------------
















## ------------------------------------------------------------------
## appCheck
## ------------------------------------------------------------------
#appCheck()
#{
#	(($# == 0)) && errorExit "No packages requested for installation"
#
#	local app="$1" func
#
#	[[ -f "$APPS/$app" ]] || errorExit "App file '$APPS/$app' not found"
#
#	dotImport "$APPS/$app" || errorExit "Unable to import app file '$APPS/$app'"
#
#	func="$app::check"
#
#	[[ $(type -t "$func") == "function" ]] && eval "$func"
#}
## ------------------------------------------------------------------
## appInstall
## ------------------------------------------------------------------
#appInstall()
#{
#
#}
## ------------------------------------------------------------------
## appRemove
## ------------------------------------------------------------------
#appRemove()
#{
#
#}
## ------------------------------------------------------------------
## aptInstall
## ------------------------------------------------------------------
#aptInstall()
#{
#	(($# == 0)) && errorExit "No packages requested for installation"
#
#	local pkg
#
#	for pkg in "${@}"
#	do
#		apt::install "$pkg" || errorExit "Failed to install '$pkg'"
#	done
#
#	echoInfo "Running garbage collection"
#
#	sudo apt clean -qq -y && return 0
#
#	return 1
#}
## ------------------------------------------------------------------
## apt::install
## ------------------------------------------------------------------
#apt::install()
#{
#	(($# == 0)) && errorExit "No packages requested for installation"
#
#	local package
#
#	echoInfo "Installling package '$package'"
#
#	sudo apt install -qq -y "$package" && return 0
#
#	return 1
#}
## ------------------------------------------------------------------
## aptRemove
## ------------------------------------------------------------------
#aptRemove()
#{
#	(($# == 0)) && errorExit "No packages requested for removal"
#
#	local pkg
#
#	for pkg in "${@}"
#	do
#		apt::remove "$pkg" || errorExit "Failed to remove '$pkg'"
#	done
#
#	echoInfo "Running garbage collection"
#
#	sudo apt autoremove && sudo apt autoclean -qq -y && return 0
#
#	return 1
#}
## ------------------------------------------------------------------
## apt::remove
## ------------------------------------------------------------------
#apt::remove()
#{
#	(($# == 0)) && errorExit "No packages requested for removal"
#
#	local package
#
#	echoInfo "Removing package '$package'"
#
#	sudo apt purge -qq -y "$package" && return 0
#
#	return 1
#}
## ------------------------------------------------------------------
## apt::remove
## ------------------------------------------------------------------
