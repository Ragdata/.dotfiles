#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2034
####################################################################
# install.sh
####################################################################
# Ragdata's Dotfiles - Dotfile Installer
#
# File:         install.sh
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# PREFLIGHT
####################################################################
# set debug mode = false
declare -x DEBUG=0
# if script is called with 'debug' as the first argument, set debug mode
if [ "${1,,}" == "debug" ]; then
	DEBUG=1
	set -- "${@:1}"
	set -axeETuo pipefail
else
	set -aeETuo pipefail
fi
shopt -s inherit_errexit
IFS=$'\n\t'	# set unofficial strict mode @see: http://redsymbol.net/articles/unofficial-bash-strict-mode/
####################################################################
# HELPER FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# install::checkBash
# ------------------------------------------------------------------
install::checkBash() { if [[ "${BASH_VERSION:0:1}" -lt 4 ]]; then echo "This script requires a minimum Bash version of 4+"; exit 1; fi }
# ------------------------------------------------------------------
# install::bin
# ------------------------------------------------------------------
install::bin()
{
	echo "Installing .dotfiles binaries ..."
	while IFS= read -r file
	do
		fileName="$(basename "$file")"
		[ -e "/usr/local/bin/$fileName" ] && rm -f "/usr/local/bin/$fileName"
		chmod 0755 "$file"
		ln -s "$file" "/usr/local/bin/$fileName"
		chmod 0755 "/usr/local/bin/$fileName"
	done < <(find "$DOTFILES/bin" -type f)
}
# ------------------------------------------------------------------
# install::deps
# ------------------------------------------------------------------
install::deps()
{
	if ! command -v add-apt-repository &> /dev/null; then
		echo "Package 'software-properties-common' not found - installing ..."
		sudo apt -qq -y install software-properties-common
	fi
	if [ -f "$DOT_CFG/data/repositories.list" ]; then
		echo "Adding configured repositories ..."
		while IFS= read -r line
		do
			sudo add-apt-repository "$line" || echo "WARNING :: Failed to add repository '$line'"
		done < "$DOT_CFG/data/repositories.list"
	fi
	if [ -f "$DOT_CFG/data/dependencies.list" ]
		echo "Installing configured dependencies ..."
		while IFS= read -r line
		do

		done < "$DOT_CFG/data/dependencies.list"
	fi
}
# ------------------------------------------------------------------
# install::dots
# ------------------------------------------------------------------
install::dots()
{
	local DOT=()
	echo "Installing dotfiles ..."
	while IFS= read -r file
	do
		DOT=()
		fileName="$(basename "$file")"
		mapfile -d "." -t DOT < <(printf '%s' "$fileName")
		mkdir -p "$HOME/.backup"
		if [ -f "$HOME/.${DOT[0]}" ]; then
			mv -b "$HOME/.${DOT[0]}" "$HOME/.backup/.${DOT[0]}"
		elif [ -L "$HOME/.${DOT[0]}" ]; then
			rm -f "$HOME/.${DOT[0]}"
		fi
		ln -s "$file" "$HOME/.${DOT[0]}"
		chmod 0644 "$HOME/.${DOT[0]}"
	done < <(find "$DOTS" -type f -maxdepth 0)
}
####################################################################
# INIT
####################################################################

declare -x ENV_DEFAULT DOTFILES

install::checkBash

# check we've got the essentials
if ! command -v git &> /dev/null; then
	echo "Package 'git' not found - installing ..."
	sudo apt-get -qq -y install git
fi

# ensure correct install location
if [ "$PWD" != "$HOME" ]; then cd "$HOME" || exit 1; fi

# check that repo exists locally
if [ ! -d "$HOME/.dotfiles" ]; then
	echo "Cloning .dotfiles repo ..."
	# @TODO - Change to release package once released
	git clone https://github.com/Ragdata/.dotfiles.git
fi

# set critical env variables
DOTFILES="$HOME/.dotfiles"
ENV_DEFAULT="$DOTFILES/cfg/.env.dist"

source "$ENV_DEFAULT" || { echo "ERROR :: Default configuration file not found!"; exit 1; }
####################################################################
# MAIN
####################################################################
install::bin
install::deps
install::dots

#ENV_DEFAULT="./cfg/.env.dist"
## verify default environment file is where you think it is
#[ -f "$ENV_DEFAULT" ] || { echo "ERROR :: Default configuration file not found!"; exit 1; }
#source "$ENV_DEFAULT"

#[[ ! $PATH =~ ?(*:)$DOT_BIN?(:*) ]] && export PATH="$PATH:$DOT_BIN"
# Import additional helpful libraries
#dotInclude "common.functions" "files.functions"
#
#
# ADDITIONAL VARIABLES
#
#USAGE="
#====================================================================
#USAGE: install.sh [OPTIONS] <args>
#====================================================================
#"
####################################################################
# CORE FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# bash::init
# ------------------------------------------------------------------
#bash::init()
#{
#	local DIALOG_BACKTITLE DIALOG_TITLE DIALOG_TEXT DIALOG_INIT
#
#	[[ ! -f "$DOT_CFG/.node" ]] && cp "$DOT_CFG/.node.dist" "$DOT_CFG/.node"
#
#	dotInclude "files.functions"
#
#	file2env "$HOME"/.dotfiles/cfg/.node
#
#	DIALOG_BACKTITLE="Ragdata's Dotfiles"
#	DIALOG_TITLE="NODE / USER CONFIG"
#
#	DIALOG_TEXT="Please confirm this node's IPv4 Address"
#	DIALOG_INIT="$(hostname -I | cut -f1 -d' ')"
#
#	[[ -z "$NODE_IPv4" ]] && { source "$HOME"/.dotfiles/lib/dialog/inputbox; export NODE_IPv4; }
#	[[ -n "$RESULT" ]] && NODE_IPv4="$RESULT"
#	[[ -n "$NODE_IPv4" ]] && sed -i "s/^$NODE_IPv4.*/NODE_IPv4=\"${NODE_IPv4}\"/" "$HOME"/.dotfiles/cfg/.node
#
#	unset DIALOG_TEXT DIALOG_INIT RESULT
#
#	DIALOG_TEXT="Please confirm the hostname of this node:"
#	DIALOG_INIT="$(hostname)"
#
#	[[ -z "$NODE_HOSTNAME" ]] && { source "$HOME"/.dotfiles/lib/dialog/inputbox; export NODE_HOSTNAME; }
#	[[ -n "$RESULT" ]] && NODE_HOSTNAME="$RESULT"
#	[[ "$RESULT" != "$DIALOG_INIT" ]] && hostname "$RESULT"
#	[[ -n "$NODE_HOSTNAME" ]] && sed -i "s/^NODE_HOSTNAME.*/NODE_HOSTNAME=\"${NODE_HOSTNAME}\"/" "$HOME"/.dotfiles/cfg/.node
#
#	unset DIALOG_TEXT DIALOG_INIT RESULT
#
#	DIALOG_TEXT="Specify the username to be used for Git commits:"
#
#	[[ -z "$GIT_USER" ]] && { source "$HOME"/.dotfiles/lib/dialog/inputbox; export GIT_USER; }
#	[[ -n "$RESULT" ]] && GIT_USER="$RESULT"
#	[[ -n "$GIT_USER" ]] && sed -i "s/^$GIT_USER.*/GIT_USER=\"${GIT_USER}\"/" "$HOME"/.dotfiles/cfg/.node
#
#	unset DIALOG_TEXT RESULT
#
#	DIALOG_TEXT="Specify the email address to be used for Git commits:"
#
#	[[ -z "$GIT_EMAIL" ]] && { source "$HOME"/.dotfiles/lib/dialog/inputbox; export GIT_EMAIL; }
#	[[ -n "$RESULT" ]] && GIT_EMAIL="$RESULT"
#	[[ -n "$GIT_EMAIL" ]] && sed -i "s/^$GIT_EMAIL.*/GIT_EMAIL=\"${GIT_EMAIL}\"/" "$HOME"/.dotfiles/cfg/.node
#
#	unset DIALOG_TEXT RESULT
#
#	DIALOG_TEXT="Specify the GPG Key ID to be used to sign Git commits:"
#
#	[[ -z "$GPG_KEYID" ]] && { source "$HOME"/.dotfiles/lib/dialog/inputbox; export GPG_KEYID; }
#	[[ -n "$RESULT" ]] && GPG_KEYID="$RESULT"
#	[[ -n "$GPG_KEYID" ]] && sed -i "s/^$GPG_KEYID.*/GPG_KEYID=\"${GPG_KEYID}\"/" "$HOME"/.dotfiles/cfg/.node
#
#	unset DIALOG_TEXT RESULT
#}
# ------------------------------------------------------------------
# bash::install
# ------------------------------------------------------------------
#bash::install()
#{
#	echo ""
#}
# ------------------------------------------------------------------
# bash::uninstall
# ------------------------------------------------------------------
#bash::uninstall()
#{
#	echo ""
#}
# ------------------------------------------------------------------
# bash::update
# ------------------------------------------------------------------
#bash::update()
#{
#	echo ""
#}
# ------------------------------------------------------------------
# bash::version
# ------------------------------------------------------------------
#bash::version()
#{
#	echo ""
#}
# ------------------------------------------------------------------
# bash::quit
# ------------------------------------------------------------------
#bash::quit()
#{
#	echo ""
#}
# ------------------------------------------------------------------
# bash::menu
# ------------------------------------------------------------------
#bash::menu()
#{
#	local option status
#
#	option=$(dialog --title "BASH INSTALLER" --backtitle "Ragdata's Dotfiles Installer" --clear --default-item "1" --menu "Select from the following options:" 15 50 5 \
#		"Install" "" \
#		"Uninstall" "" \
#		"Update" "" \
#		"About" "" \
#		"Quit" "" 3>&1 1>&2 2>&3)
#
#	status=$?
#
#	if [ "$status" = 0 ]; then
#		case "$option" in
#			"Install")		bash::install;;
#			"Uninstall")	bash::uninstall;;
#			"Update")		bash::update;;
#			"About")		bash::version -v;;
#			"Quit")			bash::quit;;
#		esac
#	fi
#}

#[ "${PWD##*/}" != ".dotfiles" ] && git clone https://github.com/Ragdata/.dotfiles.git
#
#[ -f "$DOT_CFG/.dialogrc" ] && install -v -b -C -D -t "$HOME" "$DOT_CFG/.dialogrc"
#
#tput civis
#
##bash::init
#bash::menu
#
#tput cnorm
