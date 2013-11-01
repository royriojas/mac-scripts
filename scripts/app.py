#!/usr/bin/env python
#
# simle'n'stupid vhost "parser"
#
# Usage: ./vhosts-reader.py FILE
#     FILE is a apache config file
import re
import sys
import os.path

if len(sys.argv) != 2:
    sys.exit('Usage: %s FILE' % sys.argv[0])

FILE = sys.argv[1]

if not os.path.isfile(FILE):
    sys.exit('Unknown file %s' % FILE)

f = open(FILE, 'r')
data_all = f.readlines()
f.close()

data = filter( lambda i: re.search('^((?!#).)*$', i), data_all)

ID = 0
enable = False

result = {}
vhost = []
while len(data) > 0:
    out = data.pop(0)

    # start of VirtualHost
    if "<VirtualHost" in out:
        ip_port = out.split()[1]
        ip, port = ip_port.split(':')
        port = port.replace('>', '')
        vhost.append(ip)
        vhost.append(port)
        enable = True
        continue

    if "</VirtualHost>" in out:
        result[ID] = vhost
        ID+=1
        enable = False
        vhost = []
        continue
            
    if enable:
        vhost.append(out)
        continue

for i in result:
    # result[i][0] is an IP
    # result[i][1] is a port
    # another list items are lines in vhost, grep them all
    for line in result[i]:
        if "ServerName" in line:
            servername = line.split()[1]
            continue
        if "DocumentRoot" in line:
            documentroot = line.split()[1]
            continue
    print "--> %s: ==> %s" % (servername, documentroot)