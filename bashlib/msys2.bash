# Arrow keys don't work in Vim when using msys2/cygwin if term = xterm.  Use cygwin because it allows colored syntax highlighting.
export TERM=cygwin
export EDITOR="subl -n -w"

# Open a Windows explorer window for the current directory
alias winx='/c/Windows/explorer.exe /e, $(cygpath -w $PWD)'

# display useful aliases and functions
function msys2_h()
{
    echo "p [command]: Execute a powershell command or script."
    echo "eh: Open hosts file in editor."
    echo "winx: Open a Windows explorer window for the current directory."
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

# edit hosts file
function eh() {
    edit /c/windows/system32/drivers/etc/hosts
}
