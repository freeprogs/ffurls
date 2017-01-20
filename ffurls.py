#!/usr/bin/env python3

# __PROGRAM_NAME__ __PROGRAM_VERSION__
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

"""Saves tabs opened in Firefox to a file in some format.

It takes Firefox file with actual configuration of opened tabs and
windows, finds titles and urls there and saves these pairs to a file
in a selected format.

Some file formats are mutable, some not and some are both mutable and
immutable.

Available formats:

  text -- a text file
          a raw format, it is handy for automatic processing

  html -- a html page
          it is handy for read, but it is closed for editions

   org -- org-file for Emacs
          it is handy for read, also it is handy for editions
          (recommended)

"""

__version__ = '__PROGRAM_VERSION_NO_V__'
__date__ = '__PROGRAM_DATE__'
__author__ = '__PROGRAM_AUTHOR__ __PROGRAM_AUTHOR_EMAIL__'
__license__ = 'GNU GPLv3'


import sys
import argparse
import json

def get_json_data(fname):
    """Load json-data from file on file system."""
    with open(fname, encoding='utf-8') as fin:
        return json.load(fin)

def get_ff_title_url_pairs(data):
    """Select title and url pairs from Firefox json data."""
    for win in data['windows']:
        for tab in win['tabs']:
            for entry in tab['entries']:
                entry_title = entry.get('title')
                entry_url = entry.get('url')
                yield entry_title, entry_url

def strings_to_file(fname, seq):
    """Save strings from sequence to the file on file system."""
    with open(fname, 'w', encoding='utf-8') as fout:
        for i in seq:
            print(i, file=fout)

def text_to_file(fname, text):
    """Save text to the file on file system."""
    with open(fname, 'w', encoding='utf-8') as fout:
        fout.write(text)

def replace_nones(seq, r1, r2):
    """Replace in sequence of pairs none values to replacement values.

    For example:

      [(None, 1), (1, None), (None, None)]

      becomes:

      [(r1, 1), (1, r2), (r1, r2)]

    """
    for i1, i2 in seq:
        o1 = i1 if i1 is not None else r1
        o2 = i2 if i2 is not None else r2
        yield o1, o2

def convert_ff_to_txt(ifname, ofname):
    """Convert Firefox tabs to the text file with title and urls."""
    ffurls = get_ff_title_url_pairs(get_json_data(ifname))
    ffurls_replaced = replace_nones(ffurls, 'Unknown title', 'unknown')
    tustrs = ('{}\n{}'.format(t, u) for t, u in ffurls_replaced)
    strings_to_file(ofname, tustrs)

def convert_ff_to_html(ifname, ofname):
    """Convert Firefox tabs to the html file with title and urls."""
    ffurls = get_ff_title_url_pairs(get_json_data(ifname))
    ffurls_replaced = replace_nones(ffurls, 'Unknown title', 'unknown')
    html_page = make_html_page(ffurls_replaced)
    text_to_file(ofname, html_page)

def convert_ff_to_org(ifname, ofname):
    """Convert Firefox tabs to the org file with title and urls."""
    ffurls = get_ff_title_url_pairs(get_json_data(ifname))
    ffurls_replaced = replace_nones(ffurls, 'Unknown title', 'unknown')
    org_text = make_org_text(ffurls_replaced)
    text_to_file(ofname, org_text)

def make_html_page(seq):
    """Make html-page from sequence of (title, url) pairs."""
    fmt = \
"""\
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>Saved Firefox Urls</title>
  <style type="text/css">
    body {{ font-size: small; }}
  </style>
</head>
<body>
  <ul>
{}
  </ul>
</body>
</html>
"""
    ul_items = ('    <li><a href="{1}">{0}</a>'.format(t, u)
                for t, u in seq)
    out = fmt.format('\n'.join(ul_items))
    return out

def make_org_text(seq):
    """Make org-text from sequence of (title, url) pairs."""
    fmt = \
"""\
#+STARTUP: showall

* Saved Firefox urls
{}
"""
    items = ('  - [ ] [[{1}][{0}]]'.format(t, u)
             for t, u in seq)
    out = fmt.format('\n'.join(items))
    return out

def get_prog_args():
    """Parse command line arguments to a handy object with attributes."""
    desc = """
    Converts Firefox session json file to
    a text, html or emacs org file with titles and urls.
    """
    parser = argparse.ArgumentParser(description=desc)
    parser.add_argument('--version', '-V',
                        action='version',
                        version='%(prog)s ' + 'v' + __version__)
    parser.add_argument('--license',
                        action='version',
                        version='License: ' + __license__ +
                        ', see more details in file LICENSE'
                        ' or at <http://www.gnu.org/licenses/>.',
                        help='show program\'s license and exit')
    parser.add_argument('-t',
                        choices=['text', 'html', 'org'],
                        default='text',
                        help='type of the output file (default: %(default)s)')
    parser.add_argument('ifname',
                        help='input Firefox session file (recovery.js)')
    parser.add_argument('ofname', help='output urls text, html or org file')
    return parser.parse_args()

def print_error(message):
    """Print an error message to stderr."""
    print('error:', message, file=sys.stderr)

def main():
    """Convert Firefox tabs to text, html or org file."""
    args = get_prog_args()
    ifname = args.ifname
    ofname = args.ofname
    oftype = args.t
    try:
        if oftype == 'text':
            convert_ff_to_txt(ifname, ofname)
        elif oftype == 'html':
            convert_ff_to_html(ifname, ofname)
        elif oftype == 'org':
            convert_ff_to_org(ifname, ofname)
    except FileNotFoundError:
        print_error('source data file not found: {}'.format(ifname))
        return 1
    return 0

if __name__ == '__main__':
    sys.exit(main())
