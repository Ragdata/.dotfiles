#!/usr/bin/env bash
# shellcheck disable=SC1090
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
[ -f ~/.bash_env ] && source ~/.bash_env

# include .bash_common if available
[ -f ~/.bash_common ] && source ~/.bash_common

# include .bash_functions if available
[ -f ~/.bash_functions ] && source ~/.bash_functions

# include .bash_prompts if available
[ -f ~/.bash_prompts ] && source ~/.bash_prompts

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# BASH completions
[ -f ~/.bash_completions ] && source ~/.bash_completions
