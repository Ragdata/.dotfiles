#!/usr/bin/env bash
####################################################################
# .bash_env
####################################################################
# Ragdata's Dotfiles - Dotfile Master
#
# File:         .bash_env
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:		https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

####################################################################
# DOTFILES CONFIGURATION
####################################################################
declare -xa SEARCH_CFG IMPORTS

declare -x ALIASES APPS ASSETS COMPLETIONS CUSTOM FUNCTIONS PKGS
declare -x PLUGINS PROMPTS SHELL TEMP TEMPLATES DOTFILES_VERSION DOTFILES_PROMPT

declare -x DOTFILES DOT_BIN DOT_CFG DOTS DOT_ETC DOT_LIB DOT_REG DOT_LOG

declare -x NODE_IPv4 NODE_HOSTNAME GIT_USER GIT_EMAIL GPG_EMAIL GPG_KEYID SIGN_COMMITS

declare -x LOG_SYSLOG LOG_SIZE LOG_BACKUPS LOG_ARCHIVE LOG_FILE

DOTFILES="$HOME/.dotfiles"

DOT_BIN="$DOTFILES/bin"
DOT_CFG="$DOTFILES/cfg"
DOTS="$DOTFILES/dots"
DOT_ETC="$DOTFILES/etc"
DOT_LIB="$DOTFILES/lib"
DOT_REG="$DOTFILES/reg"

ALIASES="$DOT_LIB/aliases"
APPS="$DOT_LIB/apps"
ASSETS="$DOT_LIB/assets"
COMPLETIONS="$DOT_LIB/completions"
CUSTOM="$DOT_LIB/custom"
FUNCTIONS="$DOT_LIB/functions"
HELP="$DOT_LIB/help"
PKGS="$DOT_LIB/pkgs"
PLUGINS="$DOT_LIB/plugins"
PROMPTS="$DOTS/prompts"
TEMPLATES="$DOT_LIB/templates"

TEMP="$(mktemp -d)"

SEARCH_CFG=("$HOME" "$HOME/.github" "$HOME/.github/.dotfiles" "$DOTFILES" "$DOT_CFG" "$DOTFILES/.github")

DOTFILES_PROMPT="default"
