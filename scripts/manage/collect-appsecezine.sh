#!/bin/bash

# stop on error
set -e
# stop on undefined
set -u

pathToDir="/tmp/AppSecEzine"

if [ -d ${pathToDir} ]
then
    cd ${pathToDir} && git pull
else
    git clone https://github.com/Simpsonpt/AppSecEzine.git ${pathToDir}
fi

latestFile=$(ls "${pathToDir}/Ezines" | sort -n | tail -n -1)
pathToFile="${pathToDir}/Ezines/${latestFile}"

cat "${pathToFile}"

