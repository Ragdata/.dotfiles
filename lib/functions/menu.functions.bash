#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2034
####################################################################
# menu.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         menu.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# DEPENDENCIES
####################################################################
dot::include "dotfiles.functions"
####################################################################
# DOTFILES MENU FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# menu
# ------------------------------------------------------------------
menu()
{
    group 'dot'

	debugLog "${FUNCNAME[0]}"

	local result
	local DIALOG_BACKTITLE="Ragdata's Dotfiles $DOTFILES_VERSION"
	local DIALOG_TITLE="MAIN MENU"
	local DIALOG_TEXT="Select from the following options:"
	local -a DIALOG_OPTIONS=(
		"1" "Install Menu"
		"2" "Update Menu"
		"3" "Network Menu"
		"4" "WSL Menu"
		"" ""
		"5" "Help Menu"
		"6" "Settings"
		"" ""
		"Q" "Quit"
	)

    trap 'clear' ERR

	result=$(dialog --ok-label "${OK_LABEL:-"OK"}" --cancel-label "${CANCEL_LABEL:-"Cancel"}" \
		--backtitle "${DIALOG_BACKTITLE}" --title "${DIALOG_TITLE}" --clear \
		--menu "${DIALOG_TEXT}" "${HEIGHT:-15}" "${WIDTH:-50}" "${MENU_HEIGHT:-8}" \
		"${DIALOG_OPTIONS[@]}" 3>&1 1>&2 2>&3)

	status=$?

	clear

	case "$status" in
		"$DIALOG_OK")
			case "$result" in
				1)	menu::install;;
				2)	menu::update;;
                3)  menu::network;;
				4)	menu::wsl;;
				5)	menu::help;;
				6)	menu::config;;

				Q)	exit 0;;
			esac
			;;
		"$DIALOG_CANCEL"|"$DIALOG_ESC")
			exit 0;;
	esac
}
# ------------------------------------------------------------------
# menu::config
# ------------------------------------------------------------------
menu::config()
{
    group 'dot'

	debugLog "${FUNCNAME[0]}"

	local result
	local DIALOG_BACKTITLE="Ragdata's Dotfiles $DOTFILES_VERSION"
	local DIALOG_TITLE="SETTINGS MENU"
	local DIALOG_TEXT="Select from the following options:"
	local -a DIALOG_OPTIONS=(
		"1" "Theme Menu"
		"" ""
		"X" "Back to Main Menu"
	)

    trap 'clear' ERR

	result=$(dialog --ok-label "${OK_LABEL:-"OK"}" --cancel-label "${CANCEL_LABEL:-"Cancel"}" \
		--backtitle "${DIALOG_BACKTITLE}" --title "${DIALOG_TITLE}" --clear \
		--menu "${DIALOG_TEXT}" "${HEIGHT:-15}" "${WIDTH:-50}" "${MENU_HEIGHT:-5}" \
		"${DIALOG_OPTIONS[@]}" 3>&1 1>&2 2>&3)

	status=$?

	clear

	case "$status" in
		"$DIALOG_OK")
			case "$result" in
				1)	menu::config::theme;;

				X)	menu;;
			esac
			;;
		"$DIALOG_CANCEL"|"$DIALOG_ESC")
			exit 0;;
	esac
}
# ------------------------------------------------------------------
# menu::config::theme
# ------------------------------------------------------------------
menu::config::theme()
{
    group 'dot'

	debugLog "${FUNCNAME[0]}"

	local result
	local DIALOG_BACKTITLE="Ragdata's Dotfiles $DOTFILES_VERSION"
	local DIALOG_TITLE="THEME MENU"
	local DIALOG_TEXT="Select from the following options:"
	local -a DIALOG_OPTIONS=(
		"1" "Debian"
		"2" "Redeyed"
		"3" "Slackware"
		"4" "Sourcemage"
		"5" "SUSE"
		"6" "Whiptail"
		"" ""
		"X" "Back to Config Menu"
	)

    trap 'clear' ERR

	result=$(dialog --ok-label "${OK_LABEL:-"OK"}" --cancel-label "${CANCEL_LABEL:-"Cancel"}" \
		--backtitle "${DIALOG_BACKTITLE}" --title "${DIALOG_TITLE}" --clear \
		--menu "${DIALOG_TEXT}" "${HEIGHT:-15}" "${WIDTH:-50}" "${MENU_HEIGHT:-5}" \
		"${DIALOG_OPTIONS[@]}" 3>&1 1>&2 2>&3)

	status=$?

	clear

	case "$status" in
		"$DIALOG_OK")
			case "$result" in
				1) theme=".debianrc";;
				2) theme=".redeyedrc";;
				3) theme=".slackwarerc";;
				4) theme=".sourcemagerc";;
				5) theme=".suserc";;
				6) theme=".whiptailrc";;

				X)	menu::config;;
			esac
			;;
		"$DIALOG_CANCEL"|"$DIALOG_ESC")
			exit 0;;
	esac

	clear

	if [ -f "$DOT_LIB/dialog/themes/$theme" ]; then
		[ -f "$HOME/.dialogrc" ] && rm -f "$HOME/.dialogrc"
		cp "$DOT_LIB/dialog/themes/$theme" "$HOME/.dialogrc"
	fi

	menu::config::theme
}
# ------------------------------------------------------------------
# menu::help
# ------------------------------------------------------------------
menu::help()
{
    group 'dot'

	debugLog "${FUNCNAME[0]}"

	local result
	local DIALOG_BACKTITLE="Ragdata's Dotfiles $DOTFILES_VERSION"
	local DIALOG_TITLE="HELP MENU"
	local DIALOG_TEXT="Select from the following options:"
	local -a DIALOG_OPTIONS=(
		"X" "Back to Main Menu"
	)

    trap 'clear' ERR

	result=$(dialog --ok-label "${OK_LABEL:-"OK"}" --cancel-label "${CANCEL_LABEL:-"Cancel"}" \
		--backtitle "${DIALOG_BACKTITLE}" --title "${DIALOG_TITLE}" --clear \
		--menu "${DIALOG_TEXT}" "${HEIGHT:-15}" "${WIDTH:-50}" "${MENU_HEIGHT:-5}" \
		"${DIALOG_OPTIONS[@]}" 3>&1 1>&2 2>&3)

	status=$?

	clear

	case "$status" in
		"$DIALOG_OK")
			case "$result" in
				X)	menu;;
			esac
			;;
		"$DIALOG_CANCEL"|"$DIALOG_ESC")
			exit 0;;
	esac
}
# ------------------------------------------------------------------
# menu::install
# ------------------------------------------------------------------
menu::install()
{
    group 'dot'

	debugLog "${FUNCNAME[0]}"

	local result
	local DIALOG_BACKTITLE="Ragdata's Dotfiles $DOTFILES_VERSION"
	local DIALOG_TITLE="INSTALL MENU"
	local DIALOG_TEXT="Select from the following options:"
	local -a DIALOG_OPTIONS=(
		"1" "Install Dependencies"
		"2" "Select Package Bundles to Install"
		"" ""
		"X" "Back to Main Menu"
	)

    trap 'clear' ERR

	result=$(dialog --ok-label "${OK_LABEL:-"OK"}" --cancel-label "${CANCEL_LABEL:-"Cancel"}" \
		--backtitle "${DIALOG_BACKTITLE}" --title "${DIALOG_TITLE}" --clear \
		--menu "${DIALOG_TEXT}" "${HEIGHT:-15}" "${WIDTH:-50}" "${MENU_HEIGHT:-5}" \
		"${DIALOG_OPTIONS[@]}" 3>&1 1>&2 2>&3)

	status=$?

	clear

	case "$status" in
		"$DIALOG_OK")
			case "$result" in
				1)	dot::install::repos
				    dot::install::deps;;
                2)  menu;;

				X)	menu;;
			esac
			;;
		"$DIALOG_CANCEL"|"$DIALOG_ESC")
			exit 0;;
	esac
}
# ------------------------------------------------------------------
# menu::network
# ------------------------------------------------------------------
menu::network()
{
    group 'dot'

	debugLog "${FUNCNAME[0]}"

	local result
	local DIALOG_BACKTITLE="Ragdata's Dotfiles $DOTFILES_VERSION"
	local DIALOG_TITLE="NETWORK MENU"
	local DIALOG_TEXT="Select from the following options:"
	local -a DIALOG_OPTIONS=(
	    "1" "Update Hostname"
	    "" ""
		"X" "Back to Main Menu"
	)

    trap 'clear' ERR

	result=$(dialog --ok-label "${OK_LABEL:-"OK"}" --cancel-label "${CANCEL_LABEL:-"Cancel"}" \
		--backtitle "${DIALOG_BACKTITLE}" --title "${DIALOG_TITLE}" --clear \
		--menu "${DIALOG_TEXT}" "${HEIGHT:-15}" "${WIDTH:-50}" "${MENU_HEIGHT:-5}" \
		"${DIALOG_OPTIONS[@]}" 3>&1 1>&2 2>&3)

	status=$?

	clear

	case "$status" in
		"$DIALOG_OK")
			case "$result" in
			    1)  dot::network::hostname;;
				X)	menu;;
			esac
			;;
		"$DIALOG_CANCEL"|"$DIALOG_ESC")
			exit 0;;
	esac
}
# ------------------------------------------------------------------
# menu::update
# ------------------------------------------------------------------
menu::update()
{
    group 'dot'

	debugLog "${FUNCNAME[0]}"

	local result
	local DIALOG_BACKTITLE="Ragdata's Dotfiles $DOTFILES_VERSION"
	local DIALOG_TITLE="UPDATE MENU"
	local DIALOG_TEXT="Select from the following options:"
	local -a DIALOG_OPTIONS=(
		"1" "Update Dotfiles"
		"2" "Update System"
		"" ""
		"X" "Back to Main Menu"
	)

    trap 'clear' ERR

	result=$(dialog --ok-label "${OK_LABEL:-"OK"}" --cancel-label "${CANCEL_LABEL:-"Cancel"}" \
		--backtitle "${DIALOG_BACKTITLE}" --title "${DIALOG_TITLE}" --clear \
		--menu "${DIALOG_TEXT}" "${HEIGHT:-15}" "${WIDTH:-50}" "${MENU_HEIGHT:-5}" \
		"${DIALOG_OPTIONS[@]}" 3>&1 1>&2 2>&3)

	status=$?

	clear

	case "$status" in
		"$DIALOG_OK")
			case "$result" in
				1)	dot::update;;
				2)	dot::update::sys;;

				X)	menu;;
			esac
			;;
		"$DIALOG_CANCEL"|"$DIALOG_ESC")
			exit 0;;
	esac
}
# ------------------------------------------------------------------
# menu::wsl
# ------------------------------------------------------------------
menu::wsl()
{
    group 'dot'

	debugLog "${FUNCNAME[0]}"

	local result
	local DIALOG_BACKTITLE="Ragdata's Dotfiles $DOTFILES_VERSION"
	local DIALOG_TITLE="WSL MENU"
	local DIALOG_TEXT="Select from the following options:"
	local -a DIALOG_OPTIONS=(
		"X" "Back to Main Menu"
	)

    trap 'clear' ERR

	result=$(dialog --ok-label "${OK_LABEL:-"OK"}" --cancel-label "${CANCEL_LABEL:-"Cancel"}" \
		--backtitle "${DIALOG_BACKTITLE}" --title "${DIALOG_TITLE}" --clear \
		--menu "${DIALOG_TEXT}" "${HEIGHT:-15}" "${WIDTH:-50}" "${MENU_HEIGHT:-5}" \
		"${DIALOG_OPTIONS[@]}" 3>&1 1>&2 2>&3)

	status=$?

	clear

	case "$status" in
		"$DIALOG_OK")
			case "$result" in
				X)	menu;;
			esac
			;;
		"$DIALOG_CANCEL"|"$DIALOG_ESC")
			exit 0;;
	esac
}
