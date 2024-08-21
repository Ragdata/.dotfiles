#!/usr/bin/env bash
####################################################################
# install.bash
####################################################################
# Ragdata's Dotfiles - Dotfile Master
#
# File:         install.bash
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# PREFLIGHT
####################################################################

####################################################################
# INITIALIZE
####################################################################
declare -x TERM_ESC TERM_CSI RED BLUE GREEN GOLD WHITE RESET
declare -x SYMBOL_ERROR SYMBOL_WARNING SYMBOL_INFO SYMBOL_SUCCESS
#
# TERMINAL VARIABLES
#
TERM_ESC=$'\033'
TERM_CSI="${TERM_ESC}["
# COLORS
RED="$(printf '%s31m' "$TERM_CSI")"
BLUE="$(printf '%s94m' "$TERM_CSI")"
GREEN="$(printf '%s32m' "$TERM_CSI")"
GOLD="$(printf '%s33m' "$TERM_CSI")"
WHITE="$(printf '%s97m' "$TERM_CSI")"
RESET="$(printf '%s0m' "$TERM_CSI")"
#  SYMBOLS
SYMBOL_ERROR="[!]"
SYMBOL_WARNING="[-]"
SYMBOL_INFO="[i]"
SYMBOL_SUCCESS="[+]"
#
# ADDITIONAL VARIABLES
#
USAGE="
====================================================================
USAGE: dot::install [OPTIONS] <args>
====================================================================
"
####################################################################
# FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# echoAlias
# ------------------------------------------------------------------
if ! command -v echoAlias &> /dev/null; then
	echoAlias()
	{
		local msg="${1:-}" options
		local COLOR OUTPUT PREFIX SUFFIX STREAM=1 _0=""
		local -a OUTARGS

		[[ -z "$msg" ]] && { echo -e "${RED}${SYMBOL_ERROR} ERROR :: echoAlias requires an argument${RESET}"; exit 1; }

		shift

		options=$(getopt -l "color:,prefix:,suffix:,noline" -o "c:p:s:n" -a -- "$@")

		eval set --"$options"

		while true
		do
			case "$1" in
				-c | --color)
					COLOR="$2"
					shift 2
					;;
				-p | --prefix)
					PREFIX="$2"
					shift 2
					;;
				-s | --suffix)
					SUFFIX="$2"
					shift 2
					;;
				-n | noline)
					OUTARGS+=("-n")
					shift
					;;
				--)
					shift
					break
					;;
				*)
					echo -e "${RED}${SYMBOL_ERROR} ERROR :: echoAlias - Invalid Argument '$1'${RESET}"
					exit 1
					;;
			esac
		done

		[[ -n "$COLOR" ]] && _0="${RESET}"

		OUTPUT="${COLOR}${PREFIX}${msg}${SUFFIX}${_0}"

		if [[ "$STREAM" -eq 2 ]]; then
			echo -e "${OUTARGS[@]}" "${OUTPUT}" >&2
		else
			echo -e "${OUTARGS[@]}" "$OUTPUT"
		fi
	}
fi
# ------------------------------------------------------------------
# COLOR ALIASES
# ------------------------------------------------------------------
! command -v echoRed &> /dev/null && echoRed() { echoAlias "$1" -c "${RED}" "${@:2}"; }
! command -v echoBlue &> /dev/null && echoBlue() { echoAlias "$1" -c "${BLUE}" "${@:2}"; }
! command -v echoGreen &> /dev/null && echoGreen() { echoAlias "$1" -c "${GREEN}" "${@:2}"; }
! command -v echoGold &> /dev/null && echoGold() { echoAlias "$1" -c "${GOLD}" "${@:2}"; }
! command -v echoWhite &> /dev/null && echoWhite() { echoAlias "$1" -c "${WHITE}" "${@:2}"; }
# ------------------------------------------------------------------
# MESSAGE ALIASES
# ------------------------------------------------------------------
! command -v echoError &> /dev/null && echoError() { echoAlias "$SYMBOL_ERROR $1" -c "${RED}" "${@:2}"; }
! command -v echoWarning &> /dev/null && echoWarning() { echoAlias "$SYMBOL_WARNING $1" -c "${GOLD}" "${@:2}"; }
! command -v echoInfo &> /dev/null && echoInfo() { echoAlias "$SYMBOL_INFO $1" -c "${BLUE}" "${@:2}"; }
! command -v echoSuccess &> /dev/null && echoSuccess() { echoAlias "$SYMBOL_SUCCESS $1" -c "${GREEN}" "${@:2}"; }
# ------------------------------------------------------------------
# FILTERS
# ------------------------------------------------------------------
! command -v scriptPath &> /dev/null && scriptPath() { printf '%s' "$(realpath "${BASH_SOURCE[0]}")"; }
! command -v scriptDir &> /dev/null && scriptDir() { printf '%s' "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"; }
####################################################################
# MAIN
####################################################################

