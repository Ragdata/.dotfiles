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

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# include .bash_env if available
[ -e ~/.bash_env ] && source ~/.bash_env

# load composure to support metadata
source "$DOTFILES/vendor/github.com/composure/composure.sh"
# support internal metadata
cite _about _param _example _group _author

# include .bash_common if available
[ -e ~/.bash_common ] && source ~/.bash_common

# include .bash_functions if available
[ -e ~/.bash_functions ] && source ~/.bash_functions

# include .bash_prompts if available
[ -e ~/.bash_prompts ] && source ~/.bash_prompts

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
[ -e ~/.bash_aliases ] && source ~/.bash_aliases

# BASH completions
[ -e ~/.bash_completions ] && source ~/.bash_completions

#eval "$(declare -F | sed -e 's/-f /-fx /')"
while read -ra func
do
	defn="$(declare -f "${func[2]}")"
	group="$(metafor group <<< "$defn")"
	if [[ "$group" == "bash_common" || "$group" == "bash_functions" ]]; then
		declare -fx "${func[2]}"
	fi
done < <(declare -F)
