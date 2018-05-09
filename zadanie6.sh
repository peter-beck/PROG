#!/bin/bash

declare -i time	#signaling that time will be integer
declare -i currSec
declare -i reborn

if [ "$#" != 1 ]	
then
    echo "Input argument must be declared [./zadanie6.sh N-seconds]"
    exit 1
fi

sec=$1	#store the first argument into variable
> tmp.txt #delete the content or create tmp as empty file

ps -aux | tail -n+2 > tmp.txt	#save  processes into a file

if [ $USER != "root" ]	#if the user is root, print out all processes
then
    cat tmp.txt | grep "$USER" > procesy.txt	#send only $USER processes
else
    cat tmp.txt > procesy.txt	#send everything
fi

array_maker=`cat procesy.txt | awk '{print $2}'` #save the second column to PID
PID=(`echo ${array_maker}`)
array_maker=`cat procesy.txt | awk '{print $1}'` #the first to OWNER
OWNER=(`echo ${array_maker}`)
array_maker=`cat procesy.txt | awk '{print $11}'` #the eleventh to PATH
PATH=(`echo ${array_maker}`)

printf "Naslo sa ${#PATH[@]} procesov\n"
printf "%-20s %-30s %-20s %-50s \n" "PID procesu:" "Cas spustenia procesu [s]:" "Vlastnik:" "Cesta k spustenemu suboru:"

num=0	#variable that holds numOfLine
for i in ${PATH[@]}; do
    if [ -e $i ]; #if directory exists
    then
        currSec=$(date +%s) #get date from 1970 in seconds
        reborn=$(stat -c %Y $i)	#get date from last update
        echo $currSec
        echo $reborn
        echo $i
        
        time=$(($currSec - $reborn)) #subtract currDate and last update to get lifetime
        if (( "$time" < "$sec" )); #we only want processes younger than time
        then
            output=`(ls -l $i | grep -w "exe \->" | awk '{print $11}') 2> /dev/null` #get path to exe of process
            echo $output            
            if [[ $output != "/usr/bin/sudo" ]] && [[ $output != "/bin/bash" ]] && [[ ! -z $output ]]; then #filter sudo/bash or without path
                printf "%-20s %-30s %-20s %-50s \n" "$i" "$time" "${OWNER[$num]}" "$output"
            fi
        fi
    fi
    num=$((num + 1))
done
exit 0

