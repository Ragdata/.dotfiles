#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2034
####################################################################
# install.bash
####################################################################
# Ragdata's Dotfiles - Dotfile Installer
#
# File:         install.bash
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# PREFLIGHT
####################################################################
declare -x ENV_DEFAULT
# Verify default environment file exists
[ -f "$HOME/.dotfiles/cfg/.env.dist" ] || { echo "ERROR :: Cannot find default environment variables"; exit 1; }
ENV_DEFAULT="$HOME/.dotfiles/cfg/.env.dist"
# Get Environment Variables
source "$ENV_DEFAULT"
# Look for custom environment file and include it if it's there
[ -f "$HOME/.env" ] && source "$HOME/.env"
# Add critical paths to $PATH
PATH="$DOT_BIN:$PATH"
####################################################################
# INITIALIZE
####################################################################
# Import critical files (the common library import other fundamental
# libraries as well - which means we often only need to import common)
dotImport "$FUNC_DIR/common.bash" "$FUNC_DIR/apps.bash"
#
# PATHS
#
DOTFILES="$(cd "${BASH_SOURCE%/*}" && pwd)"
#
# ADDITIONAL VARIABLES
#
USAGE="
====================================================================
USAGE: bash::install [OPTIONS] <args>
====================================================================
"
####################################################################
# FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# bash::init
# ------------------------------------------------------------------
bash::init()
{
	local DIALOG_BACKTITLE DIALOG_TITLE DIALOG_TEXT DIALOG_INIT

	[[ ! -f "$HOME"/.dotfiles/cfg/.node ]] && cp "$HOME"/.dotfiles/cfg/.node.dist "$HOME"/.dorfiles/cfg/.node

	dotImport "$FUNC_DIR/files.bash"

	file2env "$HOME"/.dotfiles/cfg/.node

	DIALOG_BACKTITLE="Ragdata's Dotfiles"
	DIALOG_TITLE="NODE / USER CONFIG"

	DIALOG_TEXT="Please confirm this node's IPv4 Address"
	DIALOG_INIT="$(hostname -I | cut -f1 -d' ')"

	[[ -z "$NODE_IPv4" ]] && { source "$HOME"/.dotfiles/lib/dialog/inputbox; export NODE_IPv4; }
	[[ -n "$RESULT" ]] && NODE_IPv4="$RESULT"
	[[ -n "$NODE_IPv4" ]] && sed -i "s/^$NODE_IPv4.*/NODE_IPv4=\"${NODE_IPv4}\"/" "$HOME"/.dotfiles/cfg/.node

	unset DIALOG_TEXT DIALOG_INIT RESULT

	DIALOG_TEXT="Please confirm the hostname of this node:"
	DIALOG_INIT="$(hostname)"

	[[ -z "$NODE_HOSTNAME" ]] && { source "$HOME"/.dotfiles/lib/dialog/inputbox; export NODE_HOSTNAME; }
	[[ -n "$RESULT" ]] && NODE_HOSTNAME="$RESULT"
	[[ "$RESULT" != "$DIALOG_INIT" ]] && hostname "$RESULT"
	[[ -n "$NODE_HOSTNAME" ]] && sed -i "s/^NODE_HOSTNAME.*/NODE_HOSTNAME=\"${NODE_HOSTNAME}\"/" "$HOME"/.dotfiles/cfg/.node

	unset DIALOG_TEXT DIALOG_INIT RESULT

	DIALOG_TEXT="Specify the username to be used for Git commits:"

	[[ -z "$GIT_USER" ]] && { source "$HOME"/.dotfiles/lib/dialog/inputbox; export GIT_USER; }
	[[ -n "$RESULT" ]] && GIT_USER="$RESULT"
	[[ -n "$GIT_USER" ]] && sed -i "s/^$GIT_USER.*/GIT_USER=\"${GIT_USER}\"/" "$HOME"/.dotfiles/cfg/.node

	unset DIALOG_TEXT RESULT

	DIALOG_TEXT="Specify the email address to be used for Git commits:"

	[[ -z "$GIT_EMAIL" ]] && { source "$HOME"/.dotfiles/lib/dialog/inputbox; export GIT_EMAIL; }
	[[ -n "$RESULT" ]] && GIT_EMAIL="$RESULT"
	[[ -n "$GIT_EMAIL" ]] && sed -i "s/^$GIT_EMAIL.*/GIT_EMAIL=\"${GIT_EMAIL}\"/" "$HOME"/.dotfiles/cfg/.node

	unset DIALOG_TEXT RESULT

	DIALOG_TEXT="Specify the GPG Key ID to be used to sign Git commits:"

	[[ -z "$GPG_KEYID" ]] && { source "$HOME"/.dotfiles/lib/dialog/inputbox; export GPG_KEYID; }
	[[ -n "$RESULT" ]] && GPG_KEYID="$RESULT"
	[[ -n "$GPG_KEYID" ]] && sed -i "s/^$GPG_KEYID.*/GPG_KEYID=\"${GPG_KEYID}\"/" "$HOME"/.dotfiles/cfg/.node

	unset DIALOG_TEXT RESULT
}
# ------------------------------------------------------------------
# bash::install
# ------------------------------------------------------------------
bash::install()
{
	echo ""
}
# ------------------------------------------------------------------
# bash::uninstall
# ------------------------------------------------------------------
bash::uninstall()
{
	echo ""
}
# ------------------------------------------------------------------
# bash::update
# ------------------------------------------------------------------
bash::update()
{
	echo ""
}
# ------------------------------------------------------------------
# bash::version
# ------------------------------------------------------------------
bash::version()
{
	echo ""
}
# ------------------------------------------------------------------
# bash::quit
# ------------------------------------------------------------------
bash::quit()
{
	echo ""
}
# ------------------------------------------------------------------
# bash::menu
# ------------------------------------------------------------------
bash::menu()
{
	local option status

	option=$(dialog --title "BASH INSTALLER" --backtitle "Ragdata's Dotfiles Installer" --clear --default-item "1" --menu "Select from the following options:" 15 50 5 \
		"Install" "" \
		"Uninstall" "" \
		"Update" "" \
		"About" "" \
		"Quit" "" 3>&1 1>&2 2>&3)

	status=$?

	if [ "$status" = 0 ]; then
		case "$option" in
			"Install")		bash::install;;
			"Uninstall")	bash::uninstall;;
			"Update")		bash::update;;
			"About")		bash::version -v;;
			"Quit")			bash::quit;;
		esac
	fi
}
####################################################################
# MAIN
####################################################################
checkBash
checkRoot
checkDir

git clone https://github.com/Ragdata/.dotfiles.git

[[ -f "$HOME"/.dotfiles/cfg/.dialogrc ]] && install -v -b -C -D -t "$HOME" "$HOME"/.dotfiles/cfg/.dialogrc

tput civis

bash::init
bash::menu

tput cnorm
