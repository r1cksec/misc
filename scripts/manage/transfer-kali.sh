#!/bin/bash                                                       

# stop on error
set -e
# stop on undefined
set -u

if [ ${#} -ne 3 ]
then
    echo "usage ${0} user fullPathToFile [up||down]"
    exit
fi

if [ "${3}" == "up" ]
then
    scp -r -i ~/.ssh/kali ${2} ${1}@192.168.56.111:/tmp
elif [ "${3}" == "down" ]
then
    scp -r -i ~/.ssh/kali ${1}@192.168.56.111:${2} /tmp
fi

echo "Copied ${2} to /tmp"

