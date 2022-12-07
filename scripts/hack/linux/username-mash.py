#!/usr/bin/env python
import sys
import os.path

if len(sys.argv) != 2:
    print("usage: {} names.txt".format((sys.argv[0])))
    sys.exit(0)

if not os.path.exists(sys.argv[1]): 
    print("{} not found".format(sys.argv[1]))
    sys.exit(0)

for line in open(sys.argv[1]):
    name = ''.join([c for c in line if  c == " " or  c.isalpha()])

    tokens = name.lower().split()

    # skip empty lines
    if len(tokens) < 1: 
        continue

    fname = tokens[0]
    lname = tokens[-1]

    print(fname + lname)
    print(lname + fname)
    print(fname + "." + lname)
    print(lname + "." + fname)
    print(lname + fname[0])
    print(fname[0] + lname)
    print(lname[0] + fname)
    print(fname[0] + "." + lname)
    print(lname[0] + "." + fname)
    print(fname)
    print(lname)

