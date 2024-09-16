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
dot::include "log.functions" "pkg.functions" "alias.functions" "menu.functions"
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

	debugLog "${FUNCNAME[0]}"

	local result source

	xdg-user-dirs-update

	echoDot "Updating package database" -s "➤" -c "${GOLD}"
    sudo apt-get -qq -y update

    if [ -f "$CUSTOM/cfg/data/dependencies.list" ]; then
        source="$CUSTOM/cfg/data"
    else
        source="$DOT_CFG/data"
    fi

	if [ -d "$source" ]; then
        echo ""
		echoDot "Installing configured dependencies" -s "➤" -c "${GOLD}"
		pkg::installList "dependencies" "$DOT_CFG/data"
	fi
}
# ------------------------------------------------------------------
# dot::install::repos
# ------------------------------------------------------------------
dot::install::repos()
{
	group 'dot'

	debugLog "${FUNCNAME[0]}"

	local result source

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

    if [ -f "$CUSTOM/cfg/data/repos.list" ]; then
        source="$CUSTOM/cfg/data/repos.list"
    else
        source="$DOT_CFG/data/repos.list"
    fi

	if [ -f "$source" ]; then
		echoDot "Adding configured repositories" -s "➤" -c "${GOLD}"
		while IFS= read -r line
		do
		    [ "${line:0:1}" != "#" ] && pkg::addRepo "$line"
		done < "$source"
	fi
}
# ------------------------------------------------------------------
# dot::config::pkg
# ------------------------------------------------------------------
dot::config::pkg()
{
	group 'dot'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local pkg="${1?}" result

	pkg::config "$pkg"
}
# ------------------------------------------------------------------
# dot::install::pkg
# ------------------------------------------------------------------
dot::install::pkg()
{
	group 'dot'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local pkg="${1?}" result

	pkg::install "$pkg"
}
# ------------------------------------------------------------------
# dot::remove::pkg
# ------------------------------------------------------------------
dot::remove::pkg()
{
	group 'dot'

	debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

	local pkg="${1?}" result

	pkg::remove "$pkg"
}
# ------------------------------------------------------------------
# dot::install
# ------------------------------------------------------------------
dot::install()
{
	group 'dot'

#   dot::install::repos
#	dot::install::deps
#
#	echo ""
#
#	read -n 1 -s -r -p "Press any key to continue ..."

	menu::install
}
####################################################################
# DOTFILES LAUNCH FUNCTIONS
####################################################################
# ------------------------------------------------------------------
# dot::launch::instance
# ------------------------------------------------------------------
dot::launch::instance()
{
    group 'dot'

    debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

    local result path

    if [ -f "$INSTANCES/$1.bash" ]; then
        path="$INSTANCES/$1.bash"
    else
        exitLog "Instance file '$1' not found"
    fi

    source "$path"
}
# ------------------------------------------------------------------
# dot::launch::script
# ------------------------------------------------------------------
dot::launch::script()
{
    group 'dot'

    debugLog "${FUNCNAME[0]}"

	(($# < 1)) && exitLog "Missing Argument(s)"

    local result path func name="${1//[$'\t\n\r']}"

    if [ -f "$SCRIPTS/$name" ]; then
        path="$SCRIPTS/$name"
    else
        exitLog "Script file '$name' not found"
    fi

    source "$path"

    func="script::$name"

    [[ $(type -t "$func") == "function" ]] || exitLog "Script function '$func' not found"

    eval "$func"; result=$?

    return $result
}
####################################################################
# DOTFILES NETWORK FUNCTIONS
####################################################################
dot::network::hostname()
{
    group 'dot'

	debugLog "${FUNCNAME[0]}"

	local result oldhost status
	local DIALOG_BACKTITLE="Ragdata's Dotfiles $DOTFILES_VERSION"
	local DIALOG_TITLE="UPDATE HOSTNAME"
	local DIALOG_TEXT="Enter data and press OK:"

    oldhost="$(hostname)"

	local -a DIALOG_ITEMS=(
        "Hostname :" 1 1 "$oldhost" 1 20 20 50 0
	)

    trap 'clear' ERR

    exec 3>&1

    result=$(dialog --insecure --extra-button --extra-label "Menu" --ok-label "${OK_LABEL:-OK}" --cancel-label "${CANCEL_LABEL:-Cancel}" \
        --backtitle "${DIALOG_BACKTITLE}" --title "${DIALOG_TITLE}" --clear \
        --mixedform "${DIALOG_TEXT}" "${HEIGHT:-15}" "${WIDTH:-50}" "${LIST_HEIGHT:-5}" \
        "${DIALOG_ITEMS[@]}" 2>&1 1>&3)

	status=$?

    exec 3>&-

	clear

    # shellcheck disable=SC2254
	case $status in
		$DIALOG_OK)
            sudo sed -i 's/^#hostname/hostname/' /etc/wsl.conf
            sudo sed -i "s/^hostname.*/hostname = $result/" /etc/wsl.conf
            sudo sed -i "s/$oldhost/$result/g" /etc/hosts
            sudo hostnamectl set-hostname "$result"
            menu::network;;
        $DIALOG_EXTRA)
            menu::network;;
		$DIALOG_CANCEL|$DIALOG_ESC)
			exit 0;;
	esac

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

    local fileName shortcut result

    debugLog "${FUNCNAME[0]}"

    echoHead "Enabling dofiles bin aliases"

    echoDot "Enabling dot.aliases - " -n

    alias::enable "dot"; result=$?

    if [ "$result" -eq 0 ]; then
        log::info "Aliases file 'dot.aliases' enabled successfully"
        echoDot "OK" -c "${LT_GREEN}"
    else
        log::error "Enabling aliases file 'dot.aliases' failed"
        echoDot "FAILED!" -c "${RED}"
    fi

    return $return
}
# ------------------------------------------------------------------
# dot::update::config
# ------------------------------------------------------------------
dot::update::config()
{
    group 'dot'

    debugLog "${FUNCNAME[0]}"

    echoHead "Updating config"

    [ -d "$CUSTOM/cfg" ] || { mkdir -p "$CUSTOM/cfg" || exitLog "Unable to create directory '$CUSTOM/cfg'"; }

    if [ -f "$CUSTOM/cfg/.node" ]; then
        echoDot "Skipped"
    else
        install -v -b -m 0644 -C -D -t "$CUSTOM/cfg" "$DOT_CFG/.node" || exitLog "Unable to install '$CUSTOM/cfg/.node'";
    fi
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

    [ -d "$HOME/.backup" ] || { mkdir -p "$HOME/.backup" || exitLog "Unable to create directory '$HOME/.backup'"; }
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

    [ -d "$CUSTOM" ] || { mkdir -p "$CUSTOM" || exitLog "Unable to create directory '$CUSTOM'"; }
    [ -d "$DOT_REG" ] || { mkdir -p "$DOT_REG" || exitLog "Unable to create directory '$DOT_REG'"; }

    dot::update::repo
    dot::update::config
    dot::update::bin
    dot::update::dots

    echo ""

    read -n 1 -s -r -p "Press any key to continue ..."

    echo ""
    echo ""

    bash -i
}
