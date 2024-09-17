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

	log::debug "${FUNCNAME[0]}"

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
	    log::info "Completion '$name' successfully enabled"
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

	log::debug "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local name="${1//[$'\t\n\r']}" source return

	sed "/.*$name\.completions\.bash/d" "$DOT_REG/completions.enabled"; return=$?

    if [ $return -eq 0 ]; then
        log::info "Completion '$name' successfully disabled"
    else
        log::error "Failed to disable completion '$name'"
    fi

	return $return
}
# ------------------------------------------------------------------
# completion::describe
# ------------------------------------------------------------------
completion::describe()
{
    group 'completion'

    log::debug "${FUNCNAME[0]}"

    local header file fileName fileID name enabled="" desc entry customFiles

    customFiles="$(find "$CUSTOM/lib/completions" -type f | wc -l)"

    clear

    echoYellow "Available Completions"
    echo ""
    header="$(printf -- '%-3s %-20s %s' " ★ " "FileID" "Description")"
    echoGold "$header"
    echoGold "line"

    if [ "$customFiles" -gt 0 ]; then

        echoGold "Custom Completions"
        echoGold "line"

        while IFS= read -r file
        do
            fileName="$(basename "$file")"
            if [ "$fileName" == ".template" ]; then continue; fi
            if grep -q "$fileName" "$COMPLETIONS"/*; then continue; fi
            fileID="${fileName%.*}"
            name="${fileName%%.*}"
            if dot::enabled "$fileID"; then enabled=" ${GOLD}★${_0} "; else enabled="   "; fi
            desc="$(metafor "about" < "$file")"
            entry="$(printf -- '%-3s %-20s %s' "$enabled" "$fileID" "$desc")"
            echoLtGreen "$entry"
        done < <(find "$CUSTOM/lib/completions" -type f | sort)

        echoGold "line"
        echoGold "Dotfiles Completions"
        echoGold "line"

    fi

    while IFS= read -r file
    do
        fileName="$(basename "$file")"
        if [ "$fileName" == ".template" ]; then continue; fi
        fileID="${fileName%.*}"
        name="${fileName%%.*}"
        if dot::enabled "$fileID"; then enabled=" ${GOLD}★${_0} "; else enabled="   "; fi
        desc="$(metafor "about" < "$file")"
        entry="$(printf -- '%-3s %-20s %s' "$enabled" "$fileID" "$desc")"
        echoLtGreen "$entry"
    done < <(find "$COMPLETIONS" -type f | sort)
    echo ""
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

    log::debug "${FUNCNAME[0]}"

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

    log::debug "${FUNCNAME[0]}"

    (($# < 1)) && exitLog "Missing Argument(s)"

    local name

    for name in "$@"
    do
        [[ "${name:0:1}" != "#" && -n "$name" ]] && completion::disable "$name"
    done
}
