#!/usr/bin/env python3

import os
import sys


def getListModified(path):
    if not os.path.isdir(path + '/.git'):
        print('.git directory does not exist')
        exit()

    bash_command = ["cd " + path, "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()

    for result in result_os.split('\n'):
        if result.find('modified:') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(f"{path}/{prepare_result}")

    return None


if len(sys.argv) >= 2:
    path = sys.argv[1]
else:
    bash_command = ["cd ~/netology.ru", "pwd"]
    path = os.popen(' && '.join(bash_command)).read().replace('\n', '')

getListModified(path)
