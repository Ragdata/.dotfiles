#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# plugin.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         plugin.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# PLUGIN FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# plugin::enable
# ------------------------------------------------------------------
plugin::enable()
{
    group 'plugin'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local plugin="${1//[$'\t\n\r']}" func result

	[ -f "$PLUGINS/$plugin/$plugin.bash" ] || exitLog "Unable to find plugin '$plugin'"

	[ -d "$DOT_REG" ] || mkdir -p "$DOT_REG"
	[ -f "$DOT_REG/plugins.enabled" ] || cp "$TEMPLATES/registry.tmpl" "$DOT_REG/plugins.enabled"

	if grep "$plugin" "$DOT_REG/plugins.enabled"; then
	    log::debug "Plugin '$plugin' already enabled"
	    return 0
	fi

	source "$PLUGINS/$plugin/$plugin.bash"

	func="$plugin::enable"
}
# ------------------------------------------------------------------
# plugin::disable
# ------------------------------------------------------------------
