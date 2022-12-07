#!/usr/bin/env python3
import html
import sys
import os
import json
import datetime

# check amount of passed arguments
if (len(sys.argv) != 2):
    print("usage: {} burpResponse".format(sys.argv[0]))
    sys.exit(1)

bracketFlag = "0"

timestamp = datetime.datetime.today().strftime("%d-%m-%Y_%H:%M:%S")
tempFile = "/tmp/xing-employees-" + timestamp

with open(sys.argv[1]) as fp:
    for l in fp:
        l = l.replace("\n","")
        if ("{" in l):
            bracketFlag = "1"
        
        if (bracketFlag == "1"):
            filePointer = open(tempFile, "a")
            filePointer.write(l)
            filePointer.close()

print("Firstname; Lastname; Job")

with open(tempFile, "r", encoding="utf-8") as fp:
    jsonObj = json.load(fp)
    for e in jsonObj["data"]["company"]["employees"]["edges"]:
        print(html.unescape(e["node"]["profileDetails"]["firstName"]) + "; ", end="")
        print(html.unescape(e["node"]["profileDetails"]["lastName"]) + "; ", end="")
        try:
            print(html.unescape(e["node"]["profileDetails"]["occupations"][0]["subline"]), end="")
        except:
            print("null", end="")
        print("")
        
# remove temp file
os.remove(tempFile)

