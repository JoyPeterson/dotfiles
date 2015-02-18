#------------------------------------------------------------------------------
# Utility functions
#------------------------------------------------------------------------------
gitmap() {
	dir="$1"; shift;
	[ ! -d "$dir" ] && echo 'Usage: gitmap <dir> <cmd>' && echo '   eg: gitmap $src git st' && return 1
	find $dir -maxdepth 3 -type d -name .git | grep -v 'vim/bundle' | while read f; do f=$(dirname $f); cd $f && echo ${f#$dir} \(`c_branch`\) && eval "$@"; cd - > /dev/null; done; # that 'echo' chops the $dir prefix from $f ... and we also through __git_ps1 output on that line
	}
gitmap1() { # as above, but compresses its subcommand output to a single line
	dir="$1"; shift;
	[ ! -d "$dir" ] && echo 'Usage: gitmap1 <dir> <cmd>' && echo '   eg: gitmap1 $src __git_ps1' && echo '   or: gitmap1 $src "__git_ps1 | grep master && echo MASTER"' && return 1
	find $dir -maxdepth 3 -type d -name .git | grep -v 'vim/bundle' | while read f; do f=$(dirname $f); cd $f && echo ${f#$dir} \(`c_branch`\) `eval "$@"`; cd - > /dev/null; done; # that 'echo' chops the $dir prefix from $f
	}
gitbr()  { gitmap "${1-$src}"; } # gitmap no-op = print dir & __git_ps1, then go to next
gitst()  { gitmap "${1-$src}" git st; }
gitlo()  { gitmap "${1-$src}" git lo; }
gitl1()  { gitmap1 "${1-$src}" git lo -1; }