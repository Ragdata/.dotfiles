#!/usr/bin/env bash

#-------------------------------------------------------------------
# SETUP SHELL
#-------------------------------------------------------------------
# First make sure ~/.history has not been truncated
if [[ $(wc -l ~/.history | awk '{print $1}') -lt 1000 ]]; then
	echo "NOTE: ~/.history appears to have been truncated. Please check your shell configuration."
fi

# History Settings
HISTCONTROL=ignoreboth:erasedups
HISTFILE=$HOME/.history
HISTFILESIZE=99999
HISTIGNORE=?:??
HISTSIZE=99999

# Enable useful shell options:
#  - autocd - change directory without no need to type 'cd' when changing directory
#  - cdspell - automatically fix directory typos when changing directory
#  - direxpand - automatically expand directory globs when completing
#  - dirspell - automatically fix directory typos when completing
#  - globstar - ** recursive glob
#  - histappend - append to history, don't overwrite
#  - histverify - expand, but don't automatically execute, history expansions
#  - nocaseglob - case-insensitive globbing
#  - no_empty_cmd_completion - do not TAB expand empty lines
shopt -s autocd cdspell direxpand dirspell globstar histappend histverify nocaseglob no_empty_cmd_completion

# Prevent file overwrite on stdout redirection.
# Use `>|` to force redirection to an existing file.
set -o noclobber

# Only logout if 'Control-d' is executed two consecutive times.
export IGNOREEOF=1

# Set preferred umask.
umask 002

# Disable Alacritty icon bouncing for interactive shells.
# Refer to: https://is.gd/8MPdGh
if [[ $- =~ i ]]; then
	printf "\e[?1042l"
fi
# PROMPT_COMMAND='history -a'

#-------------------------------------------------------------------
# ENV VARS
#-------------------------------------------------------------------
DOTFILES_PROMPT="kali"
#
# PATHS
#
BACKUP="${HOME}/.backup"
BASHRCD="${HOME}/.bashrc.d"
BASEDIR="${HOME}/.dotfiles"
CUSTOM="${BASEDIR}/custom"
DOTSDIR="${BASEDIR}/dots"
DOT_ETC="${BASEDIR}/etc"
DOT_LOG="${BASEDIR}/logs"
REGISTRY="${BASEDIR}/reg"
DOT_SYS="${BASEDIR}/sys"
DOT_CFG="${DOT_SYS}/cfg"
DOT_LIB="${DOT_SYS}/lib"

ALIASES="${DOT_LIB}/aliases"
COMPLETIONS="${DOT_LIB}/completions"
FUNCTIONS="${DOT_LIB}/functions"
PACKAGES="${DOT_LIB}/pkgs"
PLUGINS="${DOT_LIB}/plugins"
SCRIPTS="${DOT_LIB}/scripts"
TEMPLATES="${DOT_LIB}/templates"
#
# ESCAPE CHARACTERS
#
TERM_ESC=$'\033'
TERM_CSI="${TERM_ESC}["
TERM_OSC="${TERM_ESC}]"
TERM_ST="${TERM_ESC}\\"
#
# MESSAGE SYMBOLS
#
SYMBOL_ERROR="✘"
SYMBOL_WARNING="🛆"
SYMBOL_INFO="✚"
SYMBOL_SUCCESS="✔"
SYMBOL_HEAD="➤ "
SYMBOL_DOT="⦁"
