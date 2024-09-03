#!/usr/bin/env bash
####################################################################
# .bash_functions
####################################################################
# Ragdata's Dotfiles - Dotfile Master
#
# File:         .bash_functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:		https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# COMMON FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# checkBash
# ------------------------------------------------------------------
checkBash() { group 'bash_functions'; if [[ "${BASH_VERSION:0:1}" -lt 4 ]]; then errorExit "This script requires a minimum Bash version of 4+"; fi }
####################################################################
# ARRAY FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# arr::contains
# ------------------------------------------------------------------
arr::contains()
{
	group 'bash_functions'

	local e val="$1"

	shift

	for e; do [[ "$e" == "$val" ]] && return 0; done

	return 1
}
####################################################################
# DOT FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# dot::source
# ------------------------------------------------------------------
dot::source()
{
	group 'bash_functions'

	(($# > 0)) || errorExit "Missing Arguments"

	[ -f "$1" ] || errorExit "File '$1' not found"

	if arr::contains "$1" "${IMPORTS[@]}"; then
		return 0
	else
		IMPORTS+=("$1")
		# shellcheck disable=SC1090
		source "$1" || return 1
	fi

	return 0
}
# ------------------------------------------------------------------
# dot::include
# ------------------------------------------------------------------
dot::include()
{
	group 'bash_functions'

	(($# > 0)) || errorExit "Missing Arguments"

	local -a ARR
	local path

	for item in "$@"
	do
		ARR=()
		path=""
		stub=""
		if [ -f "$item" ]; then
			path="$item"
		elif [ -f "$PKGS/$item" ]; then
			path="$PKGS/$item"
		elif [[ "$item" == *"."* ]]; then
			mapfile -d "." -t ARR < <(printf '%s' "$item")
		else
			errorExit "Unrecognised item '$item'"
		fi
		if [ "${#ARR[@]}" -gt 0 ]; then
			case "${ARR[1]}" in
				alias|aliases)
					stub="aliases/$item.bash"
					;;
				completion|completions)
					stub="completions/$item.bash"
					;;
				custom)
					path="$CUSTOM/$item.bash"
					;;
				function|functions)
					stub="functions/$item.bash"
					;;
				help)
					stub="help/$item.bash"
					;;
				plugin|plugins)
					stub="plugins/$item.bash"
					;;
				*)	errorExit "Type '${ARR[1]}' not supported";;
			esac
		fi
		if [ -n "$stub" ]; then
			if [ -f "$CUSTOM/$stub" ]; then
				path="$CUSTOM/$stub"
			elif [ -f "$DOT_LIB/$stub" ]; then
				path="$DOT_LIB/$stub"
			else
				errorExit "No match for '$stub'"
			fi
		fi
		if [ -f "$path" ]; then
			dot::source "$path"
		else
			errorExit "File '$path' not found"
		fi
	done
}
####################################################################
# ERROR FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# errorHandler
# ------------------------------------------------------------------
errorHandler()
{
	group 'bash_functions'

	local -n lineNo="${1:-LINENO}"
	local -n bashLineNo="${2:-BASH_LINENO}"
	local lastCommand="${3:-BASH_COMMAND}"
	local code="${4:-0}"

	local -a OUTARR=()
	local lastCommandHeight

	[ "$code" -eq 0 ] && return 0

	lastCommandHeight="$(wc -l <<< "${lastCommand}")"

	OUTARR+=(
		"Code: ${code}"
		"Line: ${lineNo}"
		"Function: ${FUNCNAME[1]}"
		"Line History: [${bashLineNo[*]}]"
		"Function Trace: [${FUNCNAME[*]}]")

	if [ "${#BASH_SOURCE[@]}" -gt 1 ]; then
		OUTARR+=("Source Trace:")
		for item in "${BASH_SOURCE[@]}"
		do
			OUTARRAY+=(" - ${item}")
		done
	else
		OUTARR+=("Source Trace: [${BASH_SOURCE[*]}]")
	fi

	if [ "$lastCommandHeight" -gt 1 ]; then
		OUTARR+=("Last Command -> " "${lastCommand}")
	else
		OUTARR+=("Last Command: ${lastCommand}")
	fi

	printf -- '%s\n' "${OUTARR[@]}" >&2

	exit "$code"
}
# ------------------------------------------------------------------
# errorExit
# ------------------------------------------------------------------
errorExit()
{
	group 'bash_functions'

	local msg="ERROR :: " code="${2:-1}"

	[[ -n "${FUNCNAME[1]}" ]] && msg+="${FUNCNAME[1]} - "
	[[ -n "$1" ]] && msg+="$1"

	echoError "$msg"
	exit "$code"
}
