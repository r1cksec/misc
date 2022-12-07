#!/usr/bin/env python3

import sys
import os

# check amount of passed arguments
if (len(sys.argv) != 2):
    print ("usage: {} pathToDomainFile ".format(sys.argv[0]))
    print ("pathToDomainFile = one domain per line")
    sys.exit(1)

# create temporary directory
tempResults = "/tmp/allHostIps/"

if os.path.exists(tempResults):
    os.system("rm -rf " + tempResults)

os.makedirs(tempResults)

# get ip addresses of all hosts
with open(sys.argv[1]) as allDomains:
    for line in allDomains:
        line = line.replace("\n","")
        os.system ("host " + line + " | grep -Eo ' ([0-9]*\.){3}[0-9]*' > " + tempResults + line)

# sort final results
file = open(tempResults + "final-results","w") 

for files in os.listdir(tempResults):
    with open(os.path.join(tempResults, files)) as curreDomainIp:
        for l in curreDomainIp:
            file.write(l.replace("\n","") + ":" + files + "\n") 
            # read only first ip address
            break

file.close() 

os.system("sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 " + tempResults + "final-results")

