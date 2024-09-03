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
dot::include "log.functions" "dialog.functions"
####################################################################
# DOTFILES MENU FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# dot::menu
# ------------------------------------------------------------------
dot::menu()
{
    group 'dot'

	local -A CFG
	local -a MENUOPTS
	local selected status

	CFG['ok']="OK"
	CFG['cancel']="Cancel"
	CFG['backtitle']="Ragdata's Dotfiles"
	CFG['title']="Main Menu"
	CFG['text']="Select from the following options:"
	# CFG['ht']=""
	# CFG['wt']=""
	# CFG['menuHt']=""

	MENUOPTS=(
		"1" "Install Menu"
		"2" "Update Menu")

	dialog::menu CFG MENUOPTS selected; status=$?
}
# ------------------------------------------------------------------
# dot::menu::install
# ------------------------------------------------------------------
dot::menu::install()
{
    group 'dot'
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
}
# ------------------------------------------------------------------
# dot::install
# ------------------------------------------------------------------
dot::install()
{
	group 'dot'
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
			echoDot "OK" -c "${LT_GREEN}"
		else
			log::error "'$fileName' link failed"
			echoDot "FAILED!" -c "${RED}"
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
			echoDot "OK" -c "${LT_GREEN}"
		else
			log::error "'.${DOT[0]}' link failed"
			echoDot "FAILED!" -c "${RED}"
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
		echoDot "OK" -c "${LT_GREEN}"
	else
		log::error ".dotfiles sources update failed"
		echoDot "FAILED!" -c "${RED}"
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

	dot::menu
}
