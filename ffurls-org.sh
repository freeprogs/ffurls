#!/bin/bash

idir="$(ls -d $HOME/.mozilla/firefox/*.default/sessionstore-backups)"
ifile="recovery.js"
odir="$HOME/Downloads"
ofname="firefox"
ofext=".org"

ipath="$idir/$ifile"
opath="$odir/$ofname$ofext"

if [ -e "$opath" ]; then
    n=1
    while [ -e "$opath" ]; do
        opath="$odir/${ofname}_$n$ofext"
        ((n++))
    done
fi

ffurls.py -t org "$ipath" "$opath"

exit 0
