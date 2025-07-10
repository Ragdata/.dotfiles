#!/usr/bin/env bash
####################################################################
# general.functions.bash
####################################################################
# Author:       Ragdata
# Date:         02/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

# ------------------------------------------------------------------
# pathAppend
# @description Append to the global PATH variable
# ------------------------------------------------------------------
pathAppend() { if ! [[ "$PATH" = *"$1"* ]]; then export PATH="$PATH:$1"; fi; return 0; }
# ------------------------------------------------------------------
# pathPrepend
# @description Prepend to the global PATH variable
# ------------------------------------------------------------------
pathPrepend() { if ! [[ "$PATH" = *"$1"* ]]; then export PATH="$1:$PATH"; fi; return 0; }
# ------------------------------------------------------------------

