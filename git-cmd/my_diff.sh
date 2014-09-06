#!/bin/bash
# un-comment one diff tool you'd like to use

# using kdiff3 as the side-by-side diff:
kdiff3 "$2" "$5"

# using VIM
# vim -d "$2" "$5"
exit 0