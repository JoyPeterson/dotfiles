# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

#-------------------------------------------------------------------------------
# Include files
#-------------------------------------------------------------------------------
source ~/.dotfiles/bashlib/ssh.bash
source ~/.dotfiles/bashlib/msys2.bash
source ~/.dotfiles/bashlib/arc.bash

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

export et=/c/Projects/EmailTracker
export nd=/c/Projects/EmailTracker/ext/is/nexusdomain

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

# Open a file an an editor
edit ()
{
    for f in "$@";
    do
        if [ -d "$f" ]; then
            explorer.exe "$f";
        else
			ext="${f##*.}"
            case $ext in
                'doc')
                    /c/Program\ Files/Microsoft\ Office\ 15/root/office15/WINWORD.exe "$f"
                ;;
                'xls')
                    c/Program\ Files/Microsoft\ Office\ 15/root/office15/EXCEL.exe "$f"
                ;;
                'ppt')
                    c/Program\ Files/Microsoft\ Office\ 15/root/office15/POWERPNT.exe "$f"
                ;;
                'odt')
                    /c/Program\ Files/Microsoft\ Office\ 15/root/office15/WINWORD.exe "$f"
                ;;
                'png' | 'gif' | 'jpg')
                    /c/Program\ Files/TechSmith/SnagIt\ 9/SnagitEditor.exe "$f"
                ;;
                *)
                    # notepad++ "$f"
                    sublime_text "$f"
                ;;
            esac;
        fi;
    done
}

# Execute a PowerShell command
p()
{
    # Run powershell without tmp and temp set
    env -u tmp -u temp PowerShell.exe -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Unrestricted -Command "& { $@ }"
}

# Report if Git is storing a file as a binary file.
isGitBinary() {
    p=$(printf '%s\t-\t' -)
	# 4b825dc642... is a magic SHA which represents the empty tree
    t=$(git diff --numstat 4b825dc642cb6eb9a060e54bf8d69288fbee4904 HEAD -- "$1")
    case "$t" in "$p"*) echo "$1" is binary; return ;; esac
    echo "$1" is not binary
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

# edit hosts file
function eh() {
	edit /c/windows/system32/drivers/etc/hosts
}

# display useful aliases and functions
function h() {
	echo "psg [pattern]: ps aux | grep ..."
	echo "isGitBinary [file]: Report if Git is storing a file as a binary file."
	echo "p [command]: Execute a powershell command or script."
	echo "arcr: send the current branch to arc for code review."
	echo "ff [name]: Find a file with a pattern in name from the current directory."
	echo "eh: Open hosts file in editor."
}