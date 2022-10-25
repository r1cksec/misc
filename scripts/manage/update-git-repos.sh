#!/bin/bash

dirs=$(ls ~/git)

for current in ${dirs}
do
    cd ~/git/${current}
    git pull
done

