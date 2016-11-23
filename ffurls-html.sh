#!/bin/bash

idir="$(ls -d $HOME/.mozilla/firefox/*.default/sessionstore-backups)"
ifile="recovery.js"
odir="$HOME/Downloads"
ofile="firefox.html"

ipath="$idir/$ifile"
opath="$odir/$ofile"

ffurls.py -t html "$ipath" "$opath"

exit 0
