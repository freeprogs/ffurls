#!/usr/bin/env python3

# Преобразует открытые в Firefox ссылки
# в названия и ссылки в текстовом файле.

import argparse
import json

def get_json_data(fname):
    with open(fname, encoding='utf-8') as fin:
        return json.load(fin)

def get_ff_title_url_pairs(data):
    for win in data['windows']:
        for tab in win['tabs']:
            for entry in tab['entries']:
                yield entry['title'], entry['url']

def strings_to_file(fname, seq):
    with open(fname, 'w', encoding='utf-8') as fout:
        for i in seq:
            print(i, file=fout)

def convert_ff_to_txt(ifname, ofname):
    ffurls = get_ff_title_url_pairs(get_json_data(ifname))
    tustrs = ('{}\n{}'.format(t, u) for t, u in ffurls)
    strings_to_file(ofname, tustrs)

def get_prog_args():
    desc = """
    Converts Firefox session json file to
    a text or html file with titles and urls.
    """
    parser = argparse.ArgumentParser(description=desc)
    parser.add_argument('ifname',
                        help='input Firefox session file (sessionstore.js)')
    parser.add_argument('ofname', help='output urls text or html file')
    return parser.parse_args()

def main():
    args = get_prog_args()
    ifname = args.ifname
    ofname = args.ofname
    convert_ff_to_txt(ifname, ofname)

if __name__ == '__main__':
    main()
