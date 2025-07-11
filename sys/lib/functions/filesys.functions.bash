#!/usr/bin/env bash
####################################################################
# filesys.functions.bash
####################################################################
# Author:       Ragdata
# Date:         02/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

# ------------------------------------------------------------------
# backupFile
# @description Backup a file by copying it to a backup directory
# ------------------------------------------------------------------
backupFile()
{
	local filepath="$1"
	local backupdir="${2:-$HOME/.backup}"
	local timestamp=$(date +%Y%m%d%H%M%S)
	local backupfile="${backupdir}/$(basename "$filepath").bak.${timestamp}"

	if [[ -z "$filepath" ]]; then
		echoError "No file path provided."
		return 1
	fi

	if [[ ! -f "$filepath" ]]; then
		echoError "File '$filepath' does not exist."
		return 1
	fi

	# Create the backup directory if it doesn't exist
	mkdir -p "$backupdir"

	# Copy the file to the backup directory
	if ! cp -p "$filepath" "$backupfile"; then
		echoError "Failed to backup '$filepath' to '$backupfile'."
		return 1
	fi
}
# ------------------------------------------------------------------
# checkCustom
# @description Check for overriding files in the custom directory
# ------------------------------------------------------------------
checkCustom()
{
	local filepath="$1"
	local relativePath=""
	local customFile=""

	# Validate input
	if [[ -z "$filepath" ]]; then
		echoError "No file path provided."
		return 1
	fi

	# Check if filepath contains '/.dotfiles'
	if [[ "$filepath" == *"/.dotfiles"* ]]; then
		# Extract relative path after '/.dotfiles/'
		relativePath="${filepath#*/.dotfiles/}"
	else
		relativePath=""
	fi

	# Construct custom file path
	customFile="${CUSTOM:-$HOME/.dotfiles/custom}/$relativePath"

	# Check if the custom file exists
	if [[ -f "$customFile" ]]; then
		return "$customFile"
	else
		return "$filepath"
	fi
}
# ------------------------------------------------------------------
# mkcd
# @description Create a directory and change into it
# ------------------------------------------------------------------
mkcd()
{
	mkdir -p "$*" && cd
}
# ------------------------------------------------------------------
