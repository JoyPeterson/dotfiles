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

export GOPATH="C:/Users/$USER/src/go"
pathadd /c/users/$USER/src/go/bin

source /c/users/$USER/src/go/src/github.com/go-swagger/go-swagger/cmd/swagger/completion/swagger.zsh-completion