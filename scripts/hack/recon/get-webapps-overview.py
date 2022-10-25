#!/usr/bin/env python3
import json
import os
import signal
import subprocess
import sys
import time
import threading
import random


# check amount of passed arguments
if (len(sys.argv) != 3):
    print("usage: {} hostFile outputDir".format(sys.argv[0]))
    print("hostFile = Domain name one per line")
    sys.exit(1)


"""FUNCTION
Catch user interrupt (ctrl + c).

sig = The type of signal, that should be catched.
frame = The function that should be executed.
"""
def signal_handler(sig, frame):
    print("\nCatched keyboard interrupt, exit programm!")
    sys.exit(1)

# catch user interrupt (ctrl + c)
signal.signal(signal.SIGINT, signal_handler)


"""FUNCTION

Create thread and execute given command.

randInd = A random value that defines by index which command should be executed.
"""
class threadForCommand(threading.Thread):
   def __init__(self, command):
       threading.Thread.__init__(self)
       self.command = command

   def run(self):
       #os.system(self.command)
       subprocess.check_output(self.command, shell=True, executable="/bin/bash")


"""FUNCTION

Return json object for given file.

fileName = The path to the file containing the json object.
"""
def loadJson(jsonFileName):
    with open(jsonFileName, "r", encoding="utf-8") as file:
        return json.load(file)


# create directory structure
resultDirectory = sys.argv[2]

if (not os.path.exists(resultDirectory)):
    os.makedirs(resultDirectory)

allCommands = []
# run commands for each host
with open(sys.argv[1]) as allHosts:
    for host in allHosts:
        host = host.replace("\n","")

        # create directory for current host
        currOutputDir = resultDirectory + "/" + host + "/"
        if (not os.path.exists(currOutputDir)):
            os.makedirs(currOutputDir)
        else:
            print("DUPLICATE " + host)
            continue

        # host
        hostCommand = "host " + host + " > " + currOutputDir + "host.txt 2>&1"
        allCommands.append(hostCommand)

        # whois 
        whoisCommand = """
        h=$(host """ + host + """); 
        if [[ "$h" == *"has address"* ]]; 
        then
            w=$(echo "$h" | grep "has address" | head -n 1 | awk -F ' ' '{print $4}')
            whois "$w" > """ + currOutputDir + """whois.txt 2>&1;
        elif [[ "$h" == *"has IPv6 address"* ]]; 
        then
            w=$(echo "$h" | grep "has IPv6 address" | head -n 1 | awk -F ' ' '{print $5}')
            whois "$w" > """ + currOutputDir + """whois.txt 2>&1;
        else 
            printf "No whois entry found for """ + host + """";
        fi
        """
        allCommands.append(whoisCommand)

        # nmap
        nmapCommand = "nmap -sT --script /usr/share/nmap/scripts/ssl-cert.nse " \
        " --host-timeout 10 -p 443 " + host + " -oA " + currOutputDir + "nmap > " \
        + currOutputDir + "nmap-stdout.txt 2>&1"
        allCommands.append(nmapCommand)
        
        # whatweb http
        whatwebCommand = "whatweb -v --color=never -v http://" + host \
        + ":80 --log-json=" + currOutputDir + "whatweb-80.json" \
        + " > " + currOutputDir + "whatweb-80-stdout.txt 2>&1"
        allCommands.append(whatwebCommand)

        # whatweb https
        whatwebCommandTls = "whatweb -v --color=never -v https://" + host \
        + ":443 --log-json=" + currOutputDir + "whatweb-443.json" \
        + " > " + currOutputDir + "whatweb-443-stdout.txt 2>&1"
        allCommands.append(whatwebCommandTls)

counter = 0
commandAmount = len(allCommands)

# run 10 threads in parallel - execute all commands
while allCommands:
    if (threading.active_count() <= 10):
        randInd = random.randint(0,len(allCommands)-1)
        currentThread = threadForCommand(allCommands[randInd])
        del(allCommands[randInd])
        currentThread.start()
        counter = counter + 1
        print("Start: " + str(counter) + "/" + str(commandAmount))

while (threading.active_count() != 1):
    time.sleep(1)

# create result CSV file
print("Create CSV file...")

csvResult = open(resultDirectory + "/wiw-results.csv", "w")

csvResult.write("Host; IP; Netrange; Netname; SAN; HTTP Statuscode; HTTP Title; HTTP Server; HTTP Powered by; HTTPS Statuscode; HTTPS Title; HTTPS Server; HTTPS Powered by;  " + "\n")

with open(sys.argv[1]) as allHosts:
    for host in allHosts:

        try:
            host = host.replace("\n","")
            currOutputDir = resultDirectory + "/" + host + "/"
            csvLine = host + "; "
    
            # read ip address
            with open(currOutputDir + "host.txt") as hostResult:
                for line in hostResult:
                    line = line.replace("\n","")
                    # check if host resolves to ipv4 address
                    if ("has address" in line):
                        ipSplit = line.split(" ")
                        ipAdrr = ipSplit[3]
                        break
                    elif ("has IPv6 address" in line):
                        ipSplit = line.split(" ")
                        ipAdrr = ipSplit[4]
                        break
    
            csvLine = csvLine + ipAdrr + "; "
    
            # read netrange and whois owner
            with open(currOutputDir + "whois.txt") as whoisResult:
                for line in whoisResult:
                    line = line.replace("\n","")
                    line = line.replace("\t","")
                    if ("inetnum:" in line.lower() or "netrange:" in line.lower()):
                        ipRangeSplit = line.split(" - ")
                        minRange = ipRangeSplit[0].split(" ")
                        maxRange = ipRangeSplit[1].split(" ")
                        ipRange = minRange[-1] + "-" + maxRange[0]
                        break
    
            csvLine = csvLine + ipRange + "; "
    
            # read orga name
            with open(currOutputDir + "whois.txt") as whoisResult:
                for line in whoisResult:
                    line = line.replace("\n","")
                    line = line.replace("\t","")
                    if ("netname:" in line.lower() or "descr:" in line.lower()):
                        netnameSplit = line.split(" ")
                        netname = netnameSplit[-1]
                        break
    
            csvLine = csvLine + netname + "; "
    
            # read nmap ssl certificate
            with open(currOutputDir + "nmap.nmap") as nmapResult:
                commonName = ""
                subAltName = ""
                portOpen = "0"
    
                for line in nmapResult:
                    line = line.replace("\n","")
    
                    if ("ssl-cert: Subject: commonName=" in line):
                        commNameSplit = line.split("commonName=")
                        commonName = commNameSplit[1].split("/")
                        portOpen = "1"
    
                    if ("Subject Alternative Name: " in line):
                        subAltNameSplit = line.split("Subject Alternative Name: ")
                        subAltName = subAltNameSplit[1].split("DNS:")
                        portOpen = "1"
    
                if (portOpen == "1"):
                    allNames = commonName[0]
    
                    for name in subAltName:
                         allNames = allNames + " " + name.replace(", ","")
    
                    csvLine = csvLine + allNames + "; "
                else:
                    csvLine = csvLine + "; "
            
            csvLineBuf = csvLine
    
            try:
                # read whatweb results
                for port in ["80", "443"]:
                    whatwebRes = currOutputDir + "whatweb-" + port + ".json"
                    
                    if (os.path.exists(whatwebRes)):
                        wwJson = loadJson(currOutputDir + "whatweb-" + port + ".json")
    
                        # http status
                        try:
                            statusCode = wwJson[0]["http_status"]
                        except:
                            statusCode = " "
    
                        # redirect location
                        if ("30" in str(statusCode)):
                            redirLocation = wwJson[0]["plugins"]["RedirectLocation"]["string"][0]
                            statusCode = str(statusCode) + " - " + redirLocation
    
                        csvLine = csvLine + str(statusCode) + "; "
                        
                        # http title (-1 since status 301 creates multiple json objects)
                        try:
                            title = wwJson[-2]["plugins"]["Title"]["string"][0]
                        except:
                            title = " "
    
                        csvLine = csvLine + title + "; "
    
                        # http server
                        try:
                            serverString = wwJson[-2]["plugins"]["HTTPServer"]["string"][0]
                            csvLine = csvLine + serverString + "; "
                        except:
                            csvLine = csvLine + "; "
    
                        # powered by
                        try:
                            powBy = wwJson[-2]["plugins"]["PoweredBy"]["string"][0]
                            csvLine = csvLine + powBy + "; "
                        except:
                            csvLine = csvLine + "; "
    
                    else:
                        csvLine = csvLine + ";;;;;"
            
            except:
                csvLine = csvLine + ";;;;;"
        except:
            print(host + " Broken")

        csvResult.write(csvLine + "\n")

csvResult.close()


