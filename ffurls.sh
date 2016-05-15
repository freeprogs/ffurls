#!/bin/bash

idir="$(ls -d $HOME/.mozilla/firefox/*.default/sessionstore-backups)"
ifile="recovery.js"
odir="$HOME/Downloads"
ofile="firefox.txt"

ffurls.py "$idir/$ifile" "$odir/$ofile"

exit 0
