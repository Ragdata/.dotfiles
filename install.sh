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
declare -gx DEBUG
# if script is called with 'debug' as the first argument, set debug mode
if [[ "${1,,}" == "debug" || "$DEBUG" == 1 ]]; then
	[ "${1,,}" == "debug" ] && shift
	DEBUG=1
	set -axeETo pipefail
else
	set -aeETo pipefail
fi
shopt -s inherit_errexit
IFS=$'\n\t'	# set unofficial strict mode @see: http://redsymbol.net/articles/unofficial-bash-strict-mode/
TERM_ESC=$'\033'
TERM_CSI="${TERM_ESC}["
####################################################################
# TERMINAL FUNCTIONS
####################################################################
install::reset()				{ printf -- '%s0m' "$TERM_CSI"; }
install::red()					{ printf -- '%s31m' "$TERM_CSI"; }
install::green()				{ printf -- '%s92m' "$TERM_CSI"; }
install::gold()					{ printf -- '%s33m' "$TERM_CSI"; }
install::blue()					{ printf -- '%s34m' "$TERM_CSI"; }
install::white()				{ printf -- '%s97m' "$TERM_CSI"; }
# ------------------------------------------------------------------
# TERMINAL ALIASES
# ------------------------------------------------------------------
I_0="$(install::reset)"
I_RED="$(install::red)"
I_GREEN="$(install::green)"
I_GOLD="$(install::gold)"
I_BLUE="$(install::blue)"
I_WHITE="$(install::white)"
# ------------------------------------------------------------------
# TERMINAL UTILS
# ------------------------------------------------------------------
install::echoError()					{ echo -e "${I_RED}${1}${I_0}"; }
install::echoWarning()					{ echo -e "${I_GOLD}${1}${I_0}"; }
install::echoInfo()						{ echo -e "${I_BLUE}${1}${I_0}"; }
install::echoSuccess()					{ echo -e "${I_GREEN}${1}${I_0}"; }
install::errorExit()					{ install::echoError "ERROR :: $1"; exit "${2:-1}"; }
####################################################################
# HELPER FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# install::bin
# ------------------------------------------------------------------
install::bin()
{
	install::echoInfo "Installing .dotfiles binaries ..."
	while IFS= read -r file
	do
		fileName="$(basename "$file")"
		[ -e "/usr/local/bin/$fileName" ] && sudo rm -f "/usr/local/bin/$fileName"
		chmod 0755 "$file"
		sudo ln -s "$file" "/usr/local/bin/$fileName"
		sudo chmod 0755 "/usr/local/bin/$fileName"
	done < <(find "$HOME/.dotfiles/bin" -type f)
}
# ------------------------------------------------------------------
# install::cfg
# ------------------------------------------------------------------
install::cfg()
{
	# @TODO - dialog to collect info

	envsubst < "$DOTFILES/.github/.releaserc.dist" > "$DOTFILES/.github/.releaserc"
}
# ------------------------------------------------------------------
# install::checkBash
# ------------------------------------------------------------------
install::checkBash()
{
	if [[ "${BASH_VERSION:0:1}" -lt 4 ]]; then
		install::errorExit "This script requires a minimum Bash version of 4+"
	fi
}
# ------------------------------------------------------------------
# install::deps
# ------------------------------------------------------------------
install::deps()
{
	local install config

	if ! command -v add-apt-repository &> /dev/null; then
		echoInfo "Package 'software-properties-common' not found - installing ..."
		sudo apt -qq -y install software-properties-common
	fi
	if [ -f "$DOT_CFG/data/repositories.list" ]; then
		echoInfo "Adding configured repositories ..."
		while IFS= read -r line
		do
			sudo add-apt-repository "$line" || echoWarning "WARNING :: Failed to add repository '$line'"
		done < "$DOT_CFG/data/repositories.list"
		echoInfo "Updating apt database ..."
		sudo apt-get -qq -y update
	fi
	if [ -f "$DOT_CFG/data/dependencies.list" ]; then
		echoInfo "Installing configured dependencies ..."
		while IFS= read -r line
		do
			install=2
			config=2
			if [ -f "$PKGS/$line" ]; then
				echoSuccess "Found package file for '$line'"
				source "$PKGS/$line"
				if [[ "$(type -t "$line::install")" ]]; then
					echoInfo "Installing '$line' ..."
					eval "$line::install"
					install="$?"
				else
					sudo apt-get -qq -y install "$line"
					install="$?"
				fi
				if ((install==0)); then
					if [[ "$(type -t "$line::config")" == "function" ]]; then
						echoInfo "Configuring '$line' ..."
						eval "$line::config"
						config="$?"
					fi
				elif ((install==1)); then
					echoWarning "Unable to install package '$line'"
				fi
			else
				echoInfo "Installing '$line' with apt-get ..."
				sudo apt-get -qq -y install "$line"
			fi
		done < "$DOT_CFG/data/dependencies.list"
	fi
}
# ------------------------------------------------------------------
# install::dots
# ------------------------------------------------------------------
install::dots()
{
	local promptFile promptDot DOT=()

	install::echoInfo "Installing dotfiles ..."

	[ -d "$HOME/.backup" ] || { mkdir -p "$HOME/.backup" || install::errorExit "Unable to create backup directory"; }
	[ -f "$HOME/.profile" ] && mv -b "$HOME/.profile" "$HOME/.backup/.profile"
	[ -L "$HOME/.profile" ] && rm -f "$HOME/.profile"

	while IFS= read -r file
	do
		DOT=()
		if [ -f "$HOME/.dotfiles/lib/custom/dots/$fileName" ]; then
			file="$HOME/.dotfiles/lib/custom/dots/$fileName"
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

	install::echoInfo "Reloading .bashrc ..."
	source "$HOME/.bashrc"
}
# ------------------------------------------------------------------
# install::getVersion
# ------------------------------------------------------------------
install::getVersion()
{
	local releaserc

	! command -v yq &> /dev/null && { install::echoError "Dependency 'yq' not installed"; return 1; }

	releaserc="$DOTFILES/.github/.releaserc"

	if [ -f "$releaserc" ]; then
		yq 'has("version")' "$releaserc" && DOTFILES_VERSION="$(yq '.version' "$releaserc")"
	else
		DOTFILES_VERSION="v0.1.0"
	fi
}
# ------------------------------------------------------------------
# install::sudo
# ------------------------------------------------------------------
install::sudoers()
{
	if [ ! -f "/etc/sudoers.d/$USER" ]; then
		install::echoInfo "Removing password requirement for sudo ..."
		echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$USER"
	fi
}
# ------------------------------------------------------------------
# install::sysUpdate
# ------------------------------------------------------------------
install::sysUpdate()
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
	# 	install::echoInfo "Updating system files ..."
	# 	sudo apt-get -qq -y update && sudo apt-get -qq -y upgrade
	# fi
	install::echoInfo "Updating system files ..."
	sudo apt-get -qq -y update && sudo apt-get -qq -y upgrade
}
# ------------------------------------------------------------------
# install::version
# ------------------------------------------------------------------
install::version()
{
	if [ -z "$1" ]; then
		echo "$DOTFILES_VERSION"
	else
		echo "Ragdata's Dotfiles"
		echo -e "Version: ${I_WHITE}$DOTFILES_VERSION${I_0}"
		echo "$DOTFILES_COPYRIGHT"
	fi
}
####################################################################
# CORE FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# install::full
# ------------------------------------------------------------------
install::full()
{
	install::bin
	install::dots
	dotInclude "${DEBUG:+}" "common.functions"
	install::deps
}
# ------------------------------------------------------------------
# install::init
# ------------------------------------------------------------------
install::init()
{
	install::checkBash

	install::sudoers

	install::sysUpdate

	# check we've got the essentials
	if ! command -v git &> /dev/null; then
		install::echoInfo "Package 'git' not found - installing ..."
		sudo apt-get -qq -y install git
	fi
	if ! command -v dialog &> /dev/null; then
		install::echoInfo "Package 'dialog' not found - installing ..."
		sudo apt-get -qq -y install dialog
	fi

	# ensure correct install location
	if [ "$PWD" != "$HOME" ]; then cd "$HOME" || exit 1; fi

	# check that repo exists locally
	if [ ! -d "$HOME/.dotfiles" ]; then
		install::echoInfo "Cloning .dotfiles repo ..."
		# @TODO - Change to release package once released
		git clone https://github.com/Ragdata/.dotfiles.git
	else
		install::echoInfo "Updating .dotfiles repo ..."
		git -C "$HOME/.dotfiles" pull
	fi
}
# ------------------------------------------------------------------
# install::menu
# ------------------------------------------------------------------
install::menu()
{
	local option status

	option=$(dialog --title "BASH INSTALLER" --backtitle "Ragdata's Dotfiles Installer" --clear --default-item "1" --menu "Select from the following options:" 15 50 5 \
		"Reinstall" "" \
		"Uninstall" "" \
		"Version" "" \
		"Quit" "" 3>&1 1>&2 2>&3)

	status=$?

	if [ "$status" = 0 ]; then
		case "$option" in
			"Reinstall")		bash::install;;
			"Uninstall")		bash::uninstall;;
			"Update")			bash::update;;
			"Version")			bash::version -v;;
			"Quit")				bash::quit;;
		esac
	fi
}
####################################################################
# MAIN
####################################################################
#tput civis

install::init

#tput cnorm

options=$(getopt -l "version" -o "v" -a -- "$@")

eval set --"$options"

while true
do
	case "$1" in
		-v|--version)
			if [ -n "$2" ]; then
				install::version "$2"
				shift 2
			else
				install::version
				shift
			fi
			;;
		--)
			install::full
			;;
		*)
			install::errorExit "ERROR :: Invalid Argument!"
			;;
	esac
done


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
