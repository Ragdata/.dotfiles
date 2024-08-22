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
#		-a | --auto			Runs checks and installs the package if not present
#		-e | --exists		Runs the $app::check function and returns the result
#		-c | --config		Runs the $app::config function and returns the result if function exists
#		-i | --install		Runs the $app::install function and returns the result
#		-R | --reinstall	Runs the $app::reinstall function and returns the result if function exists
#							- otherwise attempts to use apt-get directly
#		-r | --remove		Runs the $app::remove function and returns the result
#		-d | --download
#			::	Accepts an OPTIONAL argument - a destination directory for
#				the package once downloaded.  If the directory does not exist,
#				an attempt will be made to create it prior to download.
#					- If the app management file does not contain its own
#					  download function, the generic `apt-get` download will
#					  be used instead.
#		-s | --source
#			::	Accepts an OPTIONAL argument - a destination directory for
#				the package source once downloaded.  This option works in
#				exactly the same way as the 'download' option except that
#				it retrieves the source code of the package in question.
#
# @examples
#		- app -a
#		- app -e -i -c
#		- app -d="/download/path"
#		- app -d"/download/path"	(note, no space between option and argument)
#
# ------------------------------------------------------------------
app()
{
	(($# < 2)) && errorExit "No package requested for installation"

	local app="$1" options

	shift

	options=$(getopt -l "auto,exists,config,install,reinstall,remove,download::,source::" -o "aeciRrd::s::" -a -- "$@")

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
			-R | --reinstall)
				app::reinstall "$app"
				shift
				;;
			-r | --remove)
				app::remove "$app"
				shift
				;;
			-d | --download)
				if [[ -z "$optarg" ]]; then app::download "$app"; shift; else app::download "$app" "$optarg"; shift 2; fi
				;;
			-s | --source)
				if [[ -z "$optarg" ]]; then app::download "$app"; shift; else app::download "$app" "$optarg"; shift 2; fi
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

	return 0
}
# ------------------------------------------------------------------
# app::auto
# ------------------------------------------------------------------
app::auto()
{
	(($# < 1)) && errorExit "No packages requested for processing"

	local app="$1"

	app::check "$app" && return 0

	app::install "$app" || return 1

	app::config "$app" && return 0

	return 1
}
# ------------------------------------------------------------------
# app::check
# ------------------------------------------------------------------
app::check()
{
	(($# < 1)) && errorExit "No packages requested for processing"

	local app="$1" func result

	[[ -f "$APPS/$app" ]] || errorExit "App file '$APPS/$app' not found"

	dotImport "$APPS/$app" || errorExit "Unable to import app file '$APPS/$app'"

	func="$app::check"

	[[ $(type -t "$func") == "function" ]] || errorExit "'$func' is not a function"

	eval "$func"; result=$?

	return "$result"
}
# ------------------------------------------------------------------
# app::config
# ------------------------------------------------------------------
app::config()
{
	(($# < 1)) && errorExit "No packages requested for processing"

	local app="$1" func result

	[[ -f "$APPS/$app" ]] || errorExit "App file '$APPS/$app' not found"

	dotImport "$APPS/$app" || errorExit "Unable to import app file '$APPS/$app'"

	func="$app::config"

	if [[ $(type -t "$func") == "function" ]]; then
		eval "$func"; result=$?
		return "$result"
	fi
	# no penalty for not having a config function
	return 0
}
# ------------------------------------------------------------------
# app::install
# ------------------------------------------------------------------
app::install()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local app="$1" func result

	[[ -f "$APPS/$app" ]] || errorExit "App file '$APPS/$app' not found"

	dotImport "$APPS/$app" || errorExit "Unable to import app file '$APPS/$app'"

	echoInfo "Installing '$app': " -n

	func="$app::install"

	if [[ $(type -t "$func") == "function" ]]; then
		eval "$func"; result=$?
	else
		sudo apt-get -qq -y install "$app"; result=$?
	fi

	if [[ "$result" -eq 0 ]]; then echoSuccess "SUCCESS!"; else echoWarning "FAILED!"; fi

	echoInfo "Running garbage collection"

	sudo apt-get -qq -y clean && sudo apt-get -qq -y autoremove

	return $result
}
# ------------------------------------------------------------------
# app::reinstall
# ------------------------------------------------------------------
app::reinstall()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local app="$1" func result

	[[ -f "$APPS/$app" ]] || errorExit "App file '$APPS/$app' not found"

	dotImport "$APPS/$app" || errorExit "Unable to import app file '$APPS/$app'"

	echoInfo "Reinstalling '$app': " -n

	func="$app::reinstall"

	if [[ $(type -t "$func") == "function" ]]; then
		eval "$func"; result=$?
	else
		sudo apt-get -qq -y reinstall "$app"; result=$?
	fi

	if [[ "$result" -eq 0 ]]; then echoSuccess "SUCCESS!"; else echoWarning "FAILED!"; fi

	echoInfo "Running garbage collection"

	sudo apt-get -qq -y clean && sudo apt-get -qq -y autoremove

	return $result
}
# ------------------------------------------------------------------
# app::update
# ------------------------------------------------------------------
app::update() { sudo apt-get -qq -y update; return $?; }
# ------------------------------------------------------------------
# app::upgrade
# ------------------------------------------------------------------
app::upgrade() { sudo apt-get -qq -y update && sudo apt-get -qq -y upgrade; return $?; }
# ------------------------------------------------------------------
# app::remove
# ------------------------------------------------------------------
app::repair() { sudo apt-get -qq -y check; return $?; }
# ------------------------------------------------------------------
# app::remove
# ------------------------------------------------------------------
app::remove()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local app="$1" func result

	[[ -f "$APPS/$app" ]] || errorExit "App file '$APPS/$app' not found"

	dotImport "$APPS/$app" || errorExit "Unable to import app file '$APPS/$app'"

	echoInfo "Removing '$app': " -n

	func="$app::remove"

	if [[ $(type -t "$func") == "function" ]]; then
		eval "$func"; result=$?
	else
		sudo apt-get -qq -y purge "$app"; result=$?
	fi

	if [[ "$result" -eq 0 ]]; then echoSuccess "SUCCESS!"; else echoWarning "FAILED!"; fi

	echoInfo "Running garbage collection"

	sudo apt-get -qq -y clean && sudo apt-get -qq -y autoremove

	return $result
}
# ------------------------------------------------------------------
# app::download
# ------------------------------------------------------------------
app::download()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local app="$1" func result dir

	if [[ -n "$2" ]]; then
		dir="$2"; [[ "${dir:0:1}" == "=" ]] && dir="${dir:1}"
		if [[ ! -d "$dir" ]]; then
			mkdir -p "$dir" || errorExit "Unable to create directory '$dir'"
		fi
		cd "$dir" || errorExit "Unable to switch to directory '$dir'"
	fi

	echoInfo "Downloading '$app': " -n

	func="$app::download"

	if [[ $(type -t "$func") == "function" ]]; then
		eval "$func"; result=$?
	else
		sudo apt-get -qq -y download "$app"; result=$?
	fi

	if [[ "$result" -eq 0 ]]; then echoSuccess "SUCCESS!"; else echoWarning "FAILED!"; fi

	if [[ -n "$dir" ]]; then cd - || errorExit "Unable to return to previous directory"; fi

	return $result
}
# ------------------------------------------------------------------
# app::source
# ------------------------------------------------------------------
app::source()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local app="$1" func result dir

	if [[ -n "$2" ]]; then
		dir="$2"; [[ "${dir:0:1}" == "=" ]] && dir="${dir:1}"
		if [[ ! -d "$dir" ]]; then
			mkdir -p "$dir" || errorExit "Unable to create directory '$dir'"
		fi
		cd "$dir" || errorExit "Unable to switch to directory '$dir'"
	fi

	echoInfo "Downloading '$app' source: " -n

	func="$app::source"

	if [[ $(type -t "$func") == "function" ]]; then
		eval "$func"; result=$?
	else
		sudo apt-get -qq -y source "$app"; result=$?
	fi

	if [[ "$result" -eq 0 ]]; then echoSuccess "SUCCESS!"; else echoWarning "FAILED!"; fi

	if [[ -n "$dir" ]]; then cd - || errorExit "Unable to return to previous directory"; fi

	return $result
}
# ------------------------------------------------------------------
# app::addRepo
# ------------------------------------------------------------------
app::addRepo()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local repo result

	for repo in "$@"
	do
		echoInfo "Adding APT repository '$repo': " -n
		sudo add-apt-repository -qq -y "$repo"; result=$?
	done

	if [[ "$result" -eq 0 ]]; then echoSuccess "SUCCESS!"; else echoWarning "FAILED!"; fi

	return $result
}
# ------------------------------------------------------------------
# appInstall
# ------------------------------------------------------------------
appInstall()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local pkg

	for pkg in "$@"
	do
		app::install "$pkg"
	done
}
# ------------------------------------------------------------------
# appRemove
# ------------------------------------------------------------------
appRemove()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local pkg

	for pkg in "$@"
	do
		app::remove "$pkg"
	done
}
# ------------------------------------------------------------------
# app::findPkg
# ------------------------------------------------------------------
app::findPkg()
{
	(($# < 1)) && errorExit "app::findPkg - cowardly refusing to search for nothing!"

	sudo apt-cache search "$1"
}
# ------------------------------------------------------------------
# app::showPkg
# ------------------------------------------------------------------
app::showPkg()
{
	(($# < 1)) && errorExit "app::showPkg - cowardly refusing to show nothing!"

	sudo apt-cache show "$1"
}
# ------------------------------------------------------------------
# app::listPkg
# ------------------------------------------------------------------
app::listPkg()
{
	(($# < 1)) && errorExit "app::listPkg - Missing Argument!"

	local cmd

	case "$1" in
		-a | --available | available)
			cmd="sudo apt-cache search ."
			;;
		-i | --installed | installed)
			cmd="sudo apt list --installed"
			;;
		*)
			errorExit "Invalid Argument!"
			;;
	esac

	if [[ -n "$2" ]]; then
		eval "$cmd" | grep "$2"
	else
		eval "$cmd"
	fi
}
