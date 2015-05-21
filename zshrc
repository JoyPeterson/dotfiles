#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

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

# Reload settings from ~/.zshrc
src() {
    source ~/.zshrc
}

#-------------------------------------------------------------------------------
# Include files
#-------------------------------------------------------------------------------
source ~/.dotfiles/bashlib/arc.bash

# Customize to your needs...

# If we have a glob this will expand it
setopt GLOB_COMPLETE
# Be Reasonable!
setopt NUMERIC_GLOB_SORT

# 10 second wait if you do something that will delete everything.
setopt RM_STAR_WAIT

export EDITOR="subl -n -w"