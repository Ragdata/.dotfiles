#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# common.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         common.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# PREFLIGHT
####################################################################
#dotInclude "$HOME/.dotfiles/cfg/.env.dist"
#dotInclude "terminal.functions" "files.functions"
####################################################################
# COMMON FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# echoReturn
# ------------------------------------------------------------------
echoReturn()
{
	local msg code="${2:-1}" type="${3:-warning}"

	[[ -n "${FUNCNAME[1]}" ]] && msg+=" ${FUNCNAME[1]} ::"
	[[ -n "$1" ]] && msg+=" $1"

	case "${type,,}" in
		success)
			echoSuccess "$msg"
			;;
		info)
			echoInfo "$msg"
			;;
		warning)
			echoWarning "$msg"
			;;
		error)
			echoError "$msg"
			;;
		none)
			echo "$msg"
			;;
	esac

	return "$code"
}
# ------------------------------------------------------------------
# errorExit
# ------------------------------------------------------------------
errorExit()
{
	local msg="ERROR :: " code="${2:-1}"

	[[ -n "${FUNCNAME[1]}" ]] && msg+=" ${FUNCNAME[1]} ::"
	[[ -n "$1" ]] && msg+=" $1"

	echoError "$msg"
	exit "$code"
}
# ------------------------------------------------------------------
# checkBash
# ------------------------------------------------------------------
checkBash() { if [[ "${BASH_VERSION:0:1}" -lt 4 ]]; then errorExit "This script requires a minimum Bash version of 4+"; fi }
# ------------------------------------------------------------------
# checkDeps
# ------------------------------------------------------------------
checkDeps()
{
	dotInclude "$FUNCTIONS/pkgs.bash" || errorExit "Unable to import library file '$FUNCTIONS/pkgs.bash'"

	local i

	(($# == 0)) && return

	[[ "$(declare -p "$1" 2> /dev/null)" != "declare -[aA]*" ]] && errorExit "'$1' not an array"

	local -n TOOLS=("$@")

	for i in "${!TOOLS[@]}"
	do
		pkg::check "${TOOLS[$i]}"
	done

	return 0
}
# ------------------------------------------------------------------
# checkDir
# ------------------------------------------------------------------
checkDir() { [[ "$PWD" != "$HOME" ]] && errorExit "This script must be executed from within your '$HOME' directory"; }
# ------------------------------------------------------------------
# checkImported
# ------------------------------------------------------------------
checkImported()
{
	local path="${1?}"

	[[ ${IMPORTS[*]} =~ (^|[[:space:]])${path}([[:space:]]|$) ]] && returns 1

	return 0
}
# ------------------------------------------------------------------
# checkRoot
# ------------------------------------------------------------------
checkRoot() { [[ "$(id -u)" -ne 0 ]] && errorExit "This script MUST be run with root privileges"; }
