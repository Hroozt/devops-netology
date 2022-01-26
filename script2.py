#!/usr/bin/env python3
import os
import socket
import sys
from time import sleep
fr=1
n=1
tlist=['drive.google.com', 'mail.google.com', 'google.com']

while n!=0:
    f=socket.gethostbyname(tlist[0])
    s=socket.gethostbyname(tlist[1])
    t=socket.gethostbyname(tlist[2])
    sleep(fr)
    print("\033c")
    cf=socket.gethostbyname(tlist[0])
    cs=socket.gethostbyname(tlist[1])
    ct=socket.gethostbyname(tlist[2])
    if (f == cf and s == cs and t == ct):
        print('URL:', tlist[0], 'IPv4:', f,'\t', 'URL:', tlist[1], 'IPv4:', s, '\t', 'URL:', tlist[2], 'IPv4:', t, '\t')
        sleep(fr)
    elif (f!=cf):
        print('ERROR:', tlist[0], 'IPv4 mismatch:', f, '->', cf, '\t', 'URL:', tlist[1], 'IPv4:', s, '\t', 'URL:', tlist[2], 'IPv4:', t, '\t')
        break
    elif (s!=cs):
        print('URL:', tlist[0], 'IPv4:', f,'\t', 'ERROR:', tlist[1], 'IPv4 mismatch:', s, '->', cs,  '\t', 'URL:', tlist[2], 'IPv4:', t, '\t')
        break
    elif (t!=ct):
        print('URL:', tlist[0], 'IPv4:', f,'\t', 'URL:', tlist[1], 'IPv4:', s, '\t', 'ERROR:', tlist[2], 'IPv4 mismatch:', t, '->', ct, '\t')
        break
