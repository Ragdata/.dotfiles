#!/usr/bin/env bash
####################################################################
# functions.bash
####################################################################
# Author:       Ragdata
# Date:         22/08/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################
# ------------------------------------------------------------------
# dot::reboot
# ------------------------------------------------------------------
# dot::reboot() { sudo systemctl reboot; }
# ------------------------------------------------------------------
# reload
# ------------------------------------------------------------------
reload() { source "$HOME/.bashrc"; }
# ------------------------------------------------------------------
# relog
# ------------------------------------------------------------------
relog() { reset; exec sudo --login --user "$USER" /bin/sh -c "cd '$PWD'; exec '$SHELL' -l"; }
# ------------------------------------------------------------------
# errorExit
# ------------------------------------------------------------------
errorExit()
{
	local msg="ERROR :: " code="${2:-1}"

	[[ -n "${FUNCNAME[1]}" ]] && msg+="${FUNCNAME[1]} - "
	[[ -n "$1" ]] && msg+="$1"

	echoError "$msg"
	exit "$code"
}
# ------------------------------------------------------------------
# is::installed
# ------------------------------------------------------------------
installed()
{
    local cmd="$1"
    if [[ -z "$cmd" ]]; then
        echoError "No package provided to check installation."
        return 1
    fi

    if ! dpkg -l | grep -q "$cmd"; then
        echoError "Package '$cmd' is not installed."
        return 1
    fi

    return 0
}
# ------------------------------------------------------------------
# setPerms
# ------------------------------------------------------------------
# @description Set permissions for all files and directories below the current directory
# ------------------------------------------------------------------
setperms()
{
    while IFS= read -r item
    do
        printf -- '%s' "."
        [ -d "$item" ] && chmod 755 "$item" || chmod 644 "$item"
    done < <(find .)
}
# ------------------------------------------------------------------
# updateRoot
# ------------------------------------------------------------------
# @description Reset terminal session without closing terminal window
# ------------------------------------------------------------------
updateRoot()
{
    echoGold "Updating root user environment..."
    sudo cp -r "/home/"$USER"/.bashrc.d/" /root/.bashrc.d/
    sudo cp /home/"$USER"/.bashrc /root/.bashrc
    sudo cp /home/"$USER"/.gitconfig /root/.gitconfig
    sudo cp /home/"$USER"/.ssh/aever_* /root/.ssh/.
    sudo cp /home/"$USER"/.ssh/config /root/.ssh/.
    sudo cp /home/"$USER"/.ssh/Ragdata_* /root/.ssh/.
    if [[ -f /root/.bash_aliases ]]; then
        rm -f /root/.bash_aliases /root/.bash_common /root/.bash_env /root/.bash_functions /root/.bash_prompts
        rm -rf /root/prompts
    fi
    echoGold "Importing GPG keys..."
    sudo gpg --import /root/.ssh/Ragdata_0x9B30915A_SECRET.asc 2>/dev/null || echo "No GPG keys to import."
    echoSuccess "DONE!"
}
