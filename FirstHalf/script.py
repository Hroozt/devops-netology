#!/usr/bin/env python3

import os
from sys import argv
n=argv

if len(n)== 1:
    print("Input path to repo")
    tmp=input()
else:
    tmp=argv[1]

bash_command = ["cd " + tmp, "git status"]
result_os = os.popen(' && '.join(bash_command)).read() 
is_change = False

print("Modified files:")
for result in result_os.split('\n'):
    if result.find('modified') != -1: 
        prepare_result = result.replace('\tmodified:   ', '') 
        print(tmp, "/", prepare_result, sep='')
#        break - прерывает скрипт на 1 совпадении
