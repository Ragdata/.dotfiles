#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# completion.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         completion.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# COMPLETION FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# completion::enable
# ------------------------------------------------------------------
completion::enable()
{
    group 'completion'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local name="${1//[$'\t\n\r']}" source

	if [ -f "$CUSTOM/lib/completions/$name.completions.bash" ]; then
	    source="$CUSTOM/lib/completions/$name.completions.bash"
	else
	    source="$COMPLETIONS/$name.completions.bash"
	fi

	[ -f "$source" ] || exitLog "Unable to find completion file '$source'"

	[ -f "$DOT_REG/completions.enabled" ] || cp "$TEMPLATES/registry.tmpl" "$DOT_REG/completions.enabled"

	if grep -q "$name\.completions\.bash" "$DOT_REG/completions.enabled"; then
	    log::debug "Completion '$name' already enabled"
	else
	    echo "$source" >> "$DOT_REG/completions.enabled"
	fi

	return 0
}
# ------------------------------------------------------------------
# completion::disable
# ------------------------------------------------------------------
completion::disable()
{
    group 'completion'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local name="${1//[$'\t\n\r']}" source return

	sed "/*$name\.completions.bash/d" "$DOT_REG/completions.enabled"; return=$?

	return $return
}
# ------------------------------------------------------------------
# completion::describe
# ------------------------------------------------------------------
completion::describe()
{
    group 'completion'
}
####################################################################
# BULK HANDLERS
####################################################################
# ------------------------------------------------------------------
# completionEnable
# ------------------------------------------------------------------
completionEnable()
{
    about 'Enable a list of completion files'
    param '@:   list/array'
    usage 'completionEnable "dot" "general" "git"'
    group 'completion'

    debugLog "${FUNCNAME[0]}"

    (($# < 1)) && exitLog "Missing Argument(s)"

    local name

    for name in "$@"
    do
        [[ "${name:0:1}" != "#" && -n "$name" ]] && completion::enable "$name"
    done
}
# ------------------------------------------------------------------
# completionDisable
# ------------------------------------------------------------------
completionDisable()
{
    about 'Disable a list of completion files'
    param '@:   list/array'
    usage 'completionDisable "dot" "general" "git"'
    group 'completion'

    debugLog "${FUNCNAME[0]}"

    (($# < 1)) && exitLog "Missing Argument(s)"

    local name

    for name in "$@"
    do
        [[ "${name:0:1}" != "#" && -n "$name" ]] && completion::disable "$name"
    done
}
