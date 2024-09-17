#!/usr/bin/env bash
# shellcheck shell=bash
####################################################################
# dotfiles.help.bash
####################################################################
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# METADATA
####################################################################
group 'help'
####################################################################
# MAIN
####################################################################
echo        ""
echoAlias   "divider" -c "${GOLD}"
echoGold    "${WHITE}'dotfiles'${_0} Command Usage"
echoAlias   "divider" -c "${GOLD}"
echo        ""
echoAlias   "dotfiles <function> <subject> <item>" -c "${WHITE}"
echo        ""
echoAlias   "Functions:" -c "${GOLD}"
echo        ""
echoDot       "show|describe" -c "${LT_GREEN}" -i
echoDot         "aliases" -c "${LT_GREEN}" -i 4
echoDot         "completions" -c "${LT_GREEN}" -i 4
echoDot         "functions" -c "${LT_GREEN}" -i 4
echoDot         "instances" -c "${LT_GREEN}" -i 4
echoDot         "pkgs|packages" -c "${LT_GREEN}" -i 4
echoDot         "plugins" -c "${LT_GREEN}" -i 4
echoDot         "prompts" -c "${LT_GREEN}" -i 4
echoDot         "scripts" -c "${LT_GREEN}" -i 4
echoDot         "stacks" -c "${LT_GREEN}" -i 4
echoDot       "enable" -c "${LT_GREEN}" -i
echoDot         "alias" -c "${LT_GREEN}" -i 4
echoDot         "aliases" -c "${LT_GREEN}" -i 4
echoDot         "completion" -c "${LT_GREEN}" -i 4
echoDot         "completions" -c "${LT_GREEN}" -i 4
echoDot         "plugin" -c "${LT_GREEN}" -i 4
echoDot         "plugins" -c "${LT_GREEN}" -i 4
echoDot       "disable" -c "${LT_GREEN}" -i
echoDot         "alias" -c "${LT_GREEN}" -i 4
echoDot         "aliases" -c "${LT_GREEN}" -i 4
echoDot         "completion" -c "${LT_GREEN}" -i 4
echoDot         "completions" -c "${LT_GREEN}" -i 4
echoDot         "plugin" -c "${LT_GREEN}" -i 4
echoDot         "plugins" -c "${LT_GREEN}" -i 4
echo          ""
echoDot       "help" -c "${LT_GREEN}" -i
echoDot       "log" -c "${LT_GREEN}" -i
echo          ""
echoDot       "install" -c "${LT_GREEN}" -i
echoDot       "config" -c "${LT_GREEN}" -i
echoDot       "remove" -c "${LT_GREEN}" -i
echo          ""
echoDot       "reboot" -c "${LT_GREEN}" -i
echoDot       "restart" -c "${LT_GREEN}" -i
echoDot       "reload" -c "${LT_GREEN}" -i
echo          ""
echoDot       "search" -c "${LT_GREEN}" -i
echo          ""
echoDot       "update" -c "${LT_GREEN}" -i
echo          ""
echoDot       "version" -c "${LT_GREEN}" -i
echo        ""
