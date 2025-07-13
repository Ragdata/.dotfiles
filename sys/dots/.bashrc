# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# PATHS
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/"$USER"/.local/bin
export CDPATH=.:~

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then PATH="$HOME/bin:$PATH"; fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then PATH="$HOME/.local/bin:$PATH"; fi

# iterate through the folders in the .bashrc.d directory
# and make sure that everything gets to where it ought to be.
include()
{
    while IFS= read -r script
    do
        source "$script" || {
            echo "Error sourcing script: $script"
            continue
        }
    done < <(find "$1" -maxdepth 1 -type f | sort)
}

[ -d "$HOME/.bashrc.d" ] && include "$HOME/.bashrc.d"
