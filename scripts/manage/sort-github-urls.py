#!/usr/bin/env python3

import sys

# check amount of passed arguments
if (len(sys.argv) != 2):
    print("usage: {} pathToGithubFile ".format(sys.argv[0]))
    sys.exit(1)

toSort = []
currentLink = ""
flag = "0"

with open(sys.argv[1]) as fp:
    for line in fp:
        line = line.replace("\n","")
        if (flag == "0"):
            currentLink = line
            flag = "1"
            continue
     
        if (flag == "1"):
            flag = "2"
            toSort.append(currentLink + " SORTMEMETROS " + line)
            continue

        if (flag == "2"):
            flag = "0"
            continue
         
uniqList = sorted(set(toSort))

for i in uniqList:
    buf = i.split(" SORTMEMETROS ")
    print(buf[0])
    print(buf[1])
    print("")

