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

# Customize to your needs...

# If we have a glob this will expand it
setopt GLOB_COMPLETE
# Be Reasonable!
setopt NUMERIC_GLOB_SORT

# 10 second wait if you do something that will delete everything.
setopt RM_STAR_WAIT

export EDITOR="subl -n -w"