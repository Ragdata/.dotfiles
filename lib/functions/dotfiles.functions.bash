#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2034
####################################################################
# dotfiles.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         dotfiles.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# DEPENDENCIES
####################################################################
# required library files
dot::include "log.functions" "pkg.functions"
####################################################################
# DOTFILES MENU FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# dot::menu
# ------------------------------------------------------------------
dot::menu()
{
    group 'dot'

	debugLog "${FUNCNAME[0]}"

	local result
	local DIALOG_BACKTITLE="Ragdata's Dotfiles"
	local DIALOG_TITLE="Main Menu"
	local DIALOG_TEXT="Select from the following options:"
	local -a DIALOG_OPTIONS=(
		"1" "Install Menu"
		"2" "Update Menu"
		"3" "Settings"

		"Q" "Quit"
	)

    trap 'clear' ERR

	result=$(dialog \
		--ok-label "${OK_LABEL:-"OK"}" \
		--cancel-label "${CANCEL_LABEL:-"Cancel"}" \
		--backtitle "${DIALOG_BACKTITLE}" \
		--title "${DIALOG_TITLE}" \
		--menu "${DIALOG_TEXT}" "${HEIGHT:-15}" "${WIDTH:-50}" "${MENU_HEIGHT:-5}" \
		"${DIALOG_OPTIONS[@]}" 3>&1 1>&2 2>&3)

	status=$?

	clear

	case "$status" in
		"$DIALOG_OK")
			case "$result" in
				1)	dot::menu::install;;
				2)	dot::menu::update;;
				3)	dot::menu::config;;

				Q)	exit 0;;
			esac
			;;
		"$DIALOG_CANCEL"|"$DIALOG_ESC")
			exit 0;;
	esac
}
# ------------------------------------------------------------------
# dot::menu::config
# ------------------------------------------------------------------
dot::menu::config()
{
    group 'dot'

	debugLog "${FUNCNAME[0]}"

	local result
	local DIALOG_BACKTITLE="Ragdata's Dotfiles"
	local DIALOG_TITLE="Settings Menu"
	local DIALOG_TEXT="Select from the following options:"
	local -a DIALOG_OPTIONS=(
		"X" "Back to Main Menu"
	)

    trap 'clear' ERR

	result=$(dialog \
		--ok-label "${OK_LABEL:-"OK"}" \
		--cancel-label "${CANCEL_LABEL:-"Cancel"}" \
		--backtitle "${DIALOG_BACKTITLE}" \
		--title "${DIALOG_TITLE}" \
		--menu "${DIALOG_TEXT}" "${HEIGHT:-15}" "${WIDTH:-50}" "${MENU_HEIGHT:-5}" \
		"${DIALOG_OPTIONS[@]}" 3>&1 1>&2 2>&3)

	status=$?

	clear

	case "$status" in
		"$DIALOG_OK")
			case "$result" in
				X)	dot::menu;;
			esac
			;;
		"$DIALOG_CANCEL"|"$DIALOG_ESC")
			exit 0;;
	esac
}
# ------------------------------------------------------------------
# dot::menu::install
# ------------------------------------------------------------------
dot::menu::install()
{
    group 'dot'

	debugLog "${FUNCNAME[0]}"

	local result
	local DIALOG_BACKTITLE="Ragdata's Dotfiles"
	local DIALOG_TITLE="Install Menu"
	local DIALOG_TEXT="Select from the following options:"
	local -a DIALOG_OPTIONS=(
		"1" "Install Dependencies"
		"" ""
		"X" "Back to Main Menu"
	)

    trap 'clear' ERR

	result=$(dialog \
		--ok-label "${OK_LABEL:-"OK"}" \
		--cancel-label "${CANCEL_LABEL:-"Cancel"}" \
		--backtitle "${DIALOG_BACKTITLE}" \
		--title "${DIALOG_TITLE}" \
		--menu "${DIALOG_TEXT}" "${HEIGHT:-15}" "${WIDTH:-50}" "${MENU_HEIGHT:-5}" \
		"${DIALOG_OPTIONS[@]}" 3>&1 1>&2 2>&3)

	status=$?

	clear

	case "$status" in
		"$DIALOG_OK")
			case "$result" in
				1)	dot::install::deps;;

				X)	dot::menu;;
			esac
			;;
		"$DIALOG_CANCEL"|"$DIALOG_ESC")
			exit 0;;
	esac
}
# ------------------------------------------------------------------
# dot::menu::update
# ------------------------------------------------------------------
dot::menu::update()
{
    group 'dot'

	debugLog "${FUNCNAME[0]}"

	local result
	local DIALOG_BACKTITLE="Ragdata's Dotfiles"
	local DIALOG_TITLE="Update Menu"
	local DIALOG_TEXT="Select from the following options:"
	local -a DIALOG_OPTIONS=(
		"1" "Update Dotfiles"
		"2" "Update System"
		"" ""
		"X" "Back to Main Menu"
	)

    trap 'clear' ERR

	result=$(dialog \
		--ok-label "${OK_LABEL:-"OK"}" \
		--cancel-label "${CANCEL_LABEL:-"Cancel"}" \
		--backtitle "${DIALOG_BACKTITLE}" \
		--title "${DIALOG_TITLE}" \
		--menu "${DIALOG_TEXT}" "${HEIGHT:-15}" "${WIDTH:-50}" "${MENU_HEIGHT:-5}" \
		"${DIALOG_OPTIONS[@]}" 3>&1 1>&2 2>&3)

	status=$?

	clear

	case "$status" in
		"$DIALOG_OK")
			case "$result" in
				1)	dot::update;;
				2)	dot::update::sys;;

				X)	dot::menu;;
			esac
			;;
		"$DIALOG_CANCEL"|"$DIALOG_ESC")
			exit 0;;
	esac
}
####################################################################
# DOTFILES FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# dot::set
# ------------------------------------------------------------------
dot::set()
{
	group 'dot'
}
####################################################################
# DOTFILES INSTALL FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# dot::install::deps
# ------------------------------------------------------------------
dot::install::deps()
{
	group 'dot'

	local result

	debugLog "${FUNCNAME[0]}"

	if ! command -v add-apt-repository &> /dev/null; then
		echoDot "Installing package 'software-properties-common' - " -s "✚" -n
		sudo apt-get -qq -y install software-properties-common; result=$?
		if [ "$result" -eq 0 ]; then
			log::info "Package installed successfully"
			echoAlias "OK" -c "${LT_GREEN}"
		else
			log::error "Package 'software-properties-common' failed to install"
			echoAlias "FAILED!" -c "${RED}"
		fi
	fi

	if [ -f "$DOT_CFG/data/repositories.list" ]; then
		echoDot "Adding configured repositories" -s "➤" -c "${GOLD}"
		while IFS= read -r line
		do
			pkg::addRepo "$line"
		done < "$DOT_CFG/data/repositories.list"
	fi

	if [ -f "$DOT_CFG/data/dependencies.list" ]; then
		echoDot "Installing configured dependencies" -s "➤" -c "${GOLD}"
		pkg::installList "dependencies" "$DOT_CFG/data"
	fi
}
# ------------------------------------------------------------------
# dot::install
# ------------------------------------------------------------------
dot::install()
{
	group 'dot'

	dot::install::deps

	echo ""

	read -n 1 -s -r -p "Press any key to continue ..."

	dot::menu
}
####################################################################
# DOTFILES UPDATE FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# dot::update::sys
# ------------------------------------------------------------------
dot::update::sys()
{
    group 'dot'

	local result

	debugLog "${FUNCNAME[0]}"

	echoHead "Updating Package Cache"
	sudo apt-get -qq -y update; result=$?
	if [ "$result" -eq 0 ]; then
		log::info "Package cache updated successfully"
		echoDot "OK" -c "${LT_GREEN}"
	else
		log::error "Package cache update failed"
		echoDot "FAILED!" -c "${RED}"
	fi

	echoHead "Upgrading System Files"
	sudo apt-get -qq -y full-upgrade; result=$?
	if [ "$result" -eq 0 ]; then
		log::info "System files upgraded successfully"
		echoDot "OK" -c "${LT_GREEN}"
	else
		log::error "System files upgrade failed"
		echoDot "FAILED!" -c "${RED}"
	fi
}
# ------------------------------------------------------------------
# dot::update::bin
# ------------------------------------------------------------------
dot::update::bin()
{
    group 'dot'

	local fileName result

	debugLog "${FUNCNAME[0]}"

	echoHead "Updating .dotfiles binaries"
	while IFS= read -r file
	do
		fileName="$(basename "$file")"
		echoDot "$fileName - " -n
		[ -e "/usr/local/bin/$fileName" ] && sudo rm -f "/usr/local/bin/$fileName"
		sudo ln -s "$file" "/usr/local/bin/$fileName"; result=$?
		if [ "$result" -eq 0 ]; then
			log::info "'$fileName' linked successfully"
			echoAlias "OK" -c "${LT_GREEN}"
		else
			log::error "'$fileName' link failed"
			echoAlias "FAILED!" -c "${RED}"
		fi
	done < <(find "$DOT_BIN" -type f)
}
# ------------------------------------------------------------------
# dot::update::dots
# ------------------------------------------------------------------
dot::update::dots()
{
    group 'dot'

	local -a DOT=()

	debugLog "${FUNCNAME[0]}"

	echoHead "Updating dotfiles"

	[ -d "$HOME/.backup" ] || { mkdir -p "$HOME/.backup" || exitLog "Unable to create directory '$HOME/.backup'" "error"; }
	[ -L "$HOME/.profile" ] && rm -f "$HOME/.profile"
	[ -f "$HOME/.profile" ] && mv -b "$HOME/.profile" "$HOME/.backup/.profile"

	while IFS= read -r file
	do
		DOT=()
		fileName="$(basename "$file")"
		[ -f "$CUSTOM/dots/$fileName" ] && file="$CUSTOM/dots/$fileName"
		mapfile -d "." -t DOT < <(printf '%s' "$fileName")
		echoDot ".${DOT[0]} - " -n
		if [ -L "$HOME/.${DOT[0]}" ]; then
			rm -f "$HOME/.${DOT[0]}"
		elif [ -f "$HOME/.${DOT[0]}" ]; then
			mv -b "$HOME/.${DOT[0]}" "$HOME/.backup/.${DOT[0]}"
		fi
		ln -s "$file" "$HOME/.${DOT[0]}"; result=$?
		if [ "$result" -eq 0 ]; then
			log::info "'.${DOT[0]}' linked successfully"
			echoAlias "OK" -c "${LT_GREEN}"
		else
			log::error "'.${DOT[0]}' link failed"
			echoAlias "FAILED!" -c "${RED}"
		fi
	done < <(find "$DOTS" -maxdepth 1 -type f)
}
# ------------------------------------------------------------------
# dot::update::repo
# ------------------------------------------------------------------
dot::update::repo()
{
    group 'dot'

	local result

	debugLog "${FUNCNAME[0]}"

	echoHead "Updating .dotfiles sources"
	git -C "$DOTFILES" pull; result=$?
	if [ "$result" -eq 0 ]; then
		log::info ".dotfiles sources updated successfully"
		echoAlias "OK" -c "${LT_GREEN}"
	else
		log::error ".dotfiles sources update failed"
		echoAlias "FAILED!" -c "${RED}"
	fi
}
# ------------------------------------------------------------------
# dot::update
# ------------------------------------------------------------------
dot::update()
{
    group 'dot'

	debugLog "${FUNCNAME[0]}"

	dot::update::repo
	dot::update::bin
	dot::update::dots

	echo ""

	read -n 1 -s -r -p "Press any key to continue ..."

	dot::menu
}
