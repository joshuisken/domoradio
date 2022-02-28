#!/usr/bin/env python
''' Construct a selector switch in domoticz using json
'''
import base64
import urllib.parse
import urllib.request

baseurl = 'http://localhost/'

selectorDef = {
    'type': 'setused',
    'idx': '256',
    'name': 'NPO Radio',
    'description': 'NPO internet radios',
    'strparam1': '',
    'strparam2': '',
    'protected': 'false',
    'switchtype': '18',
    'customimage': '12',
    'used': 'true',
    'addjvalue': '0',
    'addjvalue2': '0',
}
selectorOpts = {
    'LevelNames': ['Off', 'NPO 1', 'NPO 2'],
    'LevelActions': ['', '', ''],
    'SelectorStyle': '1',
    'LevelOffHidden': 'false'
}


def encode_options(s):
    assert len(s['LevelNames']) == len(s['LevelActions'])
    jn = lambda x: x if isinstance(x, str) else '|'.join(x)
    return ';'.join([':'.join([k, jn(s[k])]) for k in s])


def cr_url(baseurl, selectorDef, selectorOpts):
    url = baseurl + 'json.htm?'
    params = urllib.parse.urlencode(selectorDef)
    url += params
    url += '&options='
    options = encode_options(selectorOpts)
    options = str(base64.b64encode(bytes(options, encoding='utf-8')),
                  encoding='utf-8')
    url += options
    return url


def main():
    'Create/modify selector button in domoticz'
    url = cr_url(baseurl, selectorDef, selectorOpts)
    print("Fetching:", url)
    with urllib.request.urlopen(url) as f:
        print(f.read().decode('utf-8'))


if __name__ == '__main__':
    main()
