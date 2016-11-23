#!/bin/bash

idir="$(ls -d $HOME/.mozilla/firefox/*.default/sessionstore-backups)"
ifile="recovery.js"
odir="$HOME/Downloads"
ofile="firefox.txt"

ipath="$idir/$ifile"
opath="$odir/$ofile"

if [ -e "$opath" ]; then
    n=1
    while [ -e "$opath" ]; do
        opath="$odir/${ofile}_$n"
        ((n++))
    done
fi

ffurls.py -t text "$ipath" "$opath"

exit 0
