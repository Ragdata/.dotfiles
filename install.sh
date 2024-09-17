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
# Date:         18/09/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# PREFLIGHT
####################################################################
if [[ "${BASH_VERSION:0:1}" -lt 4 ]]; then
    echo "This script requires a minimum Bash version of 4+"
    exit 1
fi
####################################################################
# DEPENDENCIES
####################################################################
# source environment dot
source "$HOME/.dotfiles/dots/bash_env.bash"
# load composure to support metadata
source "$DOTFILES/vendor/github.com/erichs/composure/composure.sh"
# support internal metadata
cite _about _param _example _group _author usage label
# source common dot
source "$HOME/.dotfiles/dots/bash_common.bash"
# source functions dot
source "$HOME/.dotfiles/dots/bash_functions.bash"
# export core functions into the environment
while read -ra func
do
	defn="$(declare -f "${func[2]}")"
	group="$(metafor group <<< "$defn")"
	if [[ "$group" == "bash_common" || "$group" == "bash_functions" ]]; then
		declare -fx "${func[2]}"
	fi
done < <(declare -F)
# include required functions
dot::include "dotfiles.functions" "alias.functions"
####################################################################
# SETUP & CONFIG
####################################################################
[ -d "$CUSTOM/cfg" ] || { mkdir -p "$CUSTOM/cfg" || errorExit "Unable to create directory '$CUSTOM/cfg'"; }
[ -d "$DOTFILES/log" ] || { mkdir -p "$DOTFILES/log" || errorExit "Unable to create directory '$DOTFILES/log'"; }
[ -d "$DOTFILES/reg" ] || { mkdir -p "$DOTFILES/reg" || errorExit "Unable to create directory '$DOTFILES/reg'"; }
# copy node config file to custom config directory
if [ ! -f "$CUSTOM/cfg/.node" ]; then
    install -v -b -m 0644 -C -D -t "$CUSTOM/cfg" "$DOT_CFG/.node" || exitLog "Unable to install '$CUSTOM/cfg/.node'";
fi
####################################################################
# MAIN
####################################################################
# setup passwordless sudo
if [ ! -f "/etc/sudoers.d/$USER" ]; then
    echoInfo "Removing password requirement for sudo"
    sudo sh -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/$USER"
fi

# update & upgrade
echoInfo "Updating system files"
sudo apt-get -qq -y update && sudo apt-get -qq -y full-upgrade

# check dialog installed
if ! command -v dialog &> /dev/null; then
	echoInfo "Package 'dialog' not found - installing ..."
	sudo apt-get -qq -y install dialog
fi

# enabling dotfile bin aliases
echoInfo "Enabling dotfile bin aliases"
aliasEnable "dot" "general" "filesys" || errorExit "Unable to enable aliases"

# process dots
echoInfo "Processing dotfiles"

[ -d "$HOME/.backup" ] || { mkdir -p "$HOME/.backup" || errorExit "Unable to create directory '$HOME/.backup'"; }
[ -f "$HOME/.profile" ] && mv -b "$HOME/.profile" "$HOME/.backup/.profile"

while IFS= read -r file
do
    DOT=()
    fileName="$(basename "$file")"
    [ -f "$CUSTOM/dots/$fileName" ] && file="$CUSTOM/dots/$fileName"
    mapfile -d "." -t DOT < <(printf '%s' "$fileName")
    echo ".${DOT[0]}"
    if [ -f "$HOME/.${DOT[0]}" ]; then
       mv -b "$HOME/.${DOT[0]}" "$HOME/.backup/.${DOT[0]}"
    fi
    ln -s "$file" "$HOME/.${DOT[0]}" || errorExit "Failed to link '$HOME/.${DOT[0]}' to '$file'"
done < <(find "$DOTS" -maxdepth 1 -type f)

dot::restart
