#!/bin/bash

# This script is a part of __PROGRAM_NAME__ __PROGRAM_VERSION__
# This script saves tabs opened in Firefox as title and urls pairs in
# ~/Download/firefox.html file, using ffurls.py installed in the
# system.
#
# __PROGRAM_COPYRIGHT__ __PROGRAM_AUTHOR__ __PROGRAM_AUTHOR_EMAIL__

idir="$(ls -d $HOME/.mozilla/firefox/*.default/sessionstore-backups)"
ifile="recovery.js"
odir="$HOME/Downloads"
ofname="firefox"
ofext=".html"

ipath="$idir/$ifile"
opath="$odir/$ofname$ofext"

if [ -e "$opath" ]; then
    n=1
    while [ -e "$opath" ]; do
        opath="$odir/${ofname}_$n$ofext"
        ((n++))
    done
fi

ffurls.py -t html "$ipath" "$opath"

exit 0
