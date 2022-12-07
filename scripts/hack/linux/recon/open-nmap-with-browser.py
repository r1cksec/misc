#!/usr/bin/env python3

import xml.etree.ElementTree as ET
import sys
import os

# check amount of passed arguments
if (len(sys.argv) != 3):
    print("usage: {} fullPathToNmapXmlDir portId".format(sys.argv[0]))
    print ("\tIf portId == all, open all open ports inside browser")
    sys.exit(1)

allXmlFiles = []
pathToXmls = sys.argv[1]
portNumber = sys.argv[2]

# collect all xml files 
for files in os.listdir(pathToXmls):
    if files.endswith(".xml"):
        allXmlFiles.append(os.path.join("", files))

allHosts = []
allHostnames = []
hostName = ""

# parse every XML file inside given directory
for currentXml in allXmlFiles:
    try:
        tree = ET.parse(pathToXmls + "/" + currentXml)
    except:
        print(pathToXmls + "/" + currentXml + " is broken ")
        exit(1)
        
    root = tree.getroot()
    
    # get all hosts
    for currentHost in root.findall("./host"):
        addressObj = currentHost.find("address")
        addressD = addressObj.get("addr")
        
        # check if object is iterable
        if (currentHost.find("hostnames")):
            for hostname in currentHost.find("hostnames"):
                hostName = hostname.get("name")
    
        # check if extraPortsOrPort is iterable
        if (currentHost.find("ports")):
            # get all extra port or port
            for extraPortsOrPort in currentHost.find("ports"):
                extraPortsState = extraPortsOrPort.get("state")
        
                portid = extraPortsOrPort.get("portid")
        
                # compare current port id with given portid
                if ("all" == portNumber):
                    for state in extraPortsOrPort.findall("state"):
                        state = state.get("state")
        
                        # print only open ports
                        if (state == "open"):
                            allHosts.append(addressD + ":" + portid)
 
                elif (portid == portNumber):
                    for state in extraPortsOrPort.findall("state"):
                        state = state.get("state")
        
                        # print only open ports
                        if (state == "open"):
                            allHosts.append(addressD)
                            # add hostname
                            if (hostName != ""):
                                allHostnames.append(hostName)


uniqHosts = sorted(set(allHosts))

counter = 0
allUrls = " "

if ("all" == portNumber):
    protocols = ["http", "https", "ftp"]

    allUrls = "chromium --ignore-certificate-errors "

    for prot in protocols:
        for host in uniqHosts:
            allUrls = allUrls + " " + prot + "://" + host

    os.system(allUrls)

else:
    if ("443" in portNumber):
        protocol = "https"
    elif ("21" == portNumber):
        protocol = "ftp"
    else:
        protocol = "http"
    
    for host in uniqHosts:
        allUrls = allUrls + protocol + "://" + host + ":" + portNumber + " "
    
        if (counter == 10):
            os.system("chromium --ignore-certificate-errors " + allUrls)
            allUrls = ""
            counter = 0
    
        counter += 1
    
    for hostname in allHostnames:
        allUrls = allUrls + protocol + "://" + hostname + ":" + portNumber + " "
    
        if (counter == 10):
            os.system("chromium --ignore-certificate-errors " + allUrls)
            allUrls = ""
            counter = 0
        
        counter += 1
    
    os.system("chromium --ignore-certificate-errors " + allUrls)

