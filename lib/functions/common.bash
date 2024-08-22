#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# common.bash
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         common.bash
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# PREFLIGHT
####################################################################
# Configure the environment if it hasn't been done already
if ! declare -p ENV_DEFAULT >&2 /dev/null; then
	declare -x ENV_DEFAULT
	# Verify default environment file exists
	[ -f "$HOME/.dotfiles/cfg/.env.dist" ] || { echo "ERROR :: Cannot find default environment variables"; exit 1; }
	ENV_DEFAULT="$HOME/.dotfiles/cfg/.env.dist"
	# Get Environment Variables
	source "$ENV_DEFAULT"
	# Look for custom environment file and include it if it's there
	[ -f "$HOME/.env" ] && source "$HOME/.env"
	# Add critical paths to $PATH
	PATH="$BIN_DIR:$PATH"
fi
# Import the most used libraries
dotImport "$FUNC_DIR/terminal.bash" "$FUNC_DIR/files.bash"
####################################################################
# COMMON FUNCTIONS
####################################################################
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
	local i

	(($# == 0)) && return

	[[ "$(declare -p "$1" 2> /dev/null)" != "declare -[aA]*" ]] && errorExit "'$1' not an array"

	local -n TOOLS=("$@")
	for i in "${!TOOLS[@]}"
	do
		! command -v "${TOOLS[$i]}" &> /dev/null && errorExit "Command '${TOOLS[$i]}' not found"
	done
}
# ------------------------------------------------------------------
# checkDir
# ------------------------------------------------------------------
checkDir() { [[ "$PWD" != "$HOME" ]] && errorExit "This script must be executed from within your '$HOME' directory"; }
# ------------------------------------------------------------------
# checkRoot
# ------------------------------------------------------------------
checkRoot() { [[ "$(id -u)" -ne 0 ]] && errorExit "This script MUST be run with root privileges"; }
