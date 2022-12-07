#!/usr/bin/env python3

import datetime
import os
import sys

# check amount of passed arguments
if (len(sys.argv) != 2):
    print("usage: {} domainFile ".format(sys.argv[0]))
    sys.exit(1)

timestamp = datetime.datetime.today().strftime("%d-%m-%Y_%H:%M:%S")
tempFile = "/tmp/" + timestamp + "-host-resolved-domain-to-ip.txt"
resultBuffer = []

with open(sys.argv[1]) as allHosts:
    for currHost in allHosts:
        os.system("host " + currHost.replace("\n","") + " >> " + tempFile)

# if 1 current domain is an alias
aliasFlag = "0"
domainBuf = ""

# prevent duplicate print of domain
lastLineDomain = ""

with open(tempFile) as hostResult:
    for line in hostResult:
        if (aliasFlag == "0"):
            # skip unresolveable domains
            if ("NXDOMAIN" in line):
                continue

            # ipv4 and ipv6
            if ("has address" in line or "has IPv6 address" in line):
                line = line.replace("\n","")
                splitLine = line.split(" ")

                if (lastLineDomain == splitLine[0]):
                    continue

                if (" IPv6 " in line):
                    resultBuffer.append(splitLine[0] + "; " + splitLine[4])
                else:
                    resultBuffer.append(splitLine[0] + "; " + splitLine[3])

                lastLineDomain = splitLine[0]

            # alias
            if ("is an alias" in line):
                aliasFlag = "1"
                splitLine = line.split(" ")
                domainBuf = splitLine[0]
        else:
            if ("has address" in line or "has IPv6 address" in line):
                splitLine = line.split(" ")

                if (lastLineDomain == splitLine[0]):
                    continue

                if (" IPv6 " in line):
                    resultBuffer.append(splitLine[0] + "; " + splitLine[4])
                else:
                    resultBuffer.append(domainBuf + "; " + splitLine[3])

                lastLineDomain = splitLine[0]
                aliasFlag = "0"

seenIps = []
cleanDomains = []

for currentResult in resultBuffer:
    splitResult = currentResult.split("; ")
    currentIp = splitResult[1]
    currentDomain = splitResult[0]

    if currentIp in seenIps:
        # check if ip is wildcard
        os.system("host someNoMensLand" + currentDomain + " > " + tempFile)

        fp = open(tempFile, "r")
        fileContent = fp.readlines()
        fp.close()

        for l in fileContent:
            if ("NXDOMAIN" in l):
                cleanDomains.append(currentResult)
    else:
        seenIps.append(currentIp)
        cleanDomains.append(currentResult)

for e in cleanDomains:
    print(e)

os.system("rm " + tempFile)

