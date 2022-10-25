#!/bin/bash

# stop on error
set -e
# stop on undefined
set -u

if [ ${#} -ne 1 ]
then
    echo usage ${0} nse-file
    exit
fi

# print description of a given NSE script

# exclude 2 lines: description = [[ and: ]]
sed -n '/description = \[\[/,/\]\]/{/description = \[\[/b;/\]\]/b;p}' ${1}

echo ""

grep -A10 "usage" ${1}

