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
#-------------------------------------------------------------------
# plugin::enable
#-------------------------------------------------------------------
plugin::enable()
{
    group 'plugin'

	log::debug "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local name="${1//[$'\t\n\r']}" source

	if [ -f "$CUSTOM/lib/plugins/$name/$name.bash" ]; then
	    source="$CUSTOM/lib/plugins/$name/$name.bash"
	else
	    source="$PLUGINS/$name/$name.bash"
	fi

	[ -f "$source" ] || exitLog "Unable to find plugin file '$source'"

	[ -f "$DOT_REG/plugins.enabled" ] || cp "$TEMPLATES/registry.tmpl" "$DOT_REG/plugins.enabled"

	if grep -q "$name" "$DOT_REG/plugins.enabled"; then
	    log::debug "Plugin '$name' already enabled"
	else
	    log::info "Plugin '$name' successfully enabled"
	    echo "$name" >> "$DOT_REG/plugins.enabled"
	fi

	return 0
}
#-------------------------------------------------------------------
# plugin::enable
#-------------------------------------------------------------------
plugin::enabled()
{
    group 'plugin'

	log::debug "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local name="${1//[$'\t\n\r']}"

    if grep -q "$name" "$DOT_REG/plugins.enabled" &> /dev/null; then
        return 0
    else
        return 1
    fi
}
#-------------------------------------------------------------------
# plugin::disable
#-------------------------------------------------------------------
plugin::disable()
{
    group 'plugin'

	log::debug "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local name="${1//[$'\t\n\r']}" source return

	sed "/$name/d" "$DOT_REG/plugins.enabled"; return=$?

    if [ $return -eq 0 ]; then
        log::info "Plugin '$name' successfully disabled"
    else
        log::error "Failed to disable plugin '$name'"
    fi

	return $return
}
#-------------------------------------------------------------------
# plugin::describe
#-------------------------------------------------------------------
plugin::describe()
{
    group 'plugin'
}
####################################################################
# BULK HANDLERS
####################################################################
#-------------------------------------------------------------------
# pluginEnable
# ------------------------------------------------------------------
pluginEnable()
{
    about 'Enable a list of plugins'
    param '@:   list/array'
    usage 'pluginEnable "label-manager" "git-subtree"'
    group 'plugin'

    log::debug "${FUNCNAME[0]}"

    (($# < 1)) && exitLog "Missing Argument(s)"

    local name

    for name in "$@"
    do
        [[ "${name:0:1}" != "#" && -n "$name" ]] && plugin::enable "$name"
    done
}
# ------------------------------------------------------------------
# pluginDisable
# ------------------------------------------------------------------
pluginDisable()
{
    about 'Disable a list of plugins'
    param '@:   list/array'
    usage 'pluginDisable "label-manager" "git-subtree"'
    group 'plugin'

    log::debug "${FUNCNAME[0]}"

    (($# < 1)) && exitLog "Missing Argument(s)"

    local name

    for name in "$@"
    do
        [[ "${name:0:1}" != "#" && -n "$name" ]] && plugin::disable "$name"
    done
}
