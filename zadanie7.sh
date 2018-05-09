#!/bin/bash

if [ "$1" == "--help" ] || [ "$1" == "-h" ] #if zadanie7.sh --help or -h
then
    echo -e "Script for backing up a directory.\n"
    echo -e "Possible settings for naming a file:"
    echo -e "Setting: -n\tFormat: file_name-MM_HH_DD_MM_YY"
    echo -e "Setting: -d\tFormat: MM_HH_DD_MM_YY-file_name"
    exit 0
fi

saveFormat=0
errorCounter=0
input=""
find=""
filename=""

testName() {
    find=$(find ~ -name "$1")
    echo -e "Your file: " $find

    #echo $(test -e "$find") $?      #unneccesary, the existence is tested below
    if [ $(echo $(test -d "$find") $?) -ne 0 ]; then     #test, if the file is a directory
        echo "Not a directory!"
        let "errorCounter++"

        if [ "$errorCounter" == 3 ]; then
            echo -e "3 times wrong input detected! The program is shutting down..."
            exit 1 
        fi    
        readInput
    fi
}

readInput() {
    echo -e "Type in the name of the file you want to backup with argument [fileName -d or fileName -n]:"
    read input
    
    parameter=$(echo "$input" | rev | awk '{ print $1}' | rev)
    if [ "$parameter" == "-d" ]; then
        saveFormat=1
    elif [ "$parameter" == "-n" ]; then
        saveFormat=2
    else
        echo "Bad parameter!"
        let "errorCounter++"

        if [ "$errorCounter" == 3 ]; then
            echo -e "3 times wrong input detected! The program is shutting down..."
            exit 1 
        fi    
        readInput
    fi

    filename=$(echo "${input::-3}")
    numberOfLines=$(find ~ -name "$filename" | wc -l)

    if [ "$numberOfLines" == 0 ]; then
        echo "Not existing file!"
        let "errorCounter++"
        
        if [ "$errorCounter" == 3 ]; then
            echo -e "3 times wrong input detected! The program is shutting down..."
            exit 1 
        fi    
        readInput
    elif [ "$numberOfLines" == 1 ]; then
        testName "$filename"
    #else
        #cat $(find ~ -name "$filename")
    fi
}

#if [ "$1" == "-d" ] #if zadanie7.sh -d
#then
#    saveFormat=1
#fi

#if [ "$1" == "-n" ] #if zadanie7.sh -n
#then
#    saveFormat=2
#fi

if [ "$saveFormat" == 0 ] #classic input without arguments
then
    readInput
    filename=$(echo "$filename" | sed -e 's/ /_/g')

    if [ "$saveFormat" == 1 ] #if format -> -d
    then
        backupDirectory="$(date +%M"_"%H"_"%d"_"%m"_"%Y)-$filename"

    elif [ "$saveFormat" == 2 ] #if format -> -n
    then
        backupDirectory="$filename-$(date +%M"_"%H"_"%d"_"%m"_"%Y)"
    fi

    mkdir -p ~/backup/
    cp -nR "$find" ~/backup/"$backupDirectory"

    
fi
