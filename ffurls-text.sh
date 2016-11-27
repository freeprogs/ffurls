#!/bin/bash

# This script saves tabs opened in Firefox as title and urls pairs in
# ~/Download/firefox.txt file, using ffurls.py installed in the
# system.
#
# Copyright (C) 2016, Slava <nobody@nowhere>

idir="$(ls -d $HOME/.mozilla/firefox/*.default/sessionstore-backups)"
ifile="recovery.js"
odir="$HOME/Downloads"
ofname="firefox"
ofext=".txt"

ipath="$idir/$ifile"
opath="$odir/$ofname$ofext"

if [ -e "$opath" ]; then
    n=1
    while [ -e "$opath" ]; do
        opath="$odir/${ofname}_$n$ofext"
        ((n++))
    done
fi

ffurls.py -t text "$ipath" "$opath"

exit 0
