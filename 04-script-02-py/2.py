#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology.ru", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
bash_command = ["cd ~/netology.ru", "pwd"]
path = os.popen(' && '.join(bash_command)).read().replace('\n', '')

for result in result_os.split('\n'):
    if result.find('modified:') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(f"{path}/{prepare_result}")
