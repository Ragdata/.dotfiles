# shellcheck shell=bash
####################################################################
# ENVIRONMENT VARIABLES
####################################################################
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################
# PROMPT
DOTFILES_PROMPT="kali"
#
# PATHS
#
BACKUP="${HOME}/.backup"
BASHRCD="${HOME}/.bashrc.d"
BASEDIR="${HOME}/.dotfiles"

CUSTOM="${BASEDIR}/custom"
SRCDIR="${BASEDIR}/srv"

CFGDIR="${SRVDIR}/cfg"
DOTSDIR="${SRVDIR}/dots"
ETCDIR="${SRVDIR}/etc"
LIBDIR="${SRVDIR}/lib"
LOGDIR="${SRVDIR}/log"

REGISTRY="${SRVDIR}/reg"

ALIASES="${LIBDIR}/aliases"
ASSETS="${LIBDIR}/assets"
COMPLETIONS="${LIBDIR}/completions"
FUNCTIONS="${LIBDIR}/functions"
HELPDIR="${LIBDIR}/help"
PACKAGES="${LIBDIR}/pkgs"
PLUGINS="${LIBDIR}/plugins"
SCRIPTS="${LIBDIR}/scripts"
STACKS="${LIBDIR}/stacks"
TEMPLATES="${LIBDIR}/templates"
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
SYMBOL_SUCCESS="🗸"
SYMBOL_TIP="★"
SYMBOL_IMPORTANT="⚑"
SYMBOL_HEAD="➤ "
SYMBOL_DOT="⦁"
