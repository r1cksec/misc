#!/usr/bin/env python3

import sys
import os

# check amount of passed arguments
if (len(sys.argv) != 3):
    print ("usage: {} pathToFileWithIps pathToRanges ".format(sys.argv[0]))
    print ("pathToFileWithIps = File containing ips (possible as substring) one per line")
    print ("pathToRanges = File containing ranges (nmap format) one per line")
    sys.exit(1)

# collect all single ips in given range
os.system ("nmap -n -sL -iL " + sys.argv[2] + " | grep -Eo '([0-9]*\.){3}[0-9]*' > /tmp/allIpsInRange")

allIpsInRange = []

with open("/tmp/allIpsInRange") as allIps:
    for currIp in allIps:
        allIpsInRange.append(currIp.replace("\n",""))

# check for each ip if it is in given range
with open(sys.argv[1]) as allGivenIps:
    for ip in allGivenIps:
        ip = ip.replace("\n","")
        
        if (ip in allIpsInRange):
            print (ip)

os.system("rm /tmp/allIpsInRange")

