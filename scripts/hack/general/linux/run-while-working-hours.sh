#!/bin/bash

if [ ${#} -ne 2 ]
then
    echo "usage: run-while-working-hours.sh fileWithCommands 'intervall'"
    echo "format fileWithCommands: one command per line"
    echo "format interval = hh:mm:ss"
    exit 1
fi

seconds=$(echo "${2}" | cut -d ":" -f 3)
minutes=$(echo "${2}" | cut -d ":" -f 2)
hours=$(echo "${2}" | cut -d ":" -f 1)
sleepInSeconds=$(echo "(${hours} * 60 * 60) + (${minutes} * 60) + ${seconds}" | bc)

while read -r command || [[ -n "${command}" ]]
do
    while (true)
    do
        day=$(date +%u)
        time=$(date +"%T")

        # check for weekend
        if ! [ "${day}" == "6" ] || [ "${day}" == "7" ]
        then
            # check for working hours 07:30 - 18:00
            if [[ "${time}" > "07:30:00" && "$time" < "18:00:00" ]]
            then
                break
            fi
        fi

        sleep 600
    done
    
    echo "Execute: ${command} "
    ${command}
    echo "Done at $(date +'%Y-%m-%d %T') - Sleep for ${2} !"
    echo ""
    echo ""
    sleep ${sleepInSeconds}
    
done < ${1}

