#!/usr/bin/env bash
# shellcheck shell=bash
####################################################################
# compilers
####################################################################
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# METADATA
####################################################################
about 'A helper script for instances built on WSL2'
group 'helpers'
####################################################################
# MAIN
####################################################################
if [ "$1" != "rebooted" ]; then
    echoDot "Configuring WSL2" -s "➤" -c "${GOLD}"

    script::launch "fstab"

    echoDot "Install /etc/wsl.conf" -s "▶"
    if [ -f "$CUSTOM/etc/wsl.conf" ]; then source="$CUSTOM/etc/wsl.conf"; else source="$DOT_ETC/wsl.conf"; fi
    if [ -f "$source" ]; then sudo install -b -C -m 0644 -T "$source" /etc/wsl.conf; fi

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
    script::launch "systemd-resolved"

    echoDot "Copying .ssh-skel" -s "▶"
    if [ ! -d "$HOME/.ssh" ]; then mkdir -p "$HOME/.ssh" || exitLog "Unable to create '$HOME/.ssh'"; fi
    while IFS= read -r file
    do
        if [[ "$(basename "$file")" == *.pub || "$(basename "$file")" == *config ]]; then perm="0644"; else perm="0600"; fi
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
    if ! resolvectl query google.com; then
        echoDot "Waiting for services to boot ..." -s "➤" -c "${GOLD}"
        until resolvectl query google.com &> /dev/null
        do
            sleep 2
            printf -- '%s' "."
        done
    fi
fi
