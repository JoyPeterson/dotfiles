# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# use up/down to search history, matching the current line start
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#-------------------------------------------------------------------------------
# Include files
#-------------------------------------------------------------------------------
source ~/.dotfiles/bashlib/ssh.bash
source ~/.dotfiles/bashlib/msys2.bash
source ~/.dotfiles/bashlib/arc.bash
source ~/.dotfiles/bashlib/git.bash
source ~/.dotfiles/bashlib/vision.bash

if [ -f ~/.dotfiles/liquidprompt/liquidprompt ]; then
	source ~/.dotfiles/liquidprompt/liquidprompt
fi

#--------------------------------------------------------------------------------
# Enviromnet variables
#--------------------------------------------------------------------------------

# Add a directory to the path if it is not already part of the path.
# From http://superuser.com/a/39995
pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

pathadd ~/.git-cmd
pathadd /c/bin/arcanist/bin

export COMPOSER_HOME=~/.composer
pathadd ~/.composer/vendor/bin

#--------------------------------------------------------------------------------
# ALIASES
#--------------------------------------------------------------------------------

alias ll='ls -Aphotr --color=auto'
alias ls='ls -p --color=auto'
alias egrep='egrep --color=auto'
alias f='fgrep'
alias fgrep='fgrep --color=auto'
alias fv='fgrep -v'
alias grep='grep --color=auto'

#--------------------------------------------------------------------------------
# Functions
#--------------------------------------------------------------------------------

# Reload settings from ~/.bashrc
src() {
	source ~/.bashrc
}

function psg() {
    #        do not show grep itself           color matching string              color the PID
    # ps aux | grep -v grep | grep --ignore-case --color=always $1 | colout '^\S+\s+([0-9]+).*$' blue
    ps aux | grep -v grep | grep --ignore-case --color=always $1
}

# Find a file with a pattern in name from the current directory
# ff name
function ff() {
	find . -type f -iname '*'$*'*' -ls ;
}


# display useful aliases and functions
function h() {
    git_h
    arc_h
    msy2_h
    echo "psg [pattern]: ps aux | grep ..."
	echo "ff [name]: Find a file with a pattern in name from the current directory."
}
