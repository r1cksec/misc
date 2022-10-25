declare -a fileExtensions=("c" "cmd" "cs" "css" "html" "js" "md" "php" "py" "sh" "vbs")

# remove old dictionaries and snippets
rm -f ${HOME}/.vim/dictionaries/*
rm -f ${HOME}/.vim/UltiSnips/*

for currentExt in "${fileExtensions[@]}"
do
    # write name of files into dictionary
    files=$(ls ${HOME}/git/cheatsheets/snippets/${currentExt})

    # write files and content into dictionary and snippets
    for current in ${files}
    do
        # remove file extension
        currentName=$(echo "${current}" | cut -f 1 -d '.')

        # some extras steps are necessary because vim and ultisnips recognize file types differently
        if [[ "${currentExt}" == "cmd" ]]
        then
            echo ${currentName} >> ${HOME}/.vim/dictionaries/dosbatch.txt
            echo "snippet ${currentName} \"${currentName}\"" >> ${HOME}/.vim/UltiSnips/dosbatch.snippets
            cat ${HOME}/git/cheatsheets/snippets/${currentExt}/${current} >> ${HOME}/.vim/UltiSnips/dosbatch.snippets
            echo "endsnippet" >> ${HOME}/.vim/UltiSnips/dosbatch.snippets
            echo "" >> ${HOME}/.vim/UltiSnips/dosbatch.snippets
        elif [[ "${currentExt}" == "md" ]]
        then
            echo ${currentName} >> ${HOME}/.vim/dictionaries/${currentExt}.txt
            echo "snippet ${currentName} \"${currentName}\"" >> ${HOME}/.vim/UltiSnips/markdown.snippets
            cat ${HOME}/git/cheatsheets/snippets/${currentExt}/${current} >> ${HOME}/.vim/UltiSnips/markdown.snippets
            echo "endsnippet" >> ${HOME}/.vim/UltiSnips/markdown.snippets
            echo "" >> ${HOME}/.vim/UltiSnips/markdown.snippets
        elif [[ "${currentExt}" == "js" ]]
        then
            echo ${currentName} >> ${HOME}/.vim/dictionaries/javascript.txt
            echo "snippet ${currentName} \"${currentName}\"" >> ${HOME}/.vim/UltiSnips/javascript.snippets
            cat ${HOME}/git/cheatsheets/snippets/${currentExt}/${current} >> ${HOME}/.vim/UltiSnips/javascript.snippets
            echo "endsnippet" >> ${HOME}/.vim/UltiSnips/javascript.snippets
            echo "" >> ${HOME}/.vim/UltiSnips/javascript.snippets
        elif [[ "${currentExt}" == "py" ]]
        then
            echo ${currentName} >> ${HOME}/.vim/dictionaries/${currentExt}.txt
            echo "snippet ${currentName} \"${currentName}\"" >> ${HOME}/.vim/UltiSnips/python.snippets
            cat ${HOME}/git/cheatsheets/snippets/${currentExt}/${current} >> ${HOME}/.vim/UltiSnips/python.snippets
            echo "endsnippet" >> ${HOME}/.vim/UltiSnips/python.snippets
            echo "" >> ${HOME}/.vim/UltiSnips/python.snippets
        elif [[ "${currentExt}" == "vbs" ]]
        then
            echo ${currentName} >> ${HOME}/.vim/dictionaries/${currentExt}.txt
            echo "snippet ${currentName} \"${currentName}\"" >> ${HOME}/.vim/UltiSnips/vb.snippets
            cat ${HOME}/git/cheatsheets/snippets/${currentExt}/${current} >> ${HOME}/.vim/UltiSnips/vb.snippets
            echo "endsnippet" >> ${HOME}/.vim/UltiSnips/vb.snippets
            echo "" >> ${HOME}/.vim/UltiSnips/vb.snippets
        else
            echo ${currentName} >> ${HOME}/.vim/dictionaries/${currentExt}.txt
            echo "snippet ${currentName} \"${currentName}\"" >> ${HOME}/.vim/UltiSnips/${currentExt}.snippets
            cat ${HOME}/git/cheatsheets/snippets/${currentExt}/${current} >> ${HOME}/.vim/UltiSnips/${currentExt}.snippets
            echo "endsnippet" >> ${HOME}/.vim/UltiSnips/${currentExt}.snippets
            echo "" >> ${HOME}/.vim/UltiSnips/${currentExt}.snippets
        fi
    done
done

