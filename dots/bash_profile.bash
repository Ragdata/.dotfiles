#!/usr/bin/env bash
####################################################################
# bash_profile.bash
####################################################################
# Ragdata's Dotfiles - Dotfile Master
#
# File:         bash_profile.bash
# Author:       Ragdata
# Date:         22/08/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# If not running interactively, do nothing
case $- in
	*i*) ;;
	  *) return;;
esac

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# add .dotfiles path to ENV
[ -d "$HOME/.dotfiles" ] && export DOTFILES="$HOME/.dotfiles"

# set PATH so it includes user's private bin if it exists
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

# set PATH so it includes user's private bin if it exists
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

# set PATH so it includes important .dotfile directories
[ -d "$DOTFILES/bin" ] && PATH="$DOTFILES/bin:$PATH"

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    [ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc";
fi
