#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2034
####################################################################
# harden.bash
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         harden.bash
# Author:       Ragdata
# Date:         04/09/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# ATTRIBUTION
####################################################################
# Much of the code in this script I shamelessly ripped off from
# The Hardening Ubuntu project - Copyright 2018 Thomas Sjögren
# https://github.com/konstruktoid/hardening
####################################################################
# PREFLIGHT
####################################################################
# capture stderr
# shellcheck disable=SC2093
#exec 2>>"$DOT_LOG/stderr.log"
# if script is called with 'debug' as the first argument, set debug mode
if [ "${1,,}" == "debug" ]; then
	shift
	DOT_DEBUG=1
fi
if [ "$DOT_DEBUG" -eq 1 ]; then
 	set -axETo pipefail
	export LOG_LEVEL="DEBUG"
else
 	set -aETo pipefail
fi
#set -aeETo pipefail
shopt -s inherit_errexit
####################################################################
# DEPENDENCIES
####################################################################
# required library files
dot::include "log.functions"
####################################################################
# MAIN FUNCTION
####################################################################
harden::main()
{
	clear

	# shellcheck disable=SC1091
	source "$APPS"/harden/cfg/.ubuntu

	readonly ADDUSER
	readonly ADMINEMAIL
	readonly ARPBIN
	readonly AUDITDCONF
	readonly AUDITD_MODE
	readonly AUDITD_RULES
	readonly AUDITRULES
	readonly AUTOFILL
	readonly CHANGEME
	readonly COMMONACCOUNT
	readonly COMMONAUTH
	readonly COMMONPASSWD
	readonly COREDUMPCONF
	readonly DEFAULTGRUB
	readonly DIGBIN
	readonly DISABLEFS
	readonly DISABLEMOD
	readonly DISABLENET
	readonly FAILLOCKCONF
	readonly FW_ADMIN
	readonly JOURNALDCONF
	readonly KEEP_SNAPD
	readonly LIMITSCONF
	readonly LOGINDCONF
	readonly LOGINDEFS
	readonly LOGROTATE
	readonly LOGROTATE_CONF
	readonly LXC
	readonly NTPSERVERPOOL
	readonly PAMLOGIN
	readonly PINGBIN
	readonly PSADCONF
	readonly PSADDL
	readonly RESOLVEDCONF
	readonly RKHUNTERCONF
	readonly RSYSLOGCONF
	readonly SECURITYACCESS
	readonly SERVERIP
	readonly SSHDFILE
	readonly SSHFILE
	readonly SSH_GRPS
	readonly SSH_PORT
	readonly SYSCTL
	readonly SYSCTL_CONF
	readonly SYSTEMCONF
	readonly TIMEDATECTL
	readonly TIMESYNCD
	readonly UFWDEFAULT
	readonly USERADD
	readonly USERCONF
	readonly VERBOSE
	readonly WBIN
	readonly WHOBIN

	for s in "$APPS"/harden/scripts/*
	do
		[ -f "$s" ] && source "$s"
	done

	dot::kernel
	dot::firewall
	dot::disablenet
	dot::disablemod
	dot::systemdconf
	dot::logindconf
	dot::journalctl
	dot::timesyncd
	dot::hosts
}

