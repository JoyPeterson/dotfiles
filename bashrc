# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# use up/down to search history, matching the current line start
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#-------------------------------------------------------------------------------
# Include files
#-------------------------------------------------------------------------------
source ~/.dotfiles/bashlib/util.bash
source ~/.dotfiles/bashlib/ssh.bash
source ~/.dotfiles/bashlib/msys2.bash
source ~/.dotfiles/bashlib/arc.bash
source ~/.dotfiles/bashlib/git.bash
source ~/.dotfiles/bashlib/vision.bash
source ~/.dotfiles/bashlib/private.bash

if [ -f ~/.dotfiles/liquidprompt/liquidprompt ]; then
	source ~/.dotfiles/liquidprompt/liquidprompt
fi

if [ -f /c/Projects/ihance/IHDevBashLib/bashlib/docker.bash ]; then
    source /c/Projects/ihance/IHDevBashLib/bashlib/docker.bash
fi

#--------------------------------------------------------------------------------
# Enviromnet variables
#--------------------------------------------------------------------------------




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

# display useful aliases and functions
function h() {
    util_h
    git_h
    arc_h
    msy2_h
}
