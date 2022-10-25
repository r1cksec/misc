#!/usr/bin/env python3
import time
import threading
import sys
import os
import signal

# check amount of passed arguments
if (len(sys.argv) != 5):
    print("usage: {} pathToFileWithArgs firstCommand SecondCommand multiThreadingFlag".format(sys.argv[0]))
    print("multiThreadingFlag can be either 0 or 1")
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

"""
class threadForCommand(threading.Thread):
   def __init__(self, command):
       threading.Thread.__init__(self)
       self.command = command

   def run(self):
       os.system(self.command)

allArgs = []

# read all arguments from file
with open(sys.argv[1]) as fileWithArguments:
    for line in fileWithArguments:
        allArgs.append(line.replace("\n",""))

print("Start processing: ")
print(allArgs)

time.sleep(3)

# run 6 threads in parallel
while allArgs:
    if (sys.argv[4] == "1"):
        if (threading.active_count() <= 6):
            currentThread = threadForCommand(sys.argv[2] + allArgs[0] + sys.argv[3])
            del(allArgs[0])
            currentThread.start()

    elif (sys.argv[4] == "0"):
        os.system(sys.argv[2] + allArgs[0] + sys.argv[3])
        del(allArgs[0])

    else:
        print("multiThreadingFlag must be either 0 or 1")
        exit(1)


