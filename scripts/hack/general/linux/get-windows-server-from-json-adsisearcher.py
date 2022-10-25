#!/usr/bin/env python3

import sys
import json

# check amount of passed arguments
if (len(sys.argv) != 2):
    print("usage: {} pathToJsonComputersFile".format(sys.argv[0]))
    sys.exit(1)

def loadJson(jsonFileName):
    with open(jsonFileName, "r", encoding="utf-8") as file:
        return json.load(file)

dnsHostname = ""
fileContent = loadJson(sys.argv[1])

for obj in fileContent:
    try:
        if ("windows 10" in str(obj["operatingsystem"]).lower()):
            continue
        else:
            print(obj["dnshostname"])
            print(obj["operatingsystem"])
    except:
        continue
    print("")

