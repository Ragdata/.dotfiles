# shellcheck shell=bash
# shellcheck disable=SC2139

about '.dotfiles aliases'
group 'aliases'

alias dotfiles="source $DOT_BIN/dotfiles"
alias dotgit="source $DOT_BIN/dotgit"
alias dotlaunch="source $DOT_BIN/dotlaunch"

alias .files="dotfiles"
alias .git="dotgit"
alias .launch="dotlaunch"
