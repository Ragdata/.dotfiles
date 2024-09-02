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
# PREFLIGHT
####################################################################
[[ -z ${_PKG_FUNCTIONS+x} ]] && declare -gx _PKG_FUNCTIONS
[[ "$_PKG_FUNCTIONS" -eq 1 ]] && return 0; _PKG_FUNCTIONS=1;
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
	(($# < 2)) && errorExit "No package requested for installation"

	local pkg="$1" options

	shift

	options=$(getopt -l "auto,exists,config,install,reinstall,remove,download::,source::" -o "aeciRrd::s::" -a -- "$@")

	eval set --"$options"

	while true
	do
		case "$1" in
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
# pkg::auto
# ------------------------------------------------------------------
pkg::auto()
{
	(($# < 1)) && errorExit "No packages requested for processing"

	local pkg="$1"

	pkg::check "$pkg" && return 0

	pkg::install "$pkg" || return 1

	pkg::config "$pkg" && return 0

	return 1
}
# ------------------------------------------------------------------
# pkg::check
# ------------------------------------------------------------------
pkg::check()
{
	(($# < 1)) && errorExit "No packages requested for processing"

	local pkg="$1" func result

	if [ -f "$PKGS/$pkg" ]; then
		# Import the pkg file if one exists
		if dotInclude "$PKGS/$pkg"; then
			func="$pkg::check"
			[[ $(type -t "$func") == "function" ]] || errorExit "'$func' is not a function"
			eval "$func"; result=$?; return "$result"
		else
			errorExit "Unable to import pkg file '$PKGS/$pkg'"
		fi
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
	(($# < 1)) && errorExit "No packages requested for processing"

	local pkg="$1" func result

	if [ -f "$PKGS/$pkg" ]; then
		# Import the pkg file if one exists
		if dotInclude "$PKGS/$pkg"; then
			func="$pkg::config"
			if [[ $(type -t "$func") == "function" ]]; then
				eval "$func"; result=$?; return "$result"
			fi
		else
			errorExit "Unable to import pkg file '$PKGS/$pkg'"
		fi
	fi
	# no penalty for not having a config function
	return 0
}
# ------------------------------------------------------------------
# pkg::download
# ------------------------------------------------------------------
pkg::download()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local pkg="$1" tested=0 func result dir

	if [[ -n "$2" ]]; then
		dir="$2"; [[ "${dir:0:1}" == "=" ]] && dir="${dir:1}"
		if [[ ! -d "$dir" ]]; then
			mkdir -p "$dir" || errorExit "Unable to create directory '$dir'"
		fi
		cd "$dir" || errorExit "Unable to switch to directory '$dir'"
	fi

	echoInfo "Downloading '$pkg': " -n

	if [ -f "$PKGS/$pkg" ]; then
		# Import the pkg file if one exists
		if dotInclude "$PKGS/$pkg"; then
			func="$pkg::download"
			if [[ $(type -t "$func") == "function" ]]; then
				eval "$func"; result=$?; tested=1
			fi
		fi
	fi

	if ((tested == 0)); then sudo apt-get -qq -y download "$pkg"; result=$?; fi

	if [[ "$result" -eq 0 ]]; then echoSuccess "SUCCESS!"; else echoWarning "FAILED!"; fi

	if [[ -n "$dir" ]]; then cd - || errorExit "Unable to return to previous directory"; fi

	return $result
}
# ------------------------------------------------------------------
# pkg::findPkg
# ------------------------------------------------------------------
pkg::findPkg()
{
	(($# < 1)) && errorExit "pkg::findPkg - cowardly refusing to search for nothing!"

	sudo apt-cache search "$1"
}
# ------------------------------------------------------------------
# pkg::install
# ------------------------------------------------------------------
pkg::install()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local pkg="$1" tested=0 func result

	echoInfo "Installing '$pkg': " -n

	if [ -f "$PKGS/$pkg" ]; then
		# Import the pkg file if one exists
		if dotInclude "$PKGS/$pkg"; then
			func="$pkg::install"
			if [[ $(type -t "$func") == "function" ]]; then
				eval "$func"; result=$?; tested=1
			fi
		fi
	fi

	if ((tested == 0)); then sudo apt-get -qq -y install "$pkg"; result=$?; fi

	if [[ "$result" -eq 0 ]]; then echoSuccess "SUCCESS!"; else echoWarning "FAILED!"; fi

	echoInfo "Running garbage collection"

	sudo apt-get -qq -y clean && sudo apt-get -qq -y autoremove

	return $result
}
# ------------------------------------------------------------------
# pkg::installList
# ------------------------------------------------------------------
pkg::installList()
{
	(($# < 1)) && errorExit "Missing Argument!"

	local name="$1"
	local path="${2:-"$DOT_CFG/data"}"
	declare -a packages

	[ -f "$path/$name.list" ] || errorExit "Cannot find list file '$path/$name.list'"

	readarray packages < "$path/$name.list"

	pkgInstall "${packages[@]}"
}
# ------------------------------------------------------------------
# pkg::listPkg
# ------------------------------------------------------------------
pkg::listPkg()
{
	(($# < 1)) && errorExit "pkg::listPkg - Missing Argument!"

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
# ------------------------------------------------------------------
# pkg::reinstall
# ------------------------------------------------------------------
pkg::reinstall()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local pkg="$1" tested=0 func result

	echoInfo "Reinstalling '$pkg': " -n

	if [ -f "$PKGS/$pkg" ]; then
		# Import the pkg file if one exists
		if dotInclude "$PKGS/$pkg"; then
			func="$pkg::reinstall"
			if [[ $(type -t "$func") == "function" ]]; then
				eval "$func"; result=$?; tested=1
			fi
		fi
	fi

	if ((tested == 0)); then sudo apt-get -qq -y reinstall "$pkg"; result=$?; fi

	if [[ "$result" -eq 0 ]]; then echoSuccess "SUCCESS!"; else echoWarning "FAILED!"; fi

	echoInfo "Running garbage collection"

	sudo apt-get -qq -y clean && sudo apt-get -qq -y autoremove

	return $result
}
# ------------------------------------------------------------------
# pkg::remove
# ------------------------------------------------------------------
pkg::remove()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local pkg="$1" tested=0 func result

	echoInfo "Removing '$pkg': " -n

	if [ -f "$PKGS/$pkg" ]; then
		# Import the pkg file if one exists
		if dotInclude "$PKGS/$pkg"; then
			func="$pkg::remove"
			if [[ $(type -t "$func") == "function" ]]; then
				eval "$func"; result=$?; tested=1
			fi
		fi
	fi

	if ((tested == 0)); then sudo apt-get -qq -y purge "$pkg"; result=$?; fi

	if [[ "$result" -eq 0 ]]; then echoSuccess "SUCCESS!"; else echoWarning "FAILED!"; fi

	echoInfo "Running garbage collection"

	sudo apt-get -qq -y clean && sudo apt-get -qq -y autoremove

	return $result
}
# ------------------------------------------------------------------
# pkg::remove
# ------------------------------------------------------------------
pkg::repair() { sudo apt-get -qq -y check; return $?; }
# ------------------------------------------------------------------
# pkg::showPkg
# ------------------------------------------------------------------
pkg::showPkg()
{
	(($# < 1)) && errorExit "pkg::showPkg - cowardly refusing to show nothing!"

	sudo apt-cache show "$1"
}
# ------------------------------------------------------------------
# pkg::source
# ------------------------------------------------------------------
pkg::source()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local pkg="$1" tested=0 func result dir

	if [[ -n "$2" ]]; then
		dir="$2"; [[ "${dir:0:1}" == "=" ]] && dir="${dir:1}"
		if [[ ! -d "$dir" ]]; then
			mkdir -p "$dir" || errorExit "Unable to create directory '$dir'"
		fi
		cd "$dir" || errorExit "Unable to switch to directory '$dir'"
	fi

	echoInfo "Downloading '$pkg' source: " -n

	if [ -f "$PKGS/$pkg" ]; then
		# Import the pkg file if one exists
		if dotInclude "$PKGS/$pkg"; then
			func="$pkg::source"
			if [[ $(type -t "$func") == "function" ]]; then
				eval "$func"; result=$?; tested=1
			fi
		fi
	fi

	if ((tested == 0)); then sudo apt-get -qq -y source "$pkg"; result=$?; fi

	if [[ "$result" -eq 0 ]]; then echoSuccess "SUCCESS!"; else echoWarning "FAILED!"; fi

	if [[ -n "$dir" ]]; then cd - || errorExit "Unable to return to previous directory"; fi

	return $result
}
# ------------------------------------------------------------------
# pkg::update
# ------------------------------------------------------------------
pkg::update() { sudo apt-get -qq -y update; return $?; }
# ------------------------------------------------------------------
# pkg::upgrade
# ------------------------------------------------------------------
pkg::upgrade() { sudo apt-get -qq -y update && sudo apt-get -qq -y upgrade; return $?; }

####################################################################
# BULK HANDLERS
####################################################################
# ------------------------------------------------------------------
# pkgInstall
# ------------------------------------------------------------------
pkgInstall()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local pkg

	for pkg in "$@"
	do
		pkg::install "$pkg"
	done
}
# ------------------------------------------------------------------
# pkgRemove
# ------------------------------------------------------------------
pkgRemove()
{
	(($# < 1)) && errorExit "No package requested for processing"

	local pkg

	for pkg in "$@"
	do
		pkg::remove "$pkg"
	done
}
