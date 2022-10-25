#!/usr/bin/env python3

import sys
import os

# check amount of passed arguments
if (len(sys.argv) != 2):
    print("usage: {} hostFile ".format(sys.argv[0]))
    sys.exit(1)

# used to split input file into groups of 20 urls
counter = 0
allUrls = ""

with open(sys.argv[1]) as allHosts:
    for host in allHosts:
        allUrls = allUrls + " " + host.replace("\n","")
        counter = counter + 1

        if (counter % 20 == 0):
            os.system("chromium --ignore-certificate-errors " + allUrls + " &")
            print("Press enter to continue")
            userInput = input()
            allUrls = ""
 
