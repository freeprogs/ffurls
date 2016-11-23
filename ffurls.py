#!/usr/bin/env python3

# Преобразует открытые в Firefox ссылки
# в названия и ссылки в текстовом файле или html-файле.

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

def text_to_file(fname, text):
    with open(fname, 'w', encoding='utf-8') as fout:
        fout.write(text)

def convert_ff_to_txt(ifname, ofname):
    ffurls = get_ff_title_url_pairs(get_json_data(ifname))
    tustrs = ('{}\n{}'.format(t, u) for t, u in ffurls)
    strings_to_file(ofname, tustrs)

def convert_ff_to_html(ifname, ofname):
    ffurls = get_ff_title_url_pairs(get_json_data(ifname))
    html_page = make_html_page(ffurls)
    text_to_file(ofname, html_page)

def make_html_page(seq):
    fmt = \
"""\
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>Urls</title>
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

def get_prog_args():
    desc = """
    Converts Firefox session json file to
    a text or html file with titles and urls.
    """
    parser = argparse.ArgumentParser(description=desc)
    parser.add_argument('-t',
                        choices=['text', 'html'],
                        default='text',
                        help='type of the output file (default: %(default)s)')
    parser.add_argument('ifname',
                        help='input Firefox session file (sessionstore.js)')
    parser.add_argument('ofname', help='output urls text or html file')
    return parser.parse_args()

def main():
    args = get_prog_args()
    ifname = args.ifname
    ofname = args.ofname
    oftype = args.t
    if oftype == 'text':
        convert_ff_to_txt(ifname, ofname)
    elif oftype == 'html':
        convert_ff_to_html(ifname, ofname)

if __name__ == '__main__':
    main()
