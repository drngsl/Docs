import HTMLParser
import os
import re
import sys
import urllib

GLOBAL_REQUIREMENTS = 'https://github.com/openstack/requirements/blob' \
                      '/master/global-requirements.txt'


def retrieve_requirements(req_url=None):
    if not req_url:
        req_url = GLOBAL_REQUIREMENTS
    resp = urllib.urlopen(req_url)
    html = resp.read().decode('utf-8')
    html = HTMLParser.HTMLParser().unescape(html)
    reg = r'<td id="LC(.+?)" class="blob-code blob-code-inner' \
          r' js-file-line">(.+?)</td>'
    pattern = re.compile(reg)
    return [item[1] for item in re.findall(pattern, html)]


def calculate_diff(src, path):
    src = [r.split(' ', 1)[0] for r in src]
    diff_dict = {}
    with open(path) as f:
        line_num = 1
        for line in f.readlines():
            line = line.strip()
            if line and not line.startswith('#'):
                r = line.split(' ', 1)[0]
                if r not in src:
                    diff_dict[line_num] = r
            line_num += 1
    return diff_dict

if __name__ == '__main__':
    argv_num = len(sys.argv)
    if argv_num < 2:
        print("Command needs at least 1 arguments.")
        exit(0)
    path = sys.argv[1]
    if not os.path.exists(path):
        print("The input requirements path does not exist.")
        exit(0)

    src_req_url = None
    if argv_num > 2:
        src_req_url = sys.argv[2]

    try:
        diff_reqs = calculate_diff(retrieve_requirements(src_req_url), path)
        if len(diff_reqs) == 0:
            print("All requirements is the newest.")
        else:
            print("The following requirements need to update.")
            for line_num, req in diff_reqs.items():
                print("line: %s, %s" % (line_num, req))
    except Exception as e:
        print(e)
