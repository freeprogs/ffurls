#!/bin/bash

idir="$(ls -d $HOME/.mozilla/firefox/*.default/sessionstore-backups)"
ifile="recovery.js"
odir="$HOME/Downloads"
ofile="firefox.txt"

ipath="$idir/$ifile"
opath="$odir/$ofile"

ffurls.py "$ipath" "$opath"

exit 0
