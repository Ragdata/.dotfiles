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
declare -xa SEARCH_CFG SEARCH_DOWNLOAD IMPORTS

declare -x ALIASES ASSETS COMPLETIONS CUSTOM FUNCTIONS HELP PKGS SCRIPTS
declare -x PLUGINS PROMPTS SHELL TEMP TEMPLATES INSTANCES DOTFILES_VERSION DOTFILES_PROMPT

declare -x DOTFILES DOT_BIN DOT_CFG DOTS DOT_ETC DOT_LIB DOT_REG DOT_LOG DOT_SRC TEMP

declare -x LOG_SYSLOG LOG_SIZE LOG_BACKUPS LOG_ARCHIVE LOG_LEVEL DOT_DEBUG=0

declare -x NODE_IPv4 NODE_HOSTNAME GIT_USER GIT_EMAIL GPG_EMAIL GPG_KEYID SIGN_COMMITS

DOTFILES_VERSION="v0.1.0"

DOTFILES="$HOME/.dotfiles"

DOT_BIN="$DOTFILES/bin"
DOT_CFG="$DOTFILES/cfg"
CUSTOM="$DOTFILES/custom"
DOTS="$DOTFILES/dots"
DOT_ETC="$DOTFILES/etc"
DOT_LIB="$DOTFILES/lib"
DOT_LOG="$DOTFILES/log"
DOT_REG="$DOTFILES/reg"
DOT_SRC="$DOTFILES/src"

ALIASES="$DOT_LIB/aliases"
ASSETS="$DOT_LIB/assets"
COMPLETIONS="$DOT_LIB/completions"
FUNCTIONS="$DOT_LIB/functions"
HELP="$DOT_LIB/help"
INSTANCES="$DOT_SRC/instances"
PKGS="$DOT_LIB/pkgs"
PLUGINS="$DOT_LIB/plugins"
PROMPTS="$DOTS/prompts"
SCRIPTS="$DOT_LIB/scripts"
TEMPLATES="$DOT_LIB/templates"

TEMP="$(mktemp -d)"

SEARCH_CFG=("$HOME" "$HOME/.github" "$HOME/.github/.dotfiles" "$DOTFILES" "$DOT_CFG" "$DOTFILES/.github")
SEARCH_DOWNLOAD=("$HOME/Downloads" "/f/Libraries/Downloads/Compressed")

DOTFILES_PROMPT="default"

LOG_SYSLOG=0
LOG_SIZE=1048576
LOG_BACKUPS=5
LOG_ARCHIVE=1
LOG_LEVEL="INFO"

####################################################################
# DIALOG VARIABLES
####################################################################

declare -rx DIALOG_OK=0
declare -rx DIALOG_CANCEL=1
declare -rx DIALOG_HELP=2
declare -rx DIALOG_EXTRA=3
declare -rx DIALOG_ITEM_HELP=4
declare -rx DIALOG_ERROR=254
declare -rx DIALOG_ESC=255

declare -rx SIG_NONE=0
declare -rx SIG_HUP=1
declare -rx SIG_INT=2
declare -rx SIG_QUIT=3
declare -rx SIG_KILL=9
declare -rx SIG_TERM=15

####################################################################
# TERMINAL VARIABLES
####################################################################
declare -x TERM_ESC TERM_CSI TERM_OSC TERM_ST BG_RESET BG_0
declare -x RESET _0 BLACK RED GREEN GOLD BLUE MAGENTA CYAN LT_GREY
declare -x GREY PINK LT_GREEN YELLOW LT_BLUE PURPLE LT_CYAN WHITE
declare -x BG_BLACK BG_RED BG_GREEN BG_GOLD BG_BLUE BG_MAGENTA BG_CYAN BG_LT_GREY
declare -x BG_GREY BG_PINK BG_LT_GREEN BG_YELLOW BG_LT_BLUE BG_PURPLE BG_LT_CYAN BG_WHITE
declare -x BLINK BLINK_RAPID NO_BLINK BOLD ITALIC NORMAL DIM INVERSE NO_INVERSE
declare -x OVERLINE NO_OVERLINE UNDERLINE DOUBLE_UNDERLINE NO_UNDERLINE
declare -x UNDEROVER NO_UNDEROVER INVISIBLE VISIBLE PLAIN STRIKE NO_STRIKE
declare -x SYMBOL_ERROR SYMBOL_WARNING SYMBOL_INFO SYMBOL_SUCCESS SYMBOL_HEAD SYMBOL_DOT
declare -x DEFAULT_Y DEFAULT_N
#
# ESCAPE CHARACTERS
#
TERM_ESC=$'\033'
TERM_CSI="${TERM_ESC}["
TERM_OSC="${TERM_ESC}]"
TERM_ST="${TERM_ESC}\\"
#
# SYMBOLS
#
# ➤ ➜ 🡆 🠶 ▶ ▷
# ✖ 🞮 ✗ ✘ 🗴 🗶 🛇 ⮾ ⮿
# ✓ ✔ 🗸
# ☐ ☑ 🗹 ☒ 🗵 🗷
# • ⦁ ●
# ⮋ ⮈ ⮊ ⮉ ⮟
# ⚠ 🛆 🛈 ⯑
# ✚ ▬ ╺ ╸ ⚑
# ★ ☆ ✪ ⍟
# ☠ ☢ ☣ ☮ ☯ ♻ ⚙ ⏲ ℜ
#
SYMBOL_ERROR="✘"
SYMBOL_WARNING="🛆"
SYMBOL_INFO="✚"
SYMBOL_SUCCESS="✔"
SYMBOL_HEAD="➤ "
SYMBOL_DOT="⦁"
