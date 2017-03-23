#!/bin/bash

# This script is a part of __PROGRAM_NAME__ __PROGRAM_VERSION__
# This script saves tabs opened in Firefox as title and urls pairs in
# ~/Download/firefox.org file, using __PROGRAM_NAME__.py installed in the
# system.
#
# __PROGRAM_COPYRIGHT__ __PROGRAM_AUTHOR__ __PROGRAM_AUTHOR_EMAIL__
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

__PROGRAM_NAME__.py -t org "$ipath" "$opath"

exit 0
