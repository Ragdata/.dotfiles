#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2034
####################################################################
# init.sh
####################################################################
# Ragdata's Dotfiles - Dotfile Installer
#
# File:         init.sh
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# PREFLIGHT
####################################################################
# if script is called with 'debug' as the first argument, set debug mode
if [[ "${1,,}" == "debug" || "$DOT_DEBUG" == 1 ]]; then
	[ "${1,,}" == "debug" ] && shift
	DOT_DEBUG=1
	set -axETo pipefail
else
	set -aETo pipefail
fi
shopt -s inherit_errexit
IFS=$'\n\t'	# set unofficial strict mode @see: http://redsymbol.net/articles/unofficial-bash-strict-mode/
TERM_ESC=$'\033'
TERM_CSI="${TERM_ESC}["
####################################################################
# TERMINAL FUNCTIONS
####################################################################
init::reset()					{ printf -- '%s0m' "$TERM_CSI"; }
init::red()						{ printf -- '%s31m' "$TERM_CSI"; }
init::green()					{ printf -- '%s92m' "$TERM_CSI"; }
init::gold()					{ printf -- '%s33m' "$TERM_CSI"; }
init::blue()					{ printf -- '%s94m' "$TERM_CSI"; }
init::white()					{ printf -- '%s97m' "$TERM_CSI"; }
# ------------------------------------------------------------------
# TERMINAL ALIASES
# ------------------------------------------------------------------
I_0="$(init::reset)"
I_RED="$(init::red)"
I_GREEN="$(init::green)"
I_GOLD="$(init::gold)"
I_BLUE="$(init::blue)"
I_WHITE="$(init::white)"
# ------------------------------------------------------------------
# TERMINAL UTILS
# ------------------------------------------------------------------
init::echoError()					{ echo -e "${I_RED}${1}${I_0}"; }
init::echoWarning()					{ echo -e "${I_GOLD}${1}${I_0}"; }
init::echoInfo()					{ echo -e "${I_BLUE}${1}${I_0}"; }
init::echoSuccess()					{ echo -e "${I_GREEN}${1}${I_0}"; }
init::errorExit()					{ init::echoError "ERROR :: $1"; exit "${2:-1}"; }
####################################################################
# HELPER FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# init::bin
# ------------------------------------------------------------------
init::bin()
{
	init::echoInfo "Installing .dotfiles binaries ..."
	while IFS= read -r file
	do
		fileName="$(basename "$file")"
		[ -e "/usr/local/bin/$fileName" ] && sudo rm -f "/usr/local/bin/$fileName"
		sudo ln -s "$file" "/usr/local/bin/$fileName"
		sudo chmod 0755 "/usr/local/bin/$fileName"
	done < <(find "$HOME/.dotfiles/bin" -type f)
}
# ------------------------------------------------------------------
# init::checkBash
# ------------------------------------------------------------------
init::checkBash()
{
	if [[ "${BASH_VERSION:0:1}" -lt 4 ]]; then
		init::errorExit "This script requires a minimum Bash version of 4+"
	fi
}
# ------------------------------------------------------------------
# init::dots
# ------------------------------------------------------------------
init::dots()
{
	local promptFile promptDot DOT=()

	init::echoInfo "Installing dotfiles ..."

	[ -d "$HOME/.backup" ] || { mkdir -p "$HOME/.backup" || init::errorExit "Unable to create backup directory"; }
	[ -f "$HOME/.profile" ] && mv -b "$HOME/.profile" "$HOME/.backup/.profile"
	[ -L "$HOME/.profile" ] && rm -f "$HOME/.profile"

	while IFS= read -r file
	do
		DOT=()
		if [ -f "$HOME/.dotfiles/custom/dots/$fileName" ]; then
			file="$HOME/.dotfiles/custom/dots/$fileName"
		fi
		fileName="$(basename "$file")"
		mapfile -d "." -t DOT < <(printf '%s' "$fileName")
		echo "$HOME/.${DOT[0]} ..."
		if [ -L "$HOME/.${DOT[0]}" ]; then
			rm -f "$HOME/.${DOT[0]}"
		elif [ -f "$HOME/.${DOT[0]}" ]; then
			mv -b "$HOME/.${DOT[0]}" "$HOME/.backup/.${DOT[0]}"
		fi
		ln -s "$file" "$HOME/.${DOT[0]}"
		chmod 0644 "$HOME/.${DOT[0]}"
	done < <(find "$HOME/.dotfiles/dots" -maxdepth 1 -type f)
}
# ------------------------------------------------------------------
# init::sudoers
# ------------------------------------------------------------------
init::sudoers()
{
	if [ ! -f "/etc/sudoers.d/$USER" ]; then
		init::echoInfo "Removing password requirement for sudo ..."
		sudo sh -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/$USER"
	fi
}
# ------------------------------------------------------------------
# init::sysUpdate
# ------------------------------------------------------------------
init::sysUpdate()
{
	# local diff last_update

	# # update / upgrade
	# if [ -f /var/cache/apt/pkgcache.bin ]; then
	# 	# shellcheck disable=SC2012
	# 	last_update="$(ls -l /var/cache/apt/pkgcache.bin | cut -d' ' -f6,7,8)"
	# fi
	# if [ -n "$last_update" ]; then
	# 	last_update="$(date -d "$last_update" +%Y%m%d)"
	# 	diff=$((("$(date +%s)"-"$(date +%s -d "$last_update")")/86400))
	# fi
	# if [[ -z "$diff" || "$diff" -gt 28 ]]; then
	# 	init::echoInfo "Updating system files ..."
	# 	sudo apt-get -qq -y update && sudo apt-get -qq -y upgrade
	# fi
	init::echoInfo "Updating system files ..."
	sudo apt-get -qq -y update && sudo apt-get -qq -y full-upgrade
}
####################################################################
# HELPER FUNCTIONS
####################################################################
init::checkBash
init::sudoers
init::sysUpdate

# check we've got the essentials
if ! command -v git &> /dev/null; then
	init::echoInfo "Package 'git' not found - installing ..."
	sudo apt-get -qq -y install git
fi
if ! command -v dialog &> /dev/null; then
	init::echoInfo "Package 'dialog' not found - installing ..."
	sudo apt-get -qq -y install dialog
fi

# ensure correct install location
if [ "$PWD" != "$HOME" ]; then cd "$HOME" || exit 1; fi

# check that repo exists locally
if [ ! -d "$HOME/.dotfiles" ]; then
	init::echoInfo "Cloning .dotfiles repo ..."
	# @TODO - Change to release package once released
	git clone https://github.com/Ragdata/.dotfiles.git
else
	init::echoInfo "Updating .dotfiles repo ..."
	git -C "$HOME/.dotfiles" pull
fi

#init::bin
init::dots

echo ""
echo -e "${I_GOLD}Dotfiles Initialised!${I_0}"
echo ""
echo "The next step is to reload your shell session and run the install function using the following commands:"
echo ""
echo -e "${I_WHITE}bash -i${I_0}"
echo -e "${I_WHITE}dotfiles${I_0}"
echo ""
