#!/bin/bash

# This script is a part of __PROGRAM_NAME__ __PROGRAM_VERSION__
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

PROGNAME=`basename $0`

# Print an error message to stderr
# error(str)
error()
{
    echo "error: $PROGNAME: $1" >&2
}

# Print short help about this script
# usage()
usage()
{
    echo "Try \`$PROGNAME --help' for more information." >&2
}

# Print full help about this script
# print_help()
print_help()
{
    {
        echo "usage: $PROGNAME [ --text | --org | --html ]"
        echo ""
        echo "Save open browser Firefox tabs (title and url) to the file with a given format."
        echo ""
        echo "  noarg   --  The default format from config file is used."
        echo "  --text  --  Save output to text format."
        echo "  --org   --  Save output to org format."
        echo "  --html  --  Save output to html format."
        echo ""
    } >&2
}

# Run main script operations
# main([cmdarg])
main()
{
    if [ $# -ne 0 -a "$1" = "--help" ]; then
        print_help
        return 1
    fi
    usage
    if [ $# -eq 0 ]; then
        :
        return 0
    fi
    if [ $# -ne 0 ]; then
        case $1 in
        "--text")
            :
            return 0
            ;;
        "--org")
            :
            return 0
            ;;
        "--html")
            :
            return 0
            ;;
        *)
            :
            return 0
            ;;
        esac
    fi
}

main "$@" || exit 1
exit 0
