#!/usr/bin/env python3

import sys
import os
import xml.etree.ElementTree as ET

# check amount of passed arguments
if (len(sys.argv) != 2):
    print("usage: {} pathToNmapXmlDir ".format(sys.argv[0]))
    sys.exit(1)

allIps = []

# collect all Ips
for files in os.listdir(sys.argv[1]):
    if files.endswith(".xml"):
        with open(os.path.join(sys.argv[1], files)) as currentXmlFile:
            try:
                tree = ET.parse(currentXmlFile)
            except:
                print(os.path.join(sys.argv[1], files) + " has wrong format!")
                sys.exit(1)
            
            root = tree.getroot()
            
            # append each host at list
            for currentHost in root.findall("./host"):
                for address in currentHost.findall("address"):
                    addressD = address.get("addr")
            
                    addressType = address.get("addrtype")
                
                    if (addressType == "ipv4"):
                        allIps.append(addressD)
            

# sort uniq ips
uniqIps = sorted(set(allIps))
uniqIpArr = []

for ip in uniqIps:
    uniqIpArr.append([ip,[]])

indexOfIp = 0

# collect all ports for each host
for files in os.listdir(sys.argv[1]):
    if files.endswith(".xml"):
        with open(os.path.join(sys.argv[1], files)) as currentXmlFile:
            tree = ET.parse(currentXmlFile)
            
            root = tree.getroot()
            
            for currentHost in root.findall("./host"):
                for address in currentHost.findall("address"):
                    addressD = address.get("addr")
            
                    addressType = address.get("addrtype")
                
                    if (addressType == "ipv4"):
                        currIp = addressD
                        counter = 0

                        for ip in uniqIpArr:
                            if (ip[0] == currIp):
                                indexOfIp = counter
                            
                            counter = counter + 1
               
                isAtLeastOnePortOpen = "0"

                if (currentHost.find("ports")):
                    for extraPortsOrPort in currentHost.find("ports"):
                        extraPortsState = extraPortsOrPort.get("state")
                        count = extraPortsOrPort.get("count")
            
                        portid = extraPortsOrPort.get("portid")
            
                        for state in extraPortsOrPort.findall("state"):
                            state = state.get("state")

                            for service in extraPortsOrPort.findall("service"):
                                name = service.get("name")

                            if (state == "open"):
                                uniqIpArr[indexOfIp][1].append(portid + "/" + name)
                                isAtLeastOnePortOpen = "1"

                if (isAtLeastOnePortOpen == "0"):
                    del(uniqIpArr[indexOfIp])

counter = 0

# sort ports uniq
for ip in uniqIpArr:
    uniqPortList = sorted(set(ip[1]))
    uniqIpArr[counter][1] = uniqPortList
    counter = counter + 1

# print new nmap XML file
print("""<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE nmaprun>
<?xml-stylesheet href="file:///usr/bin/../share/nmap/nmap.xsl" type="text/xsl"?>
<!-- Nmap 7.80 scan initiated Sat Sep 26 00:01:45 2020 as: nmap -oX test -p 22 127.0.0.1 -->
<nmaprun scanner="nmap" args="nmap -oX test -p 22 127.0.0.1" start="1601071305" startstr="Sat Sep 26 00:01:45 2020" version="7.80" xmloutputversion="1.04">
<scaninfo type="connect" protocol="tcp" numservices="1" services="22"/>
<verbose level="0"/>
<debugging level="0"/>""")

for ip in uniqIpArr:
    print("""<host starttime="1601071681" endtime="1601071681"><status state="up" reason="conn-refused" reason_ttl="0"/>')""")

    print('<address addr="' + ip[0] + '" addrtype="ipv4"/>')

    print("""<hostnames>
</hostnames>
<ports>""")

    for portService in ip[1]:
        splitPortService = portService.split("/")
        print('<port protocol="tcp" portid="' + splitPortService[0] + '"><state state="open" reason="syn-ack" reason_ttl="0"/><service name="' + splitPortService[1] + '" method="table" conf="3"/></port>')

    print("""</ports>
</host>""")

print("""<runstats><finished time="1601071305" timestr="Sat Sep 26 00:01:45 2020" elapsed="0.05" summary="Nmap done at Sat Sep 26 00:01:45 2020; 1 IP address (1 host up) scanned in 0.05 seconds" exit="success"/><hosts up="1" down="0" total="1"/>
</runstats>
</nmaprun>""")

