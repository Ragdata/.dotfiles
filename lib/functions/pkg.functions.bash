#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# pkgs.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         pkgs.functions
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
# PKG FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# pkg
# ------------------------------------------------------------------
# @description The function which provides access to all parts of an
#			   pkg management file.
#
# @arg $pkg		[string]	The name of the pkg file (no path)	(required)
#
# @options
#		-a | --auto			Runs checks and installs the package if not present
#		-e | --exists		Runs the $pkg::check function and returns the result
#		-c | --config		Runs the $pkg::config function and returns the result if function exists
#		-i | --install		Runs the $pkg::install function and returns the result
#		-R | --reinstall	Runs the $pkg::reinstall function and returns the result if function exists
#							- otherwise attempts to use apt-get directly
#		-r | --remove		Runs the $pkg::remove function and returns the result
#		-d | --download
#			::	Accepts an OPTIONAL argument - a destination directory for
#				the package once downloaded.  If the directory does not exist,
#				an attempt will be made to create it prior to download.
#					- If the pkg management file does not contain its own
#					  download function, the generic `apt-get` download will
#					  be used instead.
#		-s | --source
#			::	Accepts an OPTIONAL argument - a destination directory for
#				the package source once downloaded.  This option works in
#				exactly the same way as the 'download' option except that
#				it retrieves the source code of the package in question.
#
# @examples
#		- pkg -a
#		- pkg -e -i -c
#		- pkg -d="/download/path"
#		- pkg -d"/download/path"	(note, no space between option and argument)
#
# ------------------------------------------------------------------
pkg()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 2)) && exitLog "Missing Argument(s)"

	local pkg="${1//[$'\t\n\r']}" options

	shift

	options=$(getopt -l "auto,exists,config,install,reinstall,remove,download::,source::" -o "aeciRrd::s::" -a -- "$@")

	eval set --"$options"

	while true
	do
		case "$pkg" in
			-a | --auto)
				pkg::auto "$pkg"
				shift
				# If this option is chosen, we don't allow the function to loop
				break
				;;
			-e | --exists)
				pkg::check "$pkg"
				shift
				;;
			-c | --config)
				pkg::config "$pkg"
				shift
				;;
			-i | --install)
				pkg::install "$pkg"
				shift
				;;
			-R | --reinstall)
				pkg::reinstall "$pkg"
				shift
				;;
			-r | --remove)
				pkg::remove "$pkg"
				shift
				;;
			-d | --download)
				if [[ -z "$optarg" ]]; then pkg::download "$pkg"; shift; else pkg::download "$pkg" "$optarg"; shift 2; fi
				;;
			-s | --source)
				if [[ -z "$optarg" ]]; then pkg::download "$pkg"; shift; else pkg::download "$pkg" "$optarg"; shift 2; fi
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
# pkg::addRepo
# ------------------------------------------------------------------
pkg::addRepo()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local repo="${1//[$'\t\n\r']}" result

	echoDot "Adding repository '$repo': " -s "✚" -n
	sudo add-apt-repository -y "$repo" &> /dev/null; result=$?

	if [[ "$result" -eq 0 ]]; then
		log::info "Repository '$repo' added successfully"
		echoAlias "OK" -c "${LT_GREEN}"
	else
		log::error "Failed to add repository '$repo'"
		echoAlias "FAILED!" -c "${RED}"
	fi
}
# ------------------------------------------------------------------
# pkg::auto
# ------------------------------------------------------------------
pkg::auto()
{
    group 'pkg'

	(($# < 1)) && errorExit "No packages requested for processing"

	local pkg="${1//[$'\t\n\r']}"

	pkg::check "$pkg" && return 0

	pkg::install "$pkg" || return 1

	pkg::config "$pkg" && return 0

	return 1
}
# ------------------------------------------------------------------
# pkg::bundle
# ------------------------------------------------------------------
pkg::bundle()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

    local bundle="${1//[$'\t\n\r']}"
    local path="$PKGS/bundles"

    [ -f "$path/$bundle.list" ] || exitLog "Cannot find bundle file '$path/$bundle.list'"

    pkg::installList "$bundle" "$PKGS/bundles"
}
# ------------------------------------------------------------------
# pkg::check
# ------------------------------------------------------------------
pkg::check()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local pkg="${1//[$'\t\n\r']}" func result

	if [ -f "$PKGS/$pkg" ]; then
		dot::include "$PKGS/$pkg"
		func="$pkg::check"
		[[ $(type -t "$func") == "function" ]] || return 0
		eval "$func"; result=$?; return "$result"
	else
		# perform a generic test if there's no pkg file available
		if command -v "$pkg" &> /dev/null; then return 0; else return 1; fi
	fi
}
# ------------------------------------------------------------------
# pkg::config
# ------------------------------------------------------------------
pkg::config()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local pkg="${1//[$'\t\n\r']}" func result

	if [ -f "$PKGS/$pkg" ]; then
		dot::include "$PKGS/$pkg"
		func="$pkg::config"
		[[ $(type -t "$func") == "function" ]] || return 0
		echoDot "Configuring '$pkg' - " -s "•" -n
		eval "$func"; result=$?

		if [[ "$result" -eq 0 ]]; then
			log::info "Package '$pkg' configured successfully"
			echoAlias "OK" -c "${LT_GREEN}"
		else
			log::error "Failed to configure package '$pkg'"
			echoAlias "FAILED!" -c "${RED}"
		fi

		func="$pkg::post_config"
		[[ $(type -t "$func") == "function" ]] || return 0
		eval "$func"
	fi
	# no penalty for not having a config function
	return 0
}
# ------------------------------------------------------------------
# pkg::download
# ------------------------------------------------------------------
pkg::download()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local pkg="${1//[$'\t\n\r']}" tested=0 func result dir

	if [[ -n "$2" ]]; then
		dir="$2"; [[ "${dir:0:1}" == "=" ]] && dir="${dir:1}"
		if [[ ! -d "$dir" ]]; then
			mkdir -p "$dir" || exitLog "Unable to create directory '$dir'"
		fi
		cd "$dir" || exitLog "Unable to switch to directory '$dir'"
	fi

	if [ -f "$PKGS/$pkg" ]; then
		dot::include "$PKGS/$pkg"
		func="$pkg::download"
		if [[ $(type -t "$func") == "function" ]]; then
			echoDot "Downloading '$pkg' - " -s "⮟" -n
			eval "$func"; result=$?; tested=1
		fi
	fi

	if ((tested == 0)); then
		echoDot "Downloading '$pkg' - " -s "⮟" -n
		sudo apt-get -qq -y download "$pkg" &> /dev/null; result=$?
	fi

	if [[ "$result" -eq 0 ]]; then
		log::info "Package '$pkg' downloaded successfully"
		echoAlias "OK" -c "${LT_GREEN}"
	else
		log::error "Failed to download package '$pkg'"
		echoAlias "FAILED!" -c "${RED}"
	fi

	if [[ -n "$dir" ]]; then cd - || exitLog "Unable to return to previous directory"; fi
}
# ------------------------------------------------------------------
# pkg::findPkg
# ------------------------------------------------------------------
pkg::findPkg()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	sudo apt-cache search "${1//[$'\t\n\r']}"
}
# ------------------------------------------------------------------
# pkg::install
# ------------------------------------------------------------------
pkg::install()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local pkg="${1//[$'\t\n\r']}" tested=0 func result

	if [ -f "$PKGS/$pkg" ]; then
		dot::include "$PKGS/$pkg"
		func="$pkg::install"
		if [[ $(type -t "$func") == "function" ]]; then
			echoDot "Installing '$pkg' - " -s "✚" -n
			eval "$func"; result=$?; tested=1
		fi
	fi

	if ((tested == 0)); then
		echoDot "Installing '$pkg' - " -s "✚" -n
		sudo apt-get -qq -y install "$pkg" &> /dev/null; result=$?
	fi

    if [ "$result" -eq 0 ]; then
        log::info "Package '$pkg' installed successfully"
        echoAlias "OK" -c "${LT_GREEN}"
        sudo apt-get -qq -y clean &> /dev/null && sudo apt-get -qq -y autoremove &> /dev/null
    else
        log::error "Failed to install package '$pkg'"
        echoAlias "FAILED!" -c "${RED}"
    fi

	func="$pkg::post_install"
	if [[ $(type -t "$func") == "function" ]]; then eval "$func"; fi

	pkg::config "$pkg"
}
# ------------------------------------------------------------------
# pkg::installList
# ------------------------------------------------------------------
pkg::installList()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local name="$1"
	local path="${2:-"$DOT_CFG/data"}"
	declare -a packages

	[ -f "$path/$name.list" ] || exitLog "Cannot find list file '$path/$name.list'"

	readarray packages < "$path/$name.list"

	pkgInstall "${packages[@]}"
}
# ------------------------------------------------------------------
# pkg::listPkg
# ------------------------------------------------------------------
pkg::listPkg()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local cmd

	case "$1" in
		-a | --available | available)
			cmd="sudo apt-cache search ."
			;;
		-i | --installed | installed)
			cmd="sudo apt list --installed"
			;;
		*)	exitLog "Invalid Argument!"
			;;
	esac

	if [[ -n "$2" ]]; then
		eval "$cmd" | grep "$2"
	else
		eval "$cmd"
	fi
}
# ------------------------------------------------------------------
# pkg::remove
# ------------------------------------------------------------------
pkg::remove()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local pkg="${1//[$'\t\n\r']}" tested=0 func result

	if [ -f "$PKGS/$pkg" ]; then
		dot::include "$PKGS/$pkg"
		func="$pkg::remove"
		if [[ $(type -t "$func") == "function" ]]; then
			echoDot "Removing '$pkg' - " -s "🞮" -n
			eval "$func"; result=$?; tested=1
		fi
	fi

	if ((tested == 0)); then
		echoDot "Removing '$pkg' - " -s "🞮" -n
		sudo apt-get -qq -y purge "$pkg" &> /dev/null; result=$?
	fi

    if [ "$result" -eq 0 ]; then
        log::info "Package '$pkg' removed successfully"
        echoAlias "OK" -c "${LT_GREEN}"
        sudo apt-get -qq -y clean &> /dev/null && sudo apt-get -qq -y autoremove &> /dev/null
    elif [ "$result" -eq 100 ]; then
        log::debug "Package '$pkg' not found for removal"
        echoAlias "NOT FOUND" -c "${LT_GREEN}"
    else
        log::error "Failed to remove package '$pkg'"
        echoAlias "FAILED!" -c "${RED}"
    fi

	func="$pkg::post_remove"
	[[ $(type -t "$func") == "function" ]] || return 0
	eval "$func"
}
# ------------------------------------------------------------------
# pkg::removeList
# ------------------------------------------------------------------
pkg::removeList()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local name="$1"
	local path="${2:-"$DOT_CFG/data"}"
	declare -a packages

	[ -f "$path/$name.list" ] || exitLog "Cannot find list file '$path/$name.list'"

	readarray packages < "$path/$name.list"

	pkgRemove "${packages[@]}"
}
# ------------------------------------------------------------------
# pkg::repair
# ------------------------------------------------------------------
pkg::repair() { group 'pkg'; sudo apt-get -qq -y check; return $?; }
# ------------------------------------------------------------------
# pkg::showPkg
# ------------------------------------------------------------------
pkg::showPkg()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "cowardly refusing to show nothing!"

	sudo apt-cache show "${1//[$'\t\n\r']}"
}
# ------------------------------------------------------------------
# pkg::source
# ------------------------------------------------------------------
pkg::source()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local pkg="${1//[$'\t\n\r']}" tested=0 func result dir

	if [[ -n "$2" ]]; then
		dir="$2"; [[ "${dir:0:1}" == "=" ]] && dir="${dir:1}"
		if [[ ! -d "$dir" ]]; then
			mkdir -p "$dir" || exitLog "Unable to create directory '$dir'"
		fi
		cd "$dir" || exitLog "Unable to switch to directory '$dir'"
	fi

	if [ -f "$PKGS/$pkg" ]; then
		dot::include "$PKGS/$pkg"
		func="$pkg::source"
		if [[ $(type -t "$func") == "function" ]]; then
			echoDot "Downloading '$pkg' source - " -s "⮟" -n
			eval "$func"; result=$?; tested=1
		fi
	fi

	if ((tested == 0)); then
		echoDot "Downloading '$pkg' source - " -s "⮟" -n
		sudo apt-get -qq -y download "$pkg" &> /dev/null; result=$?
	fi

	if [[ "$result" -eq 0 ]]; then
		log::info "Package '$pkg' sourced successfully"
		echoAlias "OK" -c "${LT_GREEN}"
	else
		log::error "Failed to source package '$pkg'"
		echoAlias "FAILED!" -c "${RED}"
	fi

	if [[ -n "$dir" ]]; then cd - || exitLog "Unable to return to previous directory"; fi
}
# ------------------------------------------------------------------
# pkg::update
# ------------------------------------------------------------------
pkg::update() { group 'pkg'; sudo apt-get -qq -y update; return $?; }
# ------------------------------------------------------------------
# pkg::upgrade
# ------------------------------------------------------------------
pkg::upgrade() { group 'pkg'; sudo apt-get -qq -y update && sudo apt-get -qq -y full-upgrade; return $?; }

####################################################################
# BULK HANDLERS
####################################################################
# ------------------------------------------------------------------
# pkgAddRepos
# ------------------------------------------------------------------
pkgAddRepos()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local repo result

	if ! command -v add-apt-repository &> /dev/null; then
		echoDot "Installing package 'software-properties-common' - " -s "✚" -n
		sudo apt-get -qq -y install software-properties-common; result=$?
		if [ "$result" -eq 0 ]; then
			log::info "Package installed successfully"
			echoAlias "OK" -c "${LT_GREEN}"
		else
			log::error "Package 'software-properties-common' failed to install"
			echoAlias "FAILED!" -c "${RED}"
		fi
	fi

	for repo in "$@"
	do
		[[ "${repo:0:1}" != "#" && -n "$repo" ]] && pkg::addRepo "$repo"
	done
}
# ------------------------------------------------------------------
# pkgInstall
# ------------------------------------------------------------------
pkgInstall()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local pkg

	for pkg in "$@"
	do
		[[ "${pkg:0:1}" != "#" && -n "$pkg" ]] && pkg::install "$pkg"
	done
}
# ------------------------------------------------------------------
# pkgRemove
# ------------------------------------------------------------------
pkgRemove()
{
    group 'pkg'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local pkg

	for pkg in "$@"
	do
		[[ "${pkg:0:1}" != "#" && -n "$pkg" ]] && pkg::remove "$pkg"
	done
}
