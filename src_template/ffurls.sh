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

# Get from config file browser directory
# get_config_browser_dir(file)
get_config_browser_dir()
{
    echo "~/.mozilla"
}

# Get from config file output directory
# get_config_output_dir(file)
get_config_output_dir()
{
    echo "~/Downloads"
}

# Get from config file output file name
# get_config_ofname(file)
get_config_ofname()
{
    echo "firefox"
}

# Get from config file output file extension for text format
# get_config_ofext_text(file)
get_config_ofext_text()
{
    echo "txt"
}

# Get from config file output file extension for org format
# get_config_ofext_org(file)
get_config_ofext_org()
{
    echo "org"
}

# Get from config file output file extension for html format
# get_config_ofext_html(file)
get_config_ofext_html()
{
    echo "html"
}

# Get from config file default output format
# get_config_default_ofmt(file)
get_config_default_ofmt()
{
    echo "org"
}

# Get tabs from browser Firefox and save them to the output file in a
# given format.
# extract_tabs(format,
#              browser_dir,
#              output_dir,
#              output_filename,
#              output_fileext_text,
#              output_fileext_org,
#              output_fileext_html)
extract_tabs()
{
    echo $@
    return 0
}

# Run main script operations
# main([cmdarg])
main()
{
    local config_file
    local browser_dir
    local output_dir
    local ofname
    local ofext_text
    local ofext_org
    local ofext_html
    local default_ofmt

    if [ $# -ne 0 -a "$1" = "--help" ]; then
        print_help
        return 1
    fi
    usage

    config_file="/usr/local/etc/__PROGRAM_NAME__.sh"
    browser_dir=$(get_config_browser_dir "$config_file")
    output_dir=$(get_config_output_dir "$config_file")
    ofname=$(get_config_ofname "$config_file")
    ofext_text=$(get_config_ofext_text "$config_file")
    ofext_org=$(get_config_ofext_org "$config_file")
    ofext_html=$(get_config_ofext_html "$config_file")
    default_ofmt=$(get_config_default_ofmt "$config_file")
    if [ $# -eq 0 ]; then
        extract_tabs \
            "$default_ofmt" \
            "$browser_dir" \
            "$output_dir" \
            "$ofname" \
            "$ofext_text" \
            "$ofext_org" \
            "$ofext_html" || return 1
        return 0
    fi
    if [ $# -ne 0 ]; then
        case $1 in
        "--text")
            extract_tabs \
                "text" \
                "$browser_dir" \
                "$output_dir" \
                "$ofname" \
                "$ofext_text" \
                "$ofext_org" \
                "$ofext_html" || return 1
            return 0
            ;;
        "--org")
            extract_tabs \
                "org" \
                "$browser_dir" \
                "$output_dir" \
                "$ofname" \
                "$ofext_text" \
                "$ofext_org" \
                "$ofext_html" || return 1
            return 0
            ;;
        "--html")
            extract_tabs \
                "html" \
                "$browser_dir" \
                "$output_dir" \
                "$ofname" \
                "$ofext_text" \
                "$ofext_org" \
                "$ofext_html" || return 1
            return 0
            ;;
        *)
            error "can't recognize output format: $1"
            return 1
            ;;
        esac
    fi
}

main "$@" || exit 1
exit 0
