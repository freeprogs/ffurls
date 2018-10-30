#!/usr/bin/env python3

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

"""Unzip file from internal Firefox format mozlz4.

"""

__version__ = '__PROGRAM_VERSION_NO_V__'
__date__ = '__PROGRAM_DATE__'
__author__ = '__PROGRAM_AUTHOR__ __PROGRAM_AUTHOR_EMAIL__'
__license__ = '__PROGRAM_LICENSE__'


import sys
import argparse
import lz4.block

class SrcNotFoundError(FileNotFoundError):
    """Source file not found exception."""

class DstNotFoundError(FileNotFoundError):
    """Destination file not found exception."""

class LZ4DecompressError(Exception):
    """Destination file not found exception."""

def unzip_mozlz4(ifname, ofname):
    """Unzip input file from the mozlz4 format to plain output file."""
    try:
        with open(ifname, 'rb') as fin:
            data_zipped = fin.read()
    except FileNotFoundError as exc:
        raise SrcNotFoundError(exc)
    try:
        data_unzipped = lz4.block.decompress(data_zipped[8:])
    except lz4.block.LZ4BlockError as exc:
        raise LZ4DecompressError(exc)
    try:
        with open(ofname, 'wb') as fout:
            fout.write(data_unzipped)
    except FileNotFoundError as exc:
        raise DstNotFoundError(exc)

def get_prog_args():
    """Parse command line arguments to a handy object with attributes."""
    desc = """
    Unzip file from internal Firefox format mozlz4.
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
    parser.add_argument('ifname',
                        help='input compressed file')
    parser.add_argument('ofname', help='output decompressed file')
    return parser.parse_args()

def print_error(message):
    """Print an error message to stderr."""
    print('error:', message, file=sys.stderr)

def main():
    """Unzip file from internal Firefox format mozlz4."""
    args = get_prog_args()
    ifname = args.ifname
    ofname = args.ofname
    try:
        unzip_mozlz4(ifname, ofname)
    except SrcNotFoundError:
        print_error('source data file not found: {}'.format(ifname))
        return 1
    except DstNotFoundError:
        print_error('can\'t create output file: {}'.format(ofname))
        return 1
    except LZ4DecompressError:
        print_error('can\'t decompress source file: {}'.format(ifname))
        return 1
    return 0

if __name__ == '__main__':
    sys.exit(main())
