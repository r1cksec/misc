#!/bin/bash

# flush file
echo "" > ${HOME}/.aliase

allDirs=$(ls ${HOME}/git/cheatsheets)

for currDir in ${allDirs}
do
    allFiles=$(ls ${HOME}/git/cheatsheets/${currDir})

    for currFile in ${allFiles}
    do
        # remove file extension
        fileWithoutExtension=$(echo "${currFile}" | cut -f 1 -d '.')
        echo "alias show-${currDir}-${fileWithoutExtension}=\"cat ${HOME}/git/cheatsheets/${currDir}/${currFile}\" " >> ${HOME}/.aliase
    done
done

