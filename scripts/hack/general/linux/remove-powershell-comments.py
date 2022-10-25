#!/usr/bin/env python3

import sys

# check amount of passed arguments
if (len(sys.argv) != 2):
    print("usage: {} srcFile DstFile".format(sys.argv[0]))
    sys.exit(1)

#remove comments from PowerShell scripts
codeFlag = True

with open(sys.argv[1], 'r') as readtest:
    fileContent = readtest.readlines()

with open(sys.argv[2], 'w') as removed:
    for line in fileContent:
        line = line.lstrip()

        if line.startswith("#") and not line.startswith("#>"):
            pass

        elif line.startswith("<#"):
            codeFlag = False

        elif line.startswith('\n'):
            pass

        elif line.startswith("#>"):
            codeFlag = True

        else:
            if codeFlag:
                removed.write(line)

