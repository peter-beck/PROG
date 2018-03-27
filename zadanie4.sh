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

echo -e "USER OUTPUT:" > uOUT.txt   #clear the IP.txt file with initial message
echo -e "PROGRAM OUTPUT:\n" > pOut.txt  #clear the out.txt file with initial message

#availability of my IPv4 address
mojaIP=$(ifconfig enp0s3 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
#echo "moja ip: $mojaIP"
ping -c3 $mojaIP >> pOut.txt 2>&1  #message transfer to file

if [ $? -eq 0 ] #if the ping output is 0
then 
    echo -e "\nMy IPv4 is available." >> uOUT.txt   #write the connectivity to file
    echo -e "My IP: $mojaIP" >> uOUT.txt
else
    echo -e "\nMy IPv4 is not available." >> uOUT.txt   #write the connectivity to file
fi

#availability of my default gateway
GW=$(/sbin/ip route | awk '/default/ { print $3 }')
#echo $GW

ping -c3 $GW >> pOut.txt 2>&1  #message transfer to file

if [ $? -eq 0 ] #if the ping output is 0
then 
    echo -e "\nMy default gateway is available." >> uOUT.txt   #write the connectivity to file
    echo -e "My GateWay: $GW" >> uOUT.txt
else
    echo -e "\nMy default gateway is not available." >> uOUT.txt   #write the connectivity to file
fi

#ping google 3 times
ping -c3 -i3 216.58.209.195 >> pOut.txt 2>&1  #message transfer to file

if [ $? -eq 0 ] #if the ping output is 0
then 
    echo -e "\nGoogle is available, the internet connection is working." >> uOUT.txt   #write the connectivity to file
    echo -e "My IP: 216.58.209.195" >> uOUT.txt
else
    echo -e "\nGoogle is not available." >> uOUT.txt   #write the connectivity to file
fi

#prints out the user output
cat uOUT.txt  #prints the IP's out

#duraction of the script
echo -e "\nDuraction: $SECONDS seconds"

exit 0

