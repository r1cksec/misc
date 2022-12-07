#!/usr/bin/env python3

import sys

# check amount of passed arguments
if (len(sys.argv) != 4):
    print("usage: {} passwordFile rounds length".format(sys.argv[0]))
    print("rounds - how often do you want to append stuff to a word - 1 or 2")
    print("length - how many chars does a password needs to have at least")
    sys.exit(1)

appendFirst = ["2020","2021","2022","123","1234","12345","123456"]
appendSecond = ["!","?","=","-","_","#","/"]
rounds = sys.argv[2]
length = sys.argv[3]

with open(sys.argv[1]) as basicPasswords:
    for line in basicPasswords:
        pw = line.replace("\n","")

        for app in appendFirst:
            var1 = pw.lower() + app
            var2 = pw[0].upper() + pw[1:] + app
         
            if (len(var1) >= int(length)):
                print(var1)
                print(var2)

            if (rounds == "2"):
                for app2 in appendSecond:
                    var3 = var1 + app2
                    var4 = var2 + app2

                    if (len(var3) >= int(length)):
                        print(var3)
                        print(var4)

