"""
Make sure we get the latest ocp image
"""
from html.parser import HTMLParser
import requests

class GetData(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.answer = ''
    def handle_starttag(self, tag, attrs):
        for apt in attrs:
            if apt[0] == 'href':
                if apt[1].startswith('openshift-client-linux'):
                    self.answer = apt[1]

req = requests.get('https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest')
parser = GetData()
parser.feed(req.text)
info = parser.answer
print(parser.answer)
