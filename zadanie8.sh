#!/bin/bash

if [ "$1" == "--help" ] || [ "$1" == "-h" ] #if zadanie7.sh --help or -h
then
    echo -e "Script for backing up a directory with cron.\n"
    exit 0
fi

find=""
filename=""

testName() {
    find=$(find ~ -name "$1")
    echo -e "Your file: " $find

    #echo $(test -e "$find") $?      #unneccesary, the existence is tested below
    if [ $(echo $(test -d "$find") $?) -ne 0 ]; then     #test, if the file is a directory
        echo "Not a directory!"
        let "errorCounter++"

        if [ "$errorCounter" == 1 ]; then
            echo -e "Filename is not a directory! The program is shutting down..."
            exit 1 
        fi
    fi
}

readInput() {
    filename="backup dir"
    numberOfLines=$(find ~ -name "$filename" | wc -l)

    if [ "$numberOfLines" == 0 ]; then
        echo "Not existing file!"
       
        echo -e "Filename doesnt exist! The program is shutting down..."
        exit 1
    elif [ "$numberOfLines" == 1 ]; then
        testName "$filename"
    #else
        #cat $(find ~ -name "$filename")
    fi
}


readInput

#echo $(($(date +%s) - $(date +%s -r zad8.sh)))
if [ $(echo $(($(date +%s) - $(date +%s -r home/flexin/Desktop/'backup dir')))) -le 300 ]; then   #if the last modification date of the file was more then 5 minutes
    echo "zaloha presla"

    filename=$(echo "$filename" | sed -e 's/ /_/g')

    backupDirectory="$(date +%M"_"%H"_"%d"_"%m"_"%Y)-$filename"

    mkdir -p ~/cron-backup/
    cp -nR "$find" ~/cron-backup/"$backupDirectory"

fi    
