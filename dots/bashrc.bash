#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC1091
####################################################################
# .bashrc
####################################################################
# Ragdata's Dotfiles - Dotfile Master
#
# File:         .bashrc
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	0https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export LC_ALL="C"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# include .bash_env if available
[ -e ~/.bash_env ] && source ~/.bash_env

# load composure to support metadata
source "$DOTFILES/vendor/github.com/erichs/composure/composure.sh"
# support internal metadata
# about param group author example
cite _about _param _example _group _author usage label
#cite about-alias about-completion about-function about-package
#cite about-plugin about-script about-instance about-stack

# include .bash_common if available
[ -e ~/.bash_common ] && source ~/.bash_common

# include .bash_functions if available
[ -e ~/.bash_functions ] && source ~/.bash_functions

# include .bash_plugins if available
[ -e ~/.bash_plugins ] && source ~/.bash_plugins

# include .bash_prompts if available
[ -e ~/.bash_prompts ] && source ~/.bash_prompts

# include Alias definitions if available
[ -e ~/.bash_aliases ] && source ~/.bash_aliases

# include BASH completions if available
[ -e ~/.bash_completions ] && source ~/.bash_completions

# add .node config to env
if [ -f "$CUSTOM/cfg/.node" ]; then
    dot::include "files.functions"
    file2env "$CUSTOM/cfg/.node"
fi

# export core dotfiles functions
while read -ra func
do
	defn="$(declare -f "${func[2]}")"
	group="$(metafor group <<< "$defn")"
	if [[ "$group" == "bash_common" || "$group" == "bash_functions" ]]; then
		declare -fx "${func[2]}"
	fi
done < <(declare -F)
