#!/usr/bin/env bash
# shellcheck disable=SC1090
####################################################################
# terminal.functions
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         terminal.functions
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# PREFLIGHT
####################################################################
dotImport "$HOME/.dotfiles/cfg/.env.dist"
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
declare -x SYMBOL_ERROR SYMBOL_WARNING SYMBOL_INFO SYMBOL_SUCCESS
declare -x DEFAULT_Y DEFAULT_N
#
# ESCAPE CHARACTERS
#
TERM_ESC=$'\033'
TERM_CSI="${TERM_ESC}["
TERM_OSC="${TERM_ESC}]"
TERM_ST="${TERM_ESC}\\"
####################################################################
# TERMINAL FUNCTIONS
####################################################################
#
# FG COLORS
#
term::color::reset()			{ printf -- '%s0m' "$TERM_CSI"; }
# ------------------------------------------------------------------
term::black()					{ printf -- '%s30m' "$TERM_CSI"; }
term::red()						{ printf -- '%s31m' "$TERM_CSI"; }
term::green()					{ printf -- '%s32m' "$TERM_CSI"; }
term::gold()					{ printf -- '%s33m' "$TERM_CSI"; }
term::blue()					{ printf -- '%s34m' "$TERM_CSI"; }
term::magenta()					{ printf -- '%s35m' "$TERM_CSI"; }
term::cyan()					{ printf -- '%s36m' "$TERM_CSI"; }
term::lt_grey()					{ printf -- '%s37m' "$TERM_CSI"; }
# ------------------------------------------------------------------
term::grey()					{ printf -- '%s90m' "$TERM_CSI"; }
term::pink()					{ printf -- '%s91m' "$TERM_CSI"; }
term::lt_green()				{ printf -- '%s92m' "$TERM_CSI"; }
term::yellow()					{ printf -- '%s93m' "$TERM_CSI"; }
term::lt_blue()					{ printf -- '%s94m' "$TERM_CSI"; }
term::purple()					{ printf -- '%s95m' "$TERM_CSI"; }
term::lt_cyan()					{ printf -- '%s96m' "$TERM_CSI"; }
term::white()					{ printf -- '%s97m' "$TERM_CSI"; }
# ------------------------------------------------------------------
term::color()					{ printf -- '%s38;5;%sm' "$TERM_CSI" "$1"; }
term::rbg()						{ printf -- '%s38;2;%s;%s;%sm' "$TERM_CSI" "$1" "$2" "$3"; }
#
# BG COLORS
#
term::bg::reset()				{ printf -- '%s49m' "$TERM_CSI"; }
# ------------------------------------------------------------------
term::bg::black()				{ printf -- '%s40m' "$TERM_CSI"; }
term::bg::red()					{ printf -- '%s41m' "$TERM_CSI"; }
term::bg::green()				{ printf -- '%s42m' "$TERM_CSI"; }
term::bg::gold()				{ printf -- '%s43m' "$TERM_CSI"; }
term::bg::blue()				{ printf -- '%s44m' "$TERM_CSI"; }
term::bg::magenta()				{ printf -- '%s45m' "$TERM_CSI"; }
term::bg::cyan()				{ printf -- '%s46m' "$TERM_CSI"; }
term::bg::lt_grey()				{ printf -- '%s47m' "$TERM_CSI"; }
# ------------------------------------------------------------------
term::bg::grey()				{ printf -- '%s100m' "$TERM_CSI"; }
term::bg::pink()				{ printf -- '%s101m' "$TERM_CSI"; }
term::bg::lt_green()			{ printf -- '%s102m' "$TERM_CSI"; }
term::bg::yellow()				{ printf -- '%s103m' "$TERM_CSI"; }
term::bg::lt_blue()				{ printf -- '%s104m' "$TERM_CSI"; }
term::bg::purple()				{ printf -- '%s105m' "$TERM_CSI"; }
term::bg::lt_cyan()				{ printf -- '%s106m' "$TERM_CSI"; }
term::bg::white()				{ printf -- '%s107m' "$TERM_CSI"; }
# ------------------------------------------------------------------
term::bg::color()				{ printf -- '%s48;5;%sm' "$TERM_CSI" "$1"; }
term::bg::rbg()					{ printf -- '%s48;2;%s;%s;%sm' "$TERM_CSI" "$1" "$2" "$3"; }
#
# TEXT EFFECTS
#
term::blink()					{ printf -- '%s5m' "$TERM_CSI"; }
term::blink::rapid()			{ printf -- '%s6m' "$TERM_CSI"; }
term::no::blink()				{ printf -- '%s25m' "$TERM_CSI"; }
term::bold()					{ printf -- '%s1m' "$TERM_CSI"; }
term::dim()						{ printf -- '%s2m' "$TERM_CSI"; }
term::italic()					{ printf -- '%s3m' "$TERM_CSI"; }
term::normal()					{ printf -- '%s22m' "$TERM_CSI"; }
term::inverse()					{ printf -- '%s7m' "$TERM_CSI"; }
term::no::inverse()				{ printf -- '%s27m' "$TERM_CSI"; }
term::overline()				{ printf -- '%s53m' "$TERM_CSI"; }
term::no::overline()			{ printf -- '%s55m' "$TERM_CSI"; }
term::underline()				{ printf -- '%s4m' "$TERM_CSI"; }
term::underline::double()		{ printf -- '%s21m' "$TERM_CSI"; }
term::no::underline()			{ printf -- '%s24m' "$TERM_CSI"; }
term::underover()				{ printf -- '%s4;53m' "$TERM_CSI"; }
term::no::underover()			{ printf -- '%s24;55m' "$TERM_CSI"; }
term::invisible()				{ printf -- '%s8m' "$TERM_CSI"; }
term::visible()					{ printf -- '%s28m' "$TERM_CSI"; }
term::plain()					{ printf -- '%s23m' "$TERM_CSI"; }
term::strike()					{ printf -- '%s9m' "$TERM_CSI"; }
term::no::strike()				{ printf -- '%s29m' "$TERM_CSI"; }
####################################################################
# FUNCTION ALIASES
####################################################################
#
# FG ALIASES
#
BLACK="$(term::black)"
RED="$(term::red)"
GREEN="$(term::green)"
GOLD="$(term::gold)"
BLUE="$(term::blue)"
MAGENTA="$(term::magenta)"
CYAN="$(term::cyan)"
LT_GREY="$(term::lt_grey)"
GREY="$(term::grey)"
PINK="$(term::pink)"
LT_GREEN="$(term::lt_green)"
YELLOW="$(term::yellow)"
LT_BLUE="$(term::lt_blue)"
PURPLE="$(term::purple)"
LT_CYAN="$(term::lt_cyan)"
WHITE="$(term::white)"
# ------------------------------------------------------------------
RESET="$(term::color::reset)"
_0="$(term::color::reset)"
#
# BG ALIASES
#
BG_BLACK="$(term::bg::black)"
BG_RED="$(term::bg::red)"
BG_GREEN="$(term::bg::green)"
BG_GOLD="$(term::bg::gold)"
BG_BLUE="$(term::bg::blue)"
BG_MAGENTA="$(term::bg::magenta)"
BG_CYAN="$(term::bg::cyan)"
BG_LT_GREY="$(term::bg::lt_grey)"
BG_GREY="$(term::bg::grey)"
BG_PINK="$(term::bg::pink)"
BG_LT_GREEN="$(term::bg::lt_green)"
BG_YELLOW="$(term::bg::yellow)"
BG_LT_BLUE="$(term::bg::lt_blue)"
BG_PURPLE="$(term::bg::purple)"
BG_LT_CYAN="$(term::bg::lt_cyan)"
BG_WHITE="$(term::bg::white)"
# ------------------------------------------------------------------
BG_RESET="$(term::bg::reset)"
BG_0="$(term::bg::reset)"
#
# TEXT EFFECT ALIASES
#
BLINK="$(term::blink)"
BLINK_RAPID="$(term::blink::rapid)"
NO_BLINK="$(term::no::blink)"
BOLD="$(term::bold)"
DIM="$(term::dim)"
ITALIC="$(term::italic)"
NORMAL="$(term::normal)"
INVERSE="$(term::inverse)"
NO_INVERSE="$(term::no::inverse)"
OVERLINE="$(term::overline)"
NO_OVERLINE="$(term::no::overline)"
UNDERLINE="$(term::underline)"
DOUBLE_UNDERLINE="$(term::underline::double)"
NO_UNDERLINE="$(term::no::underline)"
UNDEROVER="$(term::underover)"
NO_UNDEROVER="$(term::no::underover)"
INVISIBLE="$(term::invisible)"
VISIBLE="$(term::visible)"
PLAIN="$(term::plain)"
STRIKE="$(term::strike)"
NO_STRIKE="$(term::no::strike)"
#
# PRINTABLE
#
DEFAULT_Y="[${WHITE}Y${_0}/n]"
DEFAULT_N="[y/${WHITE}N${_0}]"
#
# ECHO COLOR ALIASES
#
echoBlack()			{ echoAlias "$1" -c "${BLACK}" "${@:2}"; }
echoRed()			{ echoAlias "$1" -c "${RED}" "${@:2}"; }
echoGreen()			{ echoAlias "$1" -c "${GREEN}" "${@:2}"; }
echoGold()			{ echoAlias "$1" -c "${GOLD}" "${@:2}"; }
echoBlue()			{ echoAlias "$1" -c "${BLUE}" "${@:2}"; }
echoMagenta()		{ echoAlias "$1" -c "${MAGENTA}" "${@:2}"; }
echoCyan()			{ echoAlias "$1" -c "${CYAN}" "${@:2}"; }
echoLtGrey()		{ echoAlias "$1" -c "${LT_GREY}" "${@:2}"; }
echoGrey()			{ echoAlias "$1" -c "${GREY}" "${@:2}"; }
echoPink()			{ echoAlias "$1" -c "${PINK}" "${@:2}"; }
echoLtGreen()		{ echoAlias "$1" -c "${LT_GREEN}" "${@:2}"; }
echoYellow()		{ echoAlias "$1" -c "${YELLOW}" "${@:2}"; }
echoLtBlue()		{ echoAlias "$1" -c "${LT_BLUE}" "${@:2}"; }
echoPurple()		{ echoAlias "$1" -c "${PURPLE}" "${@:2}"; }
echoLtCyan()		{ echoAlias "$1" -c "${LT_CYAN}" "${@:2}"; }
echoWhite()			{ echoAlias "$1" -c "${WHITE}" "${@:2}"; }
#
# ECHO STYLE ALIASES
#
echoDebug()			{ echoAlias "${ITALIC}$1${NORMAL}" -c "${WHITE}" "${@:2}"; }
echoDefault()		{ echoAlias "${RESET}$1" "${@:2}"; }
#
# ECHO MESSAGE ALIASES
#
echoError()			{ echoAlias "${SYMBOL_ERROR} $1" -c "${RED}" -E "${@:2}"; }
echoWarning()		{ echoAlias "${SYMBOL_WARNING} $1" -c "${GOLD}" "${@:2}"; }
echoInfo()			{ echoAlias "${SYMBOL_INFO} $1" -c "${BLUE}" "${@:2}"; }
echoSuccess()		{ echoAlias "${SYMBOL_SUCCESS} $1" -c "${LT_GREEN}" "${@:2}"; }
