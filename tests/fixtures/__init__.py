"""
Test fixtures and sample data for dotfiles testing.
"""

SAMPLE_BASHRC = """
# Sample .bashrc for testing
export PATH="$PATH:$HOME/.local/bin"
export EDITOR=vim

# Aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# Functions
function mkcd() {
    mkdir -p "$1" && cd "$1"
}
"""

SAMPLE_VIMRC = """
" Sample .vimrc for testing
set number
set relativenumber
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
syntax on
colorscheme desert
"""

SAMPLE_GITCONFIG = """
[user]
    name = Test User
    email = test@example.com

[core]
    editor = vim
    autocrlf = input

[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    lg = log --oneline --graph --decorate
"""
