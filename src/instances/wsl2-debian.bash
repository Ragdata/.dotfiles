#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2034
####################################################################
# wsl2-debian.bash
####################################################################
# Ragdata's Dotfiles - Function Definitions
#
# File:         wsl2-debian.bash
# Author:       Ragdata
# Date:         15/09/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# DEPENDENCIES
####################################################################
# required config files
source "$CUSTOM/cfg/.node"
# required library files
dot::include "dotfiles.functions" "script.functions"
####################################################################
# METADATA
####################################################################
about 'An instance commissioning script for systems running Debian on WSL2'
group 'instances'
####################################################################
# MAIN
####################################################################
clear

if [ "$1" != "rebooted" ]; then
    echoDot "Configuring WSL2" -s "➤" -c "${GOLD}"
    script::launch "fstab"
    echoDot "Install /etc/wsl.conf" -s "▶"
    if [ -f "$CUSTOM/etc/wsl.conf" ]; then source="$CUSTOM/etc/wsl.conf"; else source="$DOT_ETC/wsl.conf"; fi
    if [ -f "$source" ]; then sudo install -b -C -m 0644 -T "$source" /etc/wsl.conf; fi
    script::launch "systemd-resolved"
    echoDot "Write reboot command" -s "▶"
    echo "source \"$INSTANCES/wsl2-ubuntu.bash\" rebooted" >> "$DOTS/bashrc.bash"
    echo ""
    echoAlias "In order to reload config files, WSL will now shutdown." -c "${YELLOW}"
    echoAlias "Restart manually by reopening your terminal session." -c "${YELLOW}"
    echo ""
    read -n 1 -r -s -p $'Press any key to continue...\n'
    wsl.exe --shutdown
else
    echoDot "Removing reboot instruction written to .bashrc" -s "➤" -c "${GOLD}"
    sed -i '$ d' "$DOTS/bashrc.bash"
    cd "$DOTFILES" || exitLog "Unable to 'cd $DOTFILES'"
    git reset --hard
    cd - || exitLog "Unable to return to previous directory"
    echo ""
    echoDot "Configuring WSL2" -s "➤" -c "${GOLD}"
    if [ -f "$CUSTOM/cfg/.wslconfig" ]; then source="$CUSTOM/cfg/.wslconfig"; else source="$DOT_CFG/.wslconfig"; fi
    if [ -f "$source" ]; then sudo install -b -C -m 0644 -T "$source" "$WIN_HOME/.wslconfig"; fi
    echo ""
    echoDot "Copying .ssh-skel" -s "▶"
    if [ ! -d "$HOME/.ssh" ]; then mkdir -p "$HOME/.ssh" || exitLog "Unable to create '$HOME/.ssh'"; fi
    while IFS= read -r file
    do
        if [[ "$file" == "*.pub" || "$file" == "*config" ]]; then perm="0644"; else perm="0600"; fi
        install -C -m "$perm" -T "$file" "$HOME/.ssh/$(basename "$file")"
    done < <(find "$WIN_HOME/.ssh-skel" -type f)
    echoDot "Importing GPG key" -s "▶"
    gpg_key="$(find "$HOME/.ssh" -type f -name "*_SECRET.asc")"
    if [ -f "$gpg_key" ]; then
        if gpg --import "$gpg_key"; then
            rm -f "$gpg_key"
        fi
    fi
    echo ""
fi

if [ "$1" == "rebooted" ]; then
    echoDot "Processing purge list" -s "➤" -c "${GOLD}"
    pkg::removeList "purge"

    echo ""
    echoDot "Installing packages" -s "➤" -c "${GOLD}"
    pkg::install "software-properties-common"
    dot::install::deps
    pkg::install "shellcheck"

    echo ""
    echoDot "Hardening instance" -s "➤" -c "${GOLD}"
    script::launch "disablenet"
    script::launch "disablefs"
    script::launch "disablemod"
    script::launch "systemdconf"
    script::launch "logindconf"
    script::launch "timesyncd"
    script::launch "hosts"
    script::launch "issue"
    script::launch "logindefs"
    script::launch "sysctl"
    script::launch "limits"
    script::launch "user"
    script::launch "sshd"
    script::launch "password"
    script::launch "ctraltdel"
    script::launch "compilers"
    echo ""
    pkg::cleanup
fi
