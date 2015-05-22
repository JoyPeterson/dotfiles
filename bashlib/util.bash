# display useful aliases and functions
function util_h() {
    echo "psg [pattern]: ps aux | grep ..."
    echo "ff [name]: Find a file with a pattern in name from the current directory."
}

# Add a directory to the path if it is not already part of the path.
# From http://superuser.com/a/39995
pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
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