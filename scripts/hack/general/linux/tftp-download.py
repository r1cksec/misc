import tftpy
import os
import sys

# check amount of passed arguments
if (len(sys.argv) != 4):
    print("usage: {} rhost rport pathToFile ".format(sys.argv[0]))
    sys.exit(1)

rhost = sys.argv[1]
rport = sys.argv[2]
pathFile = sys.argv[3]

client = tftpy.TftpClient(rhost, rport)

with open(pathFile) as paths:
    for fileName in paths:
        fileName = fileName.replace("\n","")
        baseName = os.path.basename(fileName)

        try:
            client.download(fileName, fileName, timeout=5)
        except:
            print(fileName + " not found")
            # check if file or directory exists
            if (os.path.exists(fileName)):
                os.remove(fileName)

