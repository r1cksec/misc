#!/usr/bin/env python3

import os
import json

import sys

# check amount of passed arguments
if (len(sys.argv) != 4):
    print("usage: {} pathToJsonGroupFile pathToJsonUserFile userName".format(sys.argv[0]))
    sys.exit(1)

def loadJson(pathToFile):
    with open(pathToFile, "r", encoding="utf-8") as file:
        return json.load(file)

jsonGroupObject = loadJson(sys.argv[1])
jsonUserObject = loadJson(sys.argv[2])
user = sys.argv[3]

# get user name
for userData in jsonUserObject["data"]:
    try:
        userName = userData["Properties"]["samaccountname"]
        if (user == userName):
            userSid = userData["ObjectIdentifier"]
    except:
        continue

for groupData in jsonGroupObject["data"]:
    groupName = groupData["Properties"]["name"]
    groupDescr = groupData["Properties"]["description"]
    
    for obj in groupData["Members"]:
        if (userSid == obj["ObjectIdentifier"]):
            if (groupDescr):
                print(groupName + " - " + groupDescr)
            else:
                print(groupName)

