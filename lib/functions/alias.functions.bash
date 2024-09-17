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

	log::debug "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local name="${1//[$'\t\n\r']}" source

	if [[ $name =~ .*\.aliases ]]; then name="${name%.*}"; fi

	if [ -f "$CUSTOM/lib/aliases/$name.aliases.bash" ]; then
	    source="$CUSTOM/lib/aliases/$name.aliases.bash"
	else
	    source="$ALIASES/$name.aliases.bash"
	fi

	[ -f "$source" ] || exitLog "Unable to find alias file '$source'"

	[ -f "$DOT_REG/aliases.enabled" ] || cp "$TEMPLATES/registry.tmpl" "$DOT_REG/aliases.enabled"

	if grep -q "$name\.aliases\.bash" "$DOT_REG/aliases.enabled"; then
	    log::debug "Alias '$name' already enabled"
	else
	    log::info "Alias '$name' successfully enabled"
	    echo "$source" >> "$DOT_REG/aliases.enabled"
	fi

	return 0
}
# ------------------------------------------------------------------
# alias::disable
# ------------------------------------------------------------------
alias::disable()
{
    group 'alias'

	log::debug "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local name="${1//[$'\t\n\r']}" source return

	if [[ $name =~ .*\.aliases ]]; then name="${name%.*}"; fi

	sed -i "/.*$name\.aliases\.bash/d" "$DOT_REG/aliases.enabled"; return=$?

    if [ $return -eq 0 ]; then
        log::info "Alias '$name' successfully disabled"
    else
        log::error "Failed to disable alias '$name'"
    fi

	return $return
}
# ------------------------------------------------------------------
# alias::describe
# ------------------------------------------------------------------
alias::describe()
{
    group 'alias'

    log::debug "${FUNCNAME[0]}"

    local header file fileName fileID name enabled="" desc entry customFiles

    customFiles="$(find "$CUSTOM/lib/aliases" -type f | wc -l)"

    clear

    echoYellow "Available Aliases"
    echo ""
    header="$(printf -- '%-3s %-20s %s' " ★ " "FileID" "Description")"
    echoGold "$header"
    echoGold "line"

    if [ "$customFiles" -gt 0 ]; then

        echoGold "Custom Aliases"
        echoGold "line"

        while IFS= read -r file
        do
            fileName="$(basename "$file")"
            if [ "$fileName" == ".template" ]; then continue; fi
            if grep -q "$fileName" "$ALIASES"/*; then continue; fi
            fileID="${fileName%.*}"
            name="${fileName%%.*}"
            if dot::enabled "$fileID"; then enabled=" ${GOLD}★${_0} "; else enabled="   "; fi
            desc="$(metafor "about" < "$file")"
            entry="$(printf -- '%-3s %-20s %s' "$enabled" "$fileID" "$desc")"
            echoLtGreen "$entry"
        done < <(find "$CUSTOM/lib/aliases" -type f | sort)

        echoGold "line"
        echoGold "Dotfiles Aliases"
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
    done < <(find "$ALIASES" -type f | sort)
    echo ""
}
####################################################################
# BULK HANDLERS
####################################################################
# ------------------------------------------------------------------
# aliasEnable
# ------------------------------------------------------------------
aliasEnable()
{
    about 'Enable a list of alias files'
    param '@:   list/array'
    usage 'aliasEnable "dot" "general" "git"'
    group 'alias'

    log::debug "${FUNCNAME[0]}"

    (($# < 1)) && exitLog "Missing Argument(s)"

    local name

    for name in "$@"
    do
        [[ "${name:0:1}" != "#" && -n "$name" ]] && alias::enable "$name"
    done
}
# ------------------------------------------------------------------
# aliasDisable
# ------------------------------------------------------------------
aliasDisable()
{
    about 'Disable a list of alias files'
    param '@:   list/array'
    usage 'aliasDisable "dot" "general" "git"'
    group 'alias'

    log::debug "${FUNCNAME[0]}"

    (($# < 1)) && exitLog "Missing Argument(s)"

    local name

    for name in "$@"
    do
        [[ "${name:0:1}" != "#" && -n "$name" ]] && alias::disable "$name"
    done
}
