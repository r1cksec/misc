#!/bin/bash                                                       

# stop on error
set -e
# stop on undefined
set -u

if [ ${#} -ne 2 ]
then
    echo "usage ${0} fullPathToFile [up||down]"
    exit
fi

if [ "${2}" == "up" ]
then
    scp -r -i ~/.ssh/kali ${1} user@192.168.56.111:/tmp
elif [ "${2}" == "down" ]
then
    scp -r -i ~/.ssh/kali user@192.168.56.111:${1} /tmp
fi

echo "Copied ${1} to /tmp"

