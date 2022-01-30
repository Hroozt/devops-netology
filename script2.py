#!/usr/bin/env python3
# Скрипт проверяет изменение IP адресов переданныйх на вход
import socket
from time import sleep
import os
import json
import yaml

tlist = {'drive.google.com': '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}
n = 1


# Функция заполнения словаря Актуальными IP адресами
def fill_tlist(x):
    for node in x:
        ipaddres = socket.gethostbyname(node)
        x[node] = ipaddres
    return x


# запись в формате json \ yaml
def fill_json_yaml(y):
    with open('hosts.json', 'w') as jtmp:
        jtmp.write(str(json.dumps(y)))
    with open('hosts.yaml', 'w') as ytmp:
        ytmp.write(yaml.dump(y))
    return


# заполним словарь и запишем YAML\JSON чтобы был актуальный спикок всегда
fill_json_yaml(fill_tlist(tlist))


# цикл проверки изменения адреса. цикл прерывается при изменениях и записывает последние актуальные адреса в JSON \ YAML
while n != 0:
    tmp = fill_tlist(tlist)
    sleep(1)
    os.system('cls')
    for host in tmp:
        ipaddress = socket.gethostbyname(host)
        if ipaddress != tmp[host]:
            print(' [ERROR] ' + str(host) + ' IP mistmatch: ' + tmp[host] + ' ---> ' + ipaddress)
            tmp[host] = ipaddress
            fill_json_yaml(tmp)
            n = 0
        else:
            print(str(host) + ' ' + ipaddress + ' OK ')
