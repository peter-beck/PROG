#!/bin/bash

if [ "$1" == "--help" ] || [ "$1" == "-h" ] #if zadanie3.sh --help or -h
then
    echo -e "Uzivatel zada prve 3 bajty vo formate xx.xx.xx"
    echo -e "Skript nasledne dopise adresu v intervale 1-254 a prepinguje siet"
    echo -e "Program vypise zoznam IP adries, ktore najdeme v subore IP.txt"
    exit 0
fi

#program starts here
#echo "Napiste prve 3 bajty IP vo formate xx.xx.xx, potom slacte [ENTER]:"   #input message

#read IP #input

echo -e "NAJDENE IP:\n" > IP.txt   #clear the IP.txt file with initial message
echo -e "VYSTUP PING:\n" > out.txt  #clear the out.txt file with initial message

#availability of my IPv4 address
mojaIP=$(ifconfig enp0s3 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
#echo "moja ip: $mojaIP"
ping -c3 $mojaIP >> out.txt 2>&1  #message transfer to file

if [ $? -eq 0 ] #if the ping output is 0
then 
    echo -e "\nMy IPv4 is avalable." >> IP.txt   #write the connectivity to file
else
    echo -e "\nMy IPv4 is not avalable." >> IP.txt   #write the connectivity to file
fi

#for number in $(seq 4 1 16)    #loop, which generates numbers from 1 to 254
#do
#    ping -c3 -i3 "$IP"".""$number" >> out.txt 2>&1  #message transfer to file
#    if [ $? -eq 0 ] #if the ping output is 0
#    then 
#        echo -e ""$IP"".""$number"" >> IP.txt   #write the IP to file
#    fi
#done

#ping google 3 times
ping -c3 -i3 216.58.209.195 >> out.txt 2>&1  #message transfer to file

if [ $? -eq 0 ] #if the ping output is 0
then 
    echo -e "\nGoogle is available, the internet connection is working." >> IP.txt   #write the connectivity to file
else
    echo -e "\nGoogle is not available." >> IP.txt   #write the connectivity to file
fi

#prints out the user output
echo -e "\n"
cat IP.txt  #prints the IP's out

#duraction of the script
echo -e "\nDuraction: $SECONDS seconds"

exit 0

