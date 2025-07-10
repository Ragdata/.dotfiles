#!/usr/bin/env bash
####################################################################
# filesys.functions.bash
####################################################################
# Author:       Ragdata
# Date:         02/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

# ------------------------------------------------------------------
# mkcd
# @description Create a directory and change into it
# ------------------------------------------------------------------
mkcd()
{
	mkdir -p "$*" && cd
}
# ------------------------------------------------------------------
