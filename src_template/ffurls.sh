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

BROVERTYP_1=0
BROVERTYP_2=1
BROVERTYP_UNKNOWN=undefined

SUBPROGRAM_PARSE=__PROGRAM_NAME__-parse.py
SUBPROGRAM_UNZIP=__PROGRAM_NAME__-unzip.py

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

# Get value for the given keyname of the config text
# Config text format:
#   keyname1=value1\n
#   keyname2=value2\n
#   keynameN=valueN\n
# get_config_value(keyname)
get_config_value()
{
    local keyname=$1

    sed -n '/^'"$keyname="'/ { s/'"$keyname"'=//p; q; }'
}

# Get from config file browser directory
# get_config_browser_dir(file)
get_config_browser_dir()
{
    local file=$1
    local out

    out=$(cat "$file" | get_config_value "browser_directory")
    out="${out//\~/$HOME}"
    echo "$out"
}

# Get from config file output directory
# get_config_output_dir(file)
get_config_output_dir()
{
    local file=$1
    local out

    out=$(cat "$file" | get_config_value "output_directory")
    out="${out//\~/$HOME}"
    echo "$out"
}

# Get from config file output file name
# get_config_ofname(file)
get_config_ofname()
{
    local file=$1
    local out

    out=$(cat "$file" | get_config_value "output_filename")
    echo "$out"
}

# Get from config file output file extension for text format
# get_config_ofext_text(file)
get_config_ofext_text()
{
    local file=$1
    local out

    out=$(cat "$file" | get_config_value "output_file_extension_text")
    echo "$out"
}

# Get from config file output file extension for org format
# get_config_ofext_org(file)
get_config_ofext_org()
{
    local file=$1
    local out

    out=$(cat "$file" | get_config_value "output_file_extension_org")
    echo "$out"
}

# Get from config file output file extension for html format
# get_config_ofext_html(file)
get_config_ofext_html()
{
    local file=$1
    local out

    out=$(cat "$file" | get_config_value "output_file_extension_html")
    echo "$out"
}

# Get from config file default output format
# get_config_default_ofmt(file)
get_config_default_ofmt()
{
    local file=$1
    local out

    out=$(cat "$file" | get_config_value "default_output_format")
    echo "$out"
}

# Get tabs from browser Firefox and save them to the output file in a
# given format.
# extract_tabs_from_unzipped(
#     format,
#     browser_dir,
#     output_dir,
#     output_filename,
#     output_fileext_text,
#     output_fileext_org,
#     output_fileext_html)
extract_tabs_from_unzipped()
{
    local format=$1
    local browser_dir=$2
    local output_dir=$3
    local output_filename=$4
    local output_fileext_text=$5
    local output_fileext_org=$6
    local output_fileext_html=$7

    local ipath
    local ofmt
    local odir
    local ofname
    local ofext
    local opath
    local n

    ipath=$(\
        ls "$browser_dir"/firefox/*.default/sessionstore-backups/recovery.js \
            2>/dev/null)

    ofmt=$format
    odir=$output_dir
    ofname=$output_filename

    case $format in
    text)
        ofext=$output_fileext_text
        ;;
    org)
        ofext=$output_fileext_org
        ;;
    html)
        ofext=$output_fileext_html
        ;;
    esac

    opath="$odir/$ofname.$ofext"

    if [ -e "$opath" ]; then
        n=1
        while [ -e "$opath" ]; do
            opath="$odir/${ofname}_$n.$ofext"
            ((n++))
        done
    fi

    $SUBPROGRAM_PARSE -t "$ofmt" "$ipath" "$opath" || return 1
    return 0
}

# Get tabs from browser Firefox and save them to the output file in a
# given format.
# extract_tabs(
#     format,
#     browser_dir,
#     output_dir,
#     output_filename,
#     output_fileext_text,
#     output_fileext_org,
#     output_fileext_html)
extract_tabs_from_zipped()
{
    local format=$1
    local browser_dir=$2
    local output_dir=$3
    local output_filename=$4
    local output_fileext_text=$5
    local output_fileext_org=$6
    local output_fileext_html=$7

    local zpath
    local idir
    local ipath
    local ofmt
    local odir
    local ofname
    local ofext
    local opath
    local n

    zpath=$(\
        ls "$browser_dir"/firefox/*.default/sessionstore-backups/recovery.jsonlz4 \
            2>/dev/null)

    idir=$(\
        ls -d "$browser_dir"/firefox/*.default/sessionstore-backups \
            2>/dev/null)

    ipath="$idir/recovery.js.ffurls"

    ofmt=$format
    odir=$output_dir
    ofname=$output_filename

    case $format in
    text)
        ofext=$output_fileext_text
        ;;
    org)
        ofext=$output_fileext_org
        ;;
    html)
        ofext=$output_fileext_html
        ;;
    esac

    opath="$odir/$ofname.$ofext"

    if [ -e "$opath" ]; then
        n=1
        while [ -e "$opath" ]; do
            opath="$odir/${ofname}_$n.$ofext"
            ((n++))
        done
    fi

    cp "$zpath" "$ipath" || return 1
    $SUBPROGRAM_UNZIP "$zpath" "$ipath" || return 1
    $SUBPROGRAM_PARSE -t "$ofmt" "$ipath" "$opath" || { rm -f "$ipath"; return 1; }
    rm -f "$ipath" || return 1
    return 0
}

# Detect browser version type to determine strategy for parsing internal files
# detect_browser_version_type(dir)
detect_browser_version_type()
{
    local dir=$1
    local brovertyp_1_file=$(\
        ls "$dir"/firefox/*.default/sessionstore-backups/recovery.js \
            2>/dev/null)
    local brovertyp_2_file=$(\
        ls "$dir"/firefox/*.default/sessionstore-backups/recovery.jsonlz4 \
            2>/dev/null)

    if [ -f "$brovertyp_1_file" ]; then
        echo $BROVERTYP_1
    elif [ -f "$brovertyp_2_file" ]; then
        echo $BROVERTYP_2
    else
        echo $BROVERTYP_UNKNOWN
    fi
}

# Get tabs from browser Firefox and save them to the output file in a
# given format.
# extract_tabs(
#     format,
#     browser_dir,
#     output_dir,
#     output_filename,
#     output_fileext_text,
#     output_fileext_org,
#     output_fileext_html)
extract_tabs()
{
    local format=$1
    local browser_dir=$2
    local output_dir=$3
    local output_filename=$4
    local output_fileext_text=$5
    local output_fileext_org=$6
    local output_fileext_html=$7
    local brovertype

    brovertype=$(detect_browser_version_type "$browser_dir")
    case $brovertype in
    $BROVERTYP_1)
        extract_tabs_from_unzipped \
            "$format" \
            "$browser_dir" \
            "$output_dir" \
            "$output_filename" \
            "$output_fileext_text" \
            "$output_fileext_org" \
            "$output_fileext_html"  || return 1
        ;;
    $BROVERTYP_2)
        extract_tabs_from_zipped \
            "$format" \
            "$browser_dir" \
            "$output_dir" \
            "$output_filename" \
            "$output_fileext_text" \
            "$output_fileext_org" \
            "$output_fileext_html"  || return 1
        ;;
    *)
        error "unrecognized browser version type: $brovertype"
        return 1
        ;;
    esac
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

    config_file="/usr/local/etc/__PROGRAM_NAME__.conf"
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
