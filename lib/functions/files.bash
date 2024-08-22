#!/usr/bin/env bash
####################################################################
# files.bash
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         files.bash
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# FILESYSTEM FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# file2env
# ------------------------------------------------------------------
file2env()
{
	[[ (($# == 0)) || ! -f "$1" ]] && errorExit "No file passed or file not found"

	while IFS= read -r line
	do
		if [[ -n "$line" && "${line:0:1}" != "#" ]]; then
			key="${line##=*}"
			export "${key?}"
		fi
	done < "$1"
}
# ------------------------------------------------------------------
# scriptDir
# ------------------------------------------------------------------
scriptDir() { printf -- '%s' "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"; }
# ------------------------------------------------------------------
# scriptPath
# ------------------------------------------------------------------
scriptPath() { printf -- '%s' "$(realpath "${BASH_SOURCE[0]}")"; }
# ------------------------------------------------------------------
# searchFiles
# ------------------------------------------------------------------
searchFiles()
{
	local file="$1"
	local default="${2:-}"
	local dir outFile

	[ -z "$file" ] && errorExit "No filename passed"

	for dir in "${SEARCH_DIRS[@]}"
	do
		[ -f "$dir/$file" ] && outFile="$dir/$file"
	done

	[ -z "$outFile" ] && outFile="$default"

	printf -- '%s' "$outFile"
}
