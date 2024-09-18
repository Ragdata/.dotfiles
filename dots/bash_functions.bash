#!/usr/bin/env bash
# shellcheck disable=SC2016
# ###################################################################
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
checkBash() { about 'Checks BASH version'; group 'bash_functions'; if [[ "${BASH_VERSION:0:1}" -lt 4 ]]; then errorExit "This script requires a minimum Bash version of 4+"; fi }
####################################################################
# ARRAY FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# arr::contains
# ------------------------------------------------------------------
arr::contains()
{
    about 'Determine if an array contains the specified value'
    param '1:   value'
    param '2:   array'
    usage 'arr::contains "needle" "${HAYSTACK[@]}"'
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
# dot::enabled
# ------------------------------------------------------------------
dot::enabled()
{
    group 'bash_functions'

    log::debug "${FUNCNAME[0]}"

    (($# < 1)) && exitLog "Missing Argument(s)"

    local fileID="${1:-}" type

    type="${fileID##*.}"

    if [ -f "$DOT_REG/$type.enabled" ]; then
        if grep -q "$fileID" "$DOT_REG/$type.enabled"; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}
# ------------------------------------------------------------------
# dot::include
# ------------------------------------------------------------------
dot::include()
{
    about 'Accepts one or more file identifiers which it resolves to a file path before calling dot::source'
    param '@    file_identifier (name.type|package_name|plugin_name)'
    usage 'dot::include "dotfiles.functions" "cockpit" "label-manager"'
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
				app)
					stub="$item/$item.bash"
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
					stub="plugins/$item/$item.bash"
					;;
				*)	errorExit "Type '${ARR[1]}' not supported";;
			esac
		fi
		if [ -n "$stub" ]; then
			if [ -f "$CUSTOM/$stub" ]; then
				path="$CUSTOM/$stub"
			elif [ -f "$DOT_LIB/$stub" ]; then
				path="$DOT_LIB/$stub"
			elif [ -f "$APPS/$stub" ]; then
				path="$APPS/$stub"
			elif [ -f "$HELP/$stub" ]; then
				path="$HELP/$stub"
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
# ------------------------------------------------------------------
# dot::reboot
# ------------------------------------------------------------------
dot::reboot()
{
    about 'Reboots the instance'
    usage 'dot::reboot'
    group 'bash_functions'

    sudo systemctl reboot
}
# ------------------------------------------------------------------
# dot::reboot::install
# ------------------------------------------------------------------
dot::reboot::install()
{
    about 'Sets a flag in .bashrc which automatically executes a command after rebooting the instance'
    usage 'dot::reboot::install'
    group 'bash_functions'

    if [ "$1" != "rebooted" ]; then
        echo "source \"$1\" rebooted" >> "$HOME/.bashrc"
        echo ""
        echo "Instance will reboot and then automatically continue processing"
        echo ""
        reboot
    else
        sed -i '$ d' "$HOME/.bashrc"
    fi
}
# ------------------------------------------------------------------
# dot::reload
# ------------------------------------------------------------------
dot::reload()
{
    about 'Reloads .bashrc'
    usage 'dot::reload'
    group 'bash_functions'

    source "$HOME/.bashrc"
}
# ------------------------------------------------------------------
# dot::restart
# ------------------------------------------------------------------
dot::restart()
{
    about 'Restarts the shell by fully reloading it'
    usage 'dot::restart'
    group 'bash_functions'

    #exec "${0#-}" --rcfile "$HOME/.bashrc"
    bash -i
}
# ------------------------------------------------------------------
# dot::source
# ------------------------------------------------------------------
dot::source()
{
    about 'Executes or includes the content of the specified file in the current shell.\nTracks inclusions to limit repeat calls.'
    param '1:   path'
    usage 'dot::source "$ALIASES/dot.aliases.bash"'
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
####################################################################
# ERROR FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# errorHandler
# ------------------------------------------------------------------
errorHandler()
{
    about 'Generic error handler providing trace info'
    param '1:   LINENO'
    param '2:   BASH_LINENO'
    param '3:   ${BASH_COMMAND}'
    param '4:   $?'
    usage 'trap '\''errorHandler "LINENO" "BASH_LINENO" "${BASH_COMMAND}" "$?"'\'' ERR'
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
    about 'Generic error message with exit status'
    param '1:   message'
    param '2:   code    [default=1]'
    usage 'errorExit "File not found"'
	group 'bash_functions'

	local msg="ERROR :: " code="${2:-1}"

	[[ -n "${FUNCNAME[1]}" ]] && msg+="${FUNCNAME[1]} - "
	[[ -n "$1" ]] && msg+="$1"

	echoError "$msg"
	exit "$code"
}
####################################################################
# IS FUNCTIONS
####################################################################
is::function()
{
    about 'Determine if the subject exists as a declared function'
    param '1:   name'
    usage 'is::function "ansible::install"'
    group 'bash_functions'

    local func="${1?}"

    if [[ $(type -t "$func") == "function" ]]; then
        return 0
    else
        return 1
    fi
}
####################################################################
# TEXT FUNCTIONS
####################################################################
text::center()
{
    about 'Center text in a column of fixed width'
    param '1:   text'
    param '2:   width'
    usage 'text::center "here" 8'
    group 'bash_functions'

    local text="${1?}" width="${2?}"

    printf -- '%*s' $(( (${#text} + width) / 2 )) "$text"
}
