#--------------------------------------------------------------------------------
# Functions
#--------------------------------------------------------------------------------
# Add a directory to the path if it is not already part of the path.
# From http://superuser.com/a/39995
pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

export GOPATH="C:/Users/$USER/go"
pathadd /c/users/$USER/go/bin