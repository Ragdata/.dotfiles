#!/usr/bin/env bash
####################################################################
# functions.bash
####################################################################
# Author:       Ragdata
# Date:         22/08/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

# ------------------------------------------------------------------
# ex
# @description Easily extract compressed files
# ------------------------------------------------------------------
ex()
{
	if [ -f "$1"]; then
		case $1 in
		*.tar.bz2) tar xjf $1 ;;
        *.tar.gz) tar xzf $1 ;;
        *.bz2) bunzip2 $1 ;;
        *.rar) unrar x $1 ;;
        *.gz) gunzip $1 ;;
        *.tar) tar xf $1 ;;
        *.tbz2) tar xjf $1 ;;
        *.tgz) tar xzf $1 ;;
        *.zip) unzip $1 ;;
        *.Z) uncompress $1 ;;
        *.7z) 7z x $1 ;;
        *.deb) ar x $1 ;;
        *.tar.xz) tar xf $1 ;;
        *.tar.zst) unzstd $1 ;;
        *) echoError "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echoError "'$1' is not a valid file"
	fi
}
# ------------------------------------------------------------------
# pathReplace()
# @description Replace the PATH variable in the indicated file
# ------------------------------------------------------------------
pathReplace()
{
	local value="$1"
	local filepath="${2:-$HOME/.bashrc}"

	if [ -z "$value" ]; then
		echoError "No value provided for PATH replacement."
		return 1
	fi

	if [ ! -f "$filepath" ]; then
		echoError "File '$filepath' does not exist."
		return 1
	fi

	sed -i "s#^export PATH=.*#export PATH=\"$value\"#g" "$filepath"
	sed -i "s#^PATH=.*#PATH=\"$value\"#g" "$filepath"

	if [ $? -eq 0 ]; then
		return 0
	else
		return 1
	fi
}

# ------------------------------------------------------------------
# loadFunctions
# ------------------------------------------------------------------
# @description Load all enabled function files
# ------------------------------------------------------------------
# Load all enabled function files
if [ -f "$REGISTRY/functions.enabled" ]; then
    while IFS= read -r file
    do
        # shellcheck disable=SC1090
        if [[ "${file:0:1}" != "#" && -n "$file" ]]; then
            [ -f "$file" ] && source "$file"
        fi
    done < "$REGISTRY/functions.enabled"
fi
