#!/usr/bin/env python3
import socket
from time import sleep

tlist = {'drive.google.com': '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}

while 1 != 0:
    sleep(1)
    ipaddress = socket.gethostbyname(host)
    tlist[host] = ipaddress
    for host in tlist:
        if ipaddress != tlist[host]:
            print(' [ERROR] ' + str(host) + ' IP mistmatch: ' + tlist[host] + ' ' + ipaddress)
            break
        else:
            print(tlist[host] + ' ' + ipaddress+' OK ')
