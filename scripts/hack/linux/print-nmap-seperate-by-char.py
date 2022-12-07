 
#!/usr/bin/env python3

import xml.etree.ElementTree as ET
import os
import sys

# check amount of passed arguments
if (len(sys.argv) != 4):
    print("usage: {} pathToNmapXmlDir typeToPrint separateChar ".format(sys.argv[0]))
    print ("Type to print: ip, port, hostname")
    sys.exit(1)

pathToNmapXmlDir = sys.argv[1]
allFiles = []

for files in os.listdir(pathToNmapXmlDir):
    if files.endswith(".xml"):
        allFiles.append(os.path.join(pathToNmapXmlDir, files))

allPorts = []
allIps = []
allHostnames = []

for currentXmlFile in allFiles:
    try:
        tree = ET.parse(currentXmlFile)
    except:
        print("Malformed file " + currentXmlFile)
    
    root = tree.getroot()
    
    for currentHost in root.findall("./host"):
        for address in currentHost.findall("address"):
            if (sys.argv[2] == "ip"):
                addressD = address.get("addr")
                if ("." in addressD):
                    allIps.append(addressD)
    
        # check if object is iterable
        if (currentHost.find("hostnames")):
            for hostname in currentHost.find("hostnames"):
                if (sys.argv[2] == "hostname"):
                    name = hostname.get("name")
                    allHostnames.append(name)
    
        if (currentHost.find("ports")):
            for extraPortsOrPort in currentHost.find("ports"):
                extraPortsState = extraPortsOrPort.get("state")
        
                portid = extraPortsOrPort.get("portid")
        
                for state in extraPortsOrPort.findall("state"):
                    state = state.get("state")
        
                    if (state == "open"):
                        if (sys.argv[2] == "port"):
                            allPorts.append(portid)

if (sys.argv[2] == "ip"):
    printThisType = allIps

elif (sys.argv[2] == "port"):
    printThisType = allPorts

elif (sys.argv[2] == "hostname"):
    printThisType = allHostnames


uniqList = sorted(set(printThisType))

for currentElem in uniqList:
    if (sys.argv[3] == "\\n"):
        print(currentElem)
    else: 
        print(currentElem, end=sys.argv[3])

print("")

