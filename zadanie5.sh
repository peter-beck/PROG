#!/bin/bash

if [ "$1" == "--help" ] || [ "$1" == "-h" ] #if zadanie3.sh --help or -h
then
    echo -e "Program skontroluje dostupnost IPv4 zariadenia, predvolenej brany, DNS serverov a serveru Googla."
    exit 0
fi

#program starts here
echo -e "USER OUTPUT:" > uOUT.txt   #clear the IP.txt file with initial message
echo -e "PROGRAM OUTPUT:\n" > pOut.txt  #clear the out.txt file with initial message

#IPv4 of my NIC
netCards=($(basename -a /sys/class/net/*)) #array of my network adapters

myIP=$(ifconfig ${netCards[0]} | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}') #grep my IP from the first network adapter of the list
echo -e "\nMy IP: $myIP" >> uOUT.txt

#IPv4 of my default gateway
GW=$(/sbin/ip route | awk '/default/ { print $3 }') #get my default gateway
echo -e "My GateWay: $GW" >> uOUT.txt

#my netmask
NetMask=$(ifconfig ${netCards[0]} | grep "Mask:" | awk '{ print $4}' | grep -Po '[0-9.]{7,15}') #grep my netmask
echo -e "My netmask: $NetMask" >> uOUT.txt

#IPv4 of my DNS servers
DNS=($(nmcli dev show | grep DNS | grep -Po '[0-9.]{7,15}')) #store the IP's of all DNS servers to array

#c-style for loop
for ((x=0; x<${#DNS[@]}; x++));
do
    echo -e $((x+1))". DNS's IP: ${DNS[$x]}" >> uOUT.txt
done

#capacity of my disk's in GB
diskCapacity=($(df -H | grep sda | awk '{ print $2}'))  #store the capacity of my disk's in array


#c-style for loop
for ((x=0; x<${#diskCapacity[@]}; x++));
do
    echo -e $((x+1))". disk's capacity in GB: ${diskCapacity[$x]}" >> uOUT.txt
done

#free space on my /home partition in GiB
freeSpace=$(df -h / | grep sda | awk '{ print $4}')     #store the freespace on my "/" partition
echo -e "Free space on my \"/\" partition in GiB: $freeSpace" >> uOUT.txt

#amount of my operational memory in MiB
amountOfRAM=$(free -m | grep Mem: | awk '{ print $2}')
echo -e "Size of my RAM in MiB: $amountOfRAM""MiB" >> uOUT.txt

#usage of my RAM
usedRAM=$(free -m | grep Mem: | awk '{ print $3}')
percent=$(bc <<< "scale=4; $usedRAM/$amountOfRAM")
echo $percent
percent=$(bc <<< "scale=3; $percent*100")
#percent=$((percent*100))
echo $percent

#prints out the user output
cat uOUT.txt  #prints the IP's out

#duraction of the script
echo -e "\nDuraction: $SECONDS seconds"

exit 0

