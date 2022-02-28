#!/usr/bin/env python
''' Select links for internet sites

Intention: program domoticz such that we can use it to play Internet radio,
see also: https://www.domoticz.com/forum/viewtopic.php?t=21419
'''

import json
import os
import re
from html.parser import HTMLParser
from urllib.request import urlopen

urls = {
    'https://www.hendrikjansen.nl/henk/streaming.html':
    ('NL', [
        'NPO [3R].*',
        ]),
    'https://www.hendrikjansen.nl/henk/streaming1.html':
    ('BE LU', [
        'Radio [12]$',
        '.*Klara.*',
        ]),
}


class MyHTMLParser(HTMLParser):
    """ Collect internet radio links (<a> tags) from html
    """
    url = ''
    data = ''

    def __init__(self, wanted, stations):
        super().__init__()
        # Make a regex that matches if any of our regexes match.
        self.combined = "(" + ")|(".join(wanted) + ")"
        self.stations = stations

    def handle_starttag(self, tag, attrs):
        # Only parse the 'anchor' tag.
        if tag == "a":
            # Check the list of defined attributes.
            for name, value in attrs:
                if name == "href":
                    self.url = value

    def handle_endtag(self, tag):
        if tag == "a":
            if 'http' in self.url and re.match(self.combined, self.data):
                # print("%-30s: %s" % (self.data, self.url))
                self.stations[self.data] = self.url

    def handle_data(self, data):
        'Cleanup the name of the radio station'
        self.data = data.lstrip(' —-+').strip()


def collect_stations(urls):
    """ Parse the html files and slect radio station using a HTML parser
    """
    radio_stations = {}
    for url, (countries, wanted) in urls.items():
        print('== %-10s' % countries, end=': ')
        radio_stations[countries] = {}
        response = urlopen(url)
        text = response.read()
        with open(os.path.basename(url), 'wb') as f:
            f.write(text)
        parser = MyHTMLParser(wanted, radio_stations[countries])
        parser.feed(text.decode('utf-8'))
        print(len(radio_stations[countries]))
    return radio_stations


def main():
    radio_stations = collect_stations(urls)
    with open('radio_stations.json', 'w') as f:
        print(json.dumps(radio_stations, sort_keys=True, indent=4), file=f)


if __name__ == '__main__':
    main()
