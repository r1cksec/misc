#!/bin/bash

if [ ${#} -ne 1 ]
then
    echo usage ${0} pattern
    exit
fi

pathToNse="/usr/share/nmap/scripts/"

# search for files containing the given pattern
possibleNse=$(grep -li ${1} ${pathToNse}*)

for currentFile in ${possibleNse}
do
    skipThisFile="/usr/share/nmap/scripts/script.db"
    
    if [ "${skipThisFile}" == "${currentFile}" ]
    then
        continue
    fi
    
    echo ${currentFile}
done

