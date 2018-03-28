#!/bin/bash

if [ "$1" == "--help" ] || [ "$1" == "-h" ] #if zadanie3.sh --help or -h
then
    echo -e "Program skontroluje dostupnost IPv4 zariadenia, predvolenej brany, DNS serverov a serveru Googla."
    exit 0
fi

#program starts here
echo -e "USER OUTPUT:" > uOUT.txt   #clear the IP.txt file with initial message
echo -e "PROGRAM OUTPUT:\n" > pOut.txt  #clear the out.txt file with initial message

#availability of my IPv4 address
netCards=($(basename -a /sys/class/net/*))
echo ${netCards[0]}

mojaIP=$(ifconfig ${netCards[0]} | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
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

ping -c3 $GW >> pOut.txt 2>&1  #message transfer to file

if [ $? -eq 0 ] #if the ping output is 0
then 
    echo -e "\nMy default gateway is available." >> uOUT.txt   #write the connectivity to file
    echo -e "My GateWay: $GW" >> uOUT.txt
else
    echo -e "\nMy default gateway is not available." >> uOUT.txt   #write the connectivity to file
fi

#availability of my DNS servers
DNS=($(nmcli dev show | grep DNS | grep -Po '[0-9.]{7,15}'))

for ((x=0; x<${#DNS[@]}; x++));
do
  ping -c3 ${DNS[$x]} >> pOut.txt 2>&1  #message transfer to file

    if [ $? -eq 0 ] #if the ping output is 0
    then 
        echo -e "\n"$((x+1))". DNS is available." >> uOUT.txt   #write the connectivity to file
        echo -e "DNS's IP: ${DNS[$x]}" >> uOUT.txt
    else
        echo -e "\n"$((x+1))".This DNS is not available." >> uOUT.txt   #write the connectivity to file
        echo -e "DNS's IP: ${DNS[$x]}" >> uOUT.txt
    fi
done

#ping google 3 times
google=$(nslookup google.com | grep 'Address: ' | awk '{ print $2}')

ping -c3 $google >> pOut.txt 2>&1  #message transfer to file

if [ $? -eq 0 ] #if the ping output is 0
then 
    echo -e "\nGoogle is available, the internet connection is working." >> uOUT.txt   #write the connectivity to file
    echo -e "Google's IP: $google" >> uOUT.txt
else
    echo -e "\nGoogle is not available." >> uOUT.txt   #write the connectivity to file
fi

#prints out the user output
cat uOUT.txt  #prints the IP's out

#duraction of the script
echo -e "\nDuraction: $SECONDS seconds"

exit 0

