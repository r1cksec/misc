#!/usr/bin/env python3

import sys

# check amount of passed arguments
if (len(sys.argv) != 2):
    print("usage: {} rangeFile".format(sys.argv[0]))
    print("rangeFile: File with ripe ranges XX.XX.XXX.XXX - YY.YY.YYY.YYY, one per line")
    sys.exit(1)

with open(sys.argv[1]) as fileContent:
    for line in fileContent:
        line = line.replace("\n","")
        ranges = line.split(" - ")

        splittedRange0 = ranges[0].split(".")
        splittedRange1 = ranges[1].split(".")

        printFlag = "1"

        if (splittedRange0[0] == splittedRange1[0]):
            print(splittedRange0[0],end=".")
        else:
            print("Huge ig range !!! Check manualy !!! " + line)

        if (splittedRange0[1] == splittedRange1[1]):
            print(splittedRange0[1],end=".")
        else:
            print("Huge ig range !!! Check manualy !!! " + line)

        if (splittedRange0[2] == splittedRange1[2]):
            print(splittedRange0[2],end=".")
        else:
            for i in range(int(splittedRange0[2]), int(splittedRange1[2]), 1):
                if (printFlag == "1"):
                    print(str(i) + "." + splittedRange0[3] + "-" + splittedRange1[3])
                    printFlag = "0"
                else:
                    print(splittedRange0[0],end=".")
                    print(splittedRange0[1],end=".")
                    print(str(i) + "." + splittedRange0[3] + "-" + splittedRange1[3])

            print(splittedRange0[0],end=".")
            print(splittedRange0[1],end=".")
            print(str(i + 1) + "." + splittedRange0[3] + "-" + splittedRange1[3])

        if (printFlag == "1"):
            if (splittedRange0[3] == splittedRange1[3]):
                print(splittedRange0[3])
            else:
                print(splittedRange0[3] + "-" + splittedRange1[3])

