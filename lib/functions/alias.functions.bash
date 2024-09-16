#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# alias.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         alias.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# ALIAS FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# alias::enable
# ------------------------------------------------------------------
alias::enable()
{
    group 'alias'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local alias="${1//[$'\t\n\r']}" source

	if [ -f "$CUSTOM/lib/aliases/$alias.aliases.bash" ]; then
	    source="$CUSTOM/lib/aliases/$alias.aliases.bash"
	else
	    source="$ALIASES/$alias.aliases.bash"
	fi

	[ -f "$source" ] || exitLog "Unable to find alias file '$source'"

	[ -f "$DOT_REG/aliases.enabled" ] || cp "$TEMPLATES/registry.tmpl" "$DOT_REG/aliases.enabled"

	if grep "$alias." "$DOT_REG/aliases.enabled"; then
	    log::debug "Alias '$alias' already enabled"
	    return 0
	fi

	echo "$source" >> "$DOT_REG/aliases.enabled"

	return 0
}
# ------------------------------------------------------------------
# alias::disable
# ------------------------------------------------------------------
alias::disable()
{
    group 'alias'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local alias="${1//[$'\t\n\r']}" source return

	sed "/*$alias\.*/d" "$DOT_REG/aliases.enabled"; return=$?

	return $return
}
