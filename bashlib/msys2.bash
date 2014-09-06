# Arrow keys don't work in Vim when using msys2/cygwin if term = xterm.  Use cygwin because it allows colored syntax highlighting.
export TERM=cygwin

# Open a Windows explorer window for the current directory
alias winx='/c/Windows/explorer.exe /e, $(cygpath -w $PWD)'